// Importo libreria standard di FAUST
import("stdfaust.lib");

// ----------------------------------------
// EARLY REFLECTIONS (PRIME RIFLESSIONI)
// ----------------------------------------


/* 

Simulazione di Riverbero secondo il modello di James A. Moorer
il punto sorgente che coincide col punto di ascolto:

in una stanza: 10metri x 5metri x 3metri.

Ascoltatore/Sorgente posto al centro delle grandezze.
Velocità del suono in aria a 20° : 343,1 METRI al SECONDO

parete frontale a     5,0 METRI circa
parete posteriore a   5,0 METRI circa
parete sinistra a     2,5 METRI circa
parete destra a       2,5 METRI circa
soffitto a            1,5 METRI circa
pavimento a           1,5 METRI circa

*/


// MOORER REVERB
moorer_reverb(gainearlyreflections, lowpasscut, duratadecay) = reverbout
    // MOORER REVERB include al suo interno:
    with{

// STANZA : 10metri x 5metri x 3metri.
// ----------------------------------------
        /* 
        6 EARLY REFLECTIONS
        6 prime riflessioni per simulare il tempo di ritorno del suono da:
        4 muri laterali, soffitto e pavimento.
        */

        // tempo riflessione della parete frontale:             29.1460216 ms.
        paretefrontale = _ * gainearlyreflections : @((ma.SR / 1000.) * 29.1460216);

        // tempo riflessione della parete posteriore:           29.0000000 ms.
        pareteposteriore = _ * gainearlyreflections : @((ma.SR / 1000.) * 29.0000000);

        // tempo riflessione della parete sinistra:             14.5730108 ms.
        paretesinistra = _ * gainearlyreflections : @((ma.SR / 1000.) * 14.5730108);

        // tempo riflessione della parete destra:               14.0000000 ms.
        paretedestra = _ * gainearlyreflections : @((ma.SR / 1000.) * 14.0000000);

        // tempo riflessione soffitto:                          8.00000000 ms.
        soffitto = _ * gainearlyreflections : @((ma.SR / 1000.) * 8.00000000);

        // tempo riflessione pavimento:                         8.74380648 ms.
        pavimento = _ * gainearlyreflections : @((ma.SR / 1000.) * 8.74380648);


        // uscita delle prime riflessioni
        primeriflessioniout =   _ * gainearlyreflections
                                + paretefrontale + pareteposteriore 
                                + paretesinistra + paretedestra 
                                + soffitto + pavimento;
        

// ----------------------------------------
    /* 
    6 FILTRI COMB CON LOWPASS IIR DEL PRIMO ORDINE
    (lowpass per simulare assorbimento frequenze alte dell'aria)
    i ritardi dei ricircoli sono gli stessi delle prime riflessioni
    */

    // Filtro Lowpass (Onepole Filter) : parete frontale
    onepolefrontale = _*lowpasscut : +~(_ : *(1- lowpasscut));
    // Filtro Comb con Lowpass nella retroazione : parete frontale
    combfrontale = primeriflessioniout*0.1 : +~(_@((ma.SR / 1000.) * 29.1460216) : 
    * (duratadecay) : onepolefrontale);

    // Filtro Lowpass (Onepole Filter) : parete posteriore
    onepoleposteriore = _*lowpasscut : +~(_ : *(1- lowpasscut));
    // Filtro Comb con Lowpass nella retroazione : parete posteriore
    combposteriore = primeriflessioniout*0.1 : +~(_@((ma.SR / 1000.) * 29.0) : 
    * (duratadecay) : onepoleposteriore);

    // Filtro Lowpass (Onepole Filter) : parete sinistra
    onepolesinistra = _*lowpasscut : +~(_ : *(1- lowpasscut));
    // Filtro Comb con Lowpass nella retroazione : parete sinistra
    combsinistra = primeriflessioniout*0.1 : +~(_@((ma.SR / 1000.) * 14.5730108) : 
    * (duratadecay) : onepolesinistra);

    // Filtro Lowpass (Onepole Filter) : parete destra
    onepoledestra = _*lowpasscut : +~(_ : *(1- lowpasscut));
    // Filtro Comb con Lowpass nella retroazione : parete destra
    combdestra = primeriflessioniout*0.1 : +~(_@((ma.SR / 1000.) * 14.0) : 
    * (duratadecay) : onepoledestra);

    // Filtro Lowpass (Onepole Filter) : pavimento
    onepolepavimento = _*lowpasscut : +~(_ : *(1- lowpasscut));
    // Filtro Comb con Lowpass nella retroazione : pavimento
    combpavimento = primeriflessioniout*0.1 : +~(_@((ma.SR / 1000.) * 8.74380648) : 
    * (duratadecay) : onepolepavimento);

    // Filtro Lowpass (Onepole Filter) : soffitto
    onepolesoffitto = _*lowpasscut : +~(_ : *(1- lowpasscut));
    // Filtro Comb con Lowpass nella retroazione : soffitto
    combsoffitto = primeriflessioniout*0.1 : +~(_@((ma.SR / 1000.) * 8.0) : 
    * (duratadecay) : onepolesoffitto);


    outcombs = combfrontale + combposteriore + 
                combsinistra + combdestra +
                combpavimento + combsoffitto;


// ----------------------------------------
    /* 
    ALLPASS DOPO I 6 COMB
    */
        allpass = outcombs : 
        (+ : _ <: @((ma.SR / 1000.) * 6.0), *(0.7)) ~ 
        *(-0.7) : mem, _ : + : _;

        reverbout = primeriflessioniout + allpass;

};


// uscita con il process:
// viene usato il segnale in ingresso per testare 
// moorer_reverb(gainearlyreflections, lowpasscut, duratadecay)
process = _ <: moorer_reverb(0.5, 0.64, 0.992), moorer_reverb(0.5, 0.62, 0.993);