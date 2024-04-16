// import Standard Faust library
// https://github.com/grame-cncm/faustlibraries/
import("stdfaust.lib");

// Dirac Impulse with delay lines - Impulse at Compile Time
dirac = 1 - 1';
process = dirac, dirac;
