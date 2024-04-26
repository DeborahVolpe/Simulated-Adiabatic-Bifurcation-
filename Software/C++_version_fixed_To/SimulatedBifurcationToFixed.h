#ifndef _SimulatedBifurcation_h
#define _SimulatedBifurcation_h

#ifdef _MSC_VER
    // add uint64_t definition for windows
    typedef __int64 int64_t;
    typedef unsigned __int64 uint64_t;

    // add thread_local (C++11) support for MSVC 9 and 10 (py2.7 and py3.4 on win)
    // note: thread_local support was added in MSVC 14 (Visual Studio 2015, MSC_VER 1900)
    #if _MSC_VER < 1900
    #define thread_local __declspec(thread)
    #endif
#endif

#include <math.h>
#include <cmath>
#include <vector>
#include <string>
#include <stdexcept>
#include <iostream>
#include <fstream>

using namespace std;

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
);

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
); 

//single run of simulated bifurcation algorithm 
//for solving problems in the form H = xJx'+h
void simulated_bifurcation_run(
	//folder for files
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
	double* energy,
	//Average effective energy
	vector<double>& average_effective_energy,
	//if compute the average effective energy
	bool verbose_average,
	//if it is a single run
	bool single_run,
	// parallelism
	const unsigned int fractional_bits,
	//M parameter
	const unsigned int M,
	//delta_t_M parameter
	const long long int delta_t_M
);

//for multiple execution of the simulated bifurcation algorithm
int general_simulated_bifurcation_Tofixed(
	//folder for files
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
	const unsigned int fractional_bits,
	//M parameter
	const unsigned int M	
);

#endif