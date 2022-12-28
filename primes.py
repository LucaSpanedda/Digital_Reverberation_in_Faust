'''
To use this function, you can run the script from the command line 
and pass the desired number of prime numbers as an argument, like this:

$ python3 script.py 10

This will print the first 10 prime numbers to the terminal, 
save the list to a file named prime_numbers.txt, 
and print a message to confirm that the numbers were saved. 
If you want to get a different number of prime numbers, 
simply change the value passed as an argument when running the script.
'''

import sys


def get_prime_numbers(n):
    # Initialize an empty list to store the prime numbers
    prime_numbers = []

    # Start with the number 2 (the first prime number)
    number = 2

    # Iterate until we have found n prime numbers
    while len(prime_numbers) < n:
        # Assume the number is prime
        is_prime = True

        # Check if the number is divisible by any of the numbers
        # in the prime_numbers list up to its square root
        for i in prime_numbers:
            if i > int(number ** 0.5):
                break
            if number % i == 0:
                # If the number is divisible by i, it is not prime
                is_prime = False
                break

        # If the number is prime, add it to the prime_numbers list
        if is_prime:
            prime_numbers.append(number)

        # Increment the number and continue the loop
        number += 1

    # Return the list of prime numbers
    return prime_numbers

# Get the number of prime numbers to generate from the command line argument
n = int(sys.argv[1])

# Call the get_prime_numbers function and save the result to a variable
prime_numbers = get_prime_numbers(n)

# Print the list of prime numbers to the terminal
print(prime_numbers)

# Open the file in write mode
with open('prime_numbers.txt', 'w') as f:
    # Write the list of prime numbers to the file as a comma-separated string without brackets
    f.write(', '.join(str(number) for number in prime_numbers))

# Print a message to confirm that the numbers were saved to the file
print(f'Saved {len(prime_numbers)} prime numbers to prime_numbers.txt')