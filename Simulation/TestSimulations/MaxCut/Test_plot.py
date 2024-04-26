from FileReaderAndProblemConverter import FileReader, create_JMatrix_and_HVector
from qubovert import QUBO, boolean_var, sim
import numpy as np
import random
from numpy.random import randint
import math
from qubovert.sim import anneal_quso, anneal_qubo
from qubovert import boolean_var
import qubovert as qv
from create_Q_matrix import create_Q_matrix
import matplotlib.pyplot as plt
from matplotlib import rc
from plotEnergyProfileVLSI import plotEnergyProfile
import time
import pandas as pd
import sys
sys.path.insert(0, "../../C++_version_fixed_my_lanch_simulation")
from LanchMySimulatedMachine import SimulatedBifurcationMachineVLSIArchitectureSimulation

Folder = "MaxCutProblems3/"
TypeOfProblem = "MaxCut"
ProblemNumber = 0
#problems = list(range(3, 31)) + [50, 99, 100, 300, 500, 700, 999, 1000]
problems = [50] #list(range(19, 30))#+ list(range(31,301))+[500, 700, 999, 1000]
FolderResults2 = "MaxCutProblemsResults3C/"
NumberOfTime = 100

DictGSet = {}

logfilename = "log_maxcut1.txt"
n_bits = [20]#list(range(16, 25))
int_bits = 12

try:
    logfile = open(logfilename, "w")
except:
    print("I cannot open the log file\n")
    sys.exit()

Last = True
Latex = False
Save = True

ArchitecturePath = "../../RevisedArchitecture/NSpin/NSpinSolver/"

folder = "resultsMaxCut1/"
for ProblemDimension in problems:
    ProblemFileName = Folder + TypeOfProblem + "_" + format(ProblemDimension) + "_nodes_" + format(ProblemNumber) + "_n.txt"
    SolutionFileName = Folder + TypeOfProblem + "_" + format(ProblemDimension) + "_nodes_" + format(ProblemNumber) + "_n_sol.txt"
    qubo, quso, Energy = FileReader(ProblemFileName, SolutionFileName, ProblemDimension)
    variables, J, h, offset = create_JMatrix_and_HVector(quso)
    
    print(J)
    #if ProblemDimension < 10:
    #    plotEnergyProfile(qubo, Print=True, fileName=Folder + TypeOfProblem + "_" + format(ProblemDimension) + "_nodes_" + format(ProblemNumber) + "_n_energy", ProblemType="Maxcut")
    for bit in n_bits:
        DictGSet["MaxCut1_"+format(ProblemDimension)+ "_" + format(bit)] = {}
        if ProblemDimension < 50:
            NumberOfIteration = 100
            pt_shape = 1/20
        elif ProblemDimension < 100:
            NumberOfIteration = 200
            pt_shape = 1/40
        else: 
            NumberOfIteration = 300
            pt_shape = 1/60
            
            
        logfile.write("Solve the problem of dimension: " + format(ProblemDimension) + "\n")

        NumberOfTime = 1
        states_numpy = np.zeros((NumberOfTime, ProblemDimension))
        energies = np.zeros(NumberOfTime)
        deltaT=0.9
        #pt_shape =  7/(10*NumberOfIteration*deltaT)
        verbose = True
        #Single execution 
        print("Standard version\n")
        logfile.write("Standard version\n")
        print("Single execution\n")
        logfile.write("Single execution\n")
        
        DictGSet["MaxCut1_"+format(ProblemDimension)+ "_" + format(bit)]["My fixed"] = {}

        start = time.time()
        SB = SimulatedBifurcationMachineVLSIArchitectureSimulation()
        SB.Sample(J=J, h=h, N=ProblemDimension, offset = offset, ArchitecturePath=ArchitecturePath, numIterations=NumberOfIteration, numRuns = NumberOfTime, frac_bits=bit, int_bits=int_bits, p_shape = pt_shape, verbose=True, folder=folder )
        stop = time.time()
        t = stop - start 
        SB.PlotAndWriteAll(FileNameBase = FolderResults2+ TypeOfProblem + "_" + format(ProblemDimension) + "_nodes_SB_solver_" + format(NumberOfIteration) +"_" + format(NumberOfTime) + "_" + format(bit), Last=Last, Latex=Latex, Save=Save, OptimalValue=Energy)
        print("Time required for execution " + format(t) + "\n")
        logfile.write("Time required for execution " + format(t) + "\n") 
        print("The Energy is: " + format(SB.AverageValue()) + "\n")
        logfile.write("The Energy is: " + format(SB.AverageValue()) + "\n")
        DictGSet["MaxCut1_"+format(ProblemDimension)+ "_" + format(bit)]["My fixed"]["single_time"] = t
        DictGSet["MaxCut1_"+format(ProblemDimension)+ "_" + format(bit)]["My fixed"]["single_energy"] = SB.AverageValue()
        start = time.time()
        sol, EnergyIn = SB.HillClimbingToImproveSol(50) 
        stop = time.time()
        t_hill = stop-start
        print("Time required for of hill climbing " + format(t_hill) + "\n")
        logfile.write("Time required for of hill climbing " + format(t_hill) + "\n") 
        print("Total time " + format(t_hill + t) + "\n")
        logfile.write("Total time " + format(t_hill + t ) + "\n")
        print("The Energy is: " + format(EnergyIn) + "\n")
        logfile.write("The Energy is: " + format(EnergyIn) + "\n")
        DictGSet["MaxCut1_"+format(ProblemDimension)+ "_" + format(bit)]["My fixed"]["single_total_time"] = t + t_hill
        DictGSet["MaxCut1_"+format(ProblemDimension)+ "_" + format(bit)]["My fixed"]["single_energy_final"] = EnergyIn
        logfile.write("Multiple execution\n")          
        # multiple execution
        '''NumberOfTime = 100     
        states_numpy = np.zeros((NumberOfTime, ProblemDimension))
        energies = np.zeros(NumberOfTime)
        start = time.time()
        SB = SimulatedBifurcationMachineVLSIArchitectureSimulation()
        SB.Sample(J=J, h=h, N=ProblemDimension, offset = offset,ArchitecturePath=ArchitecturePath, numIterations=NumberOfIteration, numRuns = NumberOfTime, frac_bits=bit, int_bits=int_bits, p_shape = pt_shape, verbose=True, folder=folder )
        stop = time.time()
        t = stop - start 
        SB.PlotAndWriteAll(FileNameBase = FolderResults2+ TypeOfProblem + "_" + format(ProblemDimension) + "_nodes_SB_solver_" + format(NumberOfIteration) +"_" + format(NumberOfTime) + "_" + format(bit), Last=Last, Latex=Latex, Save=Save, OptimalValue=Energy)
        print("Time required for execution " + format(t) + "\n")
        logfile.write("Time required for execution " + format(t) + "\n") 
        print("The Energy is: " + format(SB.AverageValue()) + "\n")
        logfile.write("The Average is: " + format(SB.AverageValue()) + "\n")
        DictGSet["MaxCut1_"+format(ProblemDimension)+ "_" + format(bit)]["My fixed"]["multiple_time"] = t
        DictGSet["MaxCut1_"+format(ProblemDimension)+ "_" + format(bit)]["My fixed"]["multiple_average_energy"] = SB.AverageValue()
        start = time.time()
        sol, EnergyIn = SB.HillClimbingToImproveSol(50) 
        stop = time.time()
        t_hill = stop-start
        print("Time required for of hill climbing " + format(t_hill) + "\n")
        logfile.write("Time required for of hill climbing " + format(t_hill) + "\n") 
        print("Total time " + format(t_hill + t) + "\n")
        logfile.write("Total time " + format(t_hill + t ) + "\n")
        print("The Energy is: " + format(EnergyIn) + "\n")
        logfile.write("The Energy is: " + format(EnergyIn) + "\n") 
        DictGSet["MaxCut1_"+format(ProblemDimension)+ "_" + format(bit)]["My fixed"]["multiple_total_time"] = t + t_hill
        DictGSet["MaxCut1_"+format(ProblemDimension)+ "_" + format(bit)]["My fixed"]["multiple_final_energy"] = EnergyIn  
        '''
        DataFramePandas = pd.DataFrame.from_dict(DictGSet["MaxCut1_"+format(ProblemDimension)+ "_" + format(bit)])
        DataFramePandas.to_csv("MaxCut1_"+format(ProblemDimension)+ "_" + format(bit) +".csv")      
        print("Finish problem with size" + format(variables) + "\n\n")