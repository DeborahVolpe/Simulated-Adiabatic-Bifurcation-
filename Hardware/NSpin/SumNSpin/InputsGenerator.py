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
numberSpin = 3

# Number of steps
numberSteps = 50

NFrac = 9 
NBit = NFrac + 5

power = 2**NFrac

# Adiacent Matrix
JMatrixf = np.matrix([[0, 1.5, 2], [1.5, 0, 2.5], [2, 2.5, 0]])
JMatrix = np.matrix([[0, int(1.5*power), int(2*power)], [int(1.5*power), 0, int(2.5*power)], [int(2*power), int(2.5*power), 0]], dtype=np.int32)
print(JMatrix)	


# H vector
HVector = np.matrix([0, 0, 0],dtype=np.int32)
HVectorf = np.matrix([0, 0, 0])

# constant definition
Kf = 1  # Common value, but can be tuned
print(Kf)
K = int(Kf*2**NFrac)
print(K)
ptf = 0
deltaTf = 0.5  #The algorithm is stable when deltaT < 0.5
#deltaTf = 0.5#The algorithm is stable when deltaT < 0.5
print(deltaTf)
deltaT = int(deltaTf*2**NFrac)
print(deltaT)
temp = 0
for i in range(3):
    for j in range(3):
        temp += JMatrixf.item(i,j)**2
J_dev = math.sqrt(temp/(3*(2)))
Deltaf = 1
#Deltaf = 10*0.07 / (math.sqrt(numberSpin) * JMatrixf.std())
print(Deltaf)
Delta = int(Deltaf*2**NFrac)
print(Delta)
xif = 0.5/(math.sqrt(3) * J_dev)
#xif = 0.07 / (math.sqrt(numberSpin) * JMatrixf.std())
print(xif)
xi = int(xif*2**NFrac)
print(xi)
pt = 0
h = 0
A0 = 0

shiftVect = np.int32(NFrac) * np.ones((1,numberSpin), dtype=np.int32)

JMatrixf_xi = np.matrix([[0, 1.5*xif, 2*xif], [1.5*xif, 0, 2.5*xif], [2*xif, 2.5*xif, 0]])
JMatrix_xi = np.matrix([[0, int(1.5*xif*2**NFrac), int(2*xif*2**NFrac)], [int(1.5*xif*2**NFrac), 0, int(2.5*xif*2**NFrac)], [int(2*xif*2**NFrac), int(2.5*xif*2**NFrac), 0]], dtype=np.int32)


J21 = int(JMatrix_xi.item(1,0))
if J21 < 0:
	J21 = 2 ** NBit + J21
		
J31 = int(JMatrix_xi.item(2,0))
if J31 < 0:
	J31 = 2 ** NBit + J31
	
J12 = int(JMatrix_xi.item(0,1))
if J12 < 0:
	J12 = 2 ** NBit + J12
	
J32 = int(JMatrix_xi.item(2,1))
if J32 < 0:
	J32 = 2 ** NBit + J32
	
J13 = int(JMatrix_xi.item(0,2))
if J13 < 0:
	J13 = 2 ** NBit + J13
	
J23 = int(JMatrix_xi.item(1,2))
if J23 < 0:
	J23 = 2 ** NBit + J23
    
ParameterFile.write(format(J21, 'b').zfill(NBit) + "\n" + format(J31, 'b').zfill(NBit) + "\n" + format(J12, 'b').zfill(NBit)+ "\n" + format(J32, 'b').zfill(NBit) +  "\n" + format(J13, 'b').zfill(NBit) + "\n" + format(J23, 'b').zfill(NBit) + "\n")
print(format(J21) + " " + format(J31) + " " + format(J12) + " " + format(J32) + " " + format(J13) + " " + format(J23) + "\n")

# inizialization of x and y
xVector = np.matrix([[0,0, 0]],dtype=np.int32)
pt = 0
yVector = np.matrix([[np.int32(random.choice([-0.1, 0.1])*2**NFrac),np.int32(random.choice([-0.1, 0.1])*2**NFrac), np.int32(random.choice([-0.1, 0.1])*2**NFrac)]],dtype=np.int32)

xVectorf = np.matrix([0,0, 0])
ptf = 0
yVectorf = np.matrix([random.choice([-0.1, 0.1]),random.choice([-0.1, 0.1]), random.choice([-0.1, 0.1])])


for i in range(numberSteps):

	X0 = int(xVector.item(0))
	if X0 < 0:
		X0 = 2 ** NBit + X0

	X1 = int(xVector.item(1))
	if X1 < 0:
		X1 = 2 ** NBit + X1
		
	X2 = int(xVector.item(2))
	if X2 < 0:
		X2 = 2 ** NBit + X2

	XFile.write(format(X0, 'b').zfill(NBit) + " " + format(X1, 'b').zfill(NBit) + " " + format(X2, 'b').zfill(NBit) + "\n")
	SumVect = ((xVector*JMatrix_xi) >> shiftVect)
	print(SumVect)
	print(xVector)
	
	VerificationFile.write("Iteration " +format(i) + ": " +format(xVector) + " " + format(JMatrix) + " " + format(xVector*JMatrix_xi)  + " "+format((xVector*JMatrix_xi) >> shiftVect)   + "\n")
	sum0 = int(SumVect.item(0))
	if sum0 < 0:
		sum0 = 2**NBit + sum0
		
	sum1 = int(SumVect.item(1))
	if sum1 < 0:
		sum1 = 2**NBit + sum1
		
	sum2 = int(SumVect.item(2))
	if sum2 < 0:
		sum2 = 2**NBit + sum2
		
	SumFile.write(format(sum0, 'b').zfill(NBit) + " " + format(sum1, 'b').zfill(NBit) + " " + format(sum2, 'b').zfill(NBit) + "\n")
	
	#Iteration1
	s1Ma = (Delta*yVector) >> shiftVect
	s1Aa = (Delta - pt)
	s1Mb = (HVector*A0) >> shiftVect 
	
	# Iteration2
	s2Ma = ((s1Ma)*deltaT) >> shiftVect
	
	# Iteration 3
	s3Aa = np.add(xVector, s2Ma)
	
	# Iteration 4
	s4Ma = (K * s3Aa) >> shiftVect
	s4Mb = np.multiply(s1Aa,s3Aa) >> shiftVect
	s4Aa = SumVect + s1Mb 
	
	# Iteration 5
	s5Aa = s4Mb + s4Aa
	s5Ma = np.multiply(s4Ma, s3Aa) >> shiftVect
	
	# Iteration 6
	s6Ma = np.multiply(s5Ma, s3Aa) >> shiftVect
    
    #Iteration 7
	s7Aa = s5Aa + s6Ma
	
	# Iteration 7
	s8Ma = (s7Aa * deltaT) >> shiftVect
	
	# Iteration 8
	s9Aa = yVector-s8Ma
	
	xVector = s3Aa
	yVector = s9Aa
	

	
	
	pt += int((1/20)* 2 **NFrac)
	
	if ptf > (Deltaf +4*Kf):
		A0f = math.sqrt((ptf -Deltaf -4*Kf)/Kf)+0.1
	else:
		A0f = 0.1

	if pt > (Delta + (int(4*2**NFrac)*K) >> NFrac):
		A0 = int((math.sqrt((pt -(Delta+(int(4*2**NFrac)*K) >> NFrac))/K))*2**NFrac) + int(0.1*2**NFrac)
	else:
		A0 = int(0.1*2**NFrac)
		
	solution = np.sign(xVector)
	value = (np.matmul((np.matmul(solution, JMatrix)), np.transpose(solution)))

	xVectorf = np.add(xVectorf, Deltaf*yVectorf*deltaTf)
	tempVectorf = np.add(np.add(Kf*np.power(xVectorf, 3), (Deltaf-ptf)*xVectorf), xif*xVectorf*JMatrixf)
	yVectorf = np.subtract(yVectorf,tempVectorf*deltaTf)
	ptf = ptf +  1/20 #100/numberSteps
	solutionf = np.sign(xVectorf)
	valuef = np.matmul(np.matmul(solutionf, JMatrixf), np.transpose(solutionf))
	
SumFile.close()
XFile.close()
