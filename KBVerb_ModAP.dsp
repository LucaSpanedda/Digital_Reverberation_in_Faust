declare name 		"Luca Spanedda's KBVerb";
declare version 	"1.0.0";
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
D1  = 3823 ;    D1M = 200 ;     D1F = .0710 ;   // AP1
D2  = 4732 ;    D2M = 0 ;       D2F = 0;        // AP2
D3  = 8501 ;                                    // DEL OUT 1
D4  = 2204 ;    D4M = 300 ;     D4F = .0940 ;   // AP3
D5  = 2701 ;    D5M = 0 ;       D5F = 0;        // AP4
D6  = 7237 ;                                    // DEL OUT 2
D7  = 2532 ;    D7M = 200 ;     D7F = .0330 ;   // AP5
D8  = 2201 ;    D8M = 0 ;       D8F = 0;        // AP6
D9  = 6337 ;                                    // DEL OUT 3
D10 = 1553 ;    D10M = 300 ;    D10F = .0820 ;  // AP7
D11 = 1583 ;    D11M = 0 ;      D11F = 0;       // AP8
D12 = 5867 ;                                    // DEL OUT 4
// Reverb Time
KRT = hslider("KRT Decay ",.8, 0, 1, .001) : si.smoo;
// AP Coefficents
COEFF = .65;

// AP Loop
KBReverb(X, Y, Z, W) = 
    (X  : intD1) <: _ ,
        ( 
            ( loop_A <: 
                ( (Y : intD2), _ * KRT : loop_B <: 
                    ( (Z  : intD3), _ * KRT : loop_C <: 
                        ( (W  : intD4), _ * KRT : loop_D <: 
                            _ * KRT, 
                                si.bus(2) ),
                                    si.bus(2) ),
                                        si.bus(2) ),
                                            si.bus(2) ) ~ PROC :
                                                !, si.bus(8) : outrouting ) : 
                                                    !, si.bus(2) 
    with{
        loop_A(x, y) =  x + y   : ModAPF(D1,  D1M,  D1F )   : 
                                    ModAPF(D2,  D2M,  D2F ) : DEL(D3) ; 
        loop_B(x, y) =  x + y   : ModAPF(D4,  D4M,  D4F )   : 
                                    ModAPF(D5,  D5M,  D5F ) : DEL(D6) ;
        loop_C(x, y) =  x + y   : ModAPF(D7,  D7M,  D7F )   : 
                                    ModAPF(D8,  D8M,  D8F ) : DEL(D9) ;
        loop_D(x, y) =  x + y   : ModAPF(D10, D10M, D10F)   : 
                                    ModAPF(D11, D11M, D11F) : DEL(D12);
        intD1(x) =      x       : ModAPF(DX,  DXM,  DXF ) ;
        intD2(x) =      x       : ModAPF(DY,  DYM,  DYF ) ;
        intD3(x) =      x       : ModAPF(DZ,  DZM,  DZF ) ;
        intD4(x) =      x       : ModAPF(DW,  DWM,  DWF ) ;
        outrouting(L4, R4, L3, R3, L2, R2, L1, R1) = 
            ((L4, L2) :> _ / 2), 
            ((R3, R1) :> _ / 2);
    };

// OUTS
MIX = hslider("MIX Dry/Wet", 0, 0, 1, .001) : si.smoo;
MIXER(x) = KBReverb(x, x, x, x) : par(i, 2, x * (1-MIX) + _ * MIX);
process = MIXER;

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

// Delay
DEL(delay) = _ @ (delay);

// DSP Process in the Feedback Loop
PROC(x) = x;