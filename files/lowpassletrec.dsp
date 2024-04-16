// import Standard Faust library 
// https://github.com/grame-cncm/faustlibraries/ 
import("stdfaust.lib");

// letrec function
lowpass(cf, x) = y
// letrec definition
    letrec {
        'y = b0 * x - a1 * y;
    }
    // inside the letrec function
    with {
        b0 = 1 + a1;
        a1 = exp(-w(cf)) * -1;
        w(f) = 2 * ma.PI * f / ma.SR;
    };

// Output of the letrec function
process = lowpass(100, no.noise) <: si.bus(2);
