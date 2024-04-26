#ifndef _GenerateRandomNumbers_h
#define _GenerateRandomNumbers_h

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


//multiple random number generation
int generate_random_numbers(
	//folder for files
	string folder,
	//number of runs
    const unsigned int num_runs,
	// number of spin variables
	const unsigned int N,
	//seed for random number generator
	const uint64_t seed,
	// parallelism
	const unsigned int fractional_bits	
);

#endif