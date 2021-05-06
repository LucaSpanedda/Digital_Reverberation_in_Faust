// Importo libreria standard di FAUST
import("stdfaust.lib");

// ----------------------------------------
// EARLY REFLECTIONS (PRIME RIFLESSIONI)
// ----------------------------------------


/* 
Simulazione delle prime riflessioni in una stanza con
il punto sorgente che coincide col punto di ascolto:
*/


// col router definisco gli input che mi devo passare dentro il codice
// in questo caso 7 input: (a,b,c,d,e,f,g)
in_router(a,b,c,d,e,f,g) = a, b, c, d, e, f, g;
// process = router;

// mando il segnale in ingresso ai 7 input del router
input = _ <: in_router;
//process = input;

// definisco le prime riflessioni - multitap delay lines (NO FEEDBACK)
multitap_delay(frnt,bck,sx,dx,up,dwn,direct) =
frnt@(4481),bck@(2713),sx@(3719),dx@(3739),up@(1877),dwn@(659),direct;
//process = early_reflections;

// definisco un router per l'output che prenda 7 ingressi e li sommi
// in un unica uscita
out_router(a,b,c,d,e,f,g) = a+b+c+d+e+f+g;
//process = earlyrelfect_router;

// definisco una funzione dove esplico il percorso del segnale
early_reflections = input : multitap_delay :> out_router;

// output e test con un impulso di dirac (1 sample)
process = os.impulse : early_reflections  <: _,_;
