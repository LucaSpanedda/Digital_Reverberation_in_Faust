// Importo libreria standard di FAUST
import("stdfaust.lib");

// ----------------------------------------
// CALCOLO RIFLESSIONE da MURO
// ----------------------------------------
// imposto Metri distanza Parete e ricavo
// Ritardo della riflessione in Ms.
// ----------------------------------------



/* 
Velocità del suono in aria a 20° : 343,1 METRI al SECONDO

dunque per ricavare i diversi tempi di riflessione a diverse distanze
dobbiamo calcolare che se:
343,1 metri : 1000 millisecondi = determinati metri : ricavo tot. millisecondi

e dunque sviluppare la proporzione così :
millisecondi a parete = (1000 millisecondi * determinati metri)/ 343,1 metri


Una volta fatto questo avremo il tempo impiegato fino alla parete espresso in ms.
Se la sorgente coincide col punto di ascolto, vorrà dire che
il suono una volta arrivato alla parete sara riflesso ed impiegherà, 
lo stesso tempo a tornare al punto di origine, e dunque:

riflessione = millisecondi a parete *2

Facendo così avremo calcolato una riflessione sulla base di una distanza
*/


/* 
infine dobbiamo convertire i ms. ricavati in Campioni da inserire nella
linea di ritardo.

inserisco il tempo in Millisecondi 
e la funzione mi tira fuori il valore in campioni:
delaysamples = (ma.SR / 1000.) * delayinms;

*/

one_wall_reflection(metri_distanza_parete) = singola_riflessione
// singlereflection include al suo interno:
with{

    // --------------------------------------------------
    // CONVERSIONE DA METRI DISTANZA A CAMPIONI RITARDO PER IL DELAY
    // ms. a parete = (1000 millisecondi * determinati metri)/ 343,1m al sec. a 20°
    ms_parete = (1000 * metri_distanza_parete)/ 343.1; // CAMBIARE QUESTO NUMERO SE SI DEVE SOSTITUIRE LA COSTANTE m al sec. a 20°

    // tempo di ritorno della riflessione dalla parete alla sorgente
    riflessione_a_sorgente = ms_parete * 2;

    // ora ricaviamo dal valore in millisecondi della riflessione 
    // il corrispettivo tempo in campioni, basandoci sulla freq. di campionamento
    riflessione_in_campioni = (ma.SR / 1000.) * riflessione_a_sorgente;



// --------------------------------------------------
// LINEA DI RITARDO PER LA RIFLESSIONE DELLA PARETE
singola_riflessione = @(riflessione_in_campioni);

};



// Simulazione di alcune prime riflessioni in una stanza:
process =       _ <: 
                one_wall_reflection(5.0)
                +one_wall_reflection(10.02)
                +one_wall_reflection(8.01)
                +one_wall_reflection(2)
                +one_wall_reflection(1.75), 
                one_wall_reflection(6.2)
                +one_wall_reflection(10.01)
                +one_wall_reflection(8.02)
                +one_wall_reflection(2)
                +one_wall_reflection(1.75);
