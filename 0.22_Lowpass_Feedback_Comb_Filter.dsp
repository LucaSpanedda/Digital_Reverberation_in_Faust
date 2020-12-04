// Importo libreria standard di FAUST
import("stdfaust.lib");

// ----------------------------------------
// FEEDBACK COMB LOWPASS FILTER (IIR di N° Ordine)
// ----------------------------------------

/* 
Controlli del filtro:
delaysamples = campioni di ritardo nella retroazione
feedback = gain della retroazione col ritardo
outgain = gain generale all'uscita del filtro
lowpasscut = taglio frequenza tramite filtro onepole 
*/

combfeedbacklowpassfilter(delaysamples, feedback, outgain, lowpasscut) = combfeedblowout
// combfeedbacklowpassfilter include al suo interno:
with{

    /* 
    come filtro comb, ma all'interno della retroazione,
    a seguito del feedback entra il segnale : nel onepole.
    L'onepole è un lowpass dove si può controllare il taglio 
    di frequenza tra 0. e 1. 
    Nel feedback è già presente di default un campione di ritardo,
    ecco perché delaysamples-1.
    */

    // Filtro Lowpass (Onepole Filter)
    onepolefilter = _*lowpasscut : +~(_ : *(1- lowpasscut));

    // Filtro Comb con Lowpass nella retroazione --> (: onepolefilter)
    combfunction = +~(_@(delaysamples-1) : *(feedback) : onepolefilter);
    combfeedblowout = combfunction * outgain;

};


// uscita con il process:
// viene usato il segnale in ingresso per testare il filtro in uscita
process = _ <: combfeedbacklowpassfilter(4200, 0.98, 0., 0.15), //out 1
                        combfeedbacklowpassfilter(4000, 0.98, 0., 0.15); //out 2
