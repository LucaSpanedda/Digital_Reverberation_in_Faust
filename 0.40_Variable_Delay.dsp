// import Standard Faust library
// https://github.com/grame-cncm/faustlibraries/
import("stdfaust.lib");

// GUI AND CONVERSIONS
// Delay in samples & Delay in milliseconds
GUIdelsamps = hslider("Delay[unit:samples][style:knob]",0,0,196000,1);
GUIdelms = hslider("Delay[unit:milliseconds][style:knob]", 0, 0, 1000, 0.1)*ma.SR/1000.0;
// Interpolation in samples & in milliseconds
GUIintersamps = hslider("interpolation[unit:samples][style:knob]",
1,1,19600,1); 
GUIinterms = hslider("interpolation[unit:milliseconds][style:knob]",
10,1,100,0.1)*ma.SR/1000.0; 
// Feedback 0 to 1.
GUIfeedback = hslider("feedback[style:knob]",0,0,100,0.1)/100.0; 

onems = ma.SR/1000.0;

// VARIABLE DELAY LINE with FEEDBACK
// vardelay in samples: buffer, delay time, interpolation, feedback
vardelay(memdim,delay,inter,fb) = delcircuit
with 
{ 
    delcircuit = (+ : de.sdelay(buffer, it, dt)) ~ *(fb);
    buffer = int(memdim);
    it = inter; 
    dt = delay;
};

process = vardelay(196000,GUIdelsamps,onems,0) <: _,_;
