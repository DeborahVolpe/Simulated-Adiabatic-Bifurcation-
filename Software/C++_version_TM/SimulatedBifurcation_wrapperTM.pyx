#create in 12/06/2023 by Deborah Volpe
from libcpp.string cimport string
from libcpp.vector cimport vector
from libcpp cimport bool
from libcpp cimport int
import numpy as np 
cimport numpy as np 
from cpython cimport array
from libc.stdlib cimport malloc, free




cdef extern from "./SimulatedBifurcationTM.h":
	int TM_general_simulated_bifurcation(string folder, vector[vector[int]]& states, vector[double]& energies, const unsigned int num_runs, const vector[double]& h, const vector[vector[double]]& J, const unsigned int N, const double K, const double Delta, const double delta_t, const double xi, const double xi_h, const double pt_shape, const unsigned int num_iterations, const unsigned long long seed, bool verbose, const unsigned int M )

def SimulatedBifurcationMachineTM_v1(folder, states_numpy, energies, num_runs, h, J, N, K, Delta, delta_t, xi, xi_h, pt_shape, num_iterations, seed, verbose, M):
	num_vars = len(h)
	if num_runs*num_vars == 0:
		annealed_states = np.empty((num_runs, num_vars), dtype=np.int8)
		return annealed_states, np.zeros(num_runs, dtype=np.double)
		
	_folder = folder.encode('utf-8')	
	cdef vector[vector[int]] _states = states_numpy
	cdef vector[double] _energies = energies
	cdef unsigned int _num_runs = num_runs
	cdef vector[double] _h = h
	cdef vector[vector[double]] _J = J
	cdef unsigned int _N = N
	cdef double _K = K
	cdef double _Delta = Delta
	cdef double _delta_t = delta_t
	cdef double _xi = xi
	cdef double _xi_h = xi_h
	cdef double _pt_shape = pt_shape
	cdef unsigned int _num_iterations = num_iterations
	cdef unsigned int _M = M
	cdef unsigned long long _seed = seed
	ret = TM_general_simulated_bifurcation(_folder, _states, _energies, _num_runs, _h, _J, _N, _K, _Delta, _delta_t, _xi, _xi_h, _pt_shape, _num_iterations, _seed, verbose, _M)
	return _states, _energies