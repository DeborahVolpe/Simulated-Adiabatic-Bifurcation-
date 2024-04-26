import numpy as np
import random
import sys
import math

#In this file the input parameter to considered are reported
nome_file = "InputParameter.txt"

#opening input file
try:
	ParameterFile = open(nome_file, 'w')
except:
	print("Error: it is not possible to open or create the file" + nome_file + "\n")
	sys.exit()
	
nome_file_state = "InputState.txt"

#opening input file
try:
	StateFile = open(nome_file_state, 'w')
except:
	print("Error: it is not possible to open or create the file" + StateFile + "\n")
	sys.exit()
	
nome_file_expected_output = "ExpectedOutput.txt"

#opening input file
try:
	ExpectedOutputFile = open(nome_file_expected_output, 'w')
except:
	print("Error: it is not possible to open or create the file" + nome_file_expected_output + "\n")
	sys.exit()
	
# Number of spin
numberSpin = 2

# Number of steps
numberSteps = 200

NFrac = 15
NBit = NFrac + 5

# Adiacent Matrix
JMatrix = np.matrix([[0, int(-1*2**NFrac)], [int(-1*2**NFrac), 0]],dtype=np.int32)
JMatrixf = np.matrix([[0, -1], [-1, 0]])

# H vector
HVector = np.matrix([0, 0],dtype=np.int32)
HVectorf = np.matrix([0, 0])

# constant definition
Kf = 1# Common value, but can be tuned
Deltaf = 0.5 #0.23# Common value, but can be tuned
K = int(Kf*2**NFrac)# Common value, but can be tuned
Delta = int(Deltaf*2**NFrac)
deltaT = int(2**NFrac)#The algorithm is stable when deltaT < 0.5
deltaTf = 0.6#The algorithm is stable when deltaT < 0.5
xif = 0.1
xi = int(xif*2**NFrac)
JMatrix_xi = np.matrix([[0, int(-1*xif*2**NFrac)], [int(-1*xif*2**NFrac), 0]],dtype=np.int32)
JMatrix_xif = np.matrix([[0, -1*xif], [-1*xif, 0]])
pt = 0
h = 0
A0_start =int(0.1*2**NFrac)
ShapePt = np.int32(0.01*2**NFrac)
Delta4K	= Delta + np.int32(4*2**NFrac)
K_1 = int(2**NFrac/Kf)
offset = int(0.1*2**NFrac)

strParam = format(A0_start, 'b').zfill(NBit) + " " +  format(ShapePt, 'b').zfill(NBit) + " " + format(Delta4K, 'b').zfill(NBit) + " " + format(K_1, 'b').zfill(NBit) + " " + format(offset, 'b').zfill(NBit)

shiftVect = np.int32(NFrac) * np.ones((1,numberSpin), dtype=np.int32)

ParameterFile.write(strParam + "\n")
ParameterFile.close()


for i in range(numberSteps):
    pt += ShapePt
    s1Aa = pt
    StateFile.write("At iteration " + format(i) + " in the first state Aa: " + str(s1Aa) + "\n")
    s2Aa = s1Aa - Delta4K
    StateFile.write("At iteration " + format(i) + " in the second state Aa: " + str(s2Aa) + "\n")
    if s2Aa > 0:
        s3Ma = (s2Aa*K_1) >> NFrac
        StateFile.write("At iteration " + format(i) + " in the third state Ma: " + str(s3Ma) + "\n")
        s4Sq = int(math.sqrt(s3Ma << 1)) << 7
        StateFile.write("At iteration " + format(i) + " in the fourth state : " + str(s4Sq) + "\n")
        s5Aa = s4Sq + offset
        StateFile.write("At iteration " + format(i) + " in the fifth state : " + str(s5Aa) + "\n")
    else:
        s5Aa = A0_start
	
    A0 = s5Aa

    ExpectedOutputFile.write(format(pt, 'b').zfill(NBit) + " " + format(A0, 'b').zfill(NBit) + "\n")
	
StateFile.close()
ExpectedOutputFile.close()

