// Importo libreria standard di FAUST
import("stdfaust.lib");

// ----------------------------------------
// SCHROEDER-CHOWNING SATREV REVERBERATOR
// ----------------------------------------



/* 
Simulazione di Riverbero secondo il modello di John Chowning.
Modello SATREV, basato sul modello riverberante di Schroeder.
4 Comb IIR Paralleli e 3 Allpass in serie.
*/


// SCHROEDER REVERB IN JOHN CHOWNING IMPLEMENTATION

schroederchowning(gain_input) = schroederchowningout
// schroederchowning include al suo interno:
    with{

    // ----------------------------------------
    /* 
    4 FILTRI COMB PARALLELI 
    */

    // Input segnale e controllo gain
    ingressosegnale = _*gain_input;

    // Filtro Comb 
    combuno = ingressosegnale: +~(_@(901 -1) : *(0.805)) : mem;

    // Filtro Comb 
    combdue = ingressosegnale: +~(_@(778 -1) : *(0.827)) : mem;

    // Filtro Comb 
    combtre = ingressosegnale: +~(_@(1011 -1) : *(0.783)) : mem;

    // Filtro Comb 
    combquattro = ingressosegnale: +~(_@(1123 -1) : *(0.764)) : mem;


    combsparalleli = combuno + combdue + combtre + combquattro;


        // ----------------------------------------
        /* 
        3 ALLPASS IN SERIE DOPO I COMB
        */

        allpassuno = combsparalleli : 
        (+ : _ <: @(125 -1), *(-0.7)) ~ *(0.7) : mem, _ : + : _;

        allpassdue = allpassuno : 
        (+ : _ <: @(42 -1), *(-0.7)) ~ *(0.7) : mem, _ : + : _;

        allpasstre = allpassdue : 
        (+ : _ <: @(12 -1), *(-0.7)) ~ *(0.7) : mem, _ : + : _;

        schroederchowningout = allpasstre;

};



// uscita con il process con controllo gain:
// viene usato il segnale in ingresso per testare.
process = os.impulse <: schroederchowning(0.2), 
                schroederchowning(0.2);
