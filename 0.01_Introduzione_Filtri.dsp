// FILTRI DIGITALI
/*
REFERENZE:
Introduction to Digital Filters: 
With Audio Applications.
Libro di Julius O. Smith III.
Links alla serie di Libri di Smith:
1 Mathematics of the Discrete Fourier Transform (DFT)
2 Introduction to Digital Filters
3 Physical Audio Signal Processing
4 Spectral Audio Signal Processing
sulla pagina CCRMA di J.Smith
https://ccrma.stanford.edu/~jos/fp/
su DSP Related
https://www.dsprelated.com/freebooks.php
*/


// LINEE DI RITARDO IN FAUST
/*Le linee di ritardo in Faust 
si suddividono nelle seguenti categorie:
mem - indica un solo campione di ritardo
@ - indica un numero (ex. 44100) di campioni di ritardo variabile
x'- x indica un qualsiasi ingresso e: ' un campione di ritardo, ''(2), ecc.
rdtable - indica una tabella di sola lettura
rwtable - indica una tabella di scrittura e lettura
*/


// IMPULSO DI DIRAC
//Importo la libreria
import("stdfaust.lib");

// tramite le linee di ritardo
// possiamo creare un impulso di Dirac, che rappresenta 
// la nostra unità minima, ovvero il singolo campione
// mettendo un numero 1 e sottraendo da esso lo stesso valore
// ma facendolo ad un campione di ritardo. Così facendo
// potremo udire un valore 1 della durata di un singolo campione
// all'avvio del programma.

// Impulso
dirac = 1-1';

// Process
process = dirac, dirac;