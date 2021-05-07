// Importo libreria standard di FAUST
import("stdfaust.lib");

// ----------------------------------------
// DECADIMENTO DELAY IN TEMPO T60
// ----------------------------------------


/* 
Inserisci all'interno degli argomenti della funzione:

    - il valore in campioni del filtro 
    che stai usando per il ritardo.

    - il valore di decadimento in T60
    (tempo di decadimento di 60 dB in secondi)

    = OTTIENI in uscita dalla funzione, 
    il valore che devi passare come amplificazione
    alla retroazione del filtro per ottenere
    il tempo di decadimento T60 che si desidera
*/

// (samps,seconds) = give: samples of the filter, seconds we want for t60 decay
dect60(samps,seconds) = 1/(10^((3*(((1000 / ma.SR)*samps)/1000))/seconds));


process = _;
