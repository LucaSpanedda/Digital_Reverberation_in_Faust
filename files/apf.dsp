// import Standard Faust library
// https://github.com/grame-cncm/faustlibraries/
import("stdfaust.lib");

// (t, g) = give: delay in samples, feedback gain 0-1
apf(del, g, x) = x : (+ : _ <: @(del-1), *(g)) ~ *(-g) : mem, _ : + : _;
process = _ * .1 <: apf(100, .5);
