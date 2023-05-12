declare name 		"Luca Spanedda's KBVerb";
declare version 	"0.8";
declare author 		"Luca Spanedda";
declare copyright 	"Copyright(c) 2023 Luca Spanedda";
// import Standard Faust library
// https://github.com/grame-cncm/faustlibraries/
import("stdfaust.lib");

//------- ------------- ----- -----------
//-- Luca Spanedda's KBVerb ----------------------------------------------------
//-- Reverb Model based on: Keith Barr Allpass Loop Reverb
//------- --------

// Delay Times
DX  = 1251 ;    DXM = 0 ;       DXF = 0;        // INPUT 1
DY  = 1751 ;    DYM = 0 ;       DYF = 0;        // INPUT 2
DZ  = 1443 ;    DZM = 0 ;       DZF = 0;        // INPUT 3
DW  = 1343 ;    DWM = 0 ;       DWF = 0;        // INPUT 4
// AP FILTERS - DELAY SAMPLES/ MODULATION SAMPLES/ MODULATION FREQUENCY
D1  = 3823 ;    D1M = 197 ;     D1F = .2143 ;   // AP1
D2  = 4732 ;    D2M = 0 ;       D2F = 0;        // AP2
D3  = 8501 ;                                    // DEL OUT 1
D4  = 2204 ;    D4M = 331 ;     D4F = .1583 ;   // AP3
D5  = 2701 ;    D5M = 0 ;       D5F = 0;        // AP4
D6  = 7237 ;                                    // DEL OUT 2
D7  = 2532 ;    D7M = 211 ;     D7F = .2003 ;   // AP5
D8  = 2201 ;    D8M = 0 ;       D8F = 0;        // AP6
D9  = 6337 ;                                    // DEL OUT 3
D10 = 1553 ;    D10M = 313 ;    D10F = .1181 ;  // AP7
D11 = 1583 ;    D11M = 0 ;      D11F = 0;       // AP8
D12 = 5867 ;                                    // DEL OUT 4

// GUI
ShimmerGroup(x) = hgroup("Shimmer", x);
DRYGroup(x) = hgroup("Dry/Wet", x);
// Freeze Reverbered Signal 
FREEZE = vgroup("Freeze", checkbox("Freeze"));
// Reverb Time
KRT = DRYGroup(hslider("[1] KRT Decay [style: knob]",.8, 0, 1, .001) : si.smoo);
KRTMOD = (KRT * (1-FREEZE) + FREEZE);
// AP Coefficents
COEFF = .65;
// MIX Dry/Wet
DRY = DRYGroup(hslider("[2] Dry Sound [style: knob]", .5, 0, 1, .001) : si.smoo);
// Shimmer Amplitude
FBMIX = ShimmerGroup(hslider("[5] Shimmer [style: knob]", 0, 0, 1, .001) : si.smoo);
// Shimmer Frequency
FTUNE = ShimmerGroup(hslider("[7] Fine Tune [style: knob]", 0, -1, 1, .001) : si.smoo);
SHIFT = ShimmerGroup(hslider("[6] Frequency [style: knob]", 12, -24, 24, 1) : si.smoo);
// Input Signal
INPUT = DRYGroup(hslider("[3] Reverb IN [style: knob]", .5, 0, 1, .001) : si.smoo);

// AP Loop
KBReverb(A, B, C, D) = 
    (A : intD1) <: _ ,
        ( 
            ( loop_A <: 
                ( (B : intD2), _ * KRTMOD : loop_B <: 
                    ( (C : intD3), _ * KRTMOD : loop_C <: 
                        ( (D : intD4), _ * KRTMOD : loop_D <: 
                            _ * KRTMOD, 
                                _ ),
                                    _ ),
                                        _ ),
                                            _ ) ~ _ :
                                                !, si.bus(4) ) : 
                                                    !, si.bus(4) 
    with{
        loop_A(x, y) =  x + y   : ModAPF(D1,  D1M,  D1F )   : 
                                    ModAPF(D2,  D2M,  D2F ) : DEL(D3) ; 
        loop_B(x, y) =  x + y   : ModAPF(D4,  D4M,  D4F )   : 
                                    ModAPF(D5,  D5M,  D5F ) : DEL(D6) ;
        loop_C(x, y) =  x + y   : ModAPF(D7,  D7M,  D7F )   : 
                                    ModAPF(D8,  D8M,  D8F ) : DEL(D9) ;
        loop_D(x, y) =  x + y   : ModAPF(D10, D10M, D10F)   : 
                                    ModAPF(D11, D11M, D11F) : DEL(D12);
        intD1(x) =      x * (1-FREEZE)  : ModAPF(DX,  DXM,  DXF ) ;
        intD2(x) =      x * (1-FREEZE)  : ModAPF(DY,  DYM,  DYF ) ;
        intD3(x) =      x * (1-FREEZE)  : ModAPF(DZ,  DZM,  DZF ) ;
        intD4(x) =      x * (1-FREEZE)  : ModAPF(DW,  DWM,  DWF ) ;
    };

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

// Zavalishin's Onepole TPT Filter
// reference : same of BPSVF
onePoleTPT(cf, x) = loop ~ _ : ! , si.bus(3) // Outs: lp , hp , ap
with {
    g = tan(cf * ma.PI * (1.0/ma.SR));
    G = g / (1.0 + g);
    loop(s) = u , lp , hp , ap
    with {
        v = (x - s) * G; u = v + lp; lp = v + s; hp = x - lp; ap = lp - hp;
    };
};
// Lowpass TPT
LPTPT(cf, x) = onePoleTPT(cf, x) : (_ , ! , !);
// Highpass TPT
HPTPT(cf, x) = onePoleTPT(cf, x) : (! , _ , !);

// DC Blocker Filter
dcblocker(zero, pole, x) = x : dcblockerout
    with{
        onezero =  _ <: _,mem : _, * (zero) : -;
        onepole = + ~ * (pole);
        dcblockerout = _ : onezero : onepole;
    };

// Pitch Shift + Original
transpose(w, x, s, sig) = 
    de.fdelay(maxDelay, d, sig) * ma.fmin(d/x,1) +
    de.fdelay(maxDelay, d+w, sig) * (1-ma.fmin(d/x,1))
    with{
        maxDelay = 65536;
        i = 1 - pow(2, s/12);
        d = i : (+ : +(w) : fmod(_,w)) ~ _;
    };

// Delay
DEL(delay) = _ @ (delay);

// Input Mixer + DSP Process in the Feedback Loop
FB_MIXER(D, C, B, A, x) =   
    x * (1-FBMIX) * INPUT + (D : dcblocker(1, 0.8) : LPTPT(15000) : transpose(10000, 1, SHIFT+FTUNE)) * FBMIX, 
    x * (1-FBMIX) * INPUT + (C : dcblocker(1, 0.8) : LPTPT(15000) : transpose(10000, 1, SHIFT+FTUNE)) * FBMIX, 
    x * (1-FBMIX) * INPUT + (B : dcblocker(1, 0.8) : LPTPT(15000) : transpose(10000, 1, SHIFT+FTUNE)) * FBMIX, 
    x * (1-FBMIX) * INPUT + (A : dcblocker(1, 0.8) : LPTPT(15000) : transpose(10000, 1, SHIFT+FTUNE)) * FBMIX; 

// Output Mixer 
OUT_MIXER(D, C, B, A, x) = (D + B) / 2 + x * DRY, (C + A) / 2 + x * DRY;

// OUTPUT
FBROUTE(x) = x : ( FB_MIXER : KBReverb ) ~ si.bus(4), x : OUT_MIXER;
                    
process = FBROUTE; 