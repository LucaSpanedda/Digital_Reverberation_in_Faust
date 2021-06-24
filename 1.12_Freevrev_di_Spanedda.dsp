// ----------------------------------------
// FREEVREV di Luca Spanedda.
// Implementazione basata su:
// FREEVERB di Jezar at Dreampoint
// ----------------------------------------

// Importo libreria standard di FAUST
import("stdfaust.lib");



/* 
Simulazione di Riverbero Schroeder/Moorer 
basandosi sul modello "Freeverb" di Jezar at Dreampoint.
Utilizza 4 Allpass di Schroeder in serie, 
ed 8 Schroeder-Moorer Filtered-feedback comb-filters in parallelo.
2 Sezioni parallele e distinte del processo.
*/



// ------------ CONTROLLI -----------------
gaincontrol = vslider("gain[style:knob]",1,0,1,0.001) 
: si.smoo;
lowcutcontrol = vslider("lowcut[style:knob]",1,0,1,0.001) 
: si.smoo;
t60control = vslider("decay-seconds[style:knob]",1,0,100,1) 
: si.smoo;
// ----------------------------------------

// ------------ T60 SECTION ---------------
/* 
Inserisci all'interno degli argomenti della funzione:
    - il valore in campioni del filtro 
    che stai usando per il ritardo.
    - il valore di decadimento in T60
    (tempo di decadimento di 60 dB in secondi)
    = OTTIENI in uscita dalla funzione, 
    il valore che devi passare come amplificazione
    alla retroazione del filtro per ottenere
    il tempo di decadimento T60 che si desidera
*/
// (samps,seconds) = give: samples of the filter, 
// seconds we want for t60 decay
dect60(samps,seconds) = 
1/(10^((3*(((1000 / ma.SR)*samps)/1000))/seconds));
// ----------------------------------------

// ------------ FILTER SECTION ------------
    // LOWPASS FEEDBACK COMB FILTER 
    lfbcf(delsamps, g, lowcut) = 
        // lfbcf(delay in samples, comb filter gain, lowcut)
        (+ : @(delsamps-1) : _*lowcut : +~(_ : *(1- lowcut)))~ 
        *(g) : mem;
        // process = _ : lfbcf(3000, 0.999, 0.2) <:_,_;

    // ALLPASS FILTER
    apf(delaysamples, g) =
          (+ : _ <: @(delaysamples-1), *(g)) ~ 
         *(-g) : mem, _ : + : _;
// ----------------------------------------

// ------------ EARLY REFLECTIONS NETWORK 1
    early_reflections1 = reflections1
    with {
        in_router(a,b,c,d,e,f,g) = a, b, c, d, e, f, g;
        // process = in_router;

        input = _ <: in_router;
        //process = input;

        // multitap delay lines (NO FEEDBACK)
        multitap_delay(frnt,bck,sx,dx,up,dwn,direct) =
        frnt@(1619),
        bck@(1559),
        sx@(1493),
        dx@(1423),
        up@(1277),
        dwn@(1361),
        direct;
        //process = early_reflections;

        out_router(a,b,c,d,e,f,g) = a+b+c+d+e+f+g;
        //process = out_router;

        // early reflections routing 
        reflections1 = input : multitap_delay :> out_router;
    };
// ----------------------------------------

// ------------ EARLY REFLECTIONS NETWORK 2
    early_reflections2 = reflections2
    with {
        in_router(a,b,c,d,e,f,g) = a, b, c, d, e, f, g;
        // process = in_router;

        input = _ <: in_router;
        //process = input;

        // multitap delay lines (NO FEEDBACK)
        multitap_delay(frnt,bck,sx,dx,up,dwn,direct) =
        frnt@(1621),
        bck@(1567),
        sx@(1499),
        dx@(1433),
        up@(1283),
        dwn@(1373),
        direct;
        //process = early_reflections;

        out_router(a,b,c,d,e,f,g) = a+b+c+d+e+f+g;
        //process = out_router;

        // early reflections routing 
        reflections2 = input : multitap_delay :> out_router;
    };
// ----------------------------------------

// ------------ LATE REFLECTIONS NETWORK 1-
    freeverbtail1(seconds,absorb) = apf_section1
    with{
        in_router(a,b,c,d,e,f,g,h) = a, b, c, d, e, f, g, h;
        //process = in_router;

        // COMBS FILTER SECTION
        comb_section =
        lfbcf(1559, dect60(1559,seconds), absorb),
        lfbcf(1619, dect60(1619,seconds), absorb),
        lfbcf(1493, dect60(1493,seconds), absorb),
        lfbcf(1423, dect60(1423,seconds), absorb),
        lfbcf(1277, dect60(1277,seconds), absorb),
        lfbcf(1361, dect60(1361,seconds), absorb),
        lfbcf(1187, dect60(1187,seconds), absorb),
        lfbcf(1117, dect60(1117,seconds), absorb);
        //process = comb_section;

        out_router(a,b,c,d,e,f,g,h) = a+b+c+d+e+f+g+h;
        //process = out_router;

        combsrouting =  early_reflections1 
        <: in_router : comb_section :> out_router;
        //process = input;

        apf_section1 = combsrouting : 
        apf(223, 0.5) : apf(563, 0.5) : 
        apf(441, 0.5) : apf(341, 0.5);
        //process = apf_section;
    };
// ----------------------------------------

// ------------ LATE REFLECTIONS NETWORK 2-
    freeverbtail2(seconds,absorb) = apf_section2
    with{
        in_router(a,b,c,d,e,f,g,h) = a, b, c, d, e, f, g, h;
        //process = in_router;

        // COMBS FILTER SECTION
        comb_section =
        lfbcf(1621, dect60(1621,seconds), absorb),
        lfbcf(1567, dect60(1567,seconds), absorb),
        lfbcf(1499, dect60(1499,seconds), absorb),
        lfbcf(1433, dect60(1433,seconds), absorb),
        lfbcf(1283, dect60(1283,seconds), absorb),
        lfbcf(1373, dect60(1373,seconds), absorb),
        lfbcf(1187, dect60(1187,seconds), absorb),
        lfbcf(1123, dect60(1123,seconds), absorb);
        //process = comb_section;

        out_router(a,b,c,d,e,f,g,h) = a+b+c+d+e+f+g+h;
        //process = out_router;

        combsrouting =  early_reflections2 
        <: in_router : comb_section :> out_router;
        //process = input;

        apf_section2 = combsrouting : 
        apf(227, 0.5) : apf(557, 0.5) : 
        apf(433, 0.5) : apf(353, 0.5);
        //process = apf_section;
    };
// ----------------------------------------

// ------------ OUT PATH ------------------
freeverb1(t60,lowcut) = _ <: freeverbtail1(t60,lowcut) 
+ early_reflections1;
freeverb2(t60,lowcut) = _ <: freeverbtail2(t60,lowcut) 
+ early_reflections2;
process = _ *(gaincontrol*0.04) <: 
freeverb1(t60control,lowcutcontrol),
freeverb2(t60control,lowcutcontrol);
