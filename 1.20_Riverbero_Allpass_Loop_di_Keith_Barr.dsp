import("stdfaust.lib");
// Keith Barr Allpass Loop Reverb

apf(delaysamples) = ap
with{
        ap =
        (+ : _ <: @(delaysamples-1), *(0.5)) ~ 
        *(-0.5) : mem, _ : + : _;
};
		
		// tempo decadimento
        krt = 0.45;

        lrtap(dl,dr) = _ <: @(dl), @(dr) <: +,_,_;
        //process = lrtap(7,14);

        // section 1
        sect1(x,y) = x+y : apf(12401) : apf(2003) : lrtap(123,233) : *(krt),y,_,_;
        // process = sect1~_;
    router(a,b,c,d,e) = a, (b+d), (c+e);
    sect2(x,y) = x+y,_,_ : (apf(12037) : apf(211)),_,_ : lrtap(229,127),_,_ : router : *(krt),y,_,_;
    //process = (sect1 : sect2)~_;
    sect3(x,y) = x+y,_,_ : (apf(9901) : apf(347)),_,_ : lrtap(149,257),_,_ : router : *(krt),y,_,_;
    //process = (sect1 : sect2 : sect3)~_;
    sect4(x,y) = x+y,_,_ : (apf(7001) : apf(521)),_,_ : lrtap(263,151),_,_ : router : *(krt),_,_;
    kbreverb = (sect1 : sect2 : sect3 : sect4)~_ : !,_,_;

    process = os.impulse : kbreverb;
