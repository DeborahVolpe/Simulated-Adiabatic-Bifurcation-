import numpy as np
import random
import math
import sys
import matplotlib.pyplot as plt
from matplotlib import rc

rc('text', usetex=True)
plt.rc('text', usetex=True)

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
    
#In this file the XVector[0] and YVector[0] expected are reported
nome_file_X_Y_software = "InputX_Y_software.txt"

#opening input file
try:
	XYFile_software = open(nome_file_X_Y_software, 'w')
except:
	print("Error: it is not possible to open or create the file" + nome_file_X_Y_software + "\n")
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
numberSteps = 2**8

NFrac = 9
NBit = NFrac + 5

# Adiacent Matrix
JMatrix = np.matrix([[0, int(1*2**NFrac)], [int(1*2**NFrac), 0]],dtype=np.int32)
JMatrixf = np.matrix([[0, 1], [1, 0]])

# H vector
HVector = np.matrix([0, 0],dtype=np.int32)
HVectorf = np.matrix([0, 0])

# constant definition
Kf = 1# Common value, but can be tuned
Deltaf = 0.5 #0.23# Common value, but can be tuned
K = int(Kf*2**NFrac)# Common value, but can be tuned
Delta = int(Deltaf*2**NFrac)
deltaT = int(0.6*2**NFrac)#The algorithm is stable when deltaT < 0.5
deltaTf = 0.6#The algorithm is stable when deltaT < 0.5
xif = 0.1
xi = int(xif*2**NFrac)
JMatrix_xi = np.matrix([[0, int(1*xif*2**NFrac)], [int(1*xif*2**NFrac), 0]],dtype=np.int32)
JMatrix_xif = np.matrix([[0, 1*xif], [1*xif, 0]])

pt = 0
h = 0
ShapePt = np.int32(0.01*2**NFrac)
Delta4K	= Delta + ((4*K) >> NFrac)
K_1 = int(2**NFrac/Kf)
offset = int(0.1*2**NFrac)

# inizialization of x and y
xVector = np.matrix([[0,0]],dtype=np.int32)
xVector2 = np.matrix([[0,0]],dtype=np.int32)
pt = 0
pt2 = 0
yVector = np.matrix([[0,np.int32(random.choice([-0.1, 0.1])*2**NFrac)]],dtype=np.int32)
yVector2 = yVector.copy()

xVectorf = np.matrix([0,0])
ptf = 0
yVectorf = np.matrix([0,random.choice([-0.1, 0.1])])

y1 = int(yVector.item(1))
if y1 < 0:
	y1 = 2**NBit + y1
    
y0 = int(yVector.item(0))
if y0 < 0:
	y0 = 2**NBit + y0

A0_start = int(0.1*2**NFrac)
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
ParameterFile.write(format(deltaT, 'b').zfill(NBit) + "\n")
print("deltaT= " + format(deltaT) + "\n")
ParameterFile.write(format(0, 'b').zfill(NBit) + "\n") #HVector0
print("HVector0= " + format(0) + "\n")
ParameterFile.write(format(0, 'b').zfill(NBit) + "\n") #HVector1
print("HVector1= " + format(0) + "\n")
ParameterFile.write(format(int(xif*2**NFrac), 'b').zfill(NBit) + "\n") #J12
print("J12= " + format(int(xif*2**NFrac)) + "\n")
ParameterFile.write(format(int(xif*2**NFrac), 'b').zfill(NBit) + "\n") #J21
print("J21=" + format(int(xif*2**NFrac)))
ParameterFile.write(format(y0, 'b').zfill(NBit) + "\n")
print("y= " + format(y0))
ParameterFile.write(format(y1, 'b').zfill(NBit) + "\n")
print("y= " + format(y1))
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
    SumVect = (s3AaPE*JMatrix_xi) >> shiftVect
    IntermidiateFile.write("S2S: In iteration " + format(i) + "\n")
    IntermidiateFile.write("S2S: In iteration " + format(i) + " gives: " + str(SumVect) + "\n")
    s4MaPE = (K*s3AaPE) >> shiftVect
    s4MbPE = (s1AaPE*s3AaPE) >> shiftVect
    IntermidiateFile.write("PE: In iteration " + format(i) + " in the state4 Ma: " + str(s4MaPE) + " Mb: " + str(s4MbPE) + "\n")
    s5AaPE = s4MbPE + s2MbPE
    s5MaPE = np.multiply(s4MaPE, s3AaPE) >> shiftVect
    IntermidiateFile.write("PE: In iteration " + format(i) + " in the state5 Ma: " + str(s5MaPE) + " Aa: " + str(s5AaPE) + "\n")
    s6MaPE =  np.multiply(s3AaPE,s5MaPE) >> shiftVect
    IntermidiateFile.write("PE: In iteration " + format(i) + " in the state6 Ma: " + str(s6MaPE) + "\n")
    s7AaPE = s5AaPE + s6MaPE
    IntermidiateFile.write("PE: In iteration " + format(i) + " in the state7 Aa: " + str(s7AaPE) + "\n")
    s8AaPE = s7AaPE + SumVect
    IntermidiateFile.write("PE: In iteration " + format(i) + " in the state8 Aa: " + str(s8AaPE) + "\n")
    s9MaPE = (s8AaPE * deltaT) >> shiftVect
    IntermidiateFile.write("PE: In iteration " + format(i) + " in the state9 Ma: " + str(s9MaPE) + "\n")
    s10AaPE = yVector-s9MaPE
    IntermidiateFile.write("PE: In iteration " + format(i) + " in the state10 Aa: " + str(s10AaPE) + "\n")

    tempVector2 = np.add(np.add((K * (np.multiply((np.multiply(xVector2, xVector2) >> shiftVect), xVector2) >> shiftVect)) >> shiftVect,((Delta - pt2) * xVector2) >> shiftVect), (xVector2*((xi* JMatrix) >> shiftVect)) >> shiftVect)
    yVector2 = np.subtract(yVector2, (tempVector2 * deltaT) >> shiftVect)

    solution = np.sign(xVector2)
    value = (np.matmul((np.matmul(solution, JMatrix)), np.transpose(solution)))
	
    xVector = s3AaPE
    yVector = s10AaPE

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
    XYFile_software.write(format(xVector2.item(0)) + " " + format(xVector2.item(1)) + format(yVector2.item(0)) + " " + format(yVector2.item(1)) + "\n"  )	
IntermidiateFile.close()

plt.plot(time, x0Val, linewidth=2.0, color='b', label=r'\textit{x0 hardware}')
plt.plot(time, y0Val, linewidth=2.0, color='r', label=r'\textit{y0 hardware}')
plt.plot(time, x1Val, linewidth=2.0, color='c', label=r'\textit{x1 hardware}')
plt.plot(time, y1Val, linewidth=2.0, color='m', label=r'\textit{y1 hardware}')
plt.plot(time, x0Val2, linewidth=2.0,color='tab:blue',  label=r'\textit{x0 software}')
plt.plot(time, y0Val2, linewidth=2.0, color='tab:red', label=r'\textit{x1 software}')
plt.plot(time, x1Val2, linewidth=2.0, color='tab:purple', label=r'\textit{y0 software}')
plt.plot(time, y1Val2, linewidth=2.0, color='tab:pink', label=r'\textit{y1 software}')
plt.plot(time, asint1, linewidth=2.0, color='k', linestyle='dashed')
plt.plot(time, asint2, linewidth=2.0, color='k', linestyle='dashed')
plt.plot(time, asint3, linewidth=2.0, color='k', linestyle='dashed')
plt.plot(time, asint4, linewidth=2.0, color='k', linestyle='dashed')
#plt.title("Adiabatic Bifurcation",fontsize=18)
plt.xlabel(r'\textit{t}', fontsize=18)
plt.ylabel(r'\textit{x0(t), y0(t), x1(t), y1(t)}', fontsize=18)
leg = plt.legend(loc='upper left', frameon=True,fontsize=10)
plt.savefig('x0_x1_y0_y1_comparison_h_s.eps', format='eps')
plt.savefig('x0_x1_y0_y1_comparison_h_s.pdf', format='pdf')
plt.savefig('x0_x1_y0_y1_comparison_h_s.png', format='png')
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