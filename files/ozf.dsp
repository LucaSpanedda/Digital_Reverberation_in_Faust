// import Standard Faust library
// https://github.com/grame-cncm/faustlibraries/
import("stdfaust.lib");


// (G,x) = x=input, G=give amplitude 0-1(open-close) to the delayed signal
OZF(G,x) = (x:mem*G), x :> +;

// out
process = OZF(0.1);
