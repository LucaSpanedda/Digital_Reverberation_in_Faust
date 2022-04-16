// import Standard Faust library
// https://github.com/grame-cncm/faustlibraries/
import("stdfaust.lib");

// One-Pole filter function. OnepoleTPT(CF) = Frequency Cut in HZ
// TPT version of the One-Pole Filter by Vadim Zavalishin
// reference : (by Will Pirkle)
// http://www.willpirkle.com/Downloads/AN-4VirtualAnalogFilters.2.0.pdf
OnepoleTPT(CF,x) = circuit ~ _ : ! , _
    with {
        g = tan(CF * ma.PI / ma.SR);
        G = g / (1.0 + g);
        circuit(sig) = u , lp
            with {
                v = (x - sig) * G;
                u = v + lp;
                lp = v + sig;
            };
    };

// out
process = OnepoleTPT(100);
