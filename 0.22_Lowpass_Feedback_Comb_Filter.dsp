// Importo libreria standard di FAUST
import("stdfaust.lib");

// ----------------------------------------
// FEEDBACK COMB LOWPASS FILTER (IIR di N° Ordine)
// ----------------------------------------


/* 
NO DIRECT SIGNAL LPFB-COMB
*/

    /* 
    come filtro comb, ma all'interno della retroazione,
    a seguito del feedback entra il segnale : nel onepole.
    L'onepole è un lowpass dove si può controllare il taglio 
    di frequenza tra 0. e 1. 
    Nel feedback è già presente di default un campione di ritardo,
    ecco perché delaysamples-1.
    */


// LPFBC(Del,CFG,FCut) = give: delay samps, feedback gain 0-1, lowpass Freq.Cut HZ
LPFBC(Del,CFG,FCut) = lfbcf
with{
    G(x) = x / (1.0 + x);
    CF(x) = tan(x * ma.PI / ma.SR):G;
    lfbcf(x) = x:(+ :@(Del-1) :_*(FCut:CF): +~(_ :*(1-(FCut:CF))))~ *(CFG):mem;
}; 

// out
process = LPFBC(2000, 0.99999, 10000);
