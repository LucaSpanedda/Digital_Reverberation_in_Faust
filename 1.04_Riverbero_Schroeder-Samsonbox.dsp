// Importo libreria standard di FAUST
import("stdfaust.lib");

// ----------------------------------------
// SCHROEDER SAMSON BOX REVERBERATOR
// ----------------------------------------



/* 
Simulazione di Riverbero secondo il modello della 
Samson Box - 1977 CCRMA.
Modello SATREV, basato sul modello riverberante di Schroeder.
3 Allpass in serie e 4 Comb IIR Paralleli.
*/


// SCHROEDER REVERB IN SAMSON BOX IMPLEMENTATION

schroedersamson(gain_input) = schroedersamsonout
// schroedersamson include al suo interno:
    with{

        // ----------------------------------------
        /* 
        3 ALLPASS IN SERIE PRIMA DEI COMB
        */

        // Input segnale e controllo gain
        ingressosegnale = _*gain_input;

        allpassuno = ingressosegnale : 
        (+ : _ <: @(1051 -1), *(-0.7)) ~ *(0.7) : mem, _ : + : _;

        allpassdue = allpassuno : 
        (+ : _ <: @(337 -1), *(-0.7)) ~ *(0.7) : mem, _ : + : _;

        allpasstre = allpassdue : 
        (+ : _ <: @(113 -1), *(-0.7)) ~ *(0.7) : mem, _ : + : _;

        allpassout = allpasstre;


    // ----------------------------------------
    /* 
    4 FILTRI COMB PARALLELI DOPO GLI ALLPASS
    */

    // Filtro Comb 
    combuno = allpassout: +~(_@(4799 -1) : *(0.742)) : mem;

    // Filtro Comb 
    combdue = allpassout: +~(_@(4999 -1) : *(0.733)) : mem;

    // Filtro Comb 
    combtre = allpassout: +~(_@(5399 -1) : *(0.715)) : mem;

    // Filtro Comb 
    combquattro = allpassout: +~(_@(5801 -1) : *(0.697)) : mem;


    combsparalleli = combuno + combdue + combtre + combquattro;
    schroedersamsonout = combsparalleli;

};

// Sarebbe necessario decorrelare in uscita le somme dei comb
// per avere un buon effetto spaziale.
// nel modello originale è incluso un mixer con 4 differenti uscite
// che hanno 4 differenti linee di ritardo, che sono :
// A = z-0.046fs
// B = z-0.057fs
// C = z-0.041fs
// D = z-0.054fs


// uscita con il process con controllo gain:
// viene usato il segnale in ingresso per testare.
process = os.impulse <: schroedersamson(0.2), 
                schroedersamson(0.2);
