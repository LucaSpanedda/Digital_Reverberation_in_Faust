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

    // LOWPASS FEEDBACK COMB FILTER 
    lfbcf(delsamps, g, lowcut) = 
    // lfbcf(delay in samples, comb filter gain, lowcut)
    (+ : @(delsamps-1) : _*lowcut : +~(_ : *(1- lowcut)))~ *(g) : mem;
    // process = _ : lfbcf(3000, 0.999, 0.2) <:_,_;
        
// uscita con il process:
// viene usato il segnale in ingresso per testare il filtro in uscita
process = os.impulse : lfbcf(3000, 0.999, 0.2) <:_,_;
