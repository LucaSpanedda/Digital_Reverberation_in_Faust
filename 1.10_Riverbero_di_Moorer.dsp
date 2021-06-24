// ----------------------------------------
// RIVERBERO DI MOORER
// ----------------------------------------

// Importo libreria standard di FAUST
import("stdfaust.lib");



/* 
Simulazione di Riverbero secondo il modello di James A. Moorer
il punto sorgente che coincide col punto di ascolto
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
        frnt@(4481) *0.2,
        bck@(2713) *0.2,
        sx@(3719) *0.2,
        dx@(3739) *0.2,
        up@(1877) *0.2,
        dwn@(1783) *0.2,
        direct *0.2;
        //process = early_reflections;

        out_router(a,b,c,d,e,f,g) = a+b+c+d+e+f+g;
        //process = out_router;

        // early reflections routing 
        reflections = input : multitap_delay :> out_router;
    };
// ----------------------------------------

// ------------ LATE REFLECTIONS NETWORK --
    moorerverbtail = apf_section
    with{
        in_router(a,b,c,d,e,f) = a, b, c, d, e, f;
        //process = in_router;

        // COMBS FILTER SECTION
        comb_section =
        lfbcf(4481, 0.98, 0.8),
        lfbcf(2713, 0.98, 0.8),
        lfbcf(3719, 0.98, 0.8),
        lfbcf(3739, 0.98, 0.8),
        lfbcf(1847, 0.98, 0.8),
        lfbcf(1783, 0.98, 0.8);
        //process = comb_section;

        out_router(a,b,c,d,e,f) = a+b+c+d+e+f;
        //process = out_router;

        combsrouting =  early_reflections <: in_router : comb_section :> out_router;
        //process = input;

        apf_section = combsrouting : apf(556, 0.5) : @(4800);
        //process = apf_section;
    };
// ----------------------------------------

// ------------ OUT PATH ------------------
moorerverb = _<: moorerverbtail + early_reflections;
process = os.impulse : moorerverb <: _,_;
