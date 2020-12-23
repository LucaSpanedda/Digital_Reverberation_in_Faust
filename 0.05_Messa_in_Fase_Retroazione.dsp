// Importo libreria standard di FAUST
import("stdfaust.lib");

// ----------------------------------------
// Messa in Fase della Retroazione
// ----------------------------------------
// Per ottenere il giusto tempo di ritardo
// desiderato nel circuito di retroazione
// ----------------------------------------



/* 
nel dominio digitale la retroazione di una 
linea di ritardo, nel momento in cui viene
applicata, costa di default un campione di ritardo.
Retroazione = 1 Campione 

Nel momento in cui decido dunque di porre 
all'interno della retroazione un numero 
di campioni di ritardo,
possiamo prendere ad esempio 10 campioni
nella nostra linea di ritardo, vuole dire che,
Il segnale diretto uscirà per ritardo campioni a:

ingresso nel delay segnale --> uscita dal delay 10samp

Il 1° Ricircolo:
uscita dal delay a 10samp + 1 retroazione = 
ingresso nel delay 11samp --> uscita dal delay 21samp

Il 2° Ricircolo:
uscita dal delay a 21samp + 1 retroazione = 
ingresso nel delay 22samp --> uscita dal delay 32samp

Il 3° Ricircolo:
uscita dal delay a 32samp + 1 retroazione = 
ingresso nel delay 33samp --> uscita dal delay 43samp

e così via...


possiamo dunque notare da subito che non avremo
il corretto valore di ritardo richiesto all'interno della stessa,
a causa del campione di ritardo che avviene nel momento
in cui decido di creare un circuito di retroazione.
se utilizziamo il metodo di sottrarre un campione dalla linea 
di ritardo, avremo questo risultato:

ingresso nel delay segnale --> -1, uscita dal delay 9samp

Il 1° Ricircolo:
uscita dal delay a 9samp + 1 retroazione = 
ingresso nel delay 10samp --> -1, uscita dal delay 19samp

Il 2° Ricircolo:
uscita dal delay a 19samp + 1 retroazione = 
ingresso nel delay 20samp --> -1, uscita dal delay 29samp

Il 3° Ricircolo:
uscita dal delay a 29samp + 1 retroazione = 
ingresso nel delay 30samp --> -1, uscita dal delay 39samp

e così via...


possiamo dunque notare che con questo metodo,
rispetto al precedente avremo in ingresso alla linea di ritardo
sempre il numero di campioni di ritardo richiesti.
Ma notiamo che sin dalla prima uscita del segnale ritardato
sottraendo -1 abbiamo in out un campione di ritardo
in meno rispetto a quanto vorremmo.
Per rimettere in fase il tutto, basterà sommare un campione di ritardo
all'uscita complessiva del circuito, avendo così sin dal primo out:

ingresso nel delay segnale --> -1, uscita dal delay 9samp +1 = 10out

Il 1° Ricircolo:
uscita dal delay a 9samp + 1 retroazione = 
ingresso nel delay 10samp --> -1, uscita dal delay 19samp +1 = 20out

e così via...
*/


// Procediamo con una implementazione:

campioni_ritardo = ma.SR; 
// frequenza campionamento

process =   _ : 
            // segnale in input entra in
            +~ @(campioni_ritardo -1) *(0.8) 
            // linea ritardo con feedback: +~
            : mem;
            // uscita entra in campione singolo ritardo