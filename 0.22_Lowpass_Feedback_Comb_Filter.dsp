// Importo libreria standard di FAUST
import("stdfaust.lib");

// ----------------------------------------
// FEEDBACK COMB FILTER (IIR di N° Ordine)
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
    */

    // Filtro Lowpass (Onepole Filter)
    onepolefilter = _*lowpasscut : +~(_ : *(1- lowpasscut));

    // Filtro Comb con Lowpass nella retroazione --> (: onepolefilter)
    combfunction = +~(_@(delaysamples) : *(feedback) : onepolefilter);
    combfeedblowout = combfunction * outgain;

};


// uscita con il process:
// viene usato un noise per testare il filtro in questa uscita
process = no.noise <: combfeedbacklowpassfilter(400, 0.9, 0., 0.1), //out 1
                        combfeedbacklowpassfilter(400, 0.9, 0., 0.1); //out 2
