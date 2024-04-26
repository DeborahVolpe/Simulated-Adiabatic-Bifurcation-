import numpy as np
import random
import math
import sys
import matplotlib.pyplot as plt

#In this file the input parameter to considered are reported
nome_file = "InputParameter.txt"

#opening input file
try:
	ParameterFile = open(nome_file, 'w')
except:
	print("Error: it is not possible to open or create the file" + nome_file + "\n")
	sys.exit()

#In this file the XVector[0] and YVector[0] expected are reported
nome_file_X_Y = "InputX_Y.txt"

#opening input file
try:
	XYFile = open(nome_file_X_Y, 'w')
except:
	print("Error: it is not possible to open or create the file" + nome_file_X_Y + "\n")
	sys.exit()
	
nome_file_intermidiate = "IntermediateResults.txt"

#opening input file
try:
	IntermidiateFile = open(nome_file_intermidiate, 'w')
except:
	print("Error: it is not possible to open or create the file" + nome_file_intermidiate + "\n")
	sys.exit()


x0Val = []
x1Val = []
x0Val2 = []
x1Val2 = []
asint1 = []
asint2 = []
asint3 = []
asint4 = []
Values = []
y0Val = []
y1Val = []
y0Val2 = []
y1Val2 = []
p = []
time = []
	

# Number of spin
numberSpin = 2

# Number of steps
numberSteps = 2**7-1

NFrac = 9
NBit = NFrac + 20

# Adiacent Matrix
JMatrix = np.matrix([[0, int(-1*2**NFrac)], [int(-1*2**NFrac), 0]],dtype=np.int32)
JMatrixf = np.matrix([[0, -1], [-1, 0]])

# H vector
HVector = np.matrix([0, 0],dtype=np.int32)
HVectorf = np.matrix([0, 0])

# constant definition
Kf = 2# Common value, but can be tuned
Deltaf = 10*0.07 / (math.sqrt(numberSpin) * JMatrixf.std()) #0.23# Common value, but can be tuned
K = int(Kf*2**NFrac)# Common value, but can be tuned
Delta = int(Deltaf*2**NFrac)
deltaT = int(0.5*2**NFrac)#The algorithm is stable when deltaT < 0.5
deltaTf = 0.5#The algorithm is stable when deltaT < 0.5
xif = Deltaf* 0.07 / (math.sqrt(numberSpin) * JMatrixf.std())
xi = int(xif*2**NFrac)
pt = 0
h = 0
ShapePt = (np.int32(0.06*2**NFrac) * deltaT) >> NFrac
Delta4K	= (((Delta*int(4*2**NFrac)) >> NFrac)*K) >> NFrac
K_1 = int(2**NFrac/Kf)
offset = int(2**NFrac)

# inizialization of x and y
xVector = np.matrix([[0,0]],dtype=np.int32)
xVector2 = np.matrix([[0,0]],dtype=np.int32)
pt = 0
pt2 = 0
yVector = np.matrix([[0,np.int32(random.choice([-0.1, 0.1])*2**NFrac)]],dtype=np.int32)
yVector2 = yVector.copy()

xVectorf = np.matrix([0,0])
ptf = 0
yVectorf = np.matrix([0,random.choice([0.1, 0.1])])

y = int(yVector.item(1))
if y < 0:
	y = 2**NBit + y

A0_start = int((2**((pt-Delta-(int(4*2**NFrac)*K) >> NFrac)/K))*2**NFrac)
ParameterFile.write(format(A0_start, 'b').zfill(NBit) + "\n")
print("A0_start= " + format(A0_start) + "\n")
ParameterFile.write(format(ShapePt, 'b').zfill(NBit) + "\n")
print("ShapePt= " + format(ShapePt) + "\n")
ParameterFile.write(format(Delta4K, 'b').zfill(NBit) + "\n")
print("Delta4K= " + format(Delta4K) + "\n")
ParameterFile.write(format(K_1, 'b').zfill(NBit) + "\n")
print("K_1= " + format(K_1) + "\n")
ParameterFile.write(format(offset, 'b').zfill(NBit) + "\n")
print("offset= " + format(offset) + "\n")
ParameterFile.write(format(K, 'b').zfill(NBit) + "\n")
print("K" + format(K) + "\n")
ParameterFile.write(format(Delta, 'b').zfill(NBit) + "\n")
print("Delta= " + format(Delta) + "\n")
ParameterFile.write(format(xi, 'b').zfill(NBit) + "\n")
print("xi= " + format(xi) + "\n")
ParameterFile.write(format(deltaT, 'b').zfill(NBit) + "\n")
print("deltaT= " + format(deltaT) + "\n")
ParameterFile.write(format(0, 'b').zfill(NBit) + "\n") #HVector0
print("HVector0= " + format(0) + "\n")
ParameterFile.write(format(0, 'b').zfill(NBit) + "\n") #HVector1
print("HVector1= " + format(0) + "\n")
ParameterFile.write(format(2**NBit-2**NFrac, 'b').zfill(NBit) + "\n") #J12
print("J12= " + format(2**NBit-2**NFrac) + "\n")
ParameterFile.write(format(2**NBit-2**NFrac, 'b').zfill(NBit) + "\n") #J21
print("J21=" + format(2**NBit-2**NFrac))
ParameterFile.write(format(y, 'b').zfill(NBit) + "\n")
print("y= " + format(y))
ParameterFile.close()

shiftVect = np.int32(NFrac) * np.ones((1,numberSpin), dtype=np.int32)

for i in range(numberSteps):

	time.append(i)

	x0Val.append(xVector.item(0) / 2 ** NFrac)
	x1Val.append(xVector.item(1) / 2 ** NFrac)

	y0Val.append(yVector.item(0) / 2 ** NFrac)
	y1Val.append(yVector.item(1) / 2 ** NFrac)

	x0Val2.append(xVector2.item(0) / 2 ** NFrac)
	x1Val2.append(xVector2.item(1) / 2 ** NFrac)

	y0Val2.append(yVector2.item(0) / 2 ** NFrac)
	y1Val2.append(yVector2.item(1) / 2 ** NFrac)

	temp = xVector2.copy()
	xVector2 = np.add(xVector2, (((Delta * yVector2) >> shiftVect) * deltaT) >> shiftVect)

	s1MaPE = ((Delta * yVector) >> shiftVect)
	s1AaPE = (Delta - pt)
	s1MbPE = 0 
	IntermidiateFile.write("PE: In iteration " + format(i) + " in the state1 Ma: " + str(s1MaPE) + " Aa: " + str(s1AaPE) + " Mb: " + str(s1MbPE) + "\n")
	s2MaPE = (s1MaPE * deltaT) >> shiftVect
	s2MbPE = 0 
	IntermidiateFile.write("PE: In iteration " + format(i) + " in the state2 Ma: " + str(s2MaPE) + " Mb: " + str(s2MbPE) + "\n")
	s3AaPE = np.add(xVector, s2MaPE)
	#s3AaPE = xVector2
	IntermidiateFile.write("PE: In iteration " + format(i) + " in the state3 Aa: " + str(s3AaPE) + "\n")
	SumVect = (s3AaPE*((xi* JMatrix) >> shiftVect)) >> shiftVect
	IntermidiateFile.write("S2S: In iteration " + format(i) + "\n")
	IntermidiateFile.write("S2S: In iteration " + format(i) + " gives: " + str(SumVect) + "\n")
	s4MaPE = np.multiply(s3AaPE, s3AaPE) >> shiftVect
	s4MbPE = (s1AaPE*s3AaPE) >> shiftVect
	s4AaPE = SumVect + s2MbPE
	IntermidiateFile.write("PE: In iteration " + format(i) + " in the state4 Ma: " + str(s4MaPE) + " Aa: " +  str(s4AaPE) + " Mb: " + str(s4MbPE) + "\n")
	s5AaPE = s4MbPE + s4AaPE
	s5MaPE = np.multiply(s4MaPE, s3AaPE) >> shiftVect
	IntermidiateFile.write("PE: In iteration " + format(i) + " in the state5 Ma: " + str(s5MaPE) + " Aa: " + str(s5AaPE) + "\n")
	s6MaPE = (K*s5MaPE) >> shiftVect
	IntermidiateFile.write("PE: In iteration " + format(i) + " in the state6 Ma: " + str(s6MaPE) + "\n")
	s7AaPE = s5AaPE + s6MaPE
	IntermidiateFile.write("PE: In iteration " + format(i) + " in the state7 Aa: " + str(s7AaPE) + "\n")
	s8MaPE = (s7AaPE * deltaT) >> shiftVect
	IntermidiateFile.write("PE: In iteration " + format(i) + " in the state8 Ma: " + str(s8MaPE) + "\n")
	s9AaPE = yVector-s8MaPE
	IntermidiateFile.write("PE: In iteration " + format(i) + " in the state9 Aa: " + str(s9AaPE) + "\n")

	tempVector2 = np.add(np.add((K * (np.multiply((np.multiply(xVector2, xVector2) >> shiftVect), xVector2) >> shiftVect)) >> shiftVect,((Delta - pt2) * xVector2) >> shiftVect), (xVector2*((xi* JMatrix) >> shiftVect)) >> shiftVect)
	yVector2 = np.subtract(yVector2, (tempVector2 * deltaT) >> shiftVect)

	solution = np.sign(xVector2)
	value = (np.matmul((np.matmul(solution, JMatrix)), np.transpose(solution)))
	
	xVector = s3AaPE
	yVector = s9AaPE

	pt2 += ShapePt
	# PA0
	pt += ShapePt
	s1AaPA0 = pt
	IntermidiateFile.write("PA0: At iteration " + format(i) + " in the first state Aa: " + str(s1AaPA0) + "\n")
	s2AaPA0 = s1AaPA0 - Delta4K
	IntermidiateFile.write("PA0: At iteration " + format(i) + " in the second state Aa: " + str(s2AaPA0) + "\n")
	s3MaPA0 = (s2AaPA0*K_1) >> NFrac
	IntermidiateFile.write("PA0: At iteration " + format(i) + " in the third state Ma: " + str(s3MaPA0) + "\n")
	if s3MaPA0 > 0:
		s4SqPA0 = int(math.sqrt(s3MaPA0 << 1)) << 4
		IntermidiateFile.write("PA0: At iteration " + format(i) + " in the fourth state : " + str(s4SqPA0) + "\n")
		s5AaPA0 = s4SqPA0 + offset
		IntermidiateFile.write("PA0: At iteration " + format(i) + " in the fifth state : " + str(s5AaPA0) + "\n")
	else:
		s5AaPA0 = 0
	
	A0 = s5AaPA0

	if pt < (Delta - xi):
		asint1.append(0)
		asint2.append(0)
	else:
		asint1.append(math.sqrt((float(pt - Delta + xi) / 2 ** NFrac) / (float(K) / 2 ** NFrac)))
		asint2.append(-math.sqrt((float(pt - Delta + xi) / 2 ** NFrac) / (float(K) / 2 ** NFrac)))

	if pt < (Delta + xi):
		asint3.append(0)
		asint4.append(0)
	else:
		asint3.append(math.sqrt((float(pt - Delta - xi) / 2 ** NFrac) / (float(K) / 2 ** NFrac)))
		asint4.append(-math.sqrt((float(pt - Delta - xi) / 2 ** NFrac) / (float(K) / 2 ** NFrac)))
	
	
	solution = np.sign(xVector)
	value = (np.matmul((np.matmul(solution, JMatrix)), np.transpose(solution)))

	Values.append(value.item(0) / 2 ** NFrac)

	#xVectorf = np.add(xVectorf, Deltaf*yVectorf*deltaTf)
	#tempVectorf = np.add(np.add(Kf*np.power(xVectorf, 3), (Deltaf-ptf)*xVectorf), xif*xVectorf*JMatrixf)
	#yVectorf = np.subtract(yVectorf,tempVectorf*deltaTf)
	#ptf = ptf + 0.005*deltaTf #100/numberSteps
	#solutionf = np.sign(xVectorf)
#	valuef = np.matmul(np.matmul(solutionf, JMatrixf), np.transpose(solutionf))

	x0 = int(xVector.item(0))
	if x0 < 0:
		x0 = 2 ** NBit + x0

	y0 = int(yVector.item(0))
	if y0 < 0:
		y0 = 2 ** NBit + y0

	x1 = int(xVector.item(1))
	if x1 < 0:
		x1 = 2 ** NBit + x1

	y1 = int(yVector.item(1))
	if y1 < 0:
		y1 = 2 ** NBit + y1

	p.append(pt)
	XYFile.write(format(x0, 'b').zfill(NBit) + " " + format(x1, 'b').zfill(NBit) + " " + format(y0, 'b').zfill(NBit) + " " + format(y1, 'b').zfill(NBit) +"\n")
	
IntermidiateFile.close()

plt.plot(time, x0Val, linewidth=2.0, color='b', label='x0')
plt.plot(time, y0Val, linewidth=2.0, color='r', label='y0')
plt.plot(time, x1Val, linewidth=2.0, color='c', label='x1')
plt.plot(time, y1Val, linewidth=2.0, color='m', label='y1')
plt.plot(time, x0Val2, linewidth=2.0, color='b', linestyle='dashed', label='x02')
plt.plot(time, y0Val2, linewidth=2.0, color='r', linestyle='dashed', label='y02')
plt.plot(time, x1Val2, linewidth=2.0, color='c', linestyle='dashed', label='x12')
plt.plot(time, y1Val2, linewidth=2.0, color='m', linestyle='dashed', label='y12')
plt.plot(time, asint1, linewidth=2.0, color='k', linestyle='dashed')
plt.plot(time, asint2, linewidth=2.0, color='k', linestyle='dashed')
plt.plot(time, asint3, linewidth=2.0, color='k', linestyle='dashed')
plt.plot(time, asint4, linewidth=2.0, color='k', linestyle='dashed')
plt.title("Adiabatic Bifurcation",fontsize=18)
plt.xlabel("Number of iterations", fontsize=18)
plt.ylabel("x0(t), y0(t), x1(t), y1(t)", fontsize=18)
leg = plt.legend(bbox_to_anchor=(1.05, 1.0), loc='upper left')
plt.tight_layout()
plt.grid(True)
plt.show()

plt.plot(time, Values, linewidth=2.0, color='b')
plt.title("Adiabatic Bifurcation performance for maxCut problems",fontsize=18)
plt.xlabel("Number of iterations",fontsize=18)
plt.ylabel("Value", fontsize=18)
plt.grid(True)
plt.show()

plt.plot(time, p, linewidth=2.0, color='b')
plt.title("Adiabatic Bifurcation performance for maxCut problems",fontsize=18)
plt.xlabel("Number of iterations",fontsize=18)
plt.ylabel("p", fontsize=18)
plt.grid(True)
plt.show()