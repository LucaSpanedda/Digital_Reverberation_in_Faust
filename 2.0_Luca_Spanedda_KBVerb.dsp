declare name 		"Luca Spanedda's KBVerb";
declare version 	"1.0.0";
declare author 		"Luca Spanedda";
declare copyright 	"Copyright(c) 2022 Luca Spanedda";

// import Standard Faust library
// https://github.com/grame-cncm/faustlibraries/
import("stdfaust.lib");

// Luca Spanedda's KBVerb
// Reverb Model based on: Keith Barr Allpass Loop Reverb
KBReverb(IN) = Circuit
with{
    APF(delaysamples) = (+ : _ <: @(delaysamples-1), *(0.5)) ~ *(-0.5) : mem, _ : + : _;

    Decorrelation(L1,R1,L2,R2,L3,R3,L4,R4) = 
    (Delay(L1,Lsum_1)+Delay(L2,Lsum_2)+Delay(L3,Lsum_3)+Delay(L4,Lsum_4))/4,
    (Delay(R1,Rsum_1)+Delay(R2,Rsum_2)+Delay(R3,Rsum_3)+Delay(R4,Rsum_4))/4;

    Circuit = IN <: (Decorrelation: _*Early, _*Early),
    ((Sect_A<:(_*KRT:Sect_B<:(_*KRT:Sect_C<:(_*KRT:Sect_D<:_*KRT,_,_),_,_),_,_),_,_)~_
    : !,_,_,_,_,_,_,_,_ : Decorrelation) : routing;
    routing(a,b,c,d) = (a+c)/2,(b+d)/2;
    
    Sect_A = IN+_ : APF(APF_A1) : APF(APF_A2);
    Sect_B = IN+_ : APF(APF_B1) : APF(APF_B2);
    Sect_C = IN+_ : APF(APF_C1) : APF(APF_C2);
    Sect_D = IN+_ : APF(APF_D1) : APF(APF_D2);
    }
        with{
            Delay(x,del) = x@(del);
            Early = hslider("Early Reflections [style:knob]",0.920,0,1,0.001) : si.smoo;
            KRT = hslider("Reverb Decay [style:knob]",0.820,0,1,0.001) : si.smoo;

            // Tuning :
            APF_A1 = 3203; 
            APF_A2 = 3019;
            APF_B1 = 2879;
            APF_B2 = 2417;
            APF_C1 = 2399;
            APF_C2 = 2269;
            APF_D1 = 2083;
            APF_D2 = 2003;
            Lsum_1 = 491;
            Lsum_2 = 601;
            Lsum_3 = 881;
            Lsum_4 = 419;
            Rsum_1 = 797;
            Rsum_2 = 919;
            Rsum_3 = 631;
            Rsum_4 = 811;
            };

Dry_Wet = hslider("Dry/Wet [style:knob]",1,0,1,0.001) : si.smoo;
Master_Route(a,b,c,d) = (a+c)/2, (b+d)/2;
process = _<: (KBReverb <: _*Dry_Wet, _*Dry_Wet), _*(1-Dry_Wet), _*(1-Dry_Wet): Master_Route;
