#create in 12/06/2023 by Deborah Volpe
from libcpp.string cimport string
from libcpp.vector cimport vector
from libcpp cimport bool
from libcpp cimport int
import numpy as np 
cimport numpy as np 
from cpython cimport array
from libc.stdlib cimport malloc, free




cdef extern from "./SimulatedBifurcationToFixed.h":
	int general_simulated_bifurcation_Tofixed(string folder, vector[vector[int]]& states, vector[long long int]& energies, const unsigned int num_runs, const vector[long long int]& h, const vector[vector[long long int]]& J, const unsigned int N, const long long int K, const long long int Delta, const long long int delta_t, const long long int xi, const long long int xi_h, const long long int pt_shape, const unsigned int num_iterations, const unsigned long long seed, bool verbose, const unsigned int fractional_bits, const unsigned int M)

def SimulatedBifurcationMachineTo_fix(folder, states_numpy, energies, num_runs, h, J, N, K, Delta, delta_t, xi, xi_h, pt_shape, num_iterations, seed, verbose, fractional_bits, M):
	num_vars = len(h)
	if num_runs*num_vars == 0:
		annealed_states = np.empty((num_runs, num_vars), dtype=np.int8)
		return annealed_states, np.zeros(num_runs, dtype=np.double)
		
	_folder = folder.encode('utf-8')	
	cdef vector[vector[int]] _states = states_numpy
	cdef vector[long long int] _energies = energies
	cdef unsigned int _num_runs = num_runs
	cdef vector[long long int] _h = h
	cdef vector[vector[long long int]] _J = J
	cdef unsigned int _N = N
	cdef long long int _K = K
	cdef long long int _Delta = Delta
	cdef long long int _delta_t = delta_t
	cdef long long int _xi = xi
	cdef long long int _xi_h = xi_h
	cdef long long int _pt_shape = pt_shape
	cdef unsigned int _num_iterations = num_iterations
	cdef unsigned long long _seed = seed
	cdef unsigned int _fractional_bits = fractional_bits
	cdef unsigned int _M = M
	ret = general_simulated_bifurcation_Tofixed(_folder, _states, _energies, _num_runs, _h, _J, _N, _K, _Delta, _delta_t, _xi, _xi_h, _pt_shape, _num_iterations, _seed, verbose, _fractional_bits, _M)
	return _states, _energies