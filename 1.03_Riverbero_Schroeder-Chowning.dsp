// ----------------------------------------
// SCHROEDER-CHOWNING SATREV REVERBERATOR
// ----------------------------------------

// Importo libreria standard di FAUST
import("stdfaust.lib");



/* 
Simulazione di Riverbero secondo il modello di John Chowning.
Modello SATREV, basato sul modello riverberante di Schroeder.
4 Comb IIR Paralleli e 3 Allpass in serie.
*/



// ------------ FILTER SECTION ------------
// FEEDBACK COMB FILTER 
// (t,g) = give: delay time in samples, feedback gain 0-1
fbcf(t,g) = _ : (+  @(t-1)~ *(g)) : mem;

// ALLPASS FILTER
// (t,g) = give: delay in samples, feedback gain 0-1
apffp(t,g) = (+: _<: @(min(max(t-1,0),ma.SR)), *(-g))~ *(g) : mem, _ : + : _;
// ----------------------------------------


// ------------ COMB SECTION --------------
    schroeder4comb = combsection 
    with {
    // ROUTING PARALLELO
    in_router(a,b,c,d)= a, b, c, d;
    input = _ <: in_router;

    // 4 FILTRI COMB PARALLELI 
    combs=fbcf(901,0.805),fbcf(778,0.827),fbcf(1011,0.783),fbcf(1123,0.764);

    // SUM SEGNALI PARALLELI
    out_router(a,b,c,d) = a+b+c+d;
    // COMBS OUT
    combsection = input : combs :> out_router;
    };
// ----------------------------------------


// ------------ ALLPASS SECTION -----------
schroederallp = apffp(125,0.7):apffp(42,0.7):apffp(12,0.7);
// ----------------------------------------


// ------------ OUT PATH ------------------
satreverb = _ : schroeder4comb : schroederallp;
process = os.impulse : satreverb <: _,_;
