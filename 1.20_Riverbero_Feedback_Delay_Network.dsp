// ----------------------------------------
// fdn2combs di Luca Spanedda.
// Implementazione basata su:
// FDN di Stautner e Puckette
// ----------------------------------------

// Importo libreria standard di FAUST
import("stdfaust.lib");



/* 
Nel 1982 Stautner e Puckette presentano nella 
loro pubblicazione ”Designing multichannel reverberators” 
un algoritmo di riverberazione multicanale chiamato: 
”Feedback Delay Network” che tende a voler simulare 
il comportamento delle riﬂessioni all’interno di una stanza, 
utilizzando solo una serie di ﬁltri comb paralleli
ma con le retroazioni interconnesse fra loro.
Qui una implementazione di una FDN a soli due Comb Filter.
*/



// ------------ FILTER SECTION ------------
    // FEEDBACK COMB FILTER 
    // fbcf(delay in samples, comb filter gain)
    fbcf(t,g) = _ : (+  @(t-1)~ *(g)) : mem;
// ----------------------------------------

// ------------ FEEDBACK DELAY NETWORK ----
//
// FDN A 2 COMB FILTER
// fdn2combs(del1,del2,g12,g21,g11,g22)
//
// del1,del2 : sono i samples dei filtri comb 
//
// MATRICE delle FDN:
// g12 vuole dire g del comb 1 -->(va) al comb 2
// g21 vuole dire g del comb 2 -->(va) al comb 1
// g22 vuole dire g del comb 2 -->(va) in retroazione
// g11 vuole dire g del comb 1 -->(va) in retroazione
//
fdn2combs(del1,del2,g12,g21,g11,g22) = fdnout 
with{
    two_combs = fbcf(del1,g11), fbcf(del2,g22);
    routerin(a,b) = _+a, _+b;
    matrixout(a, b) = b*g12, a*g21;
    fdnout = _<:(routerin : two_combs : matrixout)~ si.bus(2);
};
// ----------------------------------------

// fdn2combs(del1,del2,g12,g21,g11,g22)
process = _:fdn2combs(6000,5000,0.25,0.25,0.5,0.5);
