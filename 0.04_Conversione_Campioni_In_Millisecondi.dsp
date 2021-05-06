// Importo libreria standard di FAUST
import("stdfaust.lib");

// ----------------------------------------
// CONVERSIONE CAMPIONI IN MILLISECONDI
// ----------------------------------------


/* 
Funzione Conversione ms. in Campioni :
inserisco un totale di campioni,
di cui mi serve di sapere la durata complessiva
in millisecondi basandomi sulla mia frequenza di campionamento.

Sappiamo che una frequenza di campionamento
corrisponde ad un insieme di valori che esprimono 
nel loro insieme la durata di 1 secondo (1000 ms.).

Vuole dire ad esempio,
che ad una frequenza di campionamento di 48.000
campioni al secondo, 
ho 1000 millisecondi rappresentati da 48.000 parti.
E dunque se divido i miei 1000ms. / 
nelle 48.000 parti che sarebbero i campioni del mio sistema,
otterrei la durata in millisecondi di un singolo campione
a quella frequenza di campionamento,
in questo caso dunque: 
1000 / 48.000 = 0,02ms. 
E dunque la durata in millisecondi di un singolo campione a 48.000
campioni al secondo, è di 0,02 millisecondi.
se moltiplico il numero ottenuto *
un totale di campioni, otterrò il tempo in millisecondi
di quei campioni per quella frequenza di campionamento usata.

Ovviamente come si può dedurre dalle considerazioni,
all'incrementare della frequenza di campionamento 
corrisponde una durata temporale più piccola del singolo campione,
e dunque una definizione maggiore.
*/

// (samps) = give tot. samples we want to know in milliseconds
sampsams(samps) = ((1000 / ma.SR) * samps);

process = _;
