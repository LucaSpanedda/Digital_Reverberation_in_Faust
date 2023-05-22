// Import the standard Faust Libraries
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


// Feedback Delay Network
FDN = MIMO_Network ~ MATRIX : par(i, 4, mem)
    with{    
        // Network Feedbacks Gains
        g1 = .51;    g2 = .52;    g3 = .53;    g4 = .54;
        // Feedbacks Matrix Gains
        q11 = .11;   q12 = .22;   q13 = .33;   q14 = .44;
        q21 = .41;   q22 = .32;   q23 = .23;   q24 = .14;
        q31 = .12;   q32 = .23;   q33 = .34;   q34 = .45;
        q41 = .42;   q42 = .33;   q43 = .24;   q44 = .15;

        // Matrix
        MATRIX(fb1, fb2, fb3, fb4) =
            (fb1 * q11, fb2 * q21, fb3 * q31, fb4 * q41 :> _ * g1),
            (fb1 * q12, fb2 * q22, fb3 * q32, fb4 * q42 :> _ * g2),
            (fb1 * q13, fb2 * q23, fb3 * q33, fb4 * q43 :> _ * g3),
            (fb1 * q14, fb2 * q24, fb3 * q34, fb4 * q44 :> _ * g4);
        // Network
        MIMO_Network(fb1, fb2, fb3, fb4, in1, in2, in3, in4) = 
            (fb1+in1 : DEL(3500)), (fb2+in2 : DEL(2800)), 
            (fb3+in3 : DEL(2200)), (fb4+in4 : DEL(2000))
            with{
                // Simple Delay Line (Replace -or- Add Effects Processors)
                DEL(del, x) = x@(del - 1);
            };
    };    

process = si.bus(2) <: FDN :> si.bus(2); 
