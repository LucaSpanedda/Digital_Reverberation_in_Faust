// ----------------------------------------
// FREEVERB di Jezar at Dreampoint
// ----------------------------------------

// Importo libreria standard di FAUST
import("stdfaust.lib");



/* 
Simulazione di Riverbero di Schroeder/Moorer secondo il 
modello di Jezar at Dreampoint. Utilizza 4 Allpass di Schroeder in serie, 
ed 8 Schroeder-Moorer Filtered-feedback comb-filters in parallelo.
-------------------------------------------
Nel 1979 nella sua pubblicazione ”About This Reverberation Business” James
Moorer, seguendo le proposte esposte da Schroeder nel suo articolo, 
implementa a seguito una topologia che fa uso delle TDL (tapped delay lines) 
per una simulazione delle prime riflessioni, 
ed inserisce all’interno della retroazione del FBCF 
(feedback comb filter) un filtro Lowpass, 
creando così i filtri LBCF(lowpass feedback comb filter) per ottenere 
una simulazione di assorbimento dell’aria all’interno 
del suo modello di riverberazione.
*/



// ------------ FILTER SECTION ------------
    // LOWPASS FEEDBACK COMB FILTER 
    lfbcf(delsamps, g, lowcut) = 
        // lfbcf(delay in samples, comb filter gain, lowcut)
        (+ : @(delsamps-1) : _*lowcut : +~(_ : *(1- lowcut)))~ *(g) : mem;
        // process = _ : lfbcf(3000, 0.999, 0.2) <:_,_;

    // ALLPASS FILTER
    apf(delaysamples, g) =
          (+ : _ <: @(delaysamples-1), *(g)) ~ 
         *(-g) : mem, _ : + : _;
// ----------------------------------------

// ------------ EARLY REFLECTIONS NETWORK -
    early_reflections = reflections
    with {
        in_router(a,b,c,d,e,f,g) = a, b, c, d, e, f, g;
        // process = in_router;

        input = _ <: in_router;
        //process = input;

        // multitap delay lines (NO FEEDBACK)
        multitap_delay(frnt,bck,sx,dx,up,dwn,direct) =
        frnt@(1617) *0.4,
        bck@(1557) *0.4,
        sx@(1491) *0.4,
        dx@(1422) *0.4,
        up@(1277) *0.4,
        dwn@(1356) *0.4,
        direct *0.2;
        //process = early_reflections;

        out_router(a,b,c,d,e,f,g) = a+b+c+d+e+f+g;
        //process = out_router;

        // early reflections routing 
        reflections = input : multitap_delay :> out_router;
    };
// ----------------------------------------

// ------------ LATE REFLECTIONS NETWORK --
    freeverbtail = apf_section
    with{
        in_router(a,b,c,d,e,f,g,h) = a, b, c, d, e, f, g, h;
        //process = in_router;

        // COMBS FILTER SECTION
        comb_section =
        lfbcf(1557, 0.84, 0.2),
        lfbcf(1617, 0.84, 0.2),
        lfbcf(1491, 0.84, 0.2),
        lfbcf(1422, 0.84, 0.2),
        lfbcf(1277, 0.84, 0.2),
        lfbcf(1356, 0.84, 0.2),
        lfbcf(1188, 0.84, 0.2),
        lfbcf(1116, 0.84, 0.2);
        //process = comb_section;

        out_router(a,b,c,d,e,f,g,h) = a+b+c+d+e+f+g+h;
        //process = out_router;

        combsrouting =  early_reflections <: in_router : comb_section :> out_router;
        //process = input;

        apf_section = combsrouting : 
        apf(225, 0.5) : apf(556, 0.5) : apf(441, 0.5) : apf(341, 0.5);
        //process = apf_section;
    };
// ----------------------------------------

// ------------ OUT PATH ------------------
freeverb = _<: freeverbtail + early_reflections;
process = os.impulse : freeverb <: _,_;

// Freeverb mono channel. 
// Processing for the second channel is obtained by adding 
// an integer to each of the twelve delay-line lengths. 
// This integer is called stereospread, and its default value is 23.
