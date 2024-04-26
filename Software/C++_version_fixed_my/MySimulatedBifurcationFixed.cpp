// code developed by Deborah Volpe in 12/06/2023
// for simulated bifurcation algorithm execution 
#include <math.h>
#include <cmath>
#include <vector>
#include <string>
#include <stdexcept>
#include <iostream>
#include <fstream>
#include "MySimulatedBifurcationFixed.h"

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

//for computing the energy of an intermediate state
long long int get_state_energy_intermediate(
	// state of interest
    vector<long long int>& x,
    // vector h 
    const vector<long long int>& h,
	// matrix J
    const vector<vector<long long int>>& J,
	// number of spin variables
	const unsigned int N,
	// parallelism
	const unsigned int fractional_bits
){
	// Energy initialization 
    long long int energy = 0;
	
	// compute the energy
    for (unsigned int var = 0; var < N; var++) {
        energy += (x[var] * h[var]) >> fractional_bits;
		for (unsigned int var2 = 0; var2 < N; var2++){
			energy += (((x[var]*J[var][var2]) >> fractional_bits)*x[var2]) >> fractional_bits;
		}
    }
	
    return energy;		
		
}

//for computing the energy of a state
long long int get_state_energy(
	// state of interest
    vector<int>& state,
    // vector h 
    const vector<long long int>& h,
	// matrix J
    const vector<vector<long long int>>& J,
	// number of spin variables
	const unsigned int N,
	// parallelism
	const unsigned int fractional_bits
){
	// Energy initialization 
    long long int energy = 0;
	
	// compute the energy
    for (unsigned int var = 0; var < N; var++) {
        energy += state[var] * h[var];
		for (unsigned int var2 = 0; var2 < N; var2++){
			energy += state[var]*J[var][var2]*state[var2];
		}
    }
	
    return energy;
}

//single run of simulated bifurcation algorithm 
//for solving problems in the form H = xJx'+h
void simulated_bifurcation_run(
	//string folder
	string folder,
	//number of runs
    const unsigned int num_runs,
	// vector h 
    const vector<long long int>& h,
	// matrix J
    const vector<vector<long long int>>& J,
	// number of spin variables
	const unsigned int N,
	// Kerr coefficient
	const long long int K,
	// Detuning frequency
	const long long int Delta,
	// time step
	const long long int delta_t,
	// positive constant problem dependent
	const long long int xi,
	// positive constant problem dependent
	const long long int xi_h,
	// positive constant problem dependent
	const long long int pt_shape,
	// number of iterations
	const unsigned int num_iterations,
	// if we want the log files
	bool verbose, 
	// final state
	vector<int>& state, 
	// final energy
	long long int* energy,
	//Average effective energy
	vector<double>& average_effective_energy,
	//if compute the average effective energy
	bool verbose_average,
	//if it is a single run
	bool single_run,
	// parallelism
	const unsigned int fractional_bits
){
	// string for debug file names
	string x_file_name;
	string y_file_name;
	string energies_file_name;
	
	// File pointer declaration
	ofstream x_file;
	ofstream y_file;
	ofstream energies_file;
	
	//declare double for computing itermediate energy
	long long int inter_energy;
	
	//declare and initiaze pt and at
	long long int pt = 0;
	long long int at = 0;
	
	long long int Delta4K = Delta+(K << 4);
	
	long long int K_1 = (long long int)((1/((double)K/pow(2.0, (double) fractional_bits)))*pow(2.0, (double) fractional_bits));
	
	//temporary variable
	long long int en;
	
	vector<int> s(N);
	
	vector<long long int> J_xi_row(N);
	vector<vector<long long int>> J_xi(N, J_xi_row);
	
	//uint64_t rand; // this will hold the value of the rng
	int r;
	
	if (verbose == true){	
		// choice in the file name 
		x_file_name = folder + "Problem_" + to_string(N) + "_x_evolution.txt";
		y_file_name = folder + "Problem_" + to_string(N) + "_y_evolution.txt";
		energies_file_name = folder + "Problem_" + to_string(N) +"_energy_evolution.txt";
		// open files
		x_file.open(x_file_name,ios::out);
		y_file.open(y_file_name,ios::out);
		energies_file.open(energies_file_name,ios::out);
	}
	
	//x and y vector declaration
	vector<long long int> x(N);
	vector<long long int> y(N);
	vector<long long int> x_old(N);
	
	//Initialization of the x and y vectors
	for(unsigned int i = 0; i < N; i++){
		if(single_run == false){
			//FASTRAND(rand);
			/*r = rand();
			x[i] = (long long int) (((double(int(r)% 20) - 10)/50)*pow(2.0, (double)fractional_bits));
			if(x[i] == 0) {
				r = rand();
				x[i] =(long long int) (((double(int(r)% 10) + 1)/100)*pow(2.0, (double) fractional_bits));
			}*/
			//FASTRAND(rand);
			r = rand();
			y[i] =(long long int) (((double(int(r)% 20) - 10)/100)*pow(2.0, (double) fractional_bits));
			if(y[i] == 0) {
				r = rand();
				y[i] =(long long int) (((double(int(r)% 10) + 1)/100)*pow(2.0, (double) fractional_bits));
			}
		}else{
			y[N-1] = (long long int) (0.1*pow(2.0, (double) fractional_bits));
		}
		if (verbose == true){
			if(i != N-1){
				x_file << x[i] << " ";
				y_file << y[i] << " ";
			}else{
				x_file << x[i] << "\n";
				y_file << y[i] << "\n";
			}
		}
	}
	
	//write in the energy file the intermediate energy
	if(verbose == true){
		inter_energy = get_state_energy_intermediate(x, h, J, N, fractional_bits);
		energies_file << inter_energy << "\n";
	}
	
	double temp;
	
	//Precompute the J*xi product
	for (unsigned int i = 0; i < N; i++){
		for (unsigned int j = 0; j < N; j++){
			J_xi[i][j] =  (J[i][j] * xi) >> fractional_bits;	
		}
	}
	
	//Compute the position and momentum evolution
	for(unsigned int it = 0; it < num_iterations; it++){		
		// update position variables 
		for(unsigned int i = 0; i < N; i++){
			x_old[i] = x[i];
			x[i] = x[i]+ ((((y[i]*delta_t) >> fractional_bits)*Delta) >> fractional_bits);
			if (verbose == true){
				if(i != N-1){
					x_file << x[i] << " ";
				}else{
					x_file << x[i] << "\n";
				}
			}
		}
		
		// update momentum variables
		for(unsigned int i = 0; i < N; i++){
			temp = 0;
			for (unsigned int j = 0; j < N; j++){
				temp += ((J_xi[i][j])*x_old[j]) >> fractional_bits;
			}
			y[i] = y[i] - ((long long int)((((x[i]*((x[i]*((K*x[i])>> fractional_bits)) >> fractional_bits))>>fractional_bits)+(((Delta - pt)*x[i])>>fractional_bits) + temp +  ((at*(((h[i]<< 2)*xi_h) >> fractional_bits))>>fractional_bits))*delta_t)>> fractional_bits);
			if (verbose == true){
				if(i != N-1){
					y_file << y[i] << " ";
				}else{
					y_file << y[i] << "\n";
				}
			}
		}
		
		//update the evolutions variable
		//pt
		pt += pt_shape;
		
		//at
		if (pt > Delta4K){
			at = (long long int)(((sqrt((double)(((pt-Delta4K)*K_1) >> fractional_bits)/pow(2.0, fractional_bits)))*pow(2.0, fractional_bits))+0.1*pow(2.0, fractional_bits));		
		}else{		
			at = (long long int) (0.1*pow(2.0, fractional_bits));
		}
		
		//write in the energy file the intermediate energy
		if(verbose == true){
			inter_energy = get_state_energy_intermediate(x, h, J, N, fractional_bits);
			energies_file << inter_energy << "\n";
		}
		if(verbose_average == true){
			for(unsigned int i = 0; i < N; i++){
				if (x[i] >= 0){
					s[i] = 1;
				}else{
					s[i] = -1;
				}
			}
			en = get_state_energy(s, h, J, N, fractional_bits);
			average_effective_energy [it] += en/num_runs;
		} 
	}
	
	// Compute the final state
	for(unsigned int i = 0; i < N; i++){
		if (x[i] >= 0){
			state[i] = 1;
		}else{
			state[i] = -1;
		}
	}
	
	// Compute the final energy
	*energy = get_state_energy(state, h, J, N, fractional_bits);	
	
	if (verbose){
		energies_file.close();
		x_file.close();
		y_file.close();
	}

}

//for multiple execution of the simulated bifurcation algorithm
int My_general_simulated_bifurcation_fixed(
	//string folder
	string folder,
	//final states
    vector<vector<int>>& states,
	//final energies
    vector<long long int>& energies,
	//number of runs
    const unsigned int num_runs,
    // vector h 
    const vector<long long int>& h,
	// matrix J
    const vector<vector<long long int>>& J,
	// number of spin variables
	const unsigned int N,
	// Kerr coefficient
	const long long int K,
	// Detuning frequency
	const long long int Delta,
	// time step
	const long long int delta_t,
	// positive constant problem dependent
	const long long int xi,
	// positive constant problem dependent
	const long long int xi_h,
	// positive constant problem dependent
	const long long int pt_shape,
	// number of iterations
	const unsigned int num_iterations,
	//seed for random number generator
	const uint64_t seed,
	// if we want the log files
	bool verbose,
	// parallelism
	const unsigned int fractional_bits
){
		
	// set the seed of the RNG
    // note that xorshift+ requires a non-zero seed
	//rng_state[0] = seed ? seed : RANDMAX;
	//rng_state[1] = 0;
	srand((unsigned) time(NULL));
	string effective_energy_file_name;
	ofstream effective_energy_file;
	
	long long int energy; 
	
	vector<double> average_effective_energy(num_iterations);

	for(unsigned int time = 0; time < num_runs;  time++){
		
		if (num_runs > 1){
			if(verbose == true && time == 0){
				simulated_bifurcation_run(folder, num_runs, h, J, N, K, Delta, delta_t, xi, xi_h, pt_shape, num_iterations, true, states[time], &energy, average_effective_energy, verbose, false, fractional_bits);
			}else{
				simulated_bifurcation_run(folder, num_runs, h, J, N, K, Delta, delta_t, xi, xi_h, pt_shape, num_iterations, false, states[time], &energy, average_effective_energy, verbose, false, fractional_bits);
			}
		}else{
			simulated_bifurcation_run(folder, num_runs, h, J, N, K, Delta, delta_t, xi, xi_h, pt_shape, num_iterations, verbose, states[time], &energy, average_effective_energy, verbose, true, fractional_bits);			
		}
		
		energies[time] = energy;
	}

	
	if (verbose == true){
		effective_energy_file_name = folder + "Problem_" + to_string(N) +"_effective_energy.txt";
		effective_energy_file.open(effective_energy_file_name,ios::out);
		for (unsigned int it = 0; it < num_iterations; it++){
			effective_energy_file << average_effective_energy[it] << "\n";
		}
		effective_energy_file.close();
	}
	return 0;

};
