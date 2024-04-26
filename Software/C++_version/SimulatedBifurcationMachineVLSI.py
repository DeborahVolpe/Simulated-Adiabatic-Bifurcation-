import numpy as np
import math
import matplotlib.pyplot as plt
import random
from matplotlib import rc
import time
import os
from numpy.random import randint
import neal
from GeneralSimulatedBifurcationMachine import SimulatedBifurcationMachineVLSI 


"""
12/06/2023
@author: Deborah
"""


class SimulatedBifurcationMachineVLSISolver:
    # solver constructor
    # it instantiate the variables necessry
    def __init__(self):
    
        # Problem to solve description
        self.J = None
        self.h = None
        self.offset = None
        self.N = 0
 

        # number of iterations and runs 
        self.numIterations = 100
        self.numRuns = 100
        
        # Solver parameters
        self.K = 1.0
        self.Delta = 1.0
        self.xi = 0.1
        self.xi_h = 0.1
        self.deltaT = 0.1
        self.p_shape = 100/self.numIterations
        
        # outcome of the solver
        self.energies = None
        self.optimalEnergy = None
        self.solutions = None
        self.opt2imalSolution = None
        
        #Total Execution time
        self.TotalExecutionTime = 0
        
        #Folder for temporary results
        self.folder = ""
        
        self.verbose = False
        
        self.x = None
        self.y = None
        self.valueAtIteration = None
        self.averageEffectiveValue = None
        
        
    def __create_J_h__(self, ising):
        N = len(ising.variables)
        J = np.zeros((N, N))
        h = np.zeros(N)
        offset = 0
        for key in ising.keys():
            if len(key) == 0:
                offset = ising[key]
            elif len(key) == 1:
                h[key] = ising[key]/1
            elif len(key) == 2:
                J[key] = ising[key]/2
                J[key[::-1]] = ising[key]/2
        return N, J, h, offset        


    def SampleQUBO(self, qubo, numIterations=100, numRuns = 100, **kwargs):

        ising = qubo.to_quso()
        self.N, self.J, self.h, self.offset = self.__create_J_h__(ising)
    
        # Matrix dimension check
        if not np.shape(self.J)[0] == self.N or not np.shape(self.J)[1] == self.N:
            return None
            
        #Vector dimention check
        if not np.shape(self.h)[0] == self.N:
            return None
            
        try: 
            self.numIterations = int(numIterations)
        except:
            return None
           
        try: 
            self.numRuns = int(numRuns)
        except:
            return None
            
        # Default value for shape, xi and xi_h
        # Compute the standard deviation of the J matrix
        temp = 0
        temp2 = 0
        for i in range(self.N):
            for j in range(self.N):
                temp += self.J.item(i,j)**2
            temp2 += self.h.item(i)**2
        J_dev = math.sqrt(temp/(self.N*(self.N-1)))
        h_dev = math.sqrt(temp2/(self.N*(self.N-1)))
        
        #default value for the xi parameter
        if J_dev != 0:
            self.xi = 0.5/(math.sqrt(self.N) * J_dev)
        else:
            self.xi = 0.5/(math.sqrt(self.N) * 0.01)            
        
        #default value for the xi parameter
        if h_dev != 0:
            self.xi_h = 0.5/(math.sqrt(self.N) * h_dev)
        else:
            self.xi_h = 0.5/(math.sqrt(self.N) * 0.01)
        
        #default parameter for the shape
        self.p_shape = 100/self.numIterations
        
                   
 
        for key, value in kwargs.items():
            
            # setting the parameters
            if key == "K":
                try:
                    self.K = float(value)
                except:
                    return -1
                    
            if key == "Delta":
                try:
                    self.Delta = float(value)
                except:
                    return -1
                    
            if key == "xi":
                try:
                    self.xi = float(value)
                except:
                    return -1
                    
            if key == "xi_h":
                try:
                    self.xi_h = float(value)
                except:
                    return -1
                    
            if key == "p_shape":
                try:
                    self.p_shape = float(value)
                except:
                    return -1
                    
            if key == "verbose":
                try:
                    self.verbose = bool(value)
                except:
                    return -1
                    
            if key == "folder":
                try:
                    self.folder = str(value)
                except:
                    return -1
                    

            if key == "deltaT":
                try:
                    self.deltaT = float(value)
                except:
                    return -1
        if self.folder != " ":
            isExist = os.path.exists(self.folder)
            if not isExist:

               # Create a new directory because it does not exist
               os.makedirs(self.folder)            
                 
        self.energies = np.zeros(self.numRuns)
        self.solutions = np.zeros((self.numRuns, self.N))  
        seed = randint(2**31)     
        start = time.time()
        self.solutions, self.energies  = SimulatedBifurcationMachineVLSI(self.folder,self.solutions, self.energies, self.numRuns, self.h, self.J, self.N, self.K, self.Delta, self.deltaT, self.xi, self.xi_h, self.p_shape, self.numIterations, seed, self.verbose)           
        stop = time.time()      
        self.TotalExecutionTime = stop - start       
        self.optimalEnergy = min(self.energies)
        self.optimalSolution = self.solutions[list( self.energies).index(self.optimalEnergy)]
        return self.optimalSolution, self.optimalEnergy


    def Sample(self, J, h, N, offset, numIterations=100, numRuns = 100, **kwargs):

        self.J = J
        self.h = h

        try:
            self.N = int(N)
        except:
            return None

        # Matrix dimension check
        if not np.shape(self.J)[0] == self.N or not np.shape(self.J)[1] == self.N:
            return None
            
        #Vector dimention check
        if not np.shape(self.h)[0] == self.N:
            return None
            
        # offset
        self.offset = offset
            
        try: 
            self.numIterations = int(numIterations)
        except:
            return None
           
        try: 
            self.numRuns = int(numRuns)
        except:
            return None
            
        # Default value for shape, xi and xi_h
        # Compute the standard deviation of the J matrix
        temp = 0
        temp2 = 0
        for i in range(self.N):
            for j in range(self.N):
                temp += self.J.item(i,j)**2
            temp2 += self.h.item(i)**2
        J_dev = math.sqrt(temp/(self.N*(self.N-1)))
        h_dev = math.sqrt(temp2/(self.N*(self.N-1)))
        
        #default value for the xi parameter
        if J_dev != 0:
            self.xi = 0.7/(math.sqrt(self.N) * J_dev)
        else:
            self.xi = 0.7/(math.sqrt(self.N) * 0.01)            
        
        #default value for the xi parameter
        if h_dev != 0:
            self.xi_h = 0.7/(math.sqrt(self.N) * h_dev)
        else:
            self.xi_h = 0.7/(math.sqrt(self.N) * 0.01)
        
        #default parameter for the shape
        self.p_shape = 100/self.numIterations
        
                   
 
        for key, value in kwargs.items():
            
            # setting the parameters
            if key == "K":
                try:
                    self.K = float(value)
                except:
                    return -1
                    
            if key == "Delta":
                try:
                    self.Delta = float(value)
                except:
                    return -1
                    
            if key == "xi":
                try:
                    self.xi = float(value)
                except:
                    return -1
                    
            if key == "xi_h":
                try:
                    self.xi_h = float(value)
                except:
                    return -1
                    
            if key == "p_shape":
                try:
                    self.p_shape = float(value)
                except:
                    return -1
                    
            if key == "verbose":
                try:
                    self.verbose = bool(value)
                except:
                    return -1
                    
            if key == "folder":
                try:
                    self.folder =str(value)
                except:
                    return -1
                    

            if key == "deltaT":
                try:
                    self.deltaT = float(value)
                except:
                    return -1
        if self.folder != " ":
            isExist = os.path.exists(self.folder)
            if not isExist:

               # Create a new directory because it does not exist
               os.makedirs(self.folder)            
                 
        self.energies = np.zeros(self.numRuns)
        self.solutions = np.zeros((self.numRuns, self.N))  
        seed = randint(2**31)     
        start = time.time()
        self.solutions, self.energies  = SimulatedBifurcationMachineVLSI(self.folder,self.solutions, self.energies, self.numRuns, self.h, self.J, self.N, self.K, self.Delta, self.deltaT, self.xi, self.xi_h, self.p_shape, self.numIterations, seed, self.verbose)           
        stop = time.time()      
        self.energies = list(np.array(self.energies) + self.offset)
        self.TotalExecutionTime = stop - start       
        self.optimalEnergy = min(self.energies)
        self.optimalSolution = self.solutions[list( self.energies).index(self.optimalEnergy)]
        return self.optimalSolution, self.optimalEnergy



    def energies(self):
        return self.energies
        
        
    def states(self):
        return self.states

    def read_parameters_from_files(self): 
        if self.verbose == True:
            self.x = []
            self.y = []
            for i in range(self.N):
                self.x.append([]) 
                self.y.append([])                  

            self.valueAtIteration = []
            self.averageEffectiveValue = []           
            try: 
                file_x = open(self.folder + "Problem_" + format(self.N) + "_x_evolution.txt")
            except:
                return None
            for line in file_x.readlines():
                p = line[:-1].split(" ")
                if len(p) == self.N: 
                    for i in range(len(p)):
                        self.x[i].append(float(p[i]))
                else:
                    return None
            file_x.close()
            
            try: 
                file_y = open(self.folder + "Problem_" + format(self.N) + "_y_evolution.txt")
            except:
                return None
               
            for line in file_y.readlines():
                p = line[:-1].split(" ")
                if len(p) == self.N: 
                    for i in range(len(p)):
                        self.y[i].append(float(p[i]))
                else:
                    return None
            file_y.close()
            
            try: 
                file_value = open(self.folder + "Problem_" + format(self.N) + "_energy_evolution.txt")
            except:
                return None
                

               
            for line in file_value.readlines():
                self.valueAtIteration.append(float(line[:-1]))
            file_value.close()
            
            try: 
                file_effective_energy = open(self.folder + "Problem_" + format(self.N) + "_effective_energy.txt")
            except:
                return None
               
            for line in file_effective_energy.readlines():
                self.averageEffectiveValue.append(float(line[:-1]) + self.offset)
            file_effective_energy.close()
            return 0
                    
        else:
            return None 
    

    def total_execution_time(self):
        return self.TotalExecutionTime         
        
        
    def cumulative(self, FileName="", Last=True, Latex=False, Save=False, **kwargs):
        OptimalValue = self.optimalEnergy
        for key, value in kwargs.items():
            # setting the parameters
            # Starting field OptimalValue
            if key == "OptimalValue":
                try:
                    OptimalValue = float(value)
                except:
                    return -1
        if Latex == True:
            rc('text', usetex=True)
            plt.rc('text', usetex=True)
            plt.axvline(x = OptimalValue, color = 'b', label = r'\textit{Optimal Value}')
            n, bins, patches = plt.hist(self.energies, cumulative=True, histtype='step', linewidth=2,bins=100, label=r'\textit{Simulated Adiabatic Bifurcation}')
            plt.title(r'\textbf{Cumulative distribution}',fontsize=20)
            plt.xlabel(r'\textit{Values obtained}', fontsize=20)
            plt.ylabel(r'\textit{occurrence}', fontsize=20)
        else:
            plt.axvline(x = OptimalValue, color = 'b', label = "Optimal Value")
            n, bins, patches = plt.hist(self.energies, cumulative=True, histtype='step', linewidth=2,bins=100, label="Simulated Adiabatic Bifurcation")
            plt.title("Cumulative distribution",fontsize=20)
            plt.xlabel("Values obtained", fontsize=20)
            plt.ylabel("occurrence", fontsize=20)        
        leg = plt.legend(loc='lower right', frameon=True, fontsize=15)
        leg.get_frame().set_facecolor('white')
        if Save == True:
            plt.savefig(FileName + ".png", format='png')
            plt.savefig(FileName + ".pdf", format='pdf')
            if Last == True:
                plt.close()
        else:
            if Last == True:
                plt.show()
                
    def SuccessProbability(self, **kwargs):
        OptimalValue = self.optimalEnergy
        for key, value in kwargs.items():
            # setting the parameters
            # Starting field OptimalValue
            if key == "OptimalValue":
                try:
                    OptimalValue = float(value)
                except:
                    return -1
        return list(self.energies).count(OptimalValue)/self.numRuns

    def AverageValue(self):
        return sum(list(self.energies))/self.numRuns
        
    def WriteResultsInAFile(self, nomeFileReport,  **kwargs):
        OptimalValue = self.optimalEnergy
        for key, value in kwargs.items():
            # setting the parameters
            # Starting field OptimalValue
            if key == "OptimalValue":
                try:
                    OptimalValue = float(value)
                except:
                    return -1
        try:
            ReportFile = open(nomeFileReport, "w")
        except:
            return None
        ReportFile.write("----------Report of Simulated Adiabatic Bifurcation-----------\n")
        ReportFile.write("The number of considered Spin " + format(self.N) + "\n")
        ReportFile.write("The considered Evolution Duration " + format(self.numIterations) + "\n")
        ReportFile.write("The considered Repetition time " + format(self.numRuns) + "\n")
        ReportFile.write("The considered K " + format(self.K) + "\n")
        ReportFile.write("The considered Delta " + format(self.Delta) + "\n")
        ReportFile.write("The considered deltaT " + format(self.deltaT) + "\n")
        ReportFile.write("The considered xi " + format(self.xi) + "\n")
        ReportFile.write("The considered xi_h " + format(self.xi_h) + "\n")
        ReportFile.write("The considered p_shape " + format(self.p_shape) + "\n")
        ReportFile.write("The solution found " + format(self.optimalSolution) + "\n")
        ReportFile.write("The value found " + format(self.optimalEnergy) + "\n")
        ReportFile.write("The expected optimal value " + format(OptimalValue) + "\n")
        ReportFile.write("The Success probability is " + format(self.SuccessProbability(OptimalValue=OptimalValue)) + "\n")
        ReportFile.write("The average value is " + format(self.AverageValue()) + "\n")
        ReportFile.write("The total execution time is " + format(self.TotalExecutionTime) + "\n")
        ReportFile.write("The list of values found \n\n")
        for i in range(len(self.energies)):
            ReportFile.write(format(self.energies[i]) + "\n")
        if self.verbose == True and self.x == None:
            ret = self.read_parameters_from_files()
        else:
            if self.verbose == False:
                ret = None 
            else:
                ret = 0
        if ret == 0:
            ReportFile.write("\n\n\nThe list of values last execution \n\n")
            for i in range(len(self.valueAtIteration)):
                ReportFile.write(format(self.valueAtIteration[i]) + "\n")
            ReportFile.write("\n\n\nThe list effective values average \n\n")
            for i in range(len(self.averageEffectiveValue)):
                ReportFile.write(format(self.averageEffectiveValue[i]) + "\n")
            ReportFile.write("\n\n\nThe position evolution in the last run \n\n")
            for i in range(self.N):
                ReportFile.write("\n\n\nFor the spin " + format(i) + "\n\n") 
                for elm in self.x[i]:
                    ReportFile.write(format(elm) + "\n") 
            ReportFile.write("\n\n\nThe momentum evolution in the last run \n\n")
            for i in range(self.N):
                ReportFile.write("\n\n\nFor the spin " + format(i) + "\n\n") 
                for elm in self.y[i]:
                    ReportFile.write(format(elm) + "\n")                          
        ReportFile.close()
        	
    def PlotX(self, FileName="", Last=True, Latex=False, Save=False):
        if self.verbose == True and self.x == None:
            ret = self.read_parameters_from_files()
        else:
            if self.verbose == False:
                ret = None 
            else:
                ret = 0
        if ret == 0:
            if Latex == True:
                rc('text', usetex=True)
                plt.rc('text', usetex=True)
                for i in range(self.N):
                    plt.plot(range(self.numIterations+1), self.x[i], linewidth=2.0, label = r'\textit{x' + format(i)+'}')
                plt.title(r'\textbf{Simulated Adiabatic Bifurcation}', fontsize=20)
                plt.xlabel(r'\textit{t}', fontsize=20)
                plt.ylabel(r'\textit{x}', fontsize=20)
            else:
                for i in range(self.N):
                    plt.plot(range(self.numIterations+1), self.x[i], linewidth=2.0, label = "x" + format(i))
                plt.title("Simulated Adiabatic Bifurcation", fontsize=20)
                plt.xlabel("t", fontsize=20)
                plt.ylabel("x", fontsize=20)        
            #leg = plt.legend(loc='lower right', frameon=True, fontsize=15)
            #leg.get_frame().set_facecolor('white')        
            if Save == True:
                plt.savefig(FileName+ ".png", format='png')
                plt.savefig(FileName + ".pdf", format='pdf')
                if Last == True:
                    plt.close()
            else:
                if Last == True:
                    plt.show() 
                    
    def PlotY(self, FileName="", Last=True, Latex=False, Save=False):
        if self.verbose == True and self.x == None:
            ret = self.read_parameters_from_files()
        else:
            if self.verbose == False:
                ret = None 
            else:
                ret = 0
        if ret == 0:
            if Latex == True:
                rc('text', usetex=True)
                plt.rc('text', usetex=True)
                for i in range(self.N):
                    plt.plot(range(self.numIterations+1), self.y[i], linewidth=2.0, label = r'\textit{y' + format(i)+'}')
                plt.title(r'\textbf{Simulated Adiabatic Bifurcation}', fontsize=20)
                plt.xlabel(r'\textit{t}', fontsize=20)
                plt.ylabel(r'\textit{y}', fontsize=20)
            else:
                for i in range(self.N):
                    plt.plot(range(self.numIterations+1), self.y[i], linewidth=2.0, label = "y" + format(i))
                plt.title("Simulated Adiabatic Bifurcation", fontsize=20)
                plt.xlabel("t", fontsize=20)
                plt.ylabel("y", fontsize=20)        
            #leg = plt.legend(loc='lower right', frameon=True, fontsize=15)
            #leg.get_frame().set_facecolor('white')        
            if Save == True:
                plt.savefig(FileName+ ".png", format='png')
                plt.savefig(FileName + ".pdf", format='pdf')
                if Last == True:
                    plt.close()
            else:
                if Last == True:
                    plt.show()

    def ValueAtIteration(self, FileName="", Last=True, Latex=False, Save=False):
        if self.verbose == True and self.x == None:
            ret = self.read_parameters_from_files()
        else:
            if self.verbose == False:
                ret = None 
            else:
                ret = 0
        if ret == 0:
            if Latex == True:
                rc('text', usetex=True)
                plt.rc('text', usetex=True)
                plt.plot(range(self.numIterations+1), self.valueAtIteration, linewidth=2.0, color='r')
                plt.title(r'\textbf{Simulated Adiabatic Bifurcation}', fontsize=20)
                plt.xlabel(r'\textit{t}', fontsize=20)
                plt.ylabel(r'\textit{Value}', fontsize=20)
            else:
                plt.plot(range(self.numIterations+1), self.valueAtIteration, linewidth=2.0, color='r')
                plt.title("Simulated Adiabatic Bifurcation", fontsize=20)
                plt.xlabel("t", fontsize=20)
                plt.ylabel("Value", fontsize=20)       
            if Save == True:
                plt.savefig(FileName+ ".png", format='png')
                plt.savefig(FileName + ".pdf", format='pdf')
                if Last == True:
                    plt.close()
            else:
                if Last == True:
                    plt.show() 
                
    def AverageEffectiveEnergy(self, FileName="", Last=True, Latex=False, Save=False, **kwargs):
        OptimalValue = self.optimalEnergy
        for key, value in kwargs.items():
            # setting the parameters
            # Starting field OptimalValue
            if key == "OptimalValue":
                try:
                    OptimalValue = float(value)
                except:
                    return -1
        if self.verbose == True and self.x == None:
            ret = self.read_parameters_from_files()
        else:
            if self.verbose == False:
                ret = None 
            else:
                ret = 0
        if ret == 0:
            if Latex == True:
                rc('text', usetex=True)
                plt.rc('text', usetex=True)
                plt.plot(range(self.numIterations), self.averageEffectiveValue, linewidth=2.0, color='r')
                plt.axhline(y = OptimalValue, color = 'b', linestyle = '-')
                plt.title(r'\textbf{Simulated Adiabatic Bifurcation}', fontsize=20)
                plt.xlabel(r'\textit{t}', fontsize=20)
                plt.ylabel(r'\textit{Value}', fontsize=20)
            else:
                plt.plot(range(self.numIterations), self.averageEffectiveValue, linewidth=2.0, color='r')
                plt.title("Simulated Adiabatic Bifurcation", fontsize=20)
                plt.axhline(y = OptimalValue, color = 'b', linestyle = '-')
                plt.xlabel("t", fontsize=20)
                plt.ylabel("Value", fontsize=20)
            if Save == True:
                plt.savefig(FileName+ ".png", format='png')
                plt.savefig(FileName + ".pdf", format='pdf')
                if Last == True:
                    plt.close()
            else:
                if Last == True:
                    plt.show() 
                  
    def PlotAndWriteAll(self, FileNameBase = "", Last=True, Latex=False, Save=True, **kwargs):
        OptimalValue = self.optimalEnergy
        for key, value in kwargs.items():
            # setting the parameters
            # Starting field OptimalValue
            if key == "OptimalValue":
                try:
                    OptimalValue = float(value)
                except:
                    return -1
        self.cumulative(FileName=FileNameBase + "_cumulative" , Last=Last, Latex=Latex, Save=Save, OptimalValue=OptimalValue)
        self.WriteResultsInAFile(nomeFileReport=FileNameBase + "_report.txt" ,  OptimalValue=OptimalValue)
        self.PlotX(FileName=FileNameBase + "_X",Last=Last, Latex=Latex, Save=Save)
        self.PlotY(FileName=FileNameBase + "_Y", Last=Last, Latex=Latex, Save=Save)
        self.ValueAtIteration(FileName=FileNameBase + "_value_at_iteration", Last=Last, Latex=Latex, Save=Save)
        self.AverageEffectiveEnergy(FileName=FileNameBase + "_average_effective_energy", Last=Last, Latex=Latex, Save=Save, OptimalValue=OptimalValue)        

    def HillClimbingToImproveSol(self, numIterations_hill):
        for it in range(numIterations_hill):
            for var in range(self.N):
                #Try to flip the variables
                self.optimalSolution[var] = -1*self.optimalSolution[var]
                En = (np.add(np.matmul(np.matmul(self.optimalSolution, self.J), np.transpose(self.optimalSolution)), np.matmul(self.h, np.transpose(self.optimalSolution)))) + self.offset
                if En < self.optimalEnergy:
                    self.optimalEnergy = En
                else:
                    self.optimalSolution[var] = -1*self.optimalSolution[var]
        return self.optimalSolution, self.optimalEnergy

    def SimulatedAnnealingToImproveSol(self, numIterations_sim, numRuns_sim):
        sampler = neal.SimulatedAnnealingSampler()
        sampleset = sampler.sample_ising(self.h, self.J, beta_schedule_type='geometric', num_reads = numRuns_sim, num_sweeps=numIterations_sim, initial_states= self.optimalSolution)
        En = sampleset.first.energy
        if En < self.optimalEnergy:
            self.optimalEnergy = En
            self.optimalSolution = samples.first.sample
        return self.optimalSolution, self.optimalEnergy






