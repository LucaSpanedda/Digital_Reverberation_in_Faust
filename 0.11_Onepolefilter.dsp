// Importo libreria standard di FAUST
import("stdfaust.lib");

// ----------------------------------------
// ONEPOLE FILTER (IIR di I° Ordine)
// ----------------------------------------


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

// (G)  = give amplitude 1-0 (open-close) for the lowpass cut
// (CF) = Frequency Cut in HZ
OPF(CF,x) = OPFFBcircuit ~ _ 
    with{
        g(x) = x / (1.0 + x);
        G = tan(CF * ma.PI / ma.SR):g;
        OPFFBcircuit(y) = x*G+(y*(1-G));
        };

process = OPF(20000) <: _,_;
