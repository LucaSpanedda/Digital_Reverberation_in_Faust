import("stdfaust.lib");

// Modulated Allpass filter
ModAPF(delsamples, samplesmod, freqmod, apcoeff) = ( + : _ <: 
    delayMod(delsamples, samplesmod, freqmod),
    * (apcoeff))~ * (-apcoeff) : mem, _ : + : _
    with{
        delayMod(samples, samplesMod, freqMod, x) = delay
        with{
            unipolarMod(f, samples) = ((os.osc(f) + 1) / 2) * samples;
            delay = x : de.fdelay(samples, samples - unipolarMod(freqMod, samplesMod));
        };
    };
process = 1-1' : +@(ma.SR/100) ~ _ <: _, ModAPF(1000, 500, .12, .5);
