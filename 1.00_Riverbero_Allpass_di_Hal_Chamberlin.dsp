// Importo libreria standard di FAUST
import("stdfaust.lib");

// ----------------------------------------
// RIVERBERO DI CHAMBERLIN
// ----------------------------------------
// High-quality stereo reverberator
// in libro di Hal Chamberlin:
// Musical Applications of Microprocessor
// ----------------------------------------


/* 
Controlli del filtro:
delaysamples = campioni di ritardo IIR & FIR
filtergain = gain IIR & FIR del filtro
outgain = gain generale all'uscita del filtro
*/

// FILTRO ALLPASS di CHAMBERLIN
charmberlinallpass(delayinms, filtergain, ingain) = allpassout
    // allpassfilter include al suo interno:
    with{

        /* 
        Conversione Campioni in ms. :
        inserisco il tempo in Millisecondi 
        e la funzione mi tira fuori il valore in campioni
        */
        delaysamples = (ma.SR / 1000.) * delayinms;


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

        allpassout = _ * ingain :
        (+ : _ <: @(delaysamples), *(-filtergain)) ~ 
        *(filtergain) : mem, _ : + : _;

        };


// SEZIONE DI TRE ALLPASS
charmberlintreallpass(ingain2) = trepassout
    // chamberlin tre allpass include al suo interno:
    with{

        trepassout = 
        charmberlinallpass(49.600, 0.750, ingain2) : 
        charmberlinallpass(34.650, 0.720, 1.) :
        charmberlinallpass(24.180, 0.691, 1.) ;

        };


// USCITE L & R.
// SEZIONI DI DUE ALLPASS IN PARALLELO e seguito dei TRE ALLPASS
charmberlinleftout(ingain3) = riverberoleft
    // chamberlin L reverb include al suo interno:
    with{

        riverberoleft = 
        charmberlintreallpass(ingain3) : 
        charmberlinallpass(17.850, 0.649, 1.) : 
        charmberlinallpass(10.980, 0.662, 1.) ;

        };

charmberlinrightout(ingain3) = riverberoright
    // chamberlin R reverb include al suo interno:
    with{

        riverberoright = 
        charmberlintreallpass(ingain3) : 
        charmberlinallpass(18.010, 0.646, 1.) : 
        charmberlinallpass(10.820, 0.666, 1.) ;

        };


// uscita con il process:
// viene usato il segnale in ingresso per testare 
// il riverbero digitale in uscita
// controllo dell'ampiezza del riverbero = (amp.)
process = charmberlinleftout(0.), charmberlinrightout(0.);
