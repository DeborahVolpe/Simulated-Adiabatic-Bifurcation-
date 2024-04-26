// code developed by Deborah Volpe in 12/06/2023
// for simulated bifurcation algorithm execution 
#include <math.h>
#include <cmath>
#include <vector>
#include <string>
#include <stdexcept>
#include <iostream>
#include <fstream>
#include "GenerateRandomNumbers.h"

// xorshift128+ as defined https://en.wikipedia.org/wiki/Xorshift#xorshift.2B
/*#define FASTRAND(rand) do {                       \
    uint64_t a = rng_state[0];                    \
    uint64_t const b = rng_state[1];              \
    rng_state[0] = b;                             \
    a ^= a << 23;                                 \
    rng_state[1] = a ^ b ^ (a >> 17) ^ (b >> 26); \
    rand = rng_state[1] + b;                      \
} while (0)*/
                     \

#define RANDMAX ((uint64_t)-1L)

using namespace std;


// this holds the state of our thread-safe/local RNG
thread_local uint64_t rng_state[2];

//multiple random number generation
int generate_random_numbers(
	//string folder
	string folder,
	//number of runs
    const unsigned int num_runs,
	// number of spin variables
	const unsigned int N,
	//seed for random number generator
	const uint64_t seed,
	// parallelism
	const unsigned int fractional_bits
){
		
	// set the seed of the RNG
    // note that xorshift+ requires a non-zero seed
	//rng_state[0] = seed ? seed : RANDMAX;
	//rng_state[1] = 0;
	srand((unsigned) time(NULL));
	ofstream y_file;
	string y_file_name;
	
	//y_init vector declaration
	vector<long long int> y_init(N);

	//uint64_t rand; // this will hold the value of the rng
	int r;
	
	y_file_name = folder + "Problem_" + to_string(N) + "_y_init_variables.txt";
	y_file.open(y_file_name,ios::out);	
	
	for(unsigned int time = 0; time < num_runs;  time++){
		if (num_runs == 1){
			y_init[N-1] = (long long int) (-0.1*pow(2.0, (double) fractional_bits));
		}else{
			for(unsigned int i = 0; i < N; i++){
				r = rand();
				y_init[i] =(long long int) (((double(int(r)% 20) - 10)/100)*pow(2.0, (double) fractional_bits));
				if(y_init[i] == 0) {
					r = rand();
					y_init[i] =(long long int) (((double(int(r)% 10) + 1)/100)*pow(2.0, (double) fractional_bits));
				}		
			}
		}
		for(unsigned int i = 0; i < N; i++){
			if(i != N-1){
				y_file << y_init[i] << " ";
			}else{
				y_file << y_init[i] << "\n";
			}			
		}
	}

	y_file.close();	

	return 0;

};
