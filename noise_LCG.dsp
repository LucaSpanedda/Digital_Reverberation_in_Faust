// pseudo-random noise with linear congruential generator (LCG)

noise(initSeed) = LCG ~ _ : (_ / m)
with{
    // variables
    // initSeed = an initial seed value
    a = 18446744073709551557; // a large prime number, such as 18446744073709551557
    c = 12345; // a small prime number, such as 12345
    m = 2 ^ 31; // 2.1 billion
    // linear_congruential_generator
    LCG(seed) = ((a * seed + c) + (initSeed-initSeed') % m);
};

/*
In a linear congruential generator (LCG), 
the seed value is an integer that is used to initialize the generator. 
The generator then produces a sequence of pseudo-random numbers based 
on the seed value and a set of parameters, including 
the multiplier a, the increment c, and the modulus m.

The value of a determines the amount by which the generator multiplies 
the previous value of the sequence when generating the next value. 
The value of c determines the amount by which the generator increments 
the previous value of the sequence when generating the next value. 
The value of m determines the maximum value that the generator can output.

The combination of a, c, and m should be carefully chosen to ensure that 
the generated sequence has good statistical properties, such as a long period 
and a uniform distribution. The seed value can be any integer, 
and can be used to initialize the generator and produce a specific sequence 
of pseudo-random numbers.
*/

process = par(i, 10, noise( (i+1) * 469762049) );