import("stdfaust.lib");

// Keith Barr Allpass Loop Reverb (WORK IN PROGRESS...)

allpassfilter(delaysamples) = allpassout
// allpassfilter include al suo interno:
with{

        allpass = 
        (+ : _ <: @(delaysamples-1), *(0.5)) ~ 
        *(-0.5) : mem, _ : + : _;
        allpassout = allpass;

};

allpassloopreverb(secondi_decayt60_desiderati) = retroactionloop
// allpassfilter include al suo interno:
with{

    // T60
    // delay del filtro in ms.
    delfiltroinms = ((1000/ma.SR)/6037)/1000;
    // 3 * delaydelfiltro / T60 desiderato
    esponente = (3*delfiltroinms)/secondi_decayt60_desiderati;
    // 10 alla -esponente
    outdecayt60 = 1/(10^esponente);


        //KRT control reverb decay
        krt = outdecayt60; 
        // section 1
        sect1 = _ : allpassfilter(6037) : allpassfilter(5881) : _*krt;
        // section 2
        sect2 = _ : allpassfilter(5701) : allpassfilter(5623) : _*krt;
        // section 3
        sect3 = _ : allpassfilter(4231) : allpassfilter(4337) : _*krt;
        // section 4
        sect4 = _ : allpassfilter(997) : allpassfilter(911) : _*krt;

        // retroaction
        retroactionloop = _ : (+ : _ <: sect1 : sect2 : sect3 : sect4) ~ _ ;

};

// allpassloopreverb( decadimento T60 definito in secondi)
process = allpassloopreverb(20) <: _,_ ;
