// import Standard Faust library
// https://github.com/grame-cncm/faustlibraries/
import("stdfaust.lib");

// (t,g) = delay time in samples, filter gain 0-1
ffcf(t, g, x) = (x@(t) * g), x :> +;
process = _ * .1 : ffcf(100, 1);
