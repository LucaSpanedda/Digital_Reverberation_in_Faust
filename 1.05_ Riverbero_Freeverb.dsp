// Importo libreria standard di FAUST
import("stdfaust.lib");

// ----------------------------------------
// FREEVERB di Jezar at Dreampoint
// ----------------------------------------



/* 
Simulazione di Riverbero secondo il modello di Jezar at Dreampoint.
Utilizza 4 Allpass di Schroeder in serie, 
ed 8 Schroeder-Moorer Filtered-feedback comb-filters in parallelo.
*/


// FREEVERB

freeverbjezar(gain_input, lowpasscut, duratadecay) = freeverbout
// freeverbjezar include al suo interno:
    with{

    // ----------------------------------------
    /* 
    8 FILTRI COMB PARALLELI CON LOWPASS IIR DEL PRIMO ORDINE
    (lowpass per simulare assorbimento frequenze alte dell'aria)
    */

    // Input segnale e controllo gain
    ingressosegnale = _*gain_input;

    // Filtro Lowpass (Onepole Filter) 
    onepoleuno = _*lowpasscut : +~(_ : *(1- lowpasscut));
    // Filtro Comb con Lowpass nella retroazione 
    combuno = ingressosegnale: +~(_@(1557 -1) : 
    * (duratadecay) : onepoleuno) : mem;

    // Filtro Lowpass (Onepole Filter) 
    onepoledue = _*lowpasscut : +~(_ : *(1- lowpasscut));
    // Filtro Comb con Lowpass nella retroazione 
    combdue = ingressosegnale: +~(_@(1617 -1) : 
    * (duratadecay) : onepoledue) : mem;

    // Filtro Lowpass (Onepole Filter) 
    onepoletre = _*lowpasscut : +~(_ : *(1- lowpasscut));
    // Filtro Comb con Lowpass nella retroazione 
    combtre = ingressosegnale: +~(_@(1491 -1) : 
    * (duratadecay) : onepoletre) : mem;

    // Filtro Lowpass (Onepole Filter) 
    onepolequattro = _*lowpasscut : +~(_ : *(1- lowpasscut));
    // Filtro Comb con Lowpass nella retroazione 
    combquattro = ingressosegnale: +~(_@(1422 -1) : 
    * (duratadecay) : onepolequattro) : mem;

    // Filtro Lowpass (Onepole Filter) 
    onepolecinque = _*lowpasscut : +~(_ : *(1- lowpasscut));
    // Filtro Comb con Lowpass nella retroazione 
    combcinque = ingressosegnale: +~(_@(1277 -1) : 
    * (duratadecay) : onepolecinque) : mem;

    // Filtro Lowpass (Onepole Filter) 
    onepolesei = _*lowpasscut : +~(_ : *(1- lowpasscut));
    // Filtro Comb con Lowpass nella retroazione 
    combsei = ingressosegnale: +~(_@(1356 -1) : 
    * (duratadecay) : onepolesei) : mem;

    // Filtro Lowpass (Onepole Filter) 
    onepolesette = _*lowpasscut : +~(_ : *(1- lowpasscut));
    // Filtro Comb con Lowpass nella retroazione 
    combsette = ingressosegnale: +~(_@(1188 -1) : 
    * (duratadecay) : onepolesette) : mem;

    // Filtro Lowpass (Onepole Filter) 
    onepoleotto = _*lowpasscut : +~(_ : *(1- lowpasscut));
    // Filtro Comb con Lowpass nella retroazione 
    combotto = ingressosegnale: +~(_@(1116 -1) : 
    * (duratadecay) : onepoleotto) : mem;


    combsparalleli = combuno + combdue + combtre + combquattro
                    + combcinque + combsei + combsette + combotto;


        // ----------------------------------------
        /* 
        4 ALLPASS IN SERIE DOPO I COMB
        */

        allpassuno = combsparalleli : 
        (+ : _ <: @(225 -1), *(-0.5)) ~ *(0.5) : mem, _ : + : _;

        allpassdue = allpassuno : 
        (+ : _ <: @(556 -1), *(-0.5)) ~ *(0.5) : mem, _ : + : _;

        allpasstre = allpassdue : 
        (+ : _ <: @(441 -1), *(-0.5)) ~ *(0.5) : mem, _ : + : _;

        allpassquattro = allpasstre : 
        (+ : _ <: @(341 -1), *(-0.5)) ~ *(0.5) : mem, _ : + : _;

        freeverbout = allpassquattro;

};



// uscita con il process:
// viene usato il segnale in ingresso per testare.
// freeverbjezar(gain segnale input, taglio filtro lowpass, decadimento)
process = _ <: freeverbjezar(0.2, 0.2, 0.84), 
                freeverbjezar(0.2, 0.2, 0.84);
