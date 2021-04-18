// Importo libreria standard di FAUST
import("stdfaust.lib");

// ----------------------------------------
// RIVERBERO DI MOORER
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
        Tutti i ritardi utilizzati vengono approssimati ad nel numero primo più vicino
        */

        // tempo riflessione della parete frontale, approssimazione a numero primo
        paretefrontale = _ * gainearlyreflections : @((ma.SR / 1000.) * 29.17);

        // tempo riflessione della parete posteriore, approssimazione a numero primo
        pareteposteriore = _ * gainearlyreflections : @((ma.SR / 1000.) * 29.09);

        // tempo riflessione della parete sinistra, approssimazione a numero primo
        paretesinistra = _ * gainearlyreflections : @((ma.SR / 1000.) * 14.59);

        // tempo riflessione della parete destra, approssimazione a numero primo
        paretedestra = _ * gainearlyreflections : @((ma.SR / 1000.) * 14.53);

        // tempo riflessione soffitto, approssimazione a numero primo
        soffitto = _ * gainearlyreflections : @((ma.SR / 1000.) * 8.731);

        // tempo riflessione pavimento, approssimazione a numero primo
        pavimento = _ * gainearlyreflections : @((ma.SR / 1000.) * 8.779);


        // uscita delle prime riflessioni
        primeriflessioni =   _ * gainearlyreflections
                                + paretefrontale + pareteposteriore 
                                + paretesinistra + paretedestra 
                                + soffitto + pavimento;
        

    // ----------------------------------------
    /* 
    6 FILTRI COMB CON LOWPASS IIR DEL PRIMO ORDINE
    (lowpass per simulare assorbimento frequenze alte dell'aria)
    i ritardi dei ricircoli sono gli stessi delle prime riflessioni.
    Tutti i ritardi nei comb tengono conto delle pareti e delle early reflections
    */

    // Filtro Lowpass (Onepole Filter) : parete frontale
    onepolefrontale = _*lowpasscut : +~(_ : *(1- lowpasscut));
    // Filtro Comb con Lowpass nella retroazione : parete frontale
    combfrontale = primeriflessioni : +~(_@(((ma.SR / 1000.) * 29.17)-1) : 
    * (duratadecay) : onepolefrontale) : mem;

    // Filtro Lowpass (Onepole Filter) : parete posteriore
    onepoleposteriore = _*lowpasscut : +~(_ : *(1- lowpasscut));
    // Filtro Comb con Lowpass nella retroazione : parete posteriore
    combposteriore = primeriflessioni : +~(_@(((ma.SR / 1000.) * 29.09)-1) : 
    * (duratadecay) : onepoleposteriore) : mem;

    // Filtro Lowpass (Onepole Filter) : parete sinistra
    onepolesinistra = _*lowpasscut : +~(_ : *(1- lowpasscut));
    // Filtro Comb con Lowpass nella retroazione : parete sinistra
    combsinistra = primeriflessioni : +~(_@(((ma.SR / 1000.) * 14.59)-1) : 
    * (duratadecay) : onepolesinistra) : mem;

    // Filtro Lowpass (Onepole Filter) : parete destra
    onepoledestra = _*lowpasscut : +~(_ : *(1- lowpasscut));
    // Filtro Comb con Lowpass nella retroazione : parete destra
    combdestra = primeriflessioni : +~(_@(((ma.SR / 1000.) * 14.53)-1) : 
    * (duratadecay) : onepoledestra) : mem;

    // Filtro Lowpass (Onepole Filter) : pavimento
    onepolepavimento = _*lowpasscut : +~(_ : *(1- lowpasscut));
    // Filtro Comb con Lowpass nella retroazione : pavimento
    combpavimento = primeriflessioni : +~(_@(((ma.SR / 1000.) * 8.731)-1) : 
    * (duratadecay) : onepolepavimento) : mem;

    // Filtro Lowpass (Onepole Filter) : soffitto
    onepolesoffitto = _*lowpasscut : +~(_ : *(1- lowpasscut));
    // Filtro Comb con Lowpass nella retroazione : soffitto
    combsoffitto = primeriflessioni : +~(_@(((ma.SR / 1000.) * 8.779)-1) : 
    * (duratadecay) : onepolesoffitto) : mem;


    outcombs = combfrontale + combposteriore + 
                combsinistra + combdestra +
                combpavimento + combsoffitto;


        // ----------------------------------------
        /* 
        ALLPASS DOPO I 6 COMB
        */
        allpassuno = outcombs : 
        (+ : _ <: @((ma.SR / 1000.) * 6.000 ), *(-0.7)) ~ *(0.7) : mem, _ : + : _;

        delaycoda = allpassuno : @((ma.SR / 1000.) * 8.731);

        reverbout = primeriflessioni + delaycoda;

};


// uscita con il process:
// viene usato il segnale in ingresso per testare.
// moorer_reverb(gainearlyreflections, lowpasscut, duratadecay)
process = os.impulse <: moorer_reverb(0.5, 0.7, 0.99), moorer_reverb(0.5, 0.7, 0.99);
