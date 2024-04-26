import numpy as np
from qubovert.sim import anneal_quso, anneal_qubo
from qubovert import boolean_var
import qubovert as qv

def FileReader(ProblemFileName, SolutionFileName, ProblemDimension):
    # FileName format MaxCut_Dim_nodes_num_n.txt

    x = {i: boolean_var('x(%d)' % i) for i in range(ProblemDimension)}    
    # Open file
    try:
        f = open(ProblemFileName)
    except:
        return -1
    model = 0

    QUBOmatrix = np.zeros((ProblemDimension, ProblemDimension))
    
    line_number = 0
        
    for line in f:
        if line_number < ProblemDimension:
            row = line[:-2].split(" ")
            for r in range(len(row)):
                try:
                    QUBOmatrix.itemset((r, line_number), float(row[r]))
                except:
                    return -1
            line_number +=1
                
    f.close()
    
    # Open file
    try:
        f = open(SolutionFileName)
    except:
        return -1
        
    Offset = 0
    Energy = 0
        
    for line in f:

        if line.startswith("Energy"):
            try:
                Energy = float(line.split(" ")[1])
            except:
                return -1
        if line.startswith("Offset"):
            try:
                Offset = float(line.split(" ")[1])
            except:
                return -1
    for i in range(ProblemDimension):
        for j in range(ProblemDimension):
            model += QUBOmatrix.item(i,j)*x[i]*x[j]
            
    model += Offset
    qubo = model.to_qubo()
    ising = model.to_quso()

    
    return qubo,ising, Energy
    

def create_JMatrix_and_HVector(model):
	JMatrix = np.zeros((len(model.variables), len(model.variables)))
	HVector = np.zeros(len(model.variables))
	offset = 0
	spinNumber = len(model.variables)
	for key in model.keys():
		if len(key) == 0:
			offset = model[key]
		elif len(key) == 1:
			HVector[key] = model[key]/1
		elif len(key) == 2:
			JMatrix[key] = model[key]/2
			JMatrix[key[::-1]] = model[key]/2
	return spinNumber, JMatrix, HVector, offset
    
            
        
    
    