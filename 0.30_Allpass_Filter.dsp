// Importo libreria standard di FAUST
import("stdfaust.lib");

// ----------------------------------------
// ALLPASS FILTER (FIR + IIR COMB FILTER)
// ----------------------------------------

/* 
Controlli del filtro:
delaysamples = campioni di ritardo IIR & FIR
filtergain = gain IIR & FIR del filtro
outgain = gain generale all'uscita del filtro
*/

allpassfilter(delaysamples, filtergain, outgain) = allpassout
    // allpassfilter include al suo interno:
    with{

        /* 
        dalla somma (+ si passa : ad un cavo _ ed uno split <:
        poi
        @ritardo e gain, in retroazione ~ alla somma iniziale.

        filtergain controlla l'ampiezza dei due stati di guadagno, 
        che sono nel filtro lo stesso valore ma positivo e negativo,
        da una parte *-filtergain e da una parte *+filtergain.

        Nel feedback è già presente di default un campione di ritardo,
        ecco perché delaysamples-1.
        Per mantenere invece la soglia di ritardo del valore delaysamples,
        viene aggiunto un ritardo mem (del campione sottratto)
        in coda, prima della somma di uscita dell'allpass
        */

        allpass = 
        (+ : _ <: @(delaysamples-1), *(filtergain)) ~ 
        *(-filtergain) : mem, _ : + : _;

        allpassout = allpass * outgain;

};


// uscita con il process:
// viene usato il segnale in ingresso per testare il filtro in uscita
process = _ <: allpassfilter(4200, 0.9, 0.), allpassfilter(4000, 0.9, 0.);
