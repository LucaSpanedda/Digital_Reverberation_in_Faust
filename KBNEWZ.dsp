declare name 		"Luca Spanedda's KBVerb";
declare version 	"1.0";
declare author 		"Luca Spanedda";
declare copyright 	"Copyright(c) 2023 Luca Spanedda";
// import Standard Faust library
// https://github.com/grame-cncm/faustlibraries/
import("stdfaust.lib");

//------- ------------- ----- -----------
//-- Luca Spanedda's KBVerb ----------------------------------------------------
//-- Reverb Model based on: Keith Barr Allpass Loop Reverb
//------- --------
// REVERB
reverb(I, O, N, SEQ, parspace, start) = si.bus(I) <: 
InputStage : 
    (ro.interleave(N, N/(N/2)) : par(i, N, si.bus(2) :> _) : 
        par(i, N, 
        seq(k, SEQ, 
            // cleanfunc
            ModAPF
                ( 
                    (primenumbers((k+start) + (i*parspace)) : MS2T), 
                    (primenumbers((k+start) + (i*parspace)) / 100 : MS2T), 
                    (0.5 / primenumbers((k+start) + (i*parspace)) : MS2T)
                ) 
        ) :
        _ * KRTMOD // : dcblocker(1, 0.8)
    )   : ro.crossNM(N - 1, 1)) ~ 
    si.bus(N) :> 
OutputStage
with{
    // In / Out - Network
    InputStage = par(i, N, (_ * INPUT) / (N / I));
    OutputStage = par(i, O, (_ * OUTPUT));
    // conversion : milliseconds T to samples
    MS2T(t) = (t / 1000) * ma.SR;
    // import prime numbers
    primes = component("prime_numbers.dsp").primes;
    primesThousands = component("prime_numbers.dsp").primesThousands;
    // index of the primes numbers
    primenumbers(index) = ba.take(index , list)
    with{
        list = primes;
    };
    // DC Blocker Filter
    dcblocker(zero, pole, x) = x : dcblockerout
    with{
        onezero =  _ <: _,mem : _, * (zero) : -;
        onepole = + ~ * (pole);
        dcblockerout = _ : onezero : onepole;
    };
    // function for test prime numbers
    cleanfunc(x, y, z) = _ * (x + y + z) ;
    // AP Coefficents
    COEFF = .65;
    // Modulated Allpass filter
    ModAPF(delsamples, samplesmod, freqmod) = ( + : _ <: 
        delayMod(delsamples, samplesmod, freqmod),
        * (COEFF))~ * (-COEFF) : mem, _ : + : _
        with{
            delayMod(samples, samplesMod, freqMod, x) = delay
            with{
                modulation(f, samples) = ((os.osc(f) + 1) / 2) * samples;
                delay = x : de.fdelay(samples, 
                                samples - modulation(freqMod, samplesMod));
            };
        };
    // GUI
    DRYGroup(x) = hgroup("Dry/Wet", x);
    // Freeze Reverbered Signal 
    FREEZE = vgroup("Freeze", checkbox("Freeze"));
    // Reverb Time
    KRT = DRYGroup(hslider("[1] KRT Decay [style: knob]",.8, 0, 1, .001) : si.smoo);
    KRTMOD = (KRT * (1-FREEZE) + FREEZE);
    // Input / Output - Signal
    INPUT =  DRYGroup(hslider("[3] Reverb IN  [style: knob]", 1, 0, 1, .001) : si.smoo);
    OUTPUT = DRYGroup(hslider("[3] Reverb OUT [style: knob]", 1, 0, 1, .001) : si.smoo);
};
// output
process = reverb(2, 2, 8, 2, 5, 10);