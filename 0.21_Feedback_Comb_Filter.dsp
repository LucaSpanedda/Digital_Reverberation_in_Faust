// Importo libreria standard di FAUST
import("stdfaust.lib");

// ----------------------------------------
// FEEDBACK COMB FILTER (IIR di N° Ordine)
// ----------------------------------------


/* 
Controlli del filtro:
delaysamples = campioni di ritardo nella retroazione
feedback = gain della retroazione col ritardo
*/

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
    
// (Del,G) = DEL=delay time in samples. G=feedback gain 0-1
FBCF(Del,G,x) = x:(+ @(Del-1)~ *(G)):mem;

// Out
process = FBCF(4481,0.9);
