// import Standard Faust library 
// https://github.com/grame-cncm/faustlibraries/ 
import("stdfaust.lib");

sampdel = ma.SR; 
// sample rate - ma.SR

process =   _ : 
            // input signal goes in
            +~ @(sampdel -1) *(0.8) 
            // delay line with feedback: +~
            : mem
            // output goes to a single sample delay
            <: si.bus(2);
