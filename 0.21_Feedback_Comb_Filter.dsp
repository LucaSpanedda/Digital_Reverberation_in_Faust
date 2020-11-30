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
    
    Nel feedback è già presente di default un campione di ritardo,
    ecco perché delaysamples-1.
    
    c'è un controllo di ampiezza generale * outgain
    sulla funzione in uscita combfeedbout
    */

    combfunction = +~(_@(delaysamples-1) : *(feedback));
    combfeedbout = combfunction * outgain;
    
};


// uscita con il process:
// viene usato il segnale in ingresso per testare il filtro in uscita
process = _ <: combfeedbackfilter(3400, 0.92, 0.4), //out 1
			combfeedbackfilter(3200, 0.92, 0.4); //out 2
