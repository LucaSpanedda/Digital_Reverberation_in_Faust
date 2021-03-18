import("stdfaust.lib");

// Keith Barr Allpass Loop Reverb

allpassfilter(delaysamples) = allpassout
    // allpassfilter include al suo interno:
    with{

        allpass = 
        (+ : _ <: @(delaysamples-1), *(0.5)) ~ 
        *(-0.5) : mem, _ : + : _;
        allpassout = allpass;

};


loopreverb = retroaction
    // allpassfilter include al suo interno:
    with{

        //KRT control reverb decay
        krt = 0.9; 

        // section 1
        sect1 = _ : allpassfilter(4000) : allpassfilter(3800) : _*krt;

        // section 2
        sect2 = _ : allpassfilter(3700) : allpassfilter(3600) : _*krt;

        // section 3
        sect3 = _ : allpassfilter(2200) : allpassfilter(2000) : _*krt;

        // section 4
        sect4 = _ : allpassfilter(1000) : allpassfilter(800) : _*krt;

        // retroaction
        retroaction = _ : (+ : _ <: sect1 : sect2 : sect3 : sect4) ~ _ ;
};

process = loopreverb <: _,_ ;