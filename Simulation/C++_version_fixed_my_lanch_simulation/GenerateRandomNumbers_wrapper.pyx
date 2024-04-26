#create in 12/06/2023 by Deborah Volpe
from libcpp.string cimport string
from libcpp.vector cimport vector
from libcpp cimport bool
from libcpp cimport int
import numpy as np 
cimport numpy as np 
from cpython cimport array
from libc.stdlib cimport malloc, free




cdef extern from "./GenerateRandomNumbers.h":
	int generate_random_numbers(string folder, const unsigned int num_runs, const unsigned int N, const unsigned long long seed, const unsigned int fractional_bits)

def generate_random_numbersVLSI(folder, num_runs, N, seed, fractional_bits):	
	_folder = folder.encode('utf-8')	
	cdef unsigned int _num_runs = num_runs
	cdef unsigned int _N = N
	cdef unsigned long long _seed = seed
	cdef unsigned int _fractional_bits = fractional_bits
	ret = generate_random_numbers(_folder, _num_runs, _N, _seed, _fractional_bits)
	return ret