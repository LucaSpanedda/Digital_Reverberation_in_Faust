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
DX  = 1251 ; // INPUT 1
DY  = 1751 ; // INPUT 2
DZ  = 1443 ; // INPUT 3
DW  = 1343 ; // INPUT 4
D1  = 3823 ; // AP1
D2  = 4732 ; // AP2
D3  = 8501 ; // DEL OUT 1
D4  = 2204 ; // AP3
D5  = 2701 ; // AP4
D6  = 7237 ; // DEL OUT 2
D7  = 2532 ; // AP5
D8  = 2201 ; // AP6
D9  = 6337 ; // DEL OUT 3
D10 = 1553 ; // AP7
D11 = 1583 ; // AP8
D12 = 5867 ; // DEL OUT 4

// Reverb Time
KRT = hslider("Rev Decay ",.8, 0, 1, .001) : si.smoo;
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
        loop_A(x, y) = x + y : APF(D1)  : APF(D2)   : DEL(D3)  ; 
        loop_B(x, y) = x + y : APF(D4)  : APF(D5)   : DEL(D6)  ;
        loop_C(x, y) = x + y : APF(D7)  : APF(D8)   : DEL(D9)  ;
        loop_D(x, y) = x + y : APF(D10) : APF(D11)  : DEL(D12) ;
        intD1(x) = x : APF(DX);
        intD2(x) = x : APF(DY);
        intD3(x) = x : APF(DZ);
        intD4(x) = x : APF(DW);
        outrouting(L4, R4, L3, R3, L2, R2, L1, R1) = 
            ((L4, L2) :> _ / 2), 
            ((R3, R1) :> _ / 2);
    };

// OUTS
process = _ <: KBReverb;

// Allpass filter
APF(delsamples) = (+: _<: @(delsamples-1),*(COEFF))~ *(-COEFF) : mem, _ : + : _;
// Delay
DEL(delay) = _@(delay);
// DSP Process in the Feedback Loop
PROC(x) = x;
