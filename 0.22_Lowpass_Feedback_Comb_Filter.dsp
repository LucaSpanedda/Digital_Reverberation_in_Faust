// Importo libreria standard di FAUST
import("stdfaust.lib");

// ----------------------------------------
// FEEDBACK COMB LOWPASS FILTER (IIR di N° Ordine)
// ----------------------------------------



/* 
Controlli del filtro:
delaysamples = campioni di ritardo nella retroazione
feedback = gain della retroazione col ritardo
lowpasscut = taglio frequenza tramite filtro onepole 
*/

    /* 
    come filtro comb, ma all'interno della retroazione,
    a seguito del feedback entra il segnale : nel onepole.
    L'onepole è un lowpass dove si può controllare il taglio 
    di frequenza tra 0. e 1. 
    Nel feedback è già presente di default un campione di ritardo,
    ecco perché delaysamples-1.
    */

// (t,g,cut) = give: delay samps, feedback gain 0-1, lowpass cut 1-0(open-close)
lfbcf(t,g,cut) = (+ : @(t-1) : _*cut : +~(_ : *(1-cut)))~ *(g) : mem;
        
// uscita con il process:
process = os.impulse : lfbcf(3000, 0.999, 0.2) <:_,_;
