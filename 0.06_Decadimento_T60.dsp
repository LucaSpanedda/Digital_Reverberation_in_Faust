// Importo libreria standard di FAUST
import("stdfaust.lib");

// ----------------------------------------
// DECADIMENTO DELAY IN TEMPO T60
// ----------------------------------------


/* 
Inserisci all'interno degli argomenti della funzione:

    - il valore in millisecondi del filtro 
    che stai usando per il ritardo.

    - il valore di decadimento in T60
    (tempo di decadimento di 60 dB in secondi)

    = OTTIENI in uscita dalla funzione, 
    il valore che devi passare come amplificazione
    alla retroazione del filtro per ottenere
    il tempo di decadimento T60 che si desidera
*/


decadimentot60(delay_millisecondi_filtro, secondi_decayt60_desiderati) = outdecayt60
// decadimentot60 include al suo interno:
with{

    // delay del filtro in ms.
    delfiltroinms = delay_millisecondi_filtro/1000;
    // 3 * delaydelfiltro / T60 desiderato
    esponente = (3*delfiltroinms)/secondi_decayt60_desiderati;
    // 10 alla -esponente
    outdecayt60 = 1/(10^esponente);

};


// tempo in ms ritardo, tempo T60 desiderato.
process = decadimentot60(51, 10);
