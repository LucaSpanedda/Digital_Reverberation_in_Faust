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
https://github.com/LucaSpanedda/Digital_Reverberation_in_Faust/blob/0e4a77f524bf5da3c5e844bf6c53427ae1e62aba/files/dirac.dsp#L1-L7

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
https://github.com/LucaSpanedda/Digital_Reverberation_in_Faust/blob/51ad8ef2df32e9f9d7c9b60cb7696e3529d3aa28/files/lowpassletrec.dsp#L1-L19

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

https://github.com/LucaSpanedda/Digital_Reverberation_in_Faust/blob/51ad8ef2df32e9f9d7c9b60cb7696e3529d3aa28/files/sampdel.dsp#L1-L14

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
  
https://github.com/LucaSpanedda/Digital_Reverberation_in_Faust/blob/52b221c9d6405bd762aa0b681a9f47fbbe08ad64/files/t60.dsp#L1-L6
  
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

https://github.com/LucaSpanedda/Digital_Reverberation_in_Faust/blob/d83be7d48b5450844d8f5b0071b993a8382e4621/files/ozf.dsp#L1-L10

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

https://github.com/LucaSpanedda/Digital_Reverberation_in_Faust/blob/4a690fded18ca5b94d3da2064aaa063386786236/files/opf.dsp#L1-L14

### ONEPOLE Topology Preserving Transforms (TPT)

TPT version of the One-Pole Filter by Vadim Zavalishin
reference: (by Will Pirkle)
http://www.willpirkle.com/Downloads/AN-4VirtualAnalogFilters.2.0.pdf

https://github.com/LucaSpanedda/Digital_Reverberation_in_Faust/blob/b1efcf53d94061d4703ed63be0317f3833b5a4a1/files/opftpt.dsp#L1-L18

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

https://github.com/LucaSpanedda/Digital_Reverberation_in_Faust/blob/c3d5fae9d54061deac8c2b719f8d065dccc1ad26/files/ffcf.dsp#L1-L7

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

https://github.com/LucaSpanedda/Digital_Reverberation_in_Faust/blob/cbb2d41fcad235bc4e6170bc099f3d7e736f0915/files/fbcf.dsp#L1-L12

### Lowpass FEEDBACK COMB FILTER (Nth Order IIR)

similar to the comb filter, but within the feedback,
    following the feedback enters the signal : into the onepole.
    The onepole is a lowpass where the cutoff 
    frequency can be controlled between 0. and 1. 
    In the feedback, one sample of delay is already present by default,
    hence delaysamples-1.

https://github.com/LucaSpanedda/Digital_Reverberation_in_Faust/blob/35524fa6d329f856c2dd6a9057fbf2b296c810dc/files/lpfbcf.dsp#L1-L16

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

https://github.com/LucaSpanedda/Digital_Reverberation_in_Faust/blob/ad119f43d322581c8316026c97fe35518b863284/files/apf.dsp#L1-L7

### Modulated ALLPASS FILTER

https://github.com/LucaSpanedda/Digital_Reverberation_in_Faust/blob/19acaf236017bfa39c46172a60375fbe3df51118/files/modapf.dsp#L1-L16

# Topologies and Design of Digital Reverbs

### Chamberlin Reverb

The Chamberlin Reverb is named after Hal Chamberlin, a pioneer in digital sound processing. This reverberation model was first introduced in his seminal book, Musical Applications of Microprocessors (1979).
At its core, the Chamberlin Reverb uses a network of all-pass filters (APF) to create a dense and natural-sounding reverberation effect. 
The model is particularly effective at simulating small acoustic spaces, such as rooms or chambers, and is designed with simplicity in mind, making it computationally efficient. This efficiency made it suitable for the early digital processors with limited resources.

```faust
// Chamberlin Reverb
chamberlinReverb = ap3ch <: apout1ch, apout2ch
with {
    ap3ch = apf(msasamps(49.6), 0.75) : apf(msasamps(34.75), 0.72) : apf(msasamps(24.18), 0.691);
    apout1ch = apf(msasamps(17.85), 0.649) : apf(msasamps(10.98), 0.662);
    apout2ch = apf(msasamps(18.01), 0.646) : apf(msasamps(10.82), 0.666);
};
process = chamberlinReverb;
```

### Chamberlin Reverb with Decay T60

This version includes a decay time T60 control in the comb-allpass filters, representing the time required for the signal to decay by 60 dB.

```faust
// Chamberlin Reverb with T60 Decay
chamberlinDecay(seconds) = ap3ch <: apout1ch, apout2ch
with {
    ap3ch = apf(msasamps(49.6), t60_ms(49.6, seconds)) : 
            apf(msasamps(34.75), t60_ms(34.75, seconds)) : 
            apf(msasamps(24.18), t60_ms(24.18, seconds));
    apout1ch = apf(msasamps(17.85), t60_ms(17.85, seconds)) : 
               apf(msasamps(10.98), t60_ms(10.98, seconds));
    apout2ch = apf(msasamps(18.01), t60_ms(18.01, seconds)) : 
               apf(msasamps(10.82), t60_ms(10.82, seconds));
};
process = chamberlinDecay(10);
```

### Schroeder-Chowning SATREV Reverberator

The Schroeder-Chowning SATREV Reverberator is a landmark in the history of algorithmic reverb design, based on the design proposed by Manfred Schroeder and refined by John Chowning, this model combines 4 parallel comb filters with 3 serial all-pass filters (drawn from a 1971 MUS10 software listing).

```faust
// Schroeder-Chowning SATREV Reverberator
satreverb = _ * 0.2 <: fbcfSchroeder(901, 0.805), 
    fbcfSchroeder(778, 0.827), fbcfSchroeder(1011, 0.783), 
    fbcfSchroeder(1123, 0.764) :> apf(125, 0.7) : 
    apf(42, 0.7) : apf(12, 0.7) <: _ , _ * -1;
process = satreverb;
```

### Schroeder Samson Box Reverberator
In October 1977, CCRMA took delivery of the Systems Concepts Digital Synthesizer, affectionately known as the ``Samson Box,'' named after its designer Peter Samson.
This reverberator developed for this system, which remains known as JCREV, builds upon the earlier reverberation models by Schroeder but expanding on them with improvements that catered to more complex, real-time audio processing requirements.
This model includes 3 serial all-pass filters and 4 parallel comb filters.

```faust
// Schroeder Samson Box Reverberator
jcreverb = _ * 0.06 : apf(347, 0.7) : apf(113, 0.7) : 
    apf(37, 0.7) <: fbcfSchroeder(1601, 0.802), fbcfSchroeder(1867, 0.733), 
    fbcfSchroeder(2053, 0.753), fbcfSchroeder(2251, 0.733) : 
    mix_mtx
with {
    mix_mtx = _,_,_,_ <: psum, - psum, asum, - asum : _,_,_,_;
    psum = _,_,_,_ :> _;
    asum = *(-1), _, *(-1), _ :> _;
};
process = jcreverb;
```

### Moorer Reverb

James A. Moorer’s 1979 design for digital reverberation was one of the earliest to build upon the work of Manfred R. Schroeder, refining and expanding on his ideas in significant ways. Moorer’s design, as outlined in his seminal paper "About This Reverberation Business", introduced crucial improvements to digital reverb algorithms that continue to influence modern reverberation models.
A key innovation in Moorer's approach was the use of a tapped delay line to simulate early reflections—an important feature in the perception of acoustic space. The early reflections, rather than the later reverberant tail, play a more prominent role in how we perceive the size and shape of an environment. The tapped delay line in Moorer's model could be adjusted with specific delay times and gain structures to approximate the reflections of an actual acoustic space, such as a concert hall. In his article, Moorer provides a 19-tap delay line based on a geometric simulation of the Boston Symphony Hall. He omits the first tap, which has a delay time of 0 and a gain of 1, as it represents the original dry signal.
Additionally, Moorer enhanced his reverb model by incorporating a first-order low-pass filter in the feedback loop of the six comb filters. This filter simulates the absorption effects of air, which are influenced by factors such as humidity, temperature, the frequency of sound, and the distance from the sound source. Moorer discusses how atmospheric conditions affect the intensity of sound as it travels, and this low-pass filter helped account for the natural damping of higher frequencies over distance.
This combination of early reflections through a tapped delay line and the low-pass feedback filters for air absorption marked a significant step forward in creating more realistic digital reverberation, and Moorer's work laid the foundation for many of the reverberation algorithms in use today.

```faust
// Moorer Reverb
moorerReverb = _ * 0.1 : earlyReflections <: combSection + _
with {
    earlyReflections =  _ <: 
        (_ @ sasamps(0.0043)) * 0.841,
        (_ @ sasamps(0.0215)) * 0.504,
        (_ @ sasamps(0.0225)) * 0.491,
        (_ @ sasamps(0.0268)) * 0.379,
        (_ @ sasamps(0.0270)) * 0.380,
        (_ @ sasamps(0.0298)) * 0.346,
        (_ @ sasamps(0.0458)) * 0.289,
        (_ @ sasamps(0.0485)) * 0.272,
        (_ @ sasamps(0.0572)) * 0.192,
        (_ @ sasamps(0.0587)) * 0.193,
        (_ @ sasamps(0.0595)) * 0.217,
        (_ @ sasamps(0.0612)) * 0.181,
        (_ @ sasamps(0.0707)) * 0.180,
        (_ @ sasamps(0.0708)) * 0.181,
        (_ @ sasamps(0.0726)) * 0.176,
        (_ @ sasamps(0.0741)) * 0.142,
        (_ @ sasamps(0.0753)) * 0.167,
        (_ @ sasamps(0.0797)) * 0.134 :> _;

    combSection = _ <: 
        lbcf(sasamps(0.040), 0.95, 0.5),
        lbcf(sasamps(0.041), 0.95, 0.5),
        lbcf(sasamps(0.043), 0.95, 0.5),
        lbcf(sasamps(0.055), 0.95, 0.5),
        lbcf(sasamps(0.059), 0.95, 0.5),
        lbcf(sasamps(0.061), 0.95, 0.5) :> _ :
        apf(sasamps(0.007), -0.09683) @ sasamps(0.0017);
};
process = moorerReverb;
```

### Freeverb

A more recently developed Schroeder/Moorer Reverberation Simulation 
is ``Freeverb`` -- a public domain C++ program by 
``Jezar at Dreampoint`` used extensively in the 
free-software world. 
It uses four Schroeder allpasses in series and 
eight parallel Schroeder-Moorer filtered-feedback 
comb-filters for each audio channel, 
and is said to be especially well tuned.

```faust
freeverb = _ * 0.1 : combSection : allpassSection
with {
    combSection = _ <: 
    // 1557 samples at 44100 = ms 35.3061218
    lbcf(msasamps(35.3061218), 0.84, 0.2),
    // 1617 samples at 44100 = ms 36.6666679
    lbcf(msasamps(36.6666679), 0.84, 0.2),
    // 1491 samples at 44100 = ms 33.8095245
    lbcf(msasamps(33.8095245), 0.84, 0.2),
    // 1422 samples at 44100 = ms 32.2448997
    lbcf(msasamps(32.2448997), 0.84, 0.2),
    // 1277 samples at 44100 = ms 28.9569168
    lbcf(msasamps(28.9569168), 0.84, 0.2),
    // 1356 samples at 44100 = ms 30.7482986
    lbcf(msasamps(30.7482986), 0.84, 0.2),
    // 1188 samples at 44100 = ms 26.9387760
    lbcf(msasamps(26.9387760), 0.84, 0.2),
    // 1116 samples at 44100 = ms 25.3061218
    lbcf(msasamps(25.3061218), 0.84, 0.2) :> _;

    allpassSection = 
    // 225 samples at 44100 = ms 5.1020408
    apf(msasamps(5.10204080), -0.5) :
    // 556 samples at 44100 = ms 12.6077099
    apf(msasamps(12.6077099), -0.5) :
    // 441 samples at 44100 = ms 10.0000000
    apf(msasamps(10.0000000), -0.5) :
    // 341 samples at 44100 = ms 7.7324262
    apf(msasamps(7.73242620), -0.5);
};
process = freeverb;
```

### Feedback Delay Network (FDN)

The first ideas originate from Michael Gerzon's 
Studio Sound reverb articles from 1971 and 1972.
Later, in 1982, Stautner and Puckette introduced a 
multichannel reverberation algorithm in their paper 
“Designing Multichannel Reverberators.” 
The algorithm, called the Feedback Delay Network (FDN), 
aims to simulate the behavior of reflections 
within a room by using only a series of parallel 
comb filters with interconnected feedback paths.
Below is a 4x4 example of the general design they proposed.

```faust
fdnLossless = (inputPath : delaysPath : hadamardPath : normHadamard) ~ 
si.bus(4) : delCompensation
with{
    t60(msDel, t60) = pow(0.001, msDel / t60);
    inputPath = ro.interleave(4, 2) : par(i, 4, (_, _) :> _);
    delay(ms) = _ @ (msasamps(ms) - 1);
    delaysPath = delay(68), delay(77), delay(90), delay(99);
    hadamardPath = hadamard(4);
    normHadamard = par(i, 4, _ * (1.0 / sqrt(4)));
    delCompensation = par(i, 4, mem);
};
//process = fdnLossless :> par(i, 2, _ / 2);

fdn = (inputPath : opPath : delaysPath : hadamardPath : normHadamard : decay) ~ 
si.bus(4) : delCompensation
with{
    t60(msDel, t60) = pow(0.001, msDel / t60);
    inputPath = ro.interleave(4, 2) : par(i, 4, (_, _) :> _);
    opPath = par(i, 4, op(0.4));
    delay(ms) = _ @ (msasamps(ms) - 1);
    delaysPath = delay(68), delay(77), delay(90), delay(99);
    hadamardPath = hadamard(4);
    normHadamard = par(i, 4, _ * (1.0 / sqrt(4)));
    decay = _ * t60_ms(68, 1), _ * t60_ms(77, 1), 
            _ * t60_ms(90, 1), _ * t60_ms(99, 1);
    delCompensation = par(i, 4, mem);
};
process = fdn :> par(i, 2, _ / 2);
```

### Keith Barr Allpass Loop

Keith Barr was one of the co-founders of MXR, 
back in 1973. After MXR, he founded Alesis. 
Most recently, he designed the FV-1 chip for Spin Semiconductor.
His Allpass Loop Reverb is a simplified yet effective model, 
utilizing a single allpass filter within a feedback loop.
When multiple delays and all pass filters are placed into a loop, 
sound injected into the loop will recirculate, 
and the density of any impulse will increase as the signal 
passes successively through the allpass filters. 
The result, after a short period of time, 
will be a wash of sound, completely diffused 
as a natural reverb tail. 
The reverb can usually have a mono input 
(as from a single source), 
but benefits from a stereo output which gives 
the listener a more full, surrounding reverberant image.

Here a Faust porting of: Reverb 1 program from the Spin Semiconductor FV-1 internal ROM

```faust
kb_rom_rev1(rt, damp, L, R) = aploop
with{
// input allpass sections
apSec(0) = apf(adaptSR(32768, 156), 0.5) : apf(adaptSR(32768, 223), 0.5) : apf(adaptSR(32768, 332), 0.5) : apf(adaptSR(32768, 548), 0.5);
apSec(1) = apf(adaptSR(32768, 186), 0.5) : apf(adaptSR(32768, 253), 0.5) : apf(adaptSR(32768, 302), 0.5) : apf(adaptSR(32768, 498), 0.5);

// allpass loop sections
loopSec(0) = _ @ (adaptSR(32768, 4568) - 1) : _ * rt : _ + (L : apSec(0)) : apfMod(os.osc(0.5), adaptSR(32768, 1251), adaptSR(32768, 20), 0.6) : apf(adaptSR(32768, 1751), 0.6) : op(damp) : op(- 0.05);
loopSec(1) = _ @ adaptSR(32768, 5859) : _ * rt : apf(adaptSR(32768, 1443), 0.6) : apf(adaptSR(32768, 1343), 0.6) : op(damp) : op(- 0.05);
loopSec(2) = _ @ adaptSR(32768, 4145) : _ * rt : _ + (R : apSec(1)) : apfMod(os.osc(0.5), adaptSR(32768, 1582), adaptSR(32768, 20), 0.6) : apf(adaptSR(32768, 1981), 0.6) : op(damp) : op(- 0.05);
loopSec(3) = _ @ adaptSR(32768, 3476) : _ * rt : apf(adaptSR(32768, 1274), 0.6) : apf(adaptSR(32768, 1382), 0.6) : op(damp) : op(- 0.05);

// output delay taps
outTaps = ((_ * 1.5 @ adaptSR(32768, 2630), _ * 1.2 @ adaptSR(32768, 1943), _ * 1.0 @ adaptSR(32768, 3200), _ * 0.8 @ adaptSR(32768, 4016)) :> +),
((_ * 1.0 @ adaptSR(32768, 2420), _ * 0.8 @ adaptSR(32768, 2631), _ * 1.5 @ adaptSR(32768, 1163), _ * 1.2 @ adaptSR(32768, 3330)) :> +);

// complete allpass loop
aploop = (_ : loopSec(0) <: ((loopSec(1) <: ((_ : loopSec(2) <: loopSec(3), _), _)), _)) ~ _ : ro.cross(4) <: outTaps; 
};
process = kb_rom_rev1(0.95, 0.5); 
```

Here another Reverb Model based on the Keith Barr Allpass Loop Reverb.
A Corey Kereliuk's implementation of the Reverb.

```faust
ck_kbVerb(apfG, krt) = si.bus(2) : mix(ma.PI/2) : * (0.5), * (0.5) : procLeft, procRight : si.bus(2)
with{	 
    // stereo input mix
    mix(theta) = si.bus(2) <: (*(c), *(-s), *(s), *(c)) : (+, +) : si.bus(2)
	with {
		c = cos(theta);
		s = sin(theta);
	};

    // import prime numbers
    primes = component("prime_numbers.dsp").primes;
    // calculation of left and right indexes
    ind_left(i)  = 100 + 10 * pow(2, i) : int;
    ind_right(i) = 100 + 11 * pow(2, i) : int;

    // allpass single section
    section((n1, n2)) = apf(n1, - apfG) : apf(n2, - apfG) : _ @ int(0.75 * (n1 + n2));

    // chain and ring functions
    allpass_chain(((n1, n2), ns), x) = _ : section((n1, n2)) <: R(x, ns), _
    with {
    	R(x, ((n1, n2), ns)) = _,x : + : section((n1, n2)) <: R(x, ns), _;
    	R(x, (n1, n2)) = _,x : + : section((n1, n2));
    };
    procMono(feedfwd_delays, feedback_delays, feedback_gain, x) = x : 
    (+ : allpass_chain(feedfwd_delays, x)) ~ (_,x : + : section(feedback_delays) : 
    *(feedback_gain)) :> _;
    // left reverb
	feedfwd_delays_left = par(i, 5, (ba.take((ind_left(i)), primes), ba.take((ind_left(i+1)), primes)));
	feedback_delays_left = (ba.take(100, primes), ba.take(101, primes));
	procLeft = procMono(feedfwd_delays_left, feedback_delays_left, krt);
	// right reverb
	feedfwd_delays_right = par(i, 4, (ba.take((ind_right(i)), primes), ba.take((ind_right(i+1)), primes)));
	feedback_delays_right = (ba.take(97, primes), ba.take(99, primes));
	procRight = procMono(feedfwd_delays_right, feedback_delays_right, krt);
};
process = ck_kbVerb(0.7, 0.5);
```

### James Dattorro and the Lexicon 480L Topology: A Landmark in Reverb Design

In his groundbreaking paper published in the Journal of the Audio Engineering Society, Vol. 45, No. 9, September 1997, James Dattorro opened up the design secrets behind the allpass loop reverbs, offering detailed insights into a reverb architecture that would shape the future of digital reverb technology.
Whereas earlier papers, such as Gardner’s, hinted at concepts that had been circulating privately within the music technology industry, Dattorro’s paper fully exposed the inner workings of allpass loop reverbs. He introduced a specific allpass loop reverb in great detail, including all the delay lengths and coefficients, which he described as being “in the style of [Lexicon’s] Griesinger.” This paper effectively served as a Rosetta Stone for reverb design, offering a clear and practical understanding of the mechanisms that drive reverb effects. Many modern reverb plugins and built-in synth reverbs have directly recreated the “Dattorro” reverb, underscoring the paper’s enduring influence in the field.
One of the paper’s key contributions was Dattorro’s exploration of the single loop feedback system, which was central to the Lexicon 480L’s reverb design. This architecture, which Dattorro helped reveal, is simpler yet more effective in simulating natural reverbs, providing dense and realistic sound with minimal complexity. The Lexicon 480L's feedback structure, initially shrouded in secrecy, was described in Dattorro’s work with full transparency, as the company had granted him permission to detail their proprietary system. This was a crucial moment in the advancement of reverb design, as it opened up new possibilities for digital reverberation.

```faust
greisingerReverb(decay, damp) = (si.bus(2) :> _ * (1 / 2) : predelay : op(damp) : apfsec) <: si.bus(2) : (ro.interleave(2, 2) : (par(i, 2, (_, _) :> + : loopsec(i)) : ro.crossNM(4, 1), si.bus(3))) ~ si.bus(2) : (si.block(2), si.bus(6)) : routing
with{
    predelay = _ @ msasamps(30);

    apfsec = apf(msasamps(4.771), 0.75) : apf(msasamps(3.595), 0.75) :
        apf(msasamps(12.73), 0.625) : apf(msasamps(9.307), 0.625);

    loopsec(0) = apfMod(os.osc(0.10), msasamps(30.51), msasamps(4), 0.7) : 
        _ @ msasamps(141.69) : (_ <: _, _) : (op(damp), _) : 
        (apf(msasamps(89.24), 0.5) <: _, _), _ : 
        (_ @ (msasamps(106.28) - 1) <: _, mem), _, _ :  
        (_ * decay, _, _, _) : (_, ro.cross(3));

    loopsec(1) = apfMod(os.osc(0.07), msasamps(22.58), msasamps(4), 0.7) : 
        _ @ msasamps(149.62) : (_ <: _, _) : (op(damp), _) : 
        (apf(msasamps(60.48), 0.5) <: _, _), _ : 
        (_ @ (msasamps(125.00) - 1) <: _, mem), _, _ :  
        (_ * decay, _, _, _) : (_, ro.cross(3));

    routing(dA0, ap0, dB0, dA1, ap1, dB1) = 
        ((dA0 @ msasamps(8.90), dA0 @ msasamps(99.8), ap0 @ msasamps(64.2), dB0 @ msasamps(67),
          dA1 @ msasamps(66.8), ap1 @ msasamps(6.3), dB1 @ msasamps(35.8),  0) :> +),
        ((dA0 @ msasamps(70.8), ap0 @ msasamps(11.2), dB0 @ msasamps(4.1), dA1 @ msasamps(11.8), 
          dA1 @ msasamps(121.7), ap1 @ msasamps(41.2), dB1 @ msasamps(89.7), 0) :> +);
};
process = greisingerReverb(0.8, 0.4); 
```
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
books by Julius O. Smith III.
Links to the series by Smith:

- Mathematics of the Discrete Fourier Transform (DFT)
- Introduction to Digital Filters
- Physical Audio Signal Processing
- Spectral Audio Signal Processing
  CCRMA by J.Smith https://ccrma.stanford.edu/~jos/fp/ su DSP Related [Free DSP Books](https://www.dsprelated.com/freebooks.php)

TOM ERBE - UC SAN DIEGO - REVERB TOPOLOGIES AND DESIGN http://tre.ucsd.edu/wordpress/wp-content/uploads/2018/10/reverbtopo.pdf

ARTIFICIAL REVERBERATION: su DSPRELATED [Artificial Reverberation | Physical Audio Signal Processing](https://www.dsprelated.com/freebooks/pasp/Artificial_Reverberation.html)

Corey Kereliuk - Building a Reverb Plugin in Faust
Keith Barr’s reverb architecture [Building a Reverb Plugin in Faust](https://web.archive.org/web/20210111064016/http://blog.reverberate.ca/post/faust-reverb/)

Spin Semiconductor DSP Basics [Spin Semiconductor - DSP Basics](http://www.spinsemi.com/knowledge_base/dsp_basics.html) Spin Semiconductor Audio Effects [Spin Semiconductor - Effects](http://www.spinsemi.com/knowledge_base/effects.html#Reverberation)

freeverb3vst - Reverb Algorithms Tips http://freeverb3vst.osdn.jp/tips/reverb.shtml

History of allpass loop / "ring" reverbs [History of allpass loop / &quot;ring&quot; reverbs? - Spin Semiconductor](http://www.spinsemi.com/forum/viewtopic.php?p=555&sid=5d31391b3883f1b9e013d5af80805019)

Musical Applications of Microprocessors (The Hayden microcomputer series) http://sites.music.columbia.edu/cmc/courses/g6610/fall2016/week8/Musical_Applications_of_Microprocessors-Charmberlin.pdf

Acustica_Riverbero - Alfredo Ardia [Appunti: acustica_Riverbero](http://appuntimusicaelettronica.blogspot.com/2012/10/acusticariverbero.html)

Algorithmic Reverbs: The Moorer Design [Algorithmic Reverbs: The Moorer Design | flyingSand](https://christianfloisand.wordpress.com/2012/10/18/algorithmic-reverbs-the-moorer-design/)

Dattorro Convex Optimization of a Reverberator [Dattorro Convex Optimization of a Reverberator - Wikimization](https://www.convexoptimization.com/wikimization/index.php/Dattorro_Convex_Optimization_of_a_Reverberator)

primes under 10.000 https://www.matematika.it/public/allegati/34/Numeri_primi_minori_di_10000_1_3.pdf
