// Importo libreria standard di FAUST
import("stdfaust.lib");

// ----------------------------------------
// RIVERBERO DI ALLPASS DI GIRI E CIPRIANI
// ----------------------------------------


/* 
Controlli del filtro:
filtergain = tempo di decadimento del riverbero
            (gain IIR & FIR del filtro) tra 0.min e 1.max
*/

// RIVERBERO DI ALLPASS DI GIRI E CIPRIANI
girieciprianireverb(filtergain, reverbgain) = riverberoleft, riverberoright
    // girieciprianireverb include al suo interno:
    with{

        /* 
        Conversione Campioni in millisecondi: 
        samples ritardo = (ma.SR / 1000.) * ritardo espresso in ms.
        inserisco il tempo in Millisecondi 
        e la funzione mi tira fuori il valore in campioni
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


        allpassuno = _ * reverbgain :
        (+ : _ <: @(((ma.SR / 1000.) * 49.960)-1), *(-filtergain)) ~ 
        *(filtergain) : mem, _ : + : _;

        allpassdue = allpassuno :
        (+ : _ <: @(((ma.SR / 1000.) * 54.650)-1), *(-filtergain)) ~ 
        *(filtergain) : mem, _ : + : _;

        allpasstre = allpassdue :
        (+ : _ <: @(((ma.SR / 1000.) * 24.180)-1), *(-filtergain)) ~ 
        *(filtergain) : mem, _ : + : _;


        // USCITE L & R.
        // SEZIONI DI DUE ALLPASS IN PARALLELO e seguito dei TRE ALLPASS
        riverberoleft = allpasstre :
        (+ : _ <: @(((ma.SR / 1000.) * 17.850)-1), *(-filtergain)) ~ 
        *(filtergain) : mem, _ : + : _;

        riverberoright = allpasstre :
        (+ : _ <: @(((ma.SR / 1000.) * 17.950)-1), *(-filtergain)) ~ 
        *(filtergain) : mem, _ : + : _;

    };


// uscita con il process:
// viene usato il segnale in ingresso per testare 
// il riverbero digitale in uscita
// controllo dell'ampiezza del riverbero , e gain.
process = girieciprianireverb(0.9, 1.);
