// ----------------------------------------
// ALCUNI METODI PER LA REALIZZAZIONE DI 
// CIRCUITI RICORSIVI (FEEDBACK) IN FAUST
// ----------------------------------------

/*
-------------------------------------------
Referenze:
https://www.dariosanfilippo.com/blog/2020/faust_recursive_circuits/
-------------------------------------------


Illustreremo 3 Metodi principali:

1 - Scrivere la riga di codice con recorsività interne:
    in questo modo l'operatore tilde ~ manda il segnale
    in uscita all'interno di se stesso, al primo ingresso
    disponibile. Creando un circuito di retroazione (feedback)


2 - Un secondo metodo consiste nell'utilizzo del with{} .
    Si può definire una funzione in cui vengono passati
    i vari argomenti della funzione che controllano 
    i paramteri del codice,
    e dire che quella funzione è uguale a
    uscita dal with con ~ _
    esempio:

    funzione_with(argomento1, argomento2) = out_with ~ _
    with{
        sezione1 = _ * argomento1;
        sezione2 = argomento1 * argomento2;
        out_with = sezione2;
        };

        dove out_with ~ _ rientra in se stesso.


3 - Un terzo metodo è utilizzare l'ambiente letrec.
    con questo metodo possiamo scrivere un segnale
    in modo ricorsivo, in modo simile a come vengono
    scritte le equazioni di ricorrenza.
    
    esempio:
*/

    // Importo la libreria standard di FAUST
    import("stdfaust.lib");

// metodo con letrec:
// funzione
lowpass(cf, x) = y
    // definizione letrec
    letrec {
        'y = b0 * x - a1 * y;
            }
        // cosa contiene il letrec
        with {
            b0 = 1 + a1;
            a1 = exp(-w(cf)) * -1;
            w(f) = 2 * ma.PI * f / ma.SR;
            };

// Uscita della funzione ricorsiva scritta con letrec
process = lowpass;
