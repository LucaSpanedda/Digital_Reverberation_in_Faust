// import Standard Faust library 
// https://github.com/grame-cncm/faustlibraries/ 
import("stdfaust.lib");

// (samps,seconds) = give: samples of the filter, seconds we want for t60 decay
dect60(samps,seconds) = 1/(10^((3*(((1000 / ma.SR)*samps)/1000))/seconds));
