// Importo libreria standard di FAUST
import("stdfaust.lib");

// ----------------------------------------
// EARLY REFLECTIONS (PRIME RIFLESSIONI)
// ----------------------------------------


/* 
Simulazione delle prime riflessioni in una stanza con
il punto sorgente che coincide col punto di ascolto:
Stanza: 10metri x 5metri x 3metri
Ascoltatore/Sorgente posto al centro delle grandezze.
Velocità del suono in aria a 20° : 343,1 METRI al SECONDO

parete frontale a     5,0 METRI circa
parete posteriore a   5,0 METRI circa
parete sinistra a     2,5 METRI circa
parete destra a       2,5 METRI circa
soffitto a            1,5 METRI circa
pavimento a           1,5 METRI circa
*/


// PRIME RIFLESSIONI
earlyreflections(earlyreflectgain) = primeriflessioniout
    // earlyreflections include al suo interno:
    with{

        /* 
        Conversione Campioni in ms. :
        inserisco il tempo in Millisecondi 
        e la funzione mi tira fuori il valore in campioni:
        delaysamples = (ma.SR / 1000.) * delayinms;
        */

        // tempo riflessione della parete frontale:             29.1460216 ms.
        paretefrontale = _ * earlyreflectgain : @((ma.SR / 1000.) * 29.1460216);

        // tempo riflessione della parete posteriore:           29.0000000 ms.
        pareteposteriore = _ * earlyreflectgain : @((ma.SR / 1000.) * 29.0000000);

        // tempo riflessione della parete sinistra:             14.5730108 ms.
        paretesinistra = _ * earlyreflectgain : @((ma.SR / 1000.) * 14.5730108);

        // tempo riflessione della parete destra:               14.0000000 ms.
        paretedestra = _ * earlyreflectgain : @((ma.SR / 1000.) * 14.0000000);

        // tempo riflessione soffitto:                          8.00000000 ms.
        soffitto = _ * earlyreflectgain : @((ma.SR / 1000.) * 8.00000000);

        // tempo riflessione pavimento:                         8.74380648 ms.
        pavimento = _ * earlyreflectgain : @((ma.SR / 1000.) * 8.74380648);


        // uscita delle prime riflessioni
        primeriflessioniout = _ + paretefrontale + pareteposteriore +
                                  paretesinistra + paretedestra +
                                  soffitto + pavimento;

};


// uscita con il process:
// viene usato il segnale in ingresso per testare 
// il riverbero digitale in uscita: input segnale su due canali out,
// controllo dell'ampiezza delle prime riflessioni.
process = _ <: earlyreflections(1.), earlyreflections(1.);
