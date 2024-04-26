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
double get_state_energy_intermediate(
	// state of interest
    vector<double>& x,
    // vector h 
    const vector<double>& h,
	// matrix J
    const vector<vector<double>>& J,
	// number of spin variables
	const unsigned int N
);

//for computing the energy of a state
double get_state_energy(
	// state of interest
    vector<int>& state,
    // vector h 
    const vector<double>& h,
	// matrix J
    const vector<vector<double>>& J,
	// number of spin variables
	const unsigned int N
); 

//single run of simulated bifurcation algorithm 
//for solving problems in the form H = xJx'+h
void simulated_bifurcation_run(
	//folder for files
	string folder,
	// vector h 
    const vector<double>& h,
	// matrix J
    const vector<vector<double>>& J,
	// number of spin variables
	const unsigned int N,
	// Kerr coefficient
	const double K,
	// Detuning frequency
	const double Delta,
	// time step
	const double delta_t,
	// positive constant problem dependent
	const double xi,
	// positive constant problem dependent
	const double xi_h,
	// positive constant problem dependent
	const double pt_shape,
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
	//M parameter
	const unsigned int M,
	//delta_t_M parameter
	const double delta_t_M
);

//for multiple execution of the simulated bifurcation algorithm
int TM_general_simulated_bifurcation(
	//folder for files
	string folder,
	//final states
    vector<vector<int>>& states,
	//final energies
    vector<double>& energies,
	//number of runs
    const unsigned int num_runs,
    // vector h 
    const vector<double>& h,
	// matrix J
    const vector<vector<double>>& J,
	// number of spin variables
	const unsigned int N,
	// Kerr coefficient
	const double K,
	// Detuning frequency
	const double Delta,
	// time step
	const double delta_t,
	// positive constant problem dependent
	const double xi,
	// positive constant problem dependent
	const double xi_h,
	// positive constant problem dependent
	const double pt_shape,
	// number of iterations
	const unsigned int num_iterations,
	//seed for random number generator
	const uint64_t seed,
	// if we want the log files
	bool verbose,
	//M parameter
	const unsigned int M
);

#endif