// Importo libreria standard di FAUST
import("stdfaust.lib");

// ----------------------------------------
// ONEZERO FILTER (FIR di I° Ordine)
// ----------------------------------------



/* 
Controlli del filtro:
filtergain = gain della sezione in ritardo
outgain = gain generale all'uscita del filtro 
*/

    /* 
    _ è il segnale in ingresso, (_ rappresentazione segnale)
    viene a seguito diviso in due percorsi paralleli <: 
    uno in ritardo di un campione _' (' segna il ritardo di un sample)
    e uno senza ritardo , _ (, segna il passaggio al secondo percorso)
    vengono poi risommati in un segnale unico :> _ ;

    il segnale in ritardo di un campione 
    ha un controllo di ampiezza * feedforward

    c'è un controllo di ampiezza generale * outgain
    sulla funzione in uscita onezeroout
    */

   onezerofilter(feedforward, outgain) = _ <: ( _' * feedforward ), _ :> + : *(outgain);

// uscita con il process:
// viene usato un noise per testare il filtro in questa uscita
process = no.noise : onezerofilter(1, 0.1) <: _,_;
