// Importo libreria standard di FAUST
import("stdfaust.lib");

// ----------------------------------------
// CONVERSIONE CAMPIONI IN MILLISECONDI
// ----------------------------------------


/* 
Funzione Conversione Campioni in ms. :
inserisco il tempo in Millisecondi,
e la funzione mi tira fuori il valore in Campioni.

Ad esempio, se ho una frequenza di campionamento 
di 48.000 campioni al secondo, 
vuole dire che 1000ms (1 secondo) sono rappresentati
da 48.000 parti, e che quindi una singola unità
temporale come 1 ms. Corrisponde in digitale a 48 campioni.

Per questo motivo si divide la frequenza di campionamento
per 1000ms avendo dunque in risultato un tot. di campioni
che corrisponde ad 1 ms. nel mondo digitale ad 
una determinata frequenza di campionamento.

E poi si moltiplica il risultato di questa operazione
per il totale di ms. che vogliamo ottenere come 
rappresentazione in campioni.
Se moltiplico *10. Ad esempio avrò in uscita 
dalla funzione, 480 campioni ad una frequenza di campionamento 
di 48.000 campioni al secondo.
*/

msacampioni(tempoinmillisecondi) = mscampioniout
// msacampioni include al suo interno:
with{

        mscampioniout = (ma.SR / 1000.) * tempoinmillisecondi;

};


process = _;
