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
*/

combfeedbackfilter(delaysamples, feedback, outgain) = combfeedbout
// combfeedbackfilter include al suo interno:
with{

    /* 
    +~ è il sommatore, e la retroazione 
    degli argomenti dentro parentesi ()

    _ è il segnale in ingresso, (_ rappresentazione segnale)
    in ritardo di @(delaysamples) campioni 
    (dunque valore da passare esternamente)
    che entra : nel gain del controllo della retroazione * feedback

    c'è un controllo di ampiezza generale * outgain
    sulla funzione in uscita combfeedbout
    */

    combfunction = +~(_@(delaysamples) : *(feedback));
    combfeedbout = combfunction * outgain;
    
};


// uscita con il process:
// viene usato un noise per testare il filtro in questa uscita
process = no.noise <: combfeedbackfilter(100, 0.85, 0.), //out 1
					  combfeedbackfilter(100, 0.85, 0.); //out 2