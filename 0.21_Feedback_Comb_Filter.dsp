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
    
    // FEEDBACK COMB FILTER 
    feedbckcombfilter(delsamps, g) = 
    // feedbckcombfilter(delay in samples, comb filter gain)
    _ : (+  @(delsamps-1)~ *(g)) : mem;
    // process = os.impulse : feedbckcombfilter(4481, 0.9) <: _,_;

// uscita con il process:
// viene usato il segnale in ingresso per testare il filtro in uscita
process = os.impulse : feedbckcombfilter(4481, 0.9) <: _,_;
