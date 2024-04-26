import numpy as np
import random
import math

#In this file the input parameter to considered are reported
nome_file = "InputParameter.txt"

#opening input file
try:
	ParameterFile = open(nome_file, 'w')
except:
	print("Error: it is not possible to open or create the file" + nome_file + "\n")
	sys.exit()
	
	
#In this file the sum for each iteration is reported
nome_file_sum = "InputSum.txt"

#opening input file
try:
	SumFile = open(nome_file_sum, 'w')
except:
	print("Error: it is not possible to open or create the file" + nome_file_sum + "\n")
	sys.exit()
	
#In this file the sum for each iteration is reported
nome_file_PA0 = "InputPA0.txt"

#opening input file
try:
	PA0File = open(nome_file_PA0, 'w')
except:
	print("Error: it is not possible to open or create the file" + nome_file_PA0 + "\n")
	sys.exit()
	
	
#In this file the XVector[0] and YVector[0] expected are reported
nome_file_X_Y = "InputX_Y.txt"

#opening input file
try:
	XYFile = open(nome_file_X_Y, 'w')
except:
	print("Error: it is not possible to open or create the file" + nome_file_X_Y + "\n")
	sys.exit()
	
nome_file_state = "InputState.txt"

#opening input file
try:
	StateFile = open(nome_file_state, 'w')
except:
	print("Error: it is not possible to open or create the file" + nome_file_X_Y + "\n")
	sys.exit()
	

# Number of spin
numberSpin = 2

# Number of steps
numberSteps = 2**8

NFrac = 9
NBit = NFrac + 7

# Adiacent Matrix
JMatrix = np.matrix([[0, int(1*2**NFrac)], [int(1*2**NFrac), 0]],dtype=np.int32)
JMatrixf = np.matrix([[0, 1], [1, 0]])

# H vector
HVector = np.matrix([0, 0],dtype=np.int32)
HVectorf = np.matrix([0, 0])

# constant definition
Kf = 1# Common value, but can be tuned
Deltaf = 0.5#0.23# Common value, but can be tuned
K = 1# Common value, but can be tuned
print(K)
Delta = int(Deltaf*2**NFrac)
deltaT = int(0.6*2**NFrac)#The algorithm is stable when deltaT < 0.5
deltaTf = 0.6#The algorithm is stable when deltaT < 0.5
xif = 0.1
xi = int(xif*2**NFrac)

JMatrix_xi = np.matrix([[0, int(1*xif*2**NFrac)], [int(1*xif*2**NFrac), 0]],dtype=np.int32)
JMatrix_xif = np.matrix([[0, 1*xif], [1*xif, 0]])
pt = 0
h = 0
strParam = format(K, 'b').zfill(NBit) + " " + format(Delta, 'b').zfill(NBit) + " " + format(deltaT, 'b').zfill(NBit)  + " " + format(h, 'b').zfill(NBit)

shiftVect = np.int32(NFrac) * np.ones((1,numberSpin), dtype=np.int32)


# inizialization of x and y
xVector = np.matrix([[0,0]],dtype=np.int32)
pt = 0
yVector = np.matrix([[0,np.int32(random.choice([-0.1])*2**NFrac)]],dtype=np.int32)

xVectorf = np.matrix([0,0])
ptf = 0
yVectorf = np.matrix([0,random.choice([-0.1])])

x = int(xVector.item(1))
if x < 0:
	x = 2**NBit +x

y = int(yVector.item(1))
if y < 0:
	y = 2**NBit + y

	
strParam += " " + format(x, 'b').zfill(NBit) + " " + format(y, 'b').zfill(NBit)

ParameterFile.write(strParam + "\n")
ParameterFile.close()


for i in range(numberSteps):
	SumVect = ((xVector*JMatrix_xi) >> shiftVect)
	sumV = int(SumVect.item(1))
	if sumV < 0:
		sumV = 2**NBit + sumV
	SumFile.write(format(sumV, 'b').zfill(NBit) + "\n")
	PA0File.write(format(pt, 'b').zfill(NBit) + " " + format(0, 'b').zfill(NBit) + "\n")
	s1Ma = (Delta*yVector) >> shiftVect
	s1Aa = (Delta - pt)
	s1Mb = 0 
	StateFile.write("In iteration " + format(i) + " in the state1 Ma: " + str(s1Ma) + " Aa: " + str(s1Aa) + " Mb: " + str(s1Mb) + "\n")
	s2Ma = ((s1Ma)*deltaT) >> shiftVect
	s2Mb = 0 
	StateFile.write("In iteration " + format(i) + " in the state2 Ma: " + str(s2Ma) + " Mb: " + str(s2Mb) + "\n")
	s3Aa = np.add(xVector, s2Ma)
	StateFile.write("In iteration " + format(i) + " in the state3 Aa: " + str(s3Aa) + "\n")
	s4Ma = K*s3Aa >> shiftVect
	s4Mb = np.multiply(s1Aa,s3Aa) >> shiftVect
	s4Aa = SumVect + s2Mb
	StateFile.write("In iteration " + format(i) + " in the state4 Ma: " + str(s4Ma) + " Aa: " +  str(s4Aa) + " Mb: " + str(s4Mb) + "\n")
	s5Ma = np.multiply(s4Ma, s3Aa) >> shiftVect
	s5Aa = s4Mb + s4Aa
	StateFile.write("In iteration " + format(i) + " in the state5 Ma: " + str(s5Ma) + " Aa: " + str(s5Aa) + "\n")
	s6Ma = np.multiply(s3Aa,s5Ma) >> shiftVect
	StateFile.write("In iteration " + format(i) + " in the state6 Aa: " + str(s6Ma) + "\n")
	s7Aa = s5Aa + s6Ma
	StateFile.write("In iteration " + format(i) + " in the state7 Aa: " + str(s7Aa) + "\n")
	s8Ma = (s7Aa * deltaT) >> shiftVect
	StateFile.write("In iteration " + format(i) + " in the state8 Ma: " + str(s8Ma) + "\n")
	s9Aa = yVector-s8Ma
	StateFile.write("In iteration " + format(i) + " in the state9 Aa: " + str(s9Aa) + "\n")
	
	xVector = s3Aa
	yVector = s9Aa
	pt += np.int32(0.01*(2**NFrac))
	solution = np.sign(xVector)
	value = (np.matmul((np.matmul(solution, JMatrix)), np.transpose(solution)))
    

	xVectorf = np.add(xVectorf, Deltaf*yVectorf*deltaTf)
	tempVectorf = np.add(np.add(Kf*np.power(xVectorf, 3), (Deltaf-ptf)*xVectorf), xif*xVectorf*JMatrixf)
	yVectorf = np.subtract(yVectorf,tempVectorf*deltaTf)
	ptf = ptf + 0.01#100/numberSteps
	solutionf = np.sign(xVectorf)
	valuef = np.matmul(np.matmul(solutionf, JMatrixf), np.transpose(solutionf))

	x = int(xVector.item(1))
	if x < 0:
		x = 2 ** NBit + x

	y = int(yVector.item(1))
	if y < 0:
		y = 2 ** NBit + y

	XYFile.write(format(x, 'b').zfill(NBit) + " " + format(y, 'b').zfill(NBit) + "\n")
	
SumFile.close()
PA0File.close()
XYFile.close()
