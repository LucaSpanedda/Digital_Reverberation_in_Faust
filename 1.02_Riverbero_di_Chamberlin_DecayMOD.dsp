// ----------------------------------------
// CHAMBERLIN REVERB
// with T60 Decay
// ----------------------------------------

// FAUST standard library
import("stdfaust.lib");

// MS TO SAMPLES
// (t) = give time in milliseconds we want to know in samples
msasamps(t) = (ma.SR/1000)*t;

// ALLPASS CHAMBERLIN
// (t,g) = give: delay in samples, feedback gain 0-1
apffp(t,g) = (+: _<: @(min(max(t-1,0),ma.SR)), *(-g))~ *(g) : mem, _ : + : _;

// T60 DECAY TIME from MILLISECONDS
// (ms,seconds) = give: ms delay of the filter, seconds we want for t60 decay
dect60(ms,seconds) = 1/(10^((3*(ms/1000))/seconds));

// CHAMBERLIN REVERB
// (seconds) = give: decay time in seconds of 60dB
chamberlindecay(seconds) = ap3ch <: apout1ch, apout2ch
with{
ap3ch = apffp(msasamps(49.6),dect60(49.6,seconds)) : 
apffp(msasamps(34.75),dect60(34.75,seconds)) : 
apffp(msasamps(24.18),dect60(24.18,seconds));
apout1ch = apffp(msasamps(17.85),dect60(17.85,seconds)) : 
apffp(msasamps(10.98),dect60(10.98,seconds));
apout2ch = apffp(msasamps(18.01),dect60(18.01,seconds)) : 
apffp(msasamps(10.82),dect60(10.82,seconds));
};
process = chamberlindecay(10);
