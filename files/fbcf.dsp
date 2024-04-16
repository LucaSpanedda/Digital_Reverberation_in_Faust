// import Standard Faust library
// https://github.com/grame-cncm/faustlibraries/
import("stdfaust.lib");

// Feedback Comb Filter. FBComb(Del,G,signal) 
// (Del, G) = DEL=delay time in samples. G=feedback gain 0-1
fbcf(del, g, x) = loop ~ _ 
    with {
        loop(y) = x + y@(del - 1) * g;
    };

process = _ * .1 : fbcf(4480, .9);
