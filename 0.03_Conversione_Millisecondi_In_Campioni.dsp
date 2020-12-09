// Importo libreria standard di FAUST
import("stdfaust.lib");

// ----------------------------------------
// CONVERSIONE CAMPIONI IN MILLISECONDI
// ----------------------------------------


/* 
Funzione Conversione Campioni in ms. :
inserisco il tempo in Millisecondi,
e la funzione mi tira fuori il valore in Campioni
*/

msacampioni(tempoinmillisecondi) = mscampioniout
// msacampioni include al suo interno:
with{

        mscampioniout = (ma.SR / 1000.) * tempoinmillisecondi;

};


process = _;