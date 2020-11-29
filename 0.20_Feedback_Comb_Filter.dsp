// Importo libreria standard di FAUST
import("stdfaust.lib");

// ----------------------------------------
// FASTFORWARD COMB FILTER (FIR di N° Ordine)
// ----------------------------------------

/* 
Controlli del filtro:
delaysamples = campioni di ritardo nel fastforward
feedback = gain della retroazione col ritardo
outgain = gain generale all'uscita del filtro 
*/

combfastforwardfilter(delaysamples, feedforward, outgain) = combfastout
// combfastforwardfilter include al suo interno:
with{

    /* 
    _ è il segnale in ingresso, (_ rappresentazione segnale)
    viene a seguito diviso in due percorsi paralleli <: 
    uno in ritardo di @(delaysamples) campioni
    (dunque valore da passare esternamente)
    e uno senza ritardo , _ (, segna il passaggio al secondo percorso)
    vengono poi risommati in un segnale unico :> _ ;

    il segnale in ritardo di un campione 
    ha un controllo di ampiezza * feedforward

    c'è un controllo di ampiezza generale * outgain
    sulla funzione in uscita onezeroout
    */

   combfastfunction = _ <: ( _@(delaysamples) * feedforward ), _ :> _ ;
   combfastout = combfastfunction * outgain;

};


// uscita con il process:
// viene usato un noise per testare il filtro in questa uscita
process = no.noise <: combfastforwardfilter(100, 0.9, 0.), //out 1
					  combfastforwardfilter(100, 0.9, 0.); //out 2