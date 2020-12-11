// Importo libreria standard di FAUST
import("stdfaust.lib");

// ----------------------------------------
// RIVERBERO DI CHAMBERLIN 
// con MODIFICA controllo del decadimento
// ----------------------------------------


/* 
Controlli del filtro:
filtergain = tempo di decadimento del riverbero
            (gain IIR & FIR del filtro) tra 0.min e 1.max
*/

// RIVERBERO DI ALLPASS DI HAL CHAMBERLIN
charmberlindecayfixreverb(filtergain, reverbgain) = charmberlinleftout, charmberlinrightout
    // allpassfilter include al suo interno:
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


        // TRE ALLPASS IN SERIE

        allpassuno = _ * reverbgain:
        (+ : _ <: @((ma.SR / 1000.) * 49.600), *(-filtergain)) ~ 
        *(filtergain) : mem, _ : + : _; 

        allpassdue = allpassuno : 
        (+ : _ <: @((ma.SR / 1000.) * 34.650), *(-filtergain)) ~ 
        *(filtergain) : mem, _ : + : _; 

        allpasstre = allpassdue :
        (+ : _ <: @((ma.SR / 1000.) * 24.180), *(-filtergain)) ~ 
        *(filtergain) : mem, _ : + : _;



        // USCITE L & R.
        // DUE SEZIONI IN PARALLELO DI DUE ALLPASS IN SERIE

        // chamberlin L reverb include al suo interno:
        riverberoleftuno = allpasstre :
        (+ : _ <: @((ma.SR / 1000.) * 17.850), *(-filtergain)) ~ 
        *(filtergain) : mem, _ : + : _;

        riverberoleftdue = riverberoleftuno :
        (+ : _ <: @((ma.SR / 1000.) * 10.980), *(-filtergain)) ~ 
        *(filtergain) : mem, _ : + : _;

        charmberlinleftout = riverberoleftdue;


        // chamberlin R reverb include al suo interno:
        riverberorightuno = allpasstre :
        (+ : _ <: @((ma.SR / 1000.) * 18.010), *(-filtergain)) ~ 
        *(filtergain) : mem, _ : + : _;

        riverberorightdue = riverberorightuno :
        (+ : _ <: @((ma.SR / 1000.) * 10.820), *(-filtergain)) ~ 
        *(filtergain) : mem, _ : + : _;

        charmberlinrightout = riverberorightdue;


};


// uscita con il process:
// viene usato il segnale in ingresso per testare 
// il riverbero digitale in uscita
// controllo dell'ampiezza del riverbero , e gain.
process = charmberlindecayfixreverb(0.90, 1.);
