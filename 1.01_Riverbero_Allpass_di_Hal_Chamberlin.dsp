//-----------------------------------------
// CHAMBERLIN REVERB
// ----------------------------------------
// High-quality stereo reverberator:
// Musical Applications of Microprocessor
// ----------------------------------------

// Standard Library FAUST
import("stdfaust.lib");

// MS TO SAMPLES
// (t) = give time in milliseconds we want to know in samples
msasamps(t) = (ma.SR/1000.)*t;

// ALLPASS CHAMBERLIN
// (t,g) = give: delay in samples, feedback gain 0-1
apfch(t,g) = (+: _<: @(min(max(t-1,0),ma.SR)), *(-g))~ *(g) : mem, _ : + : _;

// CHAMBERLIN REVERB
ap3ch = apfch(msasamps(49.6),0.75) : 
apfch(msasamps(34.75),0.72) : apfch(msasamps(24.18),0.691);
apout1ch = apfch(msasamps(17.85),0.649) : apfch(msasamps(10.98),0.662);
apout2ch = apfch(msasamps(18.01),0.646) : apfch(msasamps(10.82),0.666);
process = ap3ch <: apout1ch, apout2ch;
