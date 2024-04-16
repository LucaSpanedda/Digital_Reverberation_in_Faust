// import Standard Faust library
// https://github.com/grame-cncm/faustlibraries/
import("stdfaust.lib");

// LPFBC(Del, FCut) = give: delay samps, -feedback gain 0-1-, lowpass Freq.Cut HZ
lpfbcf(del, cf, x) = loop ~ _ : !, _
    with {
        onepole(CF, x) = loop ~ _ 
            with{
                g(x) = x / (1.0 + x);
                G = tan(CF * ma.PI / ma.SR):g;
                loop(y) = x * G + (y * (1 - G));
            };
        loop(y) = x + y@(del - 1) <: onepole(cf), _;
    };
process = _ * .1 : lpfbcf(2000, 10000);
