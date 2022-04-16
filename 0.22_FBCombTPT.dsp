// import Standard Faust library
// https://github.com/grame-cncm/faustlibraries/
import("stdfaust.lib");

// TPT version of the FBComb Filter
// reference : (by Will Pirkle)
// http://www.willpirkle.com/Downloads/AN-4VirtualAnalogFilters.2.0.pdf

// Feedback Comb Filter. FBComb(Del,G,signal) 
// Del=delay time in samples, G=feedback gain 0-1
FBCombTPT(Del,G,x) = FBcircuit ~ _ 
    with {
        FBcircuit(y) = x+y@(Del-1)*G;
    };

process = FBCombTPT(1000,0.998);
