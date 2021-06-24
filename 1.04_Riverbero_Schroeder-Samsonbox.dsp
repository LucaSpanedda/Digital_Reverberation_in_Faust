// ----------------------------------------
// SCHROEDER SAMSON BOX REVERBERATOR
// ----------------------------------------


// Importo libreria standard di FAUST
import("stdfaust.lib");



/* 
Simulazione di Riverbero secondo il modello della 
Samson Box - 1977 CCRMA.
Modello SATREV, basato sul modello riverberante di Schroeder.
3 Allpass in serie e 4 Comb IIR Paralleli.
-------------------------------------------
Nel 1962 Manfred Schroeder propone un’applicazione efficiente di riverberazione 
digitale nel suo articolo “Natural Sounding Artificial Reverb”. 
Schroeder propone l’utilizzo di filtri allpass e comb combinati fra di loro 
per ottenere un riverbero che non colori (grazie ai filtri allpass) 
e che crei una densità degli echi sufficiente a simulare la complessità 
delle riflessioni date da un effetto di riverberazione naturale
(almeno 1000 echi per secondo)
*/



// ------------ FILTER SECTION ------------
// FEEDBACK COMB FILTER 
// (t,g) = give: delay time in samples, feedback gain 0-1
fbcf(t,g) = _ : (+  @(t-1)~ *(g)) : mem;

// ALLPASS FILTER
// (t,g) = give: delay in samples, feedback gain 0-1
apffp(t,g) = (+: _<: @(min(max(t-1,0),ma.SR)), *(-g))~ *(g) : mem, _ : + : _;
// ----------------------------------------


// ------------ ALLPASS SECTION -----------
schroederallp = apffp(1051,0.7):apffp(337,0.7):apffp(113,0.7);
// ----------------------------------------


// ------------ COMB SECTION --------------
    schroeder4comb = combsection 
    with {
    // ROUTING PARALLELO
    in_router(a,b,c,d)= a, b, c, d;
    input = _ <: in_router;

    // 4 FILTRI COMB PARALLELI 
    combs=fbcf(4799,0.742),fbcf(4999,0.733),fbcf(5399,0.715),fbcf(5801,0.697);

    // SUM SEGNALI PARALLELI
    out_router(a,b,c,d) = a+b+c+d;
    // COMBS OUT
    combsection = input : combs :> out_router;
    };
// ----------------------------------------


// ------------ OUT PATH ------------------
samsonboxverb = _ : schroederallp : schroeder4comb;
process = os.impulse : samsonboxverb <: _,_;


// Sarebbe necessario decorrelare in uscita le somme dei comb
// per avere un buon effetto spaziale.
// nel modello originale è incluso un mixer con 4 differenti uscite
// che hanno 4 differenti linee di ritardo, che sono :
// A = z-0.046fs
// B = z-0.057fs
// C = z-0.041fs
// D = z-0.054fs
