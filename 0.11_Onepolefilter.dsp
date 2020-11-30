// Importo libreria standard di FAUST
import("stdfaust.lib");

// ----------------------------------------
// ONEPOLE FILTER (IIR di I° Ordine)
// ----------------------------------------

/* 
Controlli del filtro:
feedback = gain della retroazione col ritardo
outgain = gain generale all'uscita del filtro 
*/

onepolefilter(feedback, outgain) = onepoleout
// onepolefilter include al suo interno:
with{

    /* 
    +~ è il sommatore, e la retroazione 
    degli argomenti dentro parentesi ()
    _ è il segnale in ingresso, (_ rappresentazione segnale)
    in ritardo di un campione _ (in automatico nella retroazione)
    che entra : nel gain del controllo della retroazione * 1-feedback
    lo stesso feedback controlla l'amplificazione in ingresso
    del segnale non iniettato nella retroazione
    c'è un controllo di ampiezza generale * outgain
    sulla funzione in uscita onezeroout
    */

    onepolefunction = _*feedback : +~(_ : *(1- feedback));
    onepoleout = onepolefunction * outgain;
    
};


// uscita con il process:
// viene usato un noise per testare il filtro in questa uscita
process = no.noise <: onepolefilter(0.005, 0.), //out 1
			onepolefilter(0.005, 0.); //out 2
