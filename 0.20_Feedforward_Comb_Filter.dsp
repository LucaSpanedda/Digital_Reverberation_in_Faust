// Importo libreria standard di FAUST
import("stdfaust.lib");

// ----------------------------------------
// FEEDFORWARD COMB FILTER (FIR of N° Order)
// ----------------------------------------

/* 
Controlli del filtro:
delaysamples = campioni di ritardo nel fastforward
feedback = gain della retroazione col ritardo
outgain = gain generale all'uscita del filtro 
*/

    /* 
    _ è il segnale in ingresso, (_ rappresentazione segnale)
    viene a seguito diviso in due percorsi paralleli <: 
    uno in ritardo di @(delaysamples) campioni
    (dunque valore da passare esternamente)
    e uno senza ritardo , _ (, segna il passaggio al secondo percorso)
    vengono poi risommati in un segnale unico :> _ ;
    
    Nel feedback è già presente di default un campione di ritardo,
    ecco perché delaysamples-1.
    
    il segnale in ritardo di un campione 
    ha un controllo di ampiezza * feedforward

    c'è un controllo di ampiezza generale * outgain
    sulla funzione in uscita onezeroout
    */

// (t,g) = delay time in samples, filter gain 0-1
ffcf(t,g) = _ <: ( _@(t-1) *g), _ :> _;

// uscita con il process:
// viene usato un noise per testare il filtro in questa uscita
process = no.noise : ffcf(100, 0.9) <: _,_;
