import("stdfaust.lib");
// Keith Barr Allpass Loop Reverb

apf(delaysamples) = ap
with{
        ap =
        (+ : _ <: @(delaysamples-1), *(0.5)) ~ 
        *(-0.5) : mem, _ : + : _;
};
		
		// tempo decadimento
        krt = 0.9;

        lrtap(dl,dr) = _@(dr) <: _,_,_;
        //process = lrtap(7,14);

        // section 1
        sect1(x,y) = x+y : apf(4801) : apf(2903) : lrtap(593,659) : *(krt),y,_,_;
        // process = sect1~_;
    router(a,b,c,d,e) = a, (b+d), (c+e);
    sect2(x,y) = x+y,_,_ : (apf(4673) : apf(2801)),_,_ : lrtap(743,751),_,_ : router : *(krt),y,_,_;
    //process = (sect1 : sect2)~_;
    sect3(x,y) = x+y,_,_ : (apf(3853) : apf(2657)),_,_ : lrtap(433,599),_,_ : router : *(krt),y,_,_;
    //process = (sect1 : sect2 : sect3)~_;
    sect4(x,y) = x+y,_,_ : (apf(3049) : apf(1987)),_,_ : lrtap(911,997),_,_ : router : *(krt),_,_;
    kbreverb = (sect1 : sect2 : sect3 : sect4)~_ : !,_,_;

    process = _ : kbreverb;
