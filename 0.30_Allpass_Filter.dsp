// Importo libreria standard di FAUST
import("stdfaust.lib");

// ----------------------------------------
// ALLPASS FILTER (FIR + IIR COMB FILTER)
// ----------------------------------------


/* 
NO DIRECT SIGNAL APF
*/

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


// (t,g) = give: delay in samples, feedback gain 0-1
APF(Del,G,x) = x:(+: _<: @(Del-1), *(G))~ *(-G):mem, _ : + : _;

// out
process = APF(420, 0.9);
