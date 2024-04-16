// import Standard Faust library
// https://github.com/grame-cncm/faustlibraries/
import("stdfaust.lib");

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
