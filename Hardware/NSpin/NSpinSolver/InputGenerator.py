import numpy as np
import random
import math
import sys
import matplotlib.pyplot as plt

# In this file the input parameter to considered are reported
nome_file = "InputParameter.txt"

# opening input file
try:
    ParameterFile = open(nome_file, 'w')
except:
    print("Error: it is not possible to open or create the file" + nome_file + "\n")
    sys.exit()

# In this file the XVector[0] and YVector[0] expected are reported
nome_file_X_Y = "InputX_Y.txt"

# opening input file
try:
    XYFile = open(nome_file_X_Y, 'w')
except:
    print("Error: it is not possible to open or create the file" + nome_file_X_Y + "\n")
    sys.exit()

nome_file_intermidiate = "IntermediateResults.txt"

# opening input file
try:
    IntermidiateFile = open(nome_file_intermidiate, 'w')
except:
    print("Error: it is not possible to open or create the file" + nome_file_intermidiate + "\n")
    sys.exit()

x0Val = []
x1Val = []
x2Val = []
x0Val2 = []
x1Val2 = []
x2Val2 = []
asint1 = []
asint2 = []
asint3 = []
asint4 = []
asint5 = []
asint6 = []
Values = []
y0Val = []
y1Val = []
y2Val = []
y0Val2 = []
y1Val2 = []
y2Val2 = []
p = []
time = []
A0_val =[]
A02_val =[]
pt_val = []
pt2_val = []

# Number of spin
numberSpin = 3

NFrac = 9
NBit = NFrac + 5

# Number of steps
numberSteps = 50

power = 2**NFrac

# Adiacent Matrix
JMatrixf = np.matrix([[0, 1.5, 2], [1.5, 0, 2.5], [2, 2.5, 0]])
JMatrix = np.matrix([[0, int(1.5*power), int(2*power)], [int(1.5*power), 0, int(2.5*power)], [int(2*power), int(2.5*power), 0]], dtype=np.int32)
print(JMatrix)	
# H vector
# H vector
HVector = np.matrix([0, 0, 0],dtype=np.int32)
HVectorf = np.matrix([0, 0, 0])

# constant definition
Kf = 1  # Common value, but can be tuned
K = int(Kf*2**NFrac)
ptf = 0
pt = 0
pt2 = 0
deltaTf = 0.5  #The algorithm is stable when deltaT < 0.5
deltaT = int(deltaTf*2**NFrac)
temp = 0
for i in range(3):
    for j in range(3):
        temp += JMatrixf.item(i,j)**2
J_dev = math.sqrt(temp/(3*(2)))
Deltaf = 1
Delta = int(Deltaf*2**NFrac)
xif = 0.5/(math.sqrt(3) * J_dev)
xi = int(xif*2**NFrac)

JMatrixf_xi = np.matrix([[0, 1.5*xif, 2*xif], [1.5*xif, 0, 2.5*xif], [2*xif, 2.5*xif, 0]])
JMatrix_xi = np.matrix([[0, int(1.5*xif*2**NFrac), int(2*xif*2**NFrac)], [int(1.5*xif*2**NFrac), 0, int(2.5*xif*2**NFrac)], [int(2*xif*2**NFrac), int(2.5*xif*2**NFrac), 0]], dtype=np.int32)
HVector_xi = np.matrix([int(0*2*xif*2**NFrac), int(0*2*xif*2**NFrac), int(0*2*xif*2**NFrac)],dtype=np.int32)
HVectorf_xi = np.matrix([0*2*xif, 0*2*xif, 0*2*xif])

ShapePt = int((1/20)*2**NFrac)
A0_start = int(0.1*2**NFrac)
Delta4K	= int((Deltaf+4*Kf)*2**NFrac)
K_1 = int(2**NFrac/Kf)
offset =int(0.1*2**NFrac)

# inizialization of x and y
xVector = np.matrix([[0,0, 0]],dtype=np.int32)
xVector2 = np.matrix([[0,0, 0]],dtype=np.int32)
yVector = np.matrix([[np.int32(random.choice([-0.1, 0.1])*2**NFrac), np.int32(random.choice([-0.1, 0.1])*2**NFrac), np.int32(random.choice([-0.1, 0.1])*2**NFrac)]],dtype=np.int32)
yVector2 = np.matrix([[np.int32(random.choice([-0.1, 0.1])*2**NFrac), np.int32(random.choice([-0.1, 0.1])*2**NFrac), np.int32(random.choice([-0.1, 0.1])*2**NFrac)]],dtype=np.int32)

xVectorf = np.matrix([0,0,0])
ptf = 0
yVectorf = np.matrix([random.choice([-0.1, 0.1]),random.choice([-0.1, 0.1]), random.choice([-0.1, 0.1])])

y0 = int(yVector.item(0))
if y0 < 0:
	y0 = 2**NBit + y0
    
y1 = int(yVector.item(1))
if y1 < 0:
	y1 = 2**NBit + y1
    
y2 = int(yVector.item(2))
if y2 < 0:
	y2 = 2**NBit + y2


J21 = JMatrix_xi.item(1, 0)
if J21 < 0:
    J21 = 2 ** NBit + J21

J31 = JMatrix_xi.item(2, 0)
if J31 < 0:
    J31 = 2 ** NBit + J31

J12 = JMatrix_xi.item(0, 1)
if J12 < 0:
    J12 = 2 ** NBit + J12

J32 = JMatrix_xi.item(2, 1)
if J32 < 0:
    J32 = 2 ** NBit + J32

J13 = JMatrix_xi.item(0, 2)
if J13 < 0:
    J13 = 2 ** NBit + J13

J23 = JMatrix_xi.item(1, 2)
if J23 < 0:
    J23 = 2 ** NBit + J23

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
print("K=" + format(K) + "\n")
ParameterFile.write(format(Delta, 'b').zfill(NBit) + "\n")
print("Delta= " + format(Delta) + "\n")
ParameterFile.write(format(0, 'b').zfill(NBit) + "\n") #HVector0
print("HVector0= " + format(0) + "\n")
ParameterFile.write(format(0, 'b').zfill(NBit) + "\n") #HVector1
print("HVector1= " + format(0) + "\n")
ParameterFile.write(format(0, 'b').zfill(NBit) + "\n") #HVector1
print("HVector2= " + format(0) + "\n")
ParameterFile.write(format(y0, 'b').zfill(NBit) + "\n")
print("y= " + format(y0))
ParameterFile.write(format(y1, 'b').zfill(NBit) + "\n")
print("y= " + format(y1))
ParameterFile.write(format(y2, 'b').zfill(NBit) + "\n")
print("y= " + format(y2))
ParameterFile.write(format(deltaT, 'b').zfill(NBit) + "\n")
print("deltaT= " + format(deltaT) + "\n")
ParameterFile.write(format(J12, 'b').zfill(NBit) + "\n") #J12
print("J12= " + format(J12) + "\n")
ParameterFile.write(format(J13, 'b').zfill(NBit) + "\n") #J21
print("J13=" + format(J13))
ParameterFile.write(format(J21, 'b').zfill(NBit) + "\n") #J12
print("J21= " + format(J21) + "\n")
ParameterFile.write(format(J23, 'b').zfill(NBit) + "\n") #J21
print("J23=" + format(J23))
ParameterFile.write(format(J31, 'b').zfill(NBit) + "\n") #J12
print("J31= " + format(J31) + "\n")
ParameterFile.write(format(J32, 'b').zfill(NBit) + "\n") #J21
print("J32=" + format(J32))
ParameterFile.close()

shiftVect = np.int32(NFrac) * np.ones((1,numberSpin), dtype=np.int32)

A0 = 0
A0f = 0
A02= 0




for i in range(numberSteps):

    time.append(i)
    x0Val.append(xVector[0, 0]/2**NFrac)
    x1Val.append(xVector[0, 1]/2**NFrac)
    x2Val.append(xVector[0, 2]/2**NFrac)
    x0Val2.append(xVector2[0, 0]/2**NFrac)
    x1Val2.append(xVector2[0, 1]/2**NFrac)
    x2Val2.append(xVector2[0, 2]/2**NFrac)

    y0Val.append(yVector[0, 0]/2**NFrac)
    y1Val.append(yVector[0, 1]/2**NFrac)
    y2Val.append(yVector[0, 2]/2**NFrac)
    y0Val2.append(yVector2[0, 0]/2**NFrac)
    y1Val2.append(yVector2[0, 1]/2**NFrac)
    y2Val2.append(yVector2[0, 2]/2**NFrac)

    temp = xVector2.copy()
    tempf = xVectorf.copy()
    xVectorf = np.add(xVectorf, Deltaf*yVectorf*deltaTf)
    xVector2 = np.add(xVector2, (((Delta*yVector2) >> shiftVect)*deltaT) >> shiftVect)
    tempVectorf = np.add(np.add(Kf*np.power(xVectorf, 3), (Deltaf-ptf)*xVectorf), xif*tempf*JMatrixf)
    tempVectorf += 2*xif*A0f*HVectorf
    tempVector2 = np.add(np.add(((np.multiply((np.multiply((K * xVector2) >> shiftVect, xVector2) >> shiftVect), xVector2) >> shiftVect)),((Delta - pt) * xVector2) >> shiftVect), (temp * JMatrix_xi)  >> shiftVect)
    tempVector2 += (((((int(2*2**NFrac)*HVector) >> shiftVect)*xi) >> shiftVect)*A02) >> shiftVect
    yVectorf = np.subtract(yVectorf,tempVectorf*deltaTf)
    yVector2 = np.subtract(yVector2, (tempVector2 * deltaT) >> shiftVect)
    ptf += 1/20 #100/numberSteps
    pt2 += ShapePt
    solutionf = np.sign(xVectorf)
    solution = np.sign(xVector2)
    valuef = np.add(np.matmul(np.matmul(solutionf, JMatrixf), np.transpose(solutionf)),np.matmul(HVectorf, np.transpose(solutionf)))
    value = np.add(np.matmul(np.matmul(solution, JMatrix), np.transpose(solution)), np.matmul(HVector, np.transpose(solution)))

    SumVect = ((xVector*JMatrix_xi) >> shiftVect)
    IntermidiateFile.write("SNS: In iteration " + format(i) + " gives: " + str(SumVect) + "\n")
    s1MaPE = (Delta * yVector) >> shiftVect
    s1AaPE = (Delta - pt)
    s1MbPE = (HVector_xi*A0) >> shiftVect
    IntermidiateFile.write("PE: In iteration " + format(i) + " in the state1 Ma: " + str(s1MaPE) + " Aa: " + str(s1AaPE) + " Mb: " + str(s1MbPE) + "\n")

    s2MaPE = ((s1MaPE) * deltaT) >> shiftVect
    IntermidiateFile.write("PE: In iteration " + format(i) + " in the state2 Ma: " + str(s2MaPE) +  "\n")

    s3AaPE = np.add(xVector, s2MaPE)
    IntermidiateFile.write("PE: In iteration " + format(i) + " in the state3 Aa: " + str(s3AaPE) + "\n")

    s4MaPE = (K * s3AaPE) >> shiftVect
    s4MbPE = np.multiply(s1AaPE, s3AaPE) >> shiftVect
    s4AaPE = SumVect + s1MbPE
    IntermidiateFile.write("PE: In iteration " + format(i) + " in the state4 Ma: " + str(s4MaPE) + " Aa: " + str(s4AaPE) + " Mb: " + str(s4MbPE) + "\n")

    s5AaPE = s4MbPE + s4AaPE
    s5MaPE = np.multiply(s4MaPE, s3AaPE) >> shiftVect
    IntermidiateFile.write("PE: In iteration " + format(i) + " in the state5 Ma: " + str(s5MaPE) + " Aa: " + str(s5AaPE) + "\n")

    s6MaPE = (np.multiply(s5MaPE, s3AaPE) >> shiftVect)
    IntermidiateFile.write("PE: In iteration " + format(i) + " in the state6 Ma: " + str(s6MaPE) + "\n")

    s7AaPE = s5AaPE + s6MaPE
    IntermidiateFile.write("PE: In iteration " + format(i) + " in the state7 Aa: " + str(s7AaPE) + "\n")

    s8MaPE = (s7AaPE * deltaT) >> shiftVect
    IntermidiateFile.write("PE: In iteration " + format(i) + " in the state8 Ma: " + str(s8MaPE) + "\n")

    s9AaPE = yVector - s8MaPE
    IntermidiateFile.write("PE: In iteration " + format(i) + " in the state9 Aa: " + str(s9AaPE) + "\n")

    xVector = s3AaPE
    yVector = s9AaPE

    # PA0
    pt += ShapePt
    s1AaPA0 = pt
    IntermidiateFile.write("PA0: At iteration " + format(i) + " in the first state Aa: " + str(s1AaPA0) + "\n")
    s2AaPA0 = s1AaPA0 - Delta4K
    IntermidiateFile.write("PA0: At iteration " + format(i) + " in the second state Aa: " + str(s2AaPA0) + "\n")
    s3MaPA0 = (s2AaPA0 * K_1) >> NFrac
    IntermidiateFile.write("PA0: At iteration " + format(i) + " in the third state Ma: " + str(s3MaPA0) + "\n")
    if s3MaPA0 > 0:
        s4SqPA0 = int(math.sqrt(s3MaPA0 << 1)) << 5
        IntermidiateFile.write("PA0: At iteration " + format(i) + " in the fourth state : " + str(s4SqPA0) + "\n")
        s5AaPA0 = s4SqPA0 + offset
        IntermidiateFile.write("PA0: At iteration " + format(i) + " in the fifth state : " + str(s5AaPA0) + "\n")
    else:
        s5AaPA0 = A0_start

    A0 = s5AaPA0





    if ptf > (Deltaf +4*Kf):
        A0f = math.sqrt((ptf -Deltaf -4*Kf)/Kf)+0.1
    else:
        A0f =0.1

    if pt > (Delta + (int(4*2**NFrac)*K) >> NFrac):
        A02 = int((math.sqrt((pt -(Delta+(int(4*2**NFrac)*K) >> NFrac))/K))*2**NFrac) + int(0.1*2**NFrac)
    else:
        A02 = int(0.1*2**NFrac)

    A0_val.append(A0/2**NFrac)
    A02_val.append(A02/2**NFrac)



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

    if pt < (Delta + xi):
        asint5.append(0)
        asint6.append(0)
    else:
        asint5.append(math.sqrt((float(pt - Delta - xi) / 2 ** NFrac) / (float(K) / 2 ** NFrac)))
        asint6.append(-math.sqrt((float(pt - Delta - xi) / 2 ** NFrac) / (float(K) / 2 ** NFrac)))

    x0 = int(xVector.item(0))
    if x0 < 0:
        x0 = 2**NBit + x0

    y0 = int(yVector.item(0))
    if y0 < 0:
        y0 = 2 ** NBit + y0

    x1 = int(xVector.item(1))
    if x1 < 0:
        x1 = 2 ** NBit + x1

    y1 = int(yVector.item(1))
    if y1 < 0:
        y1 = 2**NBit + y1

    x2 = int(xVector.item(2))
    if x2 < 0:
        x2 = 2**NBit + x2

    y2 = int(yVector.item(2))
    if y2 < 0:
        y2 = 2**NBit + y2

    p.append(pt)
    XYFile.write(format(x0, 'b').zfill(NBit) + " " + format(x1, 'b').zfill(NBit) + " " + format(x2, 'b').zfill(NBit) + " " + format(y0, 'b').zfill(NBit) + " " + format(y1, 'b').zfill(NBit) +  " " + format(y2, 'b').zfill(NBit) + "\n")

IntermidiateFile.close()


plt.plot(time, x0Val, linewidth=2.0, color='b', label='x0')
plt.plot(time, y0Val, linewidth=2.0, color='r', label='y0')
plt.plot(time, x1Val, linewidth=2.0, color='c', label='x1')
plt.plot(time, y1Val, linewidth=2.0, color='m', label='y1')
plt.plot(time, x2Val, linewidth=2.0, color='y', label='x2')
plt.plot(time, y2Val, linewidth=2.0, color='g', label='y2')
plt.plot(time, x0Val2, linewidth=2.0, color='b', linestyle='dashed', label='x02')
plt.plot(time, y0Val2, linewidth=2.0, color='r', linestyle='dashed', label='y02')
plt.plot(time, x1Val2, linewidth=2.0, color='c', linestyle='dashed', label='x12')
plt.plot(time, y1Val2, linewidth=2.0, color='m', linestyle='dashed', label='y12')
plt.plot(time, x2Val2, linewidth=2.0, color='y', linestyle='dashed', label='x22')
plt.plot(time, y2Val2, linewidth=2.0, color='g', linestyle='dashed', label='y22')
plt.plot(time, asint1, linewidth=2.0, color='k', linestyle='dashed')
plt.plot(time, asint2, linewidth=2.0, color='k', linestyle='dashed')
plt.plot(time, asint3, linewidth=2.0, color='k', linestyle='dashed')
plt.plot(time, asint4, linewidth=2.0, color='k', linestyle='dashed')
plt.plot(time, asint5, linewidth=2.0, color='k', linestyle='dashed')
plt.plot(time, asint6, linewidth=2.0, color='k', linestyle='dashed')
plt.title("Adiabatic Bifurcation",fontsize=18)
plt.xlabel("Number of iterations", fontsize=18)
plt.ylabel("x0(t), y0(t), x1(t), y1(t), x2(t), y2(t)", fontsize=18)
leg = plt.legend(bbox_to_anchor=(1.05, 1.0), loc='upper left')
plt.tight_layout()
plt.grid(True)
plt.show()

plt.plot(time, A0_val, linewidth=2.0, color='b', label='A0')
plt.plot(time, A02_val, linewidth=2.0, color='r', label='A02')
plt.title("Adiabatic Bifurcation",fontsize=18)
plt.xlabel("Number of iterations", fontsize=18)
plt.ylabel("A0(t), A02(t)", fontsize=18)
leg = plt.legend(bbox_to_anchor=(1.05, 1.0), loc='upper left')
plt.tight_layout()
plt.grid(True)
plt.show()



