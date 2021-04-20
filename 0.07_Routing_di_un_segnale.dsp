// Importo libreria standard di FAUST
import("stdfaust.lib");

// ----------------------------------------
// IL ROUTING DI UN SEGNALE
// ----------------------------------------



/* 
in FAUST di base, non è un processo scontato gestire il routing
di un segnale che superi le due entrate o uscite di collegamento 
in catena.
Con la tecnica della funzione router illustrata a seguito
si rende possibile la gestione di più canali indipendenti
nello sviluppo del nostro algoritmo DSP
*/


// con la funzione router 
// definisco gli input che mi devo passare dentro il codice
// ad esempio: in questo caso 7 input (a,b,c,d,e,f,g)
router(a,b,c,d,e,f,g) = a, b, c, d, e, f, g;
// process = router;

// e gestisco le operazioni desiderate tra i canali,
// in questo caso sommo tutti i canali in un unica uscita
out_router(a,b,c,d,e,f,g) = a+b+c+d+e+f+g;
//process = out_router;

// infine definisco la funzione dove esplico il percorso del segnale
process = _ <: router :> out_router;

// avrò dunque creato un percorso di un singolo canale
// che si ramifica in 7 ingressi nella funzione router 
// e che si sommano in un unica uscita con la funzione out_router
