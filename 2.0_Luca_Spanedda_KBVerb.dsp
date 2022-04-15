// import Standard Faust library
// https://github.com/grame-cncm/faustlibraries/
import("stdfaust.lib");

// Keith Barr Allpass Loop Reverb

Reverb(IN) = KBReverb
with{
APF(delaysamples) = (+ : _ <: @(delaysamples-1), *(0.5)) ~ *(-0.5) : mem, _ : + : _;

    Decorrelation(L1,R1,L2,R2,L3,R3,L4,R4) = 
    (delay(L1,Lsum_1)+delay(L2,Lsum_2)+delay(L3,Lsum_3)+delay(L4,Lsum_4))/4,
    (delay(R1,Rsum_1)+delay(R2,Rsum_2)+delay(R3,Rsum_3)+delay(R4,Rsum_4))/4;

    KBReverb = IN <: Decorrelation,
    ((Sect_A<:(_*KRT:Sect_B<:(_*KRT:Sect_C<:(_*KRT:Sect_D<:_*KRT,_,_),_,_),_,_),_,_)~_
    : !,_,_,_,_,_,_,_,_ : Decorrelation) : routing;
    routing(a,b,c,d) = (a+c)/2,(b+d)/2;
    
    Sect_A = IN+_ : APF(APF_A1) : APF(APF_A2);
    Sect_B = IN+_ : APF(APF_B1) : APF(APF_B2);
    Sect_C = IN+_ : APF(APF_C1) : APF(APF_C2);
    Sect_D = IN+_ : APF(APF_D1) : APF(APF_D2);
    }
        with{
        delay(x,del) = x@(del);
        KRT = hslider("Decay",0,0,1,0.001) : si.smoo;

        // Tuning :
        APF_A1 = 3200; 
        APF_A2 = 3020;
        APF_B1 = 2880;
        APF_B2 = 2420;
        APF_C1 = 2430;
        APF_C2 = 2480;
        APF_D1 = 2600;
        APF_D2 = 2820;
        Lsum_1 = 480;
        Lsum_2 = 600;
        Lsum_3 = 880;
        Lsum_4 = 420;
        Rsum_1 = 800;
        Rsum_2 = 920;
        Rsum_3 = 640;
        Rsum_4 = 820;
        };

process = Reverb;
