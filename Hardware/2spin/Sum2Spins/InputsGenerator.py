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
	
	
#In this file the sum expected output
nome_file_sum = "InputSum.txt"

#opening input file
try:
	SumFile = open(nome_file_sum, 'w')
except:
	print("Error: it is not possible to open or create the file" + nome_file_sum + "\n")
	sys.exit()
	
	
#In this file the X inputs are reported
nome_file_X = "InputX.txt"

#opening input file
try:
	XFile = open(nome_file_X, 'w')
except:
	print("Error: it is not possible to open or create the file" + nome_file_X + "\n")
	sys.exit()

#Data file for verification
nome_file_Verification = "DataInter.txt"

#opening input file
try:
	VerificationFile = open(nome_file_Verification, 'w')
except:
	print("Error: it is not possible to open or create the file" + nome_file_Verification + "\n")
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
print(K)
Delta = int(Deltaf*2**NFrac)
deltaT = int(0.6*2**NFrac)#The algorithm is stable when deltaT < 0.5
deltaTf = 0.6#The algorithm is stable when deltaT < 0.5
xif = 0.1
xi = int(xif*2**NFrac)

JMatrix_xi = np.matrix([[0, int(-1*xif*2**NFrac)], [int(-1*xif*2**NFrac), 0]],dtype=np.int32)
JMatrix_xif = np.matrix([[0, -1*xif], [-1*xif, 0]])

J12 = int(JMatrix_xi.item(0,1))
if J12 < 0:
	J12 = 2 ** NBit + J12
J21 = int(JMatrix_xi.item(1,0))
if J21 < 0:
	J21 = 2 ** NBit + J21
pt = 0
h = 0

shiftVect = np.int32(NFrac) * np.ones((1,numberSpin), dtype=np.int32)


ParameterFile.write(format(J12, 'b').zfill(NBit) + " " + format(J21, 'b').zfill(NBit)  +  "\n")

print(xi)
# inizialization of x and y
xVector = np.matrix([[0,0]],dtype=np.int32)
pt = 0
yVector = np.matrix([[0,np.int32(random.choice([-0.1, 0.1])*2**NFrac)]],dtype=np.int32)

xVectorf = np.matrix([0,0])
ptf = 0
yVectorf = np.matrix([0,random.choice([-0.1, 0.1])])

x = int(xVector.item(0))
if x < 0:
	x = 2**NBit +x

y = int(yVector.item(0))
if y < 0:
	y = 2**NBit + y


for i in range(numberSteps):

	X0 = int(xVector.item(0))
	if X0 < 0:
		X0 = 2 ** NBit + X0

	X1 = int(xVector.item(1))
	if X1 < 0:
		X1 = 2 ** NBit + X1

	XFile.write(format(X0, 'b').zfill(NBit) + " " + format(X1, 'b').zfill(NBit) + "\n")
	SumVect = ((xVector*JMatrix_xi) >> shiftVect)
	print(SumVect)
	print(xVector)
	
	VerificationFile.write(format(xVector) + " " + format(JMatrix) + " " + format(xVector*JMatrix_xi)  + " "+format((xVector*JMatrix_xi) >> shiftVect)  +  "\n")
	sum0 = int(SumVect.item(0))
	if sum0 < 0:
		sum0 = 2**NBit + sum0
		
	sum1 = int(SumVect.item(1))
	if sum1 < 0:
		sum1 = 2**NBit + sum1
	SumFile.write(format(sum0, 'b').zfill(NBit) + " " + format(sum1, 'b').zfill(NBit) + "\n")
	
	#Iteration1
	s1Ma = Delta*yVector >> shiftVect
	s1Aa = (Delta - pt)
	s1Mb = 0 
	
	# Iteration2
	s2Ma = ((s1Ma)*deltaT) >> shiftVect
	s2Mb = 0 
	
	# Iteration 3
	s3Aa = np.add(xVector, s2Ma)
	
	# Iteration 4
	s4Ma = (K*s3Aa) >> shiftVect
	s4Mc = np.multiply(s3Aa, s3Aa) >> shiftVect
	s4Mb = (s1Aa*s3Aa) >> shiftVect
	s4Aa = SumVect + s2Mb 
	
	# Iteration 5
	s5Aa = s4Mb + s4Aa
	s5Ma = np.multiply(s4Ma,s4Mc) >> shiftVect
	
	# Iteration 6
	s6Aa = s5Aa + s5Ma
	
	# Iteration 7
	s7Ma = (s6Aa * deltaT) >> shiftVect
	
	# Iteration 8
	s8Aa = yVector-s7Ma
	
	xVector = s3Aa
	yVector = s8Aa
	

	
	
	pt += (np.int32(0.01*2**NFrac) * deltaT) >> NFrac
	solution = np.sign(xVector)
	value = (np.matmul((np.matmul(solution, JMatrix)), np.transpose(solution)))

	xVectorf = np.add(xVectorf, Deltaf*yVectorf*deltaTf)
	tempVectorf = np.add(np.add(Kf*np.power(xVectorf, 3), (Deltaf-ptf)*xVectorf), xif*xVectorf*JMatrixf)
	yVectorf = np.subtract(yVectorf,tempVectorf*deltaTf)
	ptf = ptf + 0.01*deltaTf #100/numberSteps
	solutionf = np.sign(xVectorf)
	valuef = np.matmul(np.matmul(solutionf, JMatrixf), np.transpose(solutionf))
	
SumFile.close()
XFile.close()
