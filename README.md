# Digital Reverberation

Digital reverberation is a continually relevant and widely discussed topic in the realms of computer music and Digital Signal Processing, as well as electroacoustic music in general. Its applications and studies have involved both commercial and academic sectors. Consequently, over time, a complex history has developed, characterized by numerous ramifications and implications, leading to a proliferation of various methods and implementation topologies. In this study, we will delve into the subject in detail, examining the main existing implementations.

## Reverberation

Reverberation is the persistence of sound after it has been produced. It is an acoustic phenomenon related to the reflection of sound waves by an obstacle placed in front of the sound source. Assumptions that determine the perception of a reverberation phenomenon:

1. The human ear cannot distinguish two sounds if they are perceived less than 100 milliseconds apart.
2. The speed of sound in the air at 20°C is approximately 340 m/s.
3. The sound source and the listener are in the same location facing the obstacle.

Given these assumptions, in an open space, reverberation can be discussed when the obstacle is less than 17 meters from the sound source. Indeed, up to this distance, the path of the sound wave from the source to the obstacle and back is less than 34 meters, and therefore the sound takes less than 100 milliseconds to return to the starting point, blending into the listener's ear with the original sound. If the obstacle is more than 17 meters away from the source, then the delay of the reflected sound compared to the direct sound is more than 100 milliseconds, and the two sounds are therefore distinct. In this case, it is called an echo.

### Duration of Reverberation

The factors that influence the duration of reverberation are multiple. The most influential ones are:

1. Room size
   
   - Larger rooms produce longer reverberations.
   - Small rooms produce shorter reverberations.

2. Materials
   
   - Hard materials like ceramics and plastics reflect sound more.
   - Soft materials like wood absorb much more sound.
   
   For these reasons related to materials, a small room like a bathroom has longer reverberation times than a large wooden room.

The best way to listen to the reverberation of a reverberant space is to produce an impulsive sound; like a clap of hands or a snap of fingers.

### Reverberation in Music

Music has made extensive use of reverberation for thousands of years. Archaeologists believe that reverberation produced by caves was used in ancient ceremonies. Many cathedrals in Europe have reverberations lasting more than 10 seconds, and the choral music of certain eras worked particularly well by exploiting the reverberation inside these cathedrals. In fact, the reverberation of individual notes overlaps on subsequent notes, transforming a monophonic melody into a polyphonic sound.

### Reflections

A standard room has 6 surfaces:

- Right wall
- Left wall
- Front wall
- Back wall
- Ceiling
- Floor

A sound, when produced, bounces off the surfaces and is subsequently heard, producing what are called:

1. First-order reflections

Each of these will produce another 6 echoes: 6 echoes, each bouncing off the 6 surfaces, will produce 36 echoes; these are called:

2. Second-order reflections

producing a total of 42 echoes in a very short period of time, and so on... Of all these echoes, none is perceived individually, but rather their ensemble and dispersion over time are perceived. Reverberation is thus composed of thousands of echoes of the original sound that persist and decay over time.

### Artificial Reverberation Models

Reverberation is artificial when it is not present in the room where the recording is taking place but is instead added later.

1. Tape echo
   A particular magnetic tape recorder/player is used, which constantly moves a tape loop inside a mechanism with a fixed recording head and a mobile playback head. The signal recorded by the first head is read by the second and mixed with the original, generating the effect. These devices are bulky and heavy. Like in any tape recording, there is background noise similar to hiss, significantly higher than that produced with digital technologies.

2. Spring reverb
   The signal is passed, through a transducer, through a metal spiral (the spring). At the other end of the spring, a transducer equivalent to the first one reintroduces the signal into the amplification circuit, mixing it with the original. The signal taken from the second transducer is slightly delayed compared to the one applied to the first, creating the reverberation effect in the listener's ear.

3. Chamber reverb
   Following the spring reverb model, in a box acoustically isolated from the outside, a curved tube is inserted to create the longest possible path. At one end of the tube is placed a small loudspeaker, while at the other end there is a microphone. The sound emitted by the loudspeaker will take some time to travel the entire tube and reach the microphone, thus generating the necessary delay. The signal taken from the microphone will be fed back into the mixing console, mixed with the original.

4. Plate reverb
   Similar to spring reverb, but with a large metal plate instead of the spring. It has two transducers attached to its surface and works in a similar way, although its quality is significantly higher.

## Digital Reverbs

They are produced by a computer or dedicated DSP integrated circuits.
There are integrated circuits on the market that include A/D and D/A converters,
memories, and timing circuits. 
An acoustic signal is transduced and converted into numbers that enter memories.
In fact, the bytes are "scrolled" from one bank to the next until the last one is reached. 
The digital signal taken from the last memory is then reconverted into analog and mixed 
with the original signal, obtaining the reverberation effect;
the farther the read point from the write point, the longer the echo time will be.
The size of these read and write memories is called delay line, and it is expressed in samples.
The large capacity of RAM memories allows achieving delays 
of several seconds and therefore smoothly transition from reverb to echo. 
The strategy used afterwards is to feed back the output of the delay line by adding it to the input,
thus creating a feedback circuit.
All this process is done because modern computers are very powerful, 
but they are not yet powerful enough to generate all the reflections 
heard in a large room, one by one.
Rather, the goal of creating digital reverbs is to implement models and strategies
to replicate the impression of the reverberation of a room.
The replication process has generated in the history of digital reverbs true and proper typical sounds different from each other
which can be implemented and preferred by musicians for aesthetic reasons.

# Digital Reverb in FAUST

Experiments and algorithms of digital reverb models in the FAUST language (GRAME)

## Delay Lines in Faust

Delay lines in Faust are divided into the following categories:
mem - indicates a single sample delay
@ - indicates a number (e.g., 44100) of variable delay samples
x'- x indicates any input and: ' a sample delay, ''(2), etc.
rdtable - indicates a read-only table
rwtable - indicates a read and write table.

Through delay lines, 
we can create a Dirac impulse, which represents 
our minimum unit, namely the single sample
by putting a number 1 and subtracting the same value from it
but doing it at a delayed sample.

Example:
https://github.com/LucaSpanedda/Digital_Reverberation_in_Faust/blob/095184bacec196ba5b8dbf83bfae14fbf1476fd5/REV.lib?plain=1#L11-L13
```
# files/dirac.dsp
```
```
files/dirac.dsp
```
## Some Methods for Implementing Recursive Circuits in the Faust Language

We will illustrate 3 main methods:

- Writing the code line with internal recursion:
  
  in this way the tilde ~ operator sends the signal
  output to itself, to the first available input
  creating a feedback circuit.
  One way to force the operator to point to a certain point
  in the code, is to put parentheses (), in this way ~
  will point to the input before the parenthesis.

- A second method consists of using with{} .
  
  You can define a function in which are passed
  the various arguments of the function that control
  the parameters of the code,
  and say that that function is equal to
  exit from the with with ~ _
  example:
  
      function_with(argument1, argument2) = out_with ~ _
       with{  
        section1 = _ * argument1;
        section2 = argument1 * argument2;
        out_with = section2;
        };
      
        where out_with ~ _ returns to itself.

Moreover, with in Faust allows declaring variables
that are not pointed to from outside the code but only
from the belonging function; in this case
the function to which with belongs is "function_with".

- A third method is to use the letrec environment.
  
  with this method we can write a signal
  recursively, similar to how
  recurrence equations are written.
  
  example:
  
  ```
   import("stdfaust.lib");
  
   // letrec:
   // function
   lowpass(cf, x) = y
   // letrec definition
   letrec {
   'y = b0 * x - a1 * y;
   }
   // inside the letrec function
   with {
   b0 = 1 + a1;
   a1 = exp(-w(cf)) * -1;
   w(f) = 2 * ma.PI * f / ma.SR;
   };
  
  // Output of the letrec function
   process = lowpass;
  ```

## Conversion of Milliseconds to Samples and Vice Versa

### Conversion from Milliseconds to Samples

Function for Conversion from Milliseconds to Samples:
we input the time in milliseconds,
and the function gives us the value in samples.

For example, if we have a sampling frequency 
of 48,000 samples per second, 
it means that 1000ms (1 second) is represented
by 48,000 parts, and therefore a single unit
of time like 1 ms. Corresponds digitally to 48 samples.

For this reason, we divide the sampling frequency
by 1000ms, resulting in a total number of samples
that corresponds to 1 ms. in the digital world at 
a certain sampling frequency.

And then we multiply the result of this operation
by the total number of milliseconds we want to obtain as 
a representation in samples.
If we multiply *10. For example, we will get
480 samples at a sampling frequency 
of 48,000 samples per second.

### Conversion from Samples to Milliseconds

Function for Conversion from Samples to Milliseconds:
we input a total number of samples,
of which we need to know the overall duration
in milliseconds based on our sampling frequency.

We know that a sampling frequency
corresponds to a set of values that express 
together the duration of 1 second (1000 ms).

It means, for example,
that at a sampling frequency of 48,000
samples per second, 
1000 milliseconds are represented by 48,000 parts.
So if we divide our 1000ms. / 
into the 48,000 parts which are the samples of our system,
we would get the duration in milliseconds of a single sample
at that sampling frequency,
in this case therefore: 
1000 / 48,000 = 0.02ms. 
And so the duration in milliseconds of a single sample at 48,000
samples per second, is 0.02 milliseconds.
If we multiply the obtained number *
a total number of samples, we will get the time in milliseconds
of those samples for that sampling frequency used.

Obviously, as can be deduced from the considerations,
as the sampling frequency increases,
the temporal duration of a single sample decreases,
and thus a greater definition.

## Phase Alignment of Feedback

In the digital domain, the feedback of a 
delay line, when applied, costs by default one sample delay.
Feedback = 1 Sample

At the moment I decide therefore to put
inside the feedback a number
of delay samples,
we can take for example 10 samples
in our delay line, it means that,
The direct signal will come out for delay samples at:

input in the delay signal --> output from the delay 10samp

1st Feedback:
output from the delay at 10samp + 1 feedback = 
input in the delay 11samp --> output from the delay 21samp

2nd Feedback:
output from the delay at 21samp + 1 feedback = 
input in the delay 22samp --> output from the delay 32samp

3rd Feedback:
output from the delay at 32samp + 1 feedback = 
input in the delay 33samp --> output from the delay 43samp

and so on...

we can therefore notice immediately that we will not have
the correct delay value required inside the same,
because of the sample delay that occurs at the moment
when I decide to create a feedback circuit.
if we use the method of subtracting one sample from the delay line,
we will have this result:

input in the delay signal --> -1, output from the delay 9samp

1st Feedback:
output from the delay at 9samp + 1 feedback = 
input in the delay 10samp --> -1, output from the delay 19samp

2nd Feedback:
output from the delay at 19samp + 1 feedback = 
input in the delay 20samp --> -1, output from the delay 29samp

3rd Feedback:
output from the delay at 29samp + 1 feedback = 
input in the delay 30samp --> -1, output from the delay 39samp

and so on...

we can therefore notice that with this method,
compared to the previous one we will have as input to the delay line
always the number of delay samples required.
But we notice that from the first output of the delayed signal
subtracting -1 we have one sample delay
less than we would like.
To realign everything, we just need to add one sample delay
to the overall output of the circuit, thus having from the first output:

input in the delay signal --> -1, output from the delay 9samp +1 = 10out

1st Feedback:
output from the delay at 9samp + 1 feedback = 
input in the delay 10samp --> -1, output from the delay 19samp +1 = 20out

and so on...

Let's proceed with an implementation:

```
campioni_ritardo = ma.SR; 
// sample rate - ma.SR

process =   _ : 
            // input signal goes in
            +~ @(campioni_ritardo -1) *(0.8) 
            // delay line with feedback: +~
            : mem;
            // output goes to a single sample delay
```

## T60 Decay Calculation

The term "T60" in the context of digital reverberation refers to the reverberation time. The reverberation time is a measure of the duration for which sound persists in a space after the sound source has stopped. It indicates how quickly the sound energy decreases over time.

The T60 value represents the time it takes for the sound level to decrease by 60 decibels (dB) compared to its initial value. In other words, it is the time taken for the sound energy to decay by 60 dB. A long T60 indicates prolonged reverberation, while a short T60 indicates shorter reverberation.

The formula below uses the relationship between the T60 decay time and the number of filter samples to calculate the amplification gain necessary. The result of the calculation is a linear value ranging from 0 to 1, representing the amplification to be applied to the filter feedback.

Insert the following arguments into the function:

- The value in samples of the filter 
  you are using for the delay.

- The decay value in T60
  (decay time of 60 dB in seconds)

- = GET as output from the function, 
  the value to be passed as amplification
  to the filter feedback to achieve
  the desired T60 decay time
  
  ```
  // (samps,seconds) = give: samples of the filter, seconds we want for t60 decay
  dect60(samps,seconds) = 1/(10^((3*(((1000 / ma.SR)*samps)/1000))/seconds));
  ```
  
# Digital Filters

### ONEZERO FILTER (1st Order FIR)

_ represents the input signal, (_ denotes the signal)
    it is then split into two parallel paths <: 
    one delayed by one sample _' (' denotes one sample delay)
    and one without delay , _ (, denotes transition to the second path)
    they are then summed into a single signal :> _ ;
    the delayed signal has a feedforward amplitude control * feedforward
    there is a general amplitude control * outgain
    on the output function onezeroout

```
// import Standard Faust library
// https://github.com/grame-cncm/faustlibraries/
import("stdfaust.lib");


// (G,x) = x=input, G=give amplitude 0-1(open-close) to the delayed signal
OZF(G,x) = (x:mem*G), x :> +;

// out
process = OZF(0.1);
```

### ONEPOLE FILTER (1st Order IIR)

+~ is the summation, and the feedback 
    of the arguments inside parentheses ()
    _ represents the input signal, (_ denotes the signal)
    delayed by one sample _ (automatically in the feedback)
    which enters : into the gain control of the feedback * 1-feedback
    the same feedback controls the input amplification
    of the signal not injected into the feedback
    there is a general amplitude control * outgain
    on the output function onezeroout

```
// import Standard Faust library
// https://github.com/grame-cncm/faustlibraries/
import("stdfaust.lib");

// (G)  = give amplitude 1-0 (open-close) for the lowpass cut
// (CF) = Frequency Cut in HZ
OPF(CF,x) = OPFFBcircuit ~ _ 
    with{
        g(x) = x / (1.0 + x);
        G = tan(CF * ma.PI / ma.SR):g;
        OPFFBcircuit(y) = x*G+(y*(1-G));
        };

process = OPF(20000) <: _,_;
```

### ONEPOLE Topology Preserving Transforms (TPT)

TPT version of the One-Pole Filter by Vadim Zavalishin
reference: (by Will Pirkle)
http://www.willpirkle.com/Downloads/AN-4VirtualAnalogFilters.2.0.pdf

```
// import Standard Faust library
// https://github.com/grame-cncm/faustlibraries/
import("stdfaust.lib");

OnepoleTPT(CF,x) = circuit ~ _ : ! , _
    with {
        g = tan(CF * ma.PI / ma.SR);
        G = g / (1.0 + g);
        circuit(sig) = u , lp
            with {
                v = (x - sig) * G;
                u = v + lp;
                lp = v + sig;
            };
    };

// out
process = OnepoleTPT(100);
```

### FEEDFORWARD COMB FILTER (Nth Order FIR)

_ represents the input signal, (_ denotes the signal)
    it is then split into two parallel paths <: 
    one delayed by @(delaysamples) samples
    (thus value to be passed externally)
    and one without delay , _ (, denotes transition to the second path)
    they are then summed into a single signal :> _ ;

In the feedback, one sample of delay is already present by default,
hence delaysamples-1.

the delayed signal has a feedforward amplitude control * feedforward

there is a general amplitude control * outgain
on the output function onezeroout

```
// import Standard Faust library
// https://github.com/grame-cncm/faustlibraries/
import("stdfaust.lib")


// (t,g) = delay time in samples, filter gain 0-1
ffcf(t, g, x) = (x@(t) * g), x :> +;
process = no.noise * .1 : ffcf(100, 1);
```

### FEEDBACK COMB FILTER (Nth Order IIR)

+~ is the summation, and the feedback 
    of the arguments inside parentheses ()
    _ represents the input signal, (_ denotes the signal)
    delayed by @(delaysamples) samples 
    (thus value to be passed externally)
    which enters : into the gain control of the feedback * feedback

In the feedback, one sample of delay is already present by default,
hence delaysamples-1.

there is a general amplitude control * outgain
on the output function combfeedbout

```
// import Standard Faust library
// https://github.com/grame-cncm/faustlibraries/
import("stdfaust.lib")


// Feedback Comb Filter. FBComb(Del,G,signal) 
// (Del, G) = DEL=delay time in samples. G=feedback gain 0-1
fbcf(del, g, x) = loop ~ _ 
    with {
        loop(y) = x + y@(del - 1) * g;
    };

process = no.noise * .1 : fbcf(4480, .9);
```

### Lowpass FEEDBACK COMB FILTER (Nth Order IIR)

similar to the comb filter, but within the feedback,
    following the feedback enters the signal : into the onepole.
    The onepole is a lowpass where the cutoff 
    frequency can be controlled between 0. and 1. 
    In the feedback, one sample of delay is already present by default,
    hence delaysamples-1.


```
// import Standard Faust library
// https://github.com/grame-cncm/faustlibraries/
import("stdfaust.lib")

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
```

### ALLPASS FILTER

from the sum (+ transitions : to a cable _ and a split <:
        then @delay and gain, in feedback ~ to the initial sum.
        filtergain controls the amplitude of the two gain states, 
        which in the filter are the same value but positive and negative,
        one side *-filtergain and one side *+filtergain.
        In the feedback, one sample of delay is already present by default,
        hence delaysamples-1.
        To maintain the delay threshold of the value delaysamples,
        a mem delay (of the subtracted sample) is added
        at the end

```
// import Standard Faust library
// https://github.com/grame-cncm/faustlibraries/
import("stdfaust.lib")


// (t, g) = give: delay in samples, feedback gain 0-1
apf(del, g, x) = x : (+ : _ <: @(del-1), *(g))~ *(-g) : mem, _ : + : _;
process = no.noise * .1 <: apf(100, .5);
```

### Modulated ALLPASS FILTER

```
// import Standard Faust library
// https://github.com/grame-cncm/faustlibraries/
import("stdfaust.lib")


// Modulated Allpass filter
ModAPF(delsamples, samplesmod, freqmod, apcoeff) = ( + : _ <: 
    delayMod(delsamples, samplesmod, freqmod),
    * (apcoeff))~ * (-apcoeff) : mem, _ : + : _
    with{
        delayMod(samples, samplesMod, freqMod, x) = delay
        with{
            unipolarMod(f, samples) = ((os.osc(f) + 1) / 2) * samples;
            delay = x : de.fdelay(samples, samples - unipolarMod(freqMod, samplesMod));
        };
    };
process = 1-1' : +@(ma.SR/100) ~ _ <: _, ModAPF(1000, 500, .12, .5);
```

# Topologies and Design of Digital Reverbs

## References

- Manfred Schroeder, “Natural Sounding Artificial Reverb,” 1962. 

- Michael Gerzon, “Synthetic Stereo Reverberation,” 1971. 

- James (Andy) Moorer, “About This Reverberation Business,” 1979

- Christopher Moore, “Time-Modulated Delay System and Improved Reverberation Using Same,” 1979. 

- John Stautner and Miller Puckette, “Designing Multichannel Reverberators,” 1982. 

- Jon Dattorro, “Effect Design - Part 1: Reverberator and Other Filters,” 1997.

- Jean-Marc Jot, “Efficient models for reverberation and distance rendering in computer music and virtual audio reality,” 1997. 

- D. Rochesso, “Reverberation,” DAFX - Digital Audio Effects, Udo Zölzer, 2002.
  
  ## Topologies
  
  - Manfred Schroeder propone l'applicazione di una rete di allpass e comb filters.
  - James Moorer implementa un filtro lowpass all'interno della retroazione dei comb.
  - Christopher Moore propone linee di ritardo modulate nel tempo e uscite Multi-tap da modelli delle early relfection.
  - William Martens e Gary Kendall propongono delle early reflection spazializzate.
  - Michael Gerzon, John Stautner & Miller Puckette propongono le Feedback Delay Network (mixer a matrice per i feedback).
  - David Griesinger propone un singolo Loop di Feedback utilizzando ritardi e filtri allpass.

# Main References

Introduction to Digital Filters: 
With Audio Applications.
Libro di Julius O. Smith III.
Links alla serie di Libri di Smith:

- Mathematics of the Discrete Fourier Transform (DFT)
- Introduction to Digital Filters
- Physical Audio Signal Processing
- Spectral Audio Signal Processing
  sulla pagina CCRMA di J.Smith https://ccrma.stanford.edu/~jos/fp/ su DSP Related [Free DSP Books](https://www.dsprelated.com/freebooks.php)

TOM ERBE - UC SAN DIEGO - REVERB TOPOLOGIES AND DESIGN http://tre.ucsd.edu/wordpress/wp-content/uploads/2018/10/reverbtopo.pdf

ARTIFICIAL REVERBERATION: su DSPRELATED [Artificial Reverberation | Physical Audio Signal Processing](https://www.dsprelated.com/freebooks/pasp/Artificial_Reverberation.html)

Corey Kereliuk - Building a Reverb Plugin in Faust
Keith Barr’s reverb architecture http://blog.reverberate.ca/post/faust-reverb/

Spin Semiconductor DSP Basics [Spin Semiconductor - DSP Basics](http://www.spinsemi.com/knowledge_base/dsp_basics.html) Spin Semiconductor Audio Effects [Spin Semiconductor - Effects](http://www.spinsemi.com/knowledge_base/effects.html#Reverberation)

freeverb3vst - Reverb Algorithms Tips http://freeverb3vst.osdn.jp/tips/reverb.shtml

History of allpass loop / "ring" reverbs [History of allpass loop / &quot;ring&quot; reverbs? - Spin Semiconductor](http://www.spinsemi.com/forum/viewtopic.php?p=555&sid=5d31391b3883f1b9e013d5af80805019)

Musical Applications of Microprocessors (The Hayden microcomputer series) http://sites.music.columbia.edu/cmc/courses/g6610/fall2016/week8/Musical_Applications_of_Microprocessors-Charmberlin.pdf

Acustica_Riverbero - Alfredo Ardia [Appunti: acustica_Riverbero](http://appuntimusicaelettronica.blogspot.com/2012/10/acusticariverbero.html)

Algorithmic Reverbs: The Moorer Design [Algorithmic Reverbs: The Moorer Design | flyingSand](https://christianfloisand.wordpress.com/2012/10/18/algorithmic-reverbs-the-moorer-design/)

Dattorro Convex Optimization of a Reverberator [Dattorro Convex Optimization of a Reverberator - Wikimization](https://www.convexoptimization.com/wikimization/index.php/Dattorro_Convex_Optimization_of_a_Reverberator)

Tabella dei numeri primi inferiori a 10.000 https://www.matematika.it/public/allegati/34/Numeri_primi_minori_di_10000_1_3.pdf

Introduction to Digital Filters: 
With Audio Applications.
Libro di Julius O. Smith III.
Links alla serie di Libri di Smith:

- Mathematics of the Discrete Fourier Transform (DFT)
- Introduction to Digital Filters
- Physical Audio Signal Processing
- Spectral Audio Signal Processing
  sulla pagina CCRMA di J.Smith https://ccrma.stanford.edu/~jos/fp/ su DSP Related [Free DSP Books](https://www.dsprelated.com/freebooks.php)

TOM ERBE - UC SAN DIEGO - REVERB TOPOLOGIES AND DESIGN http://tre.ucsd.edu/wordpress/wp-content/uploads/2018/10/reverbtopo.pdf

ARTIFICIAL REVERBERATION: su DSPRELATED [Artificial Reverberation | Physical Audio Signal Processing](https://www.dsprelated.com/freebooks/pasp/Artificial_Reverberation.html)

Corey Kereliuk - Building a Reverb Plugin in Faust
Keith Barr’s reverb architecture http://blog.reverberate.ca/post/faust-reverb/

Spin Semiconductor DSP Basics [Spin Semiconductor - DSP Basics](http://www.spinsemi.com/knowledge_base/dsp_basics.html) Spin Semiconductor Audio Effects [Spin Semiconductor - Effects](http://www.spinsemi.com/knowledge_base/effects.html#Reverberation)

freeverb3vst - Reverb Algorithms Tips http://freeverb3vst.osdn.jp/tips/reverb.shtml

History of allpass loop / "ring" reverbs http://www.spinsemi.com/forum/viewtopic.php?p=555&sid=5d31391b3883f1b9e013d5af80805019

Musical Applications of Microprocessors (The Hayden microcomputer series) http://sites.music.columbia.edu/cmc/courses/g6610/fall2016/week8/Musical_Applications_of_Microprocessors-Charmberlin.pdf

Acustica_Riverbero - Alfredo Ardia [Appunti: acustica_Riverbero](http://appuntimusicaelettronica.blogspot.com/2012/10/acusticariverbero.html)

Algorithmic Reverbs: The Moorer Design [Algorithmic Reverbs: The Moorer Design | flyingSand](https://christianfloisand.wordpress.com/2012/10/18/algorithmic-reverbs-the-moorer-design/)

Dattorro Convex Optimization of a Reverberator [Dattorro Convex Optimization of a Reverberator - Wikimization](https://www.convexoptimization.com/wikimization/index.php/Dattorro_Convex_Optimization_of_a_Reverberator)

Tabella dei numeri primi inferiori a 10.000 https://www.matematika.it/public/allegati/34/Numeri_primi_minori_di_10000_1_3.pdfReferenze principali

Introduction to Digital Filters: 
With Audio Applications.
Libro di Julius O. Smith III.
Links alla serie di Libri di Smith:

- Mathematics of the Discrete Fourier Transform (DFT)
- Introduction to Digital Filters
- Physical Audio Signal Processing
- Spectral Audio Signal Processing
  sulla pagina CCRMA di J.Smith https://ccrma.stanford.edu/~jos/fp/ su DSP Related [Free DSP Books](https://www.dsprelated.com/freebooks.php)

TOM ERBE - UC SAN DIEGO - REVERB TOPOLOGIES AND DESIGN http://tre.ucsd.edu/wordpress/wp-content/uploads/2018/10/reverbtopo.pdf

ARTIFICIAL REVERBERATION: su DSPRELATED [Artificial Reverberation | Physical Audio Signal Processing](https://www.dsprelated.com/freebooks/pasp/Artificial_Reverberation.html)

Corey Kereliuk - Building a Reverb Plugin in Faust
Keith Barr’s reverb architecture http://blog.reverberate.ca/post/faust-reverb/

Spin Semiconductor DSP Basics [Spin Semiconductor - DSP Basics](http://www.spinsemi.com/knowledge_base/dsp_basics.html) Spin Semiconductor Audio Effects [Spin Semiconductor - Effects](http://www.spinsemi.com/knowledge_base/effects.html#Reverberation)

freeverb3vst - Reverb Algorithms Tips http://freeverb3vst.osdn.jp/tips/reverb.shtml

History of allpass loop / "ring" reverbs http://www.spinsemi.com/forum/viewtopic.php?p=555&sid=5d31391b3883f1b9e013d5af80805019

Musical Applications of Microprocessors (The Hayden microcomputer series) http://sites.music.columbia.edu/cmc/courses/g6610/fall2016/week8/Musical_Applications_of_Microprocessors-Charmberlin.pdf

Acustica_Riverbero - Alfredo Ardia http://appuntimusicaelettronica.blogspot.com/2012/10/acusticariverbero.html

Algorithmic Reverbs: The Moorer Design [Algorithmic Reverbs: The Moorer Design | flyingSand](https://christianfloisand.wordpress.com/2012/10/18/algorithmic-reverbs-the-moorer-design/)

Dattorro Convex Optimization of a Reverberator [Dattorro Convex Optimization of a Reverberator - Wikimization](https://www.convexoptimization.com/wikimization/index.php/Dattorro_Convex_Optimization_of_a_Reverberator)

Tabella dei numeri primi inferiori a 10.000 https://www.matematika.it/public/allegati/34/Numeri_primi_minori_di_10000_1_3.pdf 
