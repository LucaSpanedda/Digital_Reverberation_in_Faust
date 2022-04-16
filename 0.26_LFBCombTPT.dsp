// import Standard Faust library
// https://github.com/grame-cncm/faustlibraries/
import("stdfaust.lib");


// TPT version of the Lowpass Feedback Comb Filter. FBComb(Del,G,signal) 
// Del=delay time in samples, G=feedback gain 0-1
// TPT version of the One-Pole Filter by Vadim Zavalishin
// reference : (by Will Pirkle)
// http://www.willpirkle.com/Downloads/AN-4VirtualAnalogFilters.2.0.pdf
LFBCombTPT(Del,G,CF) = LFBCcircuit ~ _ 
    with{
        LFBCcircuit(y,z) = z+(LowpassTPT(y)@(Del-1))*G
            with{
                LowpassTPT(x) = (lowpasscircuit ~ _ : ! , _)
                    with{
                        g = tan(CF * ma.PI / ma.SR);
                        G = g / (1.0 + g);
                        lowpasscircuit(sig) = u , lp
                            with{
                                v = (x - sig) * G;
                                u = v + lp;
                                lp = v + sig;
                                };
                        };
                };    
        };

// out
process = LFBComb(1000,0.998,10000);
