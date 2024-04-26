import qubovert as qv
from qubovert.sim import anneal_quso, anneal_qubo
import numpy as np
import dimod

"""
17/11/2021
@author: Deborah
"""


def create_Q_matrix(qubo):
    Q = np.zeros((len(qubo.variables), len(qubo.variables)))
    offset = 0
    NVar = len(qubo.variables)
    for key in qubo.keys():
        if len(key) == 1:
            Q[key, key] = qubo[key]
        elif len(key) == 2:
            Q[key] = qubo[key] / 2
            Q[key[::-1]] = qubo[key] / 2
        elif len(key) == 0:
            offset = qubo[key]

    return NVar, Q, offset
    

def create_Q_matrix_bqm (bqm):
    offset = bqm.offset
    l = bqm.linear
    quad = bqm.quadratic
    NVar = len(l)
    Q = np.zeros((NVar, NVar))
    
    for i in range(NVar):
        Q[i, i] = l[i]
        
    for i in range(NVar):
        for j in range(NVar):
            if i!=j and (i,j) in quad.keys():
                Q[i, j] = quad[(i,j)]/2
                Q[j, i] = quad[(i,j)]/2
    return NVar, Q, offset
