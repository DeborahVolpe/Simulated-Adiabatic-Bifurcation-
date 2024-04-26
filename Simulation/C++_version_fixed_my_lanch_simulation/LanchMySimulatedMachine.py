import numpy as np
import math
import matplotlib.pyplot as plt
import random
from matplotlib import rc
import time
import os
import sys
from numpy.random import randint
import neal
from GeneralRandomNumberGenerator import generate_random_numbersVLSI
import subprocess

"""
12/06/2023
@author: Deborah
"""


class SimulatedBifurcationMachineVLSIArchitectureSimulation:
    # solver constructor
    # it instantiate the variables necessry
    def __init__(self):
    
        # Problem to solve description
        self.J = None
        self.h = None
        self.J_int = None
        self.h_int = None
        self.offset = None
        self.N = 0
        self.frac_bits = 20
        self.int_bits = 20
        self.total_bits = self.frac_bits+self.int_bits
 

        # number of iterations and runs 
        self.numIterations = 100
        self.numRuns = 100
        
        # Solver parameters
        self.K = int(1.0*2**self.frac_bits)
        self.K_1 = int(1.0*2**self.frac_bits)
        self.Delta = int(1.0*2**self.frac_bits)
        self.Delta4K = int((1.0+4*1.0)*2**self.frac_bits)
        self.xi = int(0.1*2**self.frac_bits)
        self.xi_h = int(0.1*2**self.frac_bits)
        self.deltaT = int(0.1*2**self.frac_bits)
        self.p_shape = int((100/self.numIterations)*2**self.frac_bits)
        self.cwd = os.getcwd() 
        
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
                J[key[::-1]] =ising[key]/2
        return N, J, h, offset        
        
    def createSimulationsFile(self):
        nome_file = self.ArchitecturePath + self.folder + "InputParameter_" +format(self.N) +".txt"
        try:
            ParameterFile = open(nome_file, 'w')
        except:
            print("Error: it is not possible to open or create the file" + nome_file + "\n")
            sys.exit()
        A0_start = int(0.1*2**self.frac_bits)
        ParameterFile.write(format(A0_start, 'b').zfill(self.total_bits) + "\n")
        ParameterFile.write(format(self.p_shape, 'b').zfill(self.total_bits) + "\n")
        ParameterFile.write(format(self.Delta4K, 'b').zfill(self.total_bits) + "\n")
        ParameterFile.write(format(self.K_1, 'b').zfill(self.total_bits) + "\n")
        offset =int(0.1*2**self.frac_bits)
        ParameterFile.write(format(offset, 'b').zfill(self.total_bits) + "\n")
        ParameterFile.write(format(self.K, 'b').zfill(self.total_bits) + "\n")
        ParameterFile.write(format(self.Delta, 'b').zfill(self.total_bits) + "\n")
        for i in range(self.N):
            h_i = self.h_int.item(i)
            if h_i < 0:
                h_i = 2**self.total_bits + h_i
            ParameterFile.write(format(h_i, 'b').zfill(self.total_bits) + "\n")
        ParameterFile.write(format(self.deltaT, 'b').zfill(self.total_bits) + "\n")
        for i in range(self.N):
            for j in range(self.N):
                if i != j:
                    J_ij = self.J_int.item(i,j)
                    if J_ij < 0:
                        J_ij = 2**self.total_bits + J_ij
                    ParameterFile.write(format(J_ij, 'b').zfill(self.total_bits) + "\n")
        ParameterFile.close()  
        # y file
        seed = randint(2**31) 
        ret = generate_random_numbersVLSI( self.ArchitecturePath +self.folder, self.numRuns, self.N, seed, self.frac_bits)

    def SampleQUBO(self, qubo, ArchitecturePath, numIterations=100, numRuns = 100, frac_bits=32, int_bits = 32, **kwargs):

        ising = qubo.to_quso()
        self.N, self.J, self.h, self.offset = self.__create_J_h__(ising)
        self.ArchitecturePath = ArchitecturePath
        
        try:
            self.frac_bits = int(frac_bits)
        except:
            return None
            
        try:
            self.int_bits = int(int_bits)
        except:
            return None
            
        self.total_bits = self.frac_bits + self.int_bits
    
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
            self.xi = int((0.5/(math.sqrt(self.N) * J_dev))*2**self.frac_bits)
        else:
            self.xi = int((0.5/(math.sqrt(self.N) * 0.01))*2**self.frac_bits)            
        
        #default value for the xi parameter
        if h_dev != 0:
            self.xi_h = int((0.5/(math.sqrt(self.N) * h_dev))*2**self.frac_bits)
        else:
            self.xi_h = int((0.5/(math.sqrt(self.N) * 0.01))*2**self.frac_bits)
        
        #default parameter for the shape
        self.p_shape = int((100/self.numIterations)*2**self.frac_bits)
        
                   
 
        for key, value in kwargs.items():
            
            # setting the parameters
            if key == "K":
                try:
                    self.K = int(float(value)*2**self.frac_bits)
                    self.K_ = int(float(1/value)*2**self.frac_bits)
                except:
                    return -1
                    
            if key == "Delta":
                try:
                    self.Delta = int(float(value)*2**self.frac_bits)
                except:
                    return -1
               
            if key == "Delta4K":
                try:
                    self.Delta4K = int(float(value)*2**self.frac_bits)
                except:
                    return -1
                    
            if key == "xi":
                try:
                    self.xi = int(float(value)*2**self.frac_bits)
                except:
                    return -1
                    
            if key == "xi_h":
                try:
                    self.xi_h = int(float(value)*2**self.frac_bits)
                except:
                    return -1
                    
            if key == "p_shape":
                try:
                    self.p_shape = int(float(value)*2**self.frac_bits)
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
                    self.deltaT = int(float(value)*2**self.frac_bits)
                except:
                    return -1
        if self.folder != " ":
            isExist = os.path.exists(self.ArchitecturePath+self.folder)
            if not isExist:
               # Create a new directory because it does not exist
                os.makedirs(self.ArchitecturePath+self.folder) 
                
        self.J_int = (self.J*self.xi).astype(int)
        self.h_int = (self.h*self.xi_h).astype(int)        
        self.energies = np.zeros(self.numRuns)
        self.solutions = np.zeros((self.numRuns, self.N))  
        
        self.createSimulationsFile()
        self.createTestbenchFile()
        self.ModifyCompileTestbenchFile()
        self.LanchModelsimWindows()
        self.read_parameters_from_files()       
        self.optimalEnergy = min(self.energies)
        self.optimalSolution = self.solutions[list( self.energies).index(self.optimalEnergy)]
        os.chdir(self.cwd)
        return self.optimalSolution, self.optimalEnergy


    def Sample(self, J, h, N, offset, ArchitecturePath, numIterations=100, numRuns = 100, frac_bits=32, int_bits = 32, **kwargs):

        self.J = J
        self.h = h
        self.ArchitecturePath = ArchitecturePath
     
        try:
            self.frac_bits = int(frac_bits)
        except:
            return None
            
        try:
            self.int_bits = int(int_bits)
        except:
            return None
            
        self.total_bits = self.frac_bits + self.int_bits

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
            self.xi = int((0.5/(math.sqrt(self.N) * J_dev))*2**self.frac_bits)
        else:
            self.xi = int((0.5/(math.sqrt(self.N) * 0.01))*2**self.frac_bits)            
        
        #default value for the xi parameter
        if h_dev != 0:
            self.xi_h = int((0.5/(math.sqrt(self.N) * h_dev))*2**self.frac_bits)
        else:
            self.xi_h = int((0.5/(math.sqrt(self.N) * 0.01))*2**self.frac_bits)
        
        #default parameter for the shape
        self.p_shape = int((100/self.numIterations)*2**self.frac_bits)
        
                   
 
        for key, value in kwargs.items():
            
            # setting the parameters
            if key == "K":
                try:
                    self.K = int(float(value)*2**self.frac_bits)
                    self.K_ = int(float(1/value)*2**self.frac_bits)
                except:
                    return -1
                    
            if key == "Delta":
                try:
                    self.Delta = int(float(value)*2**self.frac_bits)
                except:
                    return -1
               
            if key == "Delta4K":
                try:
                    self.Delta4K = int(float(value)*2**self.frac_bits)
                except:
                    return -1
                    
            if key == "xi":
                try:
                    self.xi = int(float(value)*2**self.frac_bits)
                except:
                    return -1
                    
            if key == "xi_h":
                try:
                    self.xi_h = int(float(value)*2**self.frac_bits)
                except:
                    return -1
                    
            if key == "p_shape":
                try:
                    self.p_shape = int(float(value)*2**self.frac_bits)
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
                    self.deltaT = int(float(value)*2**self.frac_bits)
                except:
                    return -1
        if self.folder != " ":
            isExist = os.path.exists(self.ArchitecturePath+self.folder)
            if not isExist:
               # Create a new directory because it does not exist
               os.makedirs(self.ArchitecturePath+self.folder)           
               
        self.J_int = ((self.J*self.xi)).astype(int)
        self.h_int = ((self.h*self.xi_h)).astype(int)       
        self.energies = np.zeros(self.numRuns)
        self.solutions = np.zeros((self.numRuns, self.N))  
        self.createSimulationsFile()
        self.createTestbenchFile()
        self.ModifyCompileTestbenchFile()
        self.LanchModelsimWindows()
        self.read_parameters_from_files()
        self.optimalEnergy = min(self.energies)
        self.optimalSolution = self.solutions[list( self.energies).index(self.optimalEnergy)]
        os.chdir(self.cwd)
        return self.optimalSolution, self.optimalEnergy

    def createTestbenchFile(self):
        testbench_file_name = self.ArchitecturePath + "Testbench"+ format(self.N) + "Spin.vhd"

        try:
            TestbenchFile = open(testbench_file_name, 'w')
        except:
            print("Error: it is not possible to open or create the file" + testbench_file_name + "\n")
            sys.exit()
            
            
        testbench_fixed_file_name = self.ArchitecturePath + "TestbenchFixedParts.vhd"

        try:
            TestbenchFixedFile = open(testbench_fixed_file_name, 'r')
        except:
            print("Error: it is not possible to open or create the file" + testbench_fixed_file_name + "\n")
            sys.exit()
            
        lines = TestbenchFixedFile.readlines()
        i = 0
        while(not lines[i].startswith("_")):
            TestbenchFile.write(lines[i])
            i += 1
        i += 1
        TestbenchFile.write("\tsignal data_in									: std_logic_vector(" + format(self.total_bits-1) + " downto 0);\n")
        TestbenchFile.write("\tsignal X_out									: bus_array(" + format(self.N-1)+ " downto 0, " + format(self.total_bits-1)+ " downto 0);\n")
        TestbenchFile.write("\tsignal Y_out									: bus_array(" + format(self.N-1)+ " downto 0, " + format(self.total_bits-1)+ " downto 0);\n") 
        TestbenchFile.write("\tsignal S										: std_logic_vector("  + format(self.N-1) + " downto 0);\n") 
        for k in range(self.N):
            TestbenchFile.write("\tsignal X"+format(k) +"										: std_logic_vector(" + format(self.total_bits-1)+ " downto 0);\n") 
            TestbenchFile.write("\tsignal Y"+format(k) +"										: std_logic_vector(" + format(self.total_bits-1)+ " downto 0);\n")  
            TestbenchFile.write("\tsignal S"+format(k) +"										: std_logic;\n")             
        while(not lines[i].startswith("_")):
            TestbenchFile.write(lines[i])
            i += 1
        i += 1
        TestbenchFile.write("\t\t\t\t\t\t\t\tINT 					=> " + format(self.int_bits) +",\n")
        TestbenchFile.write("\t\t\t\t\t\t\t\tFRAC 					=> " + format(self.frac_bits) +",\n")
        TestbenchFile.write("\t\t\t\t\t\t\t\tM 					    => " + format(math.ceil(math.log(self.N,2))) +",\n")        
        TestbenchFile.write("\t\t\t\t\t\t\t\tNSPIN 					=> " + format(self.N) +",\n")
        TestbenchFile.write("\t\t\t\t\t\t\t\tN 					    => " + format(math.ceil(math.log(self.numIterations,2))) +",\n") 
        TestbenchFile.write("\t\t\t\t\t\t\t\tN_ITERATION	 		=> " + format(self.numIterations) +"\n")
        while(not lines[i].startswith("_")):
            TestbenchFile.write(lines[i])
            i += 1
        i += 1
        for k in range(self.N):
            TestbenchFile.write("\t\tslv_from_slm_row(X"+format(k)+", X_out, "+format(k)+");\n")
            TestbenchFile.write("\t\tslv_from_slm_row(Y"+format(k)+", Y_out, "+format(k)+");\n")
            TestbenchFile.write("\t\tS"+format(k)+"					<= S("+format(k) +");\n")
        while(not lines[i].startswith("_")):
            TestbenchFile.write(lines[i])
            i += 1
        i += 1
        TestbenchFile.write("\t\t\t\t\t\t\t\t\tvariable data_in_v 			: std_logic_vector("+format(self.total_bits-1)+" downto 0);\n")
        TestbenchFile.write("\t\t\t\t\t\t\t\t\tbegin\n")
        TestbenchFile.write("\t\t\t\t\t\t\t\t\tfile_open(ParamFileRandom, " +r'"'+ self.folder+ "Problem_" + format(self.N) + "_y_init_variables.txt" +r'"'+ ", read_mode);\n")
        TestbenchFile.write("\t\t\t\t\t\t\t\t\tfile_open(file_outputS, " +r'"'+ self.folder+ "output_file_" + format(self.N) + ".txt"+r'"'+", write_mode);\n")
        TestbenchFile.write("\t\t\t\t\t\t\t\t\tfile_open(file_output_X_Y, " +r'"'+ self.folder+ "output_file_X_Y_" + format(self.N) + ".txt"+r'"'+", write_mode);\n")
        TestbenchFile.write("\t\t\t\t\t\t\t\t\twhile i < " + format(self.numRuns) + " loop\n") 
        while(not lines[i].startswith("_")):
            TestbenchFile.write(lines[i])
            i += 1
        i += 1
        TestbenchFile.write("\t\t\t\t\t\t\t\t\t\tfile_open(ParamFile, "+r'"'+  self.folder+ "InputParameter_" + format(self.N) + ".txt"+r'"'+", read_mode);\n")        
        while(not lines[i].startswith("_")):
            TestbenchFile.write(lines[i])
            i += 1
        i += 1
        TestbenchFile.write("\t\t\t\t\t\t\t\t\t\tif k = " + format(self.N+6) + " then\n")
        while(not lines[i].startswith("_")):
            TestbenchFile.write(lines[i])
            i += 1
        i += 1
        for k in range(self.N):
            TestbenchFile.write("\t\t\t\t\t\t\t\t\t\t\tread(v_ILINEYR, y);\n")
            if k != self.N -1:
                TestbenchFile.write("\t\t\t\t\t\t\t\t\t\t\tread(v_ILINEYR, space);\n")
            TestbenchFile.write("\t\t\t\t\t\t\t\t\t\t\tdata_in <= std_logic_vector(to_signed(y, " +format(self.total_bits) + "));\n")
            TestbenchFile.write("\t\t\t\t\t\t\t\t\t\t\twait for 10 ns;\n")
        while(not lines[i].startswith("_")):
            TestbenchFile.write(lines[i])
            i += 1
        i += 1
        for k in range(self.N):
            TestbenchFile.write("										write(v_OLINE_X_Y, X" + format(k) + ");\n")
            TestbenchFile.write("										write(v_OLINE_X_Y, ' ');\n")
        while(not lines[i].startswith("_")):
            TestbenchFile.write(lines[i])
            i += 1
        i += 1            
        for k in range(self.N):
            TestbenchFile.write("										write(v_OLINE_X_Y, Y" + format(k) + ");\n")
            if k != self.N-1:
                TestbenchFile.write("										write(v_OLINE_X_Y, ' ');\n")
        while(not lines[i].startswith("_")):
            TestbenchFile.write(lines[i])
            i += 1 
        i += 1
        for k in range(self.N):
            TestbenchFile.write("									write(v_OLINE, S" + format(k)+");\n")
            if k != self.N-1:
                TestbenchFile.write("									write(v_OLINE, ' ');\n")
        while(not lines[i].startswith("_")):
            TestbenchFile.write(lines[i])
            i += 1
        i += 1
        TestbenchFixedFile.close()
        TestbenchFile.close()
        
    def ModifyCompileTestbenchFile(self):
        fileName= self.ArchitecturePath + "TestbenchCompile.do"
        try:
            CompileTestbenchFile = open(fileName, 'w')
        except:
            print("Error: it is not possible to open or create the file" + testbench_file_name + "\n")
            sys.exit()        
        CompileTestbenchFile.write("vcom ../common_component/clock_gen.vhd\n")
        CompileTestbenchFile.write("vcom Testbench"+ format(self.N) + "Spin.vhd\n")

           
    def LanchModelsimWindows(self):
        self.cwd = os.getcwd()    
        os.chdir(self.ArchitecturePath)
        os.environ["PATH"] += os.pathsep + r'C:/intelFPGA/17.0/modelsim_ase/win32aloem'
        try:
            os.rmdir("work")
        except OSError:
            pass
        try:
            os.remove("transcript")
        except OSError:
            pass
        try:
            os.remove("vsim.wlf") 
        except OSError:
            pass
        print ("Starting simulation...")
        os.system("vsim -modelsimini C:/intelFPGA/17.0/modelsim_ase/modelsim.ini -c -do transcript.tcl")
        #process = subprocess.call(["vsim", "-c", "-do", "transcript.tcl"])
        print ("Simulation completed")
        
    def LanchModelsimServer(self):
        os.environ["PATH"] += os.pathsep + "/eda/mentor/2020-21/RHELx86/QUESTA-CORE-PRIME_2020.4/questasim/linux_x86_64"
        os.environ["LM_LICENSE_FILE"] = "1717@led-x3850-1.polito.it"
        os.chdir(self.ArchitecturePath)
        os.system("rm -rf work")
        os.system("rm transcript")
        os.system("rm vsim.wlf") 
        print ("Starting simulation...")
        process = subprocess.call(["vsim", "-c", "-do", "transcript.tcl"])
        print ("Simulation completed")
           
            
    def energies(self):
        return self.energies
        
        
    def states(self):
        return self.states

    def read_parameters_from_files(self): 
        try: 
            file_x = open( self.folder+ "output_file_X_Y_" + format(self.N) + ".txt", "r")
        except:
            return None
        self.x = {}
        self.y = {}
        self.valueAtIteration = {}
        self.averageEffectiveValue = [0]*(self.numIterations-1)   
        lines = file_x.readlines()
        sol = np.zeros(self.N)
        runs = 0
        iteration = 0
        self.x[runs] = []
        self.y[runs] = []
        self.valueAtIteration[runs] = []
        for i in range(self.N):
            self.x[runs].append([])
            self.y[runs].append([]) 
            
        for line in lines:
            p = line[:-1].split(" ")
            if len(p) == 2*self.N:
                for i in range(self.N):
                    x_to_convert = p[i]
                    if x_to_convert[0] == '1':
                        x_converted = float((int(x_to_convert[1:], 2) - 2**(len(x_to_convert)-1))/2**self.frac_bits)
                    else:
                        x_converted = float((int(x_to_convert[1:], 2))/2**self.frac_bits)
                    self.x[runs][i].append(x_converted)
                    sol.itemset(i, np.sign(x_converted))
                for i in range(self.N):
                    y_to_convert = p[i+self.N]
                    if y_to_convert[0] == '1':
                        y_converted = float((int(y_to_convert[1:], 2) - 2**(len(x_to_convert)-1))/2**self.frac_bits)
                    else:
                        y_converted = float((int(y_to_convert[1:], 2))/2**self.frac_bits)
                    self.y[runs][i].append(y_converted)
                En = (np.matmul(sol, np.transpose(np.matmul(self.J, np.transpose(sol)))) + np.matmul(sol, np.transpose(self.h))).item(0) + self.offset
                self.valueAtIteration[runs].append(En)
                self.averageEffectiveValue[iteration] += En/self.numRuns
                iteration += 1
            else:
                runs += 1
                iteration = 0
                self.x[runs] = []
                self.y[runs] = []
                self.valueAtIteration[runs] = []
                for i in range(self.N):
                    self.x[runs].append([])
                    self.y[runs].append([])                    
                    
        file_x.close()
        
        
        try: 
            file_s = open( self.folder+ "output_file_" + format(self.N) + ".txt", "r")
        except:
            return None
        sol = np.zeros(self.N)
        lines = file_s.readlines()
        First = True
        self.optimalEnergy = None
        run = 0
        for line in lines:
            p = line[:-1].split(" ")
            if len(p) == self.N: 
                for i in range(self.N):
                    if p[i] == '0':
                        sol.itemset(i, 1)
                    else:
                        sol.itemset(i, -1)
                    self.solutions.itemset((run, i), sol.item(i))
                En = (np.matmul(sol, np.transpose(np.matmul(self.J, np.transpose(sol)))) + np.matmul(sol, np.transpose(self.h))).item(0) + self.offset
                self.energies.itemset(run, En)
            run += 1
                
        file_s.close()
                    
                

           
        
        
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
        ReportFile.write("The considered number of fractional bit " + format(self.frac_bits) + "\n")
        ReportFile.write("The considered number of integer bit " + format(self.int_bits) + "\n")
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
            for i in range(len(self.valueAtIteration[self.numRuns-1])):
                ReportFile.write(format(self.valueAtIteration[self.numRuns-1][i]) + "\n")
            ReportFile.write("\n\n\nThe list effective values average \n\n")
            for i in range(len(self.averageEffectiveValue)):
                ReportFile.write(format(self.averageEffectiveValue[i]) + "\n")
            ReportFile.write("\n\n\nThe position evolution in the last run \n\n")
            for i in range(self.N):
                ReportFile.write("\n\n\nFor the spin " + format(i) + "\n\n") 
                for elm in self.x[self.numRuns-1][i]:
                    ReportFile.write(format(elm) + "\n") 
            ReportFile.write("\n\n\nThe momentum evolution in the last run \n\n")
            for i in range(self.N):
                ReportFile.write("\n\n\nFor the spin " + format(i) + "\n\n") 
                for elm in self.y[self.numRuns-1][i]:
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
                    plt.plot(range(self.numIterations-1), self.x[self.numRuns-1][i], linewidth=2.0, label = r'\textit{x' + format(i)+'}')
                plt.title(r'\textbf{Simulated Adiabatic Bifurcation}', fontsize=20)
                plt.xlabel(r'\textit{t}', fontsize=20)
                plt.ylabel(r'\textit{x}', fontsize=20)
            else:
                for i in range(self.N):
                    plt.plot(range(self.numIterations-1), self.x[self.numRuns-1][i], linewidth=2.0, label = "x" + format(i))
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
                    plt.plot(range(self.numIterations-1), self.y[self.numRuns-1][i], linewidth=2.0, label = r'\textit{y' + format(i)+'}')
                plt.title(r'\textbf{Simulated Adiabatic Bifurcation}', fontsize=20)
                plt.xlabel(r'\textit{t}', fontsize=20)
                plt.ylabel(r'\textit{y}', fontsize=20)
            else:
                for i in range(self.N):
                    plt.plot(range(self.numIterations-1), self.y[self.numRuns-1][i], linewidth=2.0, label = "y" + format(i))
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
                plt.plot(range(self.numIterations-1), self.valueAtIteration[self.numRuns-1], linewidth=2.0, color='r')
                plt.title(r'\textbf{Simulated Adiabatic Bifurcation}', fontsize=20)
                plt.xlabel(r'\textit{t}', fontsize=20)
                plt.ylabel(r'\textit{Value}', fontsize=20)
            else:
                plt.plot(range(self.numIterations-1), self.valueAtIteration[self.numRuns-1], linewidth=2.0, color='r')
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
                plt.plot(range(self.numIterations-1), self.averageEffectiveValue, linewidth=2.0, color='r')
                plt.axhline(y = OptimalValue, color = 'b', linestyle = '-')
                plt.title(r'\textbf{Simulated Adiabatic Bifurcation}', fontsize=20)
                plt.xlabel(r'\textit{t}', fontsize=20)
                plt.ylabel(r'\textit{Value}', fontsize=20)
            else:
                plt.plot(range(self.numIterations-1), self.averageEffectiveValue, linewidth=2.0, color='r')
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






