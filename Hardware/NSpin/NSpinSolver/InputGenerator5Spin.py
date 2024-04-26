import numpy as np
import random
import math
import sys
import matplotlib.pyplot as plt
from matplotlib import rc

rc('text', usetex=True)
plt.rc('text', usetex=True)

# In this file the input parameter to considered are reported
nome_file = "InputParameter5.txt"

# opening input file
try:
    ParameterFile = open(nome_file, 'w')
except:
    print("Error: it is not possible to open or create the file" + nome_file + "\n")
    sys.exit()

# In this file the XVector[0] and YVector[0] expected are reported
nome_file_X_Y = "InputX_Y5.txt"

# opening input file
try:
    XYFile = open(nome_file_X_Y, 'w')
except:
    print("Error: it is not possible to open or create the file" + nome_file_X_Y + "\n")
    sys.exit()

nome_file_intermidiate = "IntermediateResults5.txt"

# opening input file
try:
    IntermidiateFile = open(nome_file_intermidiate, 'w')
except:
    print("Error: it is not possible to open or create the file" + nome_file_intermidiate + "\n")
    sys.exit()

x0Val = []
x1Val = []
x2Val = []
x4Val = []
x3Val = []
x0Val2 = []
x1Val2 = []
x2Val2 = []
x3Val2 = []
x4Val2 = []
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
y3Val = []
y4Val = []
y0Val2 = []
y1Val2 = []
y2Val2 = []
y3Val2 = []
y4Val2 = []
p = []
time = []
A0_val =[]
A02_val =[]
pt_val = []
pt2_val = []

# Number of spin
numberSpin = 5

NFrac = 9
NBit = NFrac + 11

# Number of steps
numberSteps = 300

# Adiacent Matrix
JMatrixf = np.matrix([[0, 0.75, 0, 0.75, 0.25], [0.75, 0, 0.5, 0, 0], [0, 0.5, 0, 0.5, 0], [0.75, 0, 0.5, 0, 0.75], [0.25, 0, 0, 0.75, 0]])
JMatrix =np.matrix([[0, int(0.75*2**NFrac), 0, int(0.75*2**NFrac), int(0.25*2**NFrac)], [int(0.75*2**NFrac), 0, int(0.5*2**NFrac), 0, 0], [0, int(0.5*2**NFrac), 0, int(0.5*2**NFrac), 0], [int(0.75*2**NFrac), 0, int(0.5*2**NFrac), 0, int(0.75*2**NFrac)], [int(0.25*2**NFrac), 0, 0, int(0.75*2**NFrac), 0]], dtype=np.int32)

# H vector
HVectorf = np.matrix([0, 0, 0, 0, 0])
HVector = np.matrix([0, 0, 0, 0, 0])
#HVectorf = np.matrix([10, 0, -3])
#HVector = np.matrix([int(10*2**NFrac), 0, int(-3*2**NFrac)])

# constant definition
Kf = 2  # Common value, but can be tuned
K = int(Kf*2**NFrac)
ptf = 0
pt = 0
pt2 = 0
deltaTf = 0.1  #The algorithm is stable when deltaT < 0.5
deltaT = int(deltaTf*2**NFrac)
avg = 0
for i in range(numberSpin):
	Deltai = 0
	for j in range(numberSpin):
		Deltai += JMatrixf.item((i, j))
	avg += abs(Deltai)
avg = avg / (numberSpin)
Deltaf = avg * Kf * 0.5
Delta = int(Deltaf*2**NFrac)
xif = Kf * 0.5
xi = int(xif*2**NFrac)
ShapePt = int(0.01*2**NFrac)
A0_start =int((2**((pt-Delta-(int(4*2**NFrac)*K) >> NFrac)/K))*2**NFrac)
Delta4K	= (Delta + (int(4*2**NFrac)*K) >> NFrac)
K_1 = int(2**NFrac/Kf)
offset =int(1*2**NFrac)

# inizialization of x and y
xVector = np.matrix([[0,0, 0, 0, 0]],dtype=np.int32)
xVector2 = np.matrix([[0,0, 0, 0, 0]],dtype=np.int32)
yVector = np.matrix([[0, 0, 0, 0, np.int32(random.choice([ 0.1])*2**NFrac)]],dtype=np.int32)
yVector2 = np.matrix([[0, 0, 0, 0, np.int32(random.choice([+0.1])*2**NFrac)]],dtype=np.int32)

xVectorf = np.matrix([0,0,0, 0, 0])
ptf = 0
yVectorf = np.matrix([0,0, 0, 0, random.choice([-0.1, 0.1])])

y = int(yVector.item(4))
if y < 0:
	y = 2**NBit + y


J21 = int(JMatrix.item(1, 0)*xi >> NFrac)
if J21 < 0:
    J21 = 2 ** NBit + J21

J31 = int(JMatrix.item(2, 0)*xi >> NFrac)
if J31 < 0:
    J31 = 2 ** NBit + J31

J41 = int(JMatrix.item(3, 0)*xi >> NFrac)
if J41 < 0:
    J41 = 2 ** NBit + J41

J51 = int(JMatrix.item(4, 0)*xi >> NFrac)
if J51 < 0:
    J51 = 2 ** NBit + J51

J12 = int(JMatrix.item(0, 1)*xi >> NFrac)
if J12 < 0:
    J12 = 2 ** NBit + J12

J32 = int(JMatrix.item(2, 1)*xi >> NFrac)
if J32 < 0:
    J32 = 2 ** NBit + J32

J42 = int(JMatrix.item(3, 1)*xi >> NFrac)
if J42 < 0:
    J42 = 2 ** NBit + J42

J52 = int(JMatrix.item(4, 1)*xi >> NFrac)
if J52 < 0:
    J52 = 2 ** NBit + J52

J13 = int(JMatrix.item(0, 2)*xi >> NFrac)
if J13 < 0:
    J13 = 2 ** NBit + J13

J23 = int(JMatrix.item(1, 2)*xi >> NFrac)
if J23 < 0:
    J23 = 2 ** NBit + J23

J43 = int(JMatrix.item(3, 2)*xi >> NFrac)
if J43 < 0:
    J43 = 2 ** NBit + J43

J53 = int(JMatrix.item(4, 2)*xi >> NFrac)
if J53 < 0:
    J53 = 2 ** NBit + J53

J14 = int(JMatrix.item(0, 3) * xi >> NFrac)
if J14 < 0:
    J14 = 2 ** NBit + J14

J24 = int(JMatrix.item(1, 3) * xi >> NFrac)
if J24 < 0:
    J24 = 2 ** NBit + J24

J34 = int(JMatrix.item(2, 3) * xi >> NFrac)
if J34 < 0:
    J34 = 2 ** NBit + J34

J54 = int(JMatrix.item(4, 3) * xi >> NFrac)
if J54 < 0:
    J54 = 2 ** NBit + J54

J15 = int(JMatrix.item(0, 4) * xi >> NFrac)
if J15 < 0:
    J15 = 2 ** NBit + J15

J25 = int(JMatrix.item(1, 4) * xi >> NFrac)
if J25 < 0:
    J25 = 2 ** NBit + J25

J35 = int(JMatrix.item(2, 4) * xi >> NFrac)
if J35 < 0:
    J35 = 2 ** NBit + J35

J45 = int(JMatrix.item(3, 4) * xi >> NFrac)
if J45 < 0:
    J45 = 2 ** NBit + J45

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
ParameterFile.write(format(xi, 'b').zfill(NBit) + "\n")
print("xi= " + format(xi) + "\n")
ParameterFile.write(format(deltaT, 'b').zfill(NBit) + "\n")
print("deltaT= " + format(deltaT) + "\n")
ParameterFile.write(format(0, 'b').zfill(NBit) + "\n") #HVector0
print("HVector0= " + format(0) + "\n")
ParameterFile.write(format(0, 'b').zfill(NBit) + "\n") #HVector1
print("HVector1= " + format(0) + "\n")
ParameterFile.write(format(int(0), 'b').zfill(NBit) + "\n") #HVector1
print("HVector2= " + format(0) + "\n")
ParameterFile.write(format(int(0), 'b').zfill(NBit) + "\n") #HVector1
print("HVector3= " + format(0) + "\n")
ParameterFile.write(format(int(0), 'b').zfill(NBit) + "\n") #HVector1
print("HVector4= " + format(0) + "\n")
ParameterFile.write(format(y, 'b').zfill(NBit) + "\n")
print("y= " + format(y))
ParameterFile.write(format(J12, 'b').zfill(NBit) + "\n") #J12
print("J12= " + format(J12) + "\n")
ParameterFile.write(format(J13, 'b').zfill(NBit) + "\n") #J21
print("J13=" + format(J13))
ParameterFile.write(format(J14, 'b').zfill(NBit) + "\n") #J21
print("J14=" + format(J14))
ParameterFile.write(format(J15, 'b').zfill(NBit) + "\n") #J21
print("J15=" + format(J15))
ParameterFile.write(format(J21, 'b').zfill(NBit) + "\n") #J12
print("J21= " + format(J21) + "\n")
ParameterFile.write(format(J23, 'b').zfill(NBit) + "\n") #J21
print("J23=" + format(J23))
ParameterFile.write(format(J24, 'b').zfill(NBit) + "\n") #J21
print("J24=" + format(J24))
ParameterFile.write(format(J25, 'b').zfill(NBit) + "\n") #J21
print("J25=" + format(J25))
ParameterFile.write(format(J31, 'b').zfill(NBit) + "\n") #J12
print("J31= " + format(J31) + "\n")
ParameterFile.write(format(J32, 'b').zfill(NBit) + "\n") #J21
print("J32=" + format(J32))
ParameterFile.write(format(J34, 'b').zfill(NBit) + "\n") #J21
print("J34=" + format(J34))
ParameterFile.write(format(J35, 'b').zfill(NBit) + "\n") #J21
print("J35=" + format(J35))
ParameterFile.write(format(J41, 'b').zfill(NBit) + "\n") #J12
print("J41= " + format(J41) + "\n")
ParameterFile.write(format(J42, 'b').zfill(NBit) + "\n") #J21
print("J42=" + format(J42))
ParameterFile.write(format(J43, 'b').zfill(NBit) + "\n") #J21
print("J43=" + format(J43))
ParameterFile.write(format(J45, 'b').zfill(NBit) + "\n") #J21
print("J45=" + format(J45))
ParameterFile.write(format(J51, 'b').zfill(NBit) + "\n") #J12
print("J51= " + format(J51) + "\n")
ParameterFile.write(format(J52, 'b').zfill(NBit) + "\n") #J21
print("J52=" + format(J52))
ParameterFile.write(format(J53, 'b').zfill(NBit) + "\n") #J21
print("J53=" + format(J53))
ParameterFile.write(format(J54, 'b').zfill(NBit) + "\n") #J21
print("J54=" + format(J54))
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
    x3Val.append(xVector[0, 3]/2**NFrac)
    x4Val.append(xVector[0, 4]/2**NFrac)
    x0Val2.append(xVector2[0, 0]/2**NFrac)
    x1Val2.append(xVector2[0, 1]/2**NFrac)
    x2Val2.append(xVector2[0, 2]/2**NFrac)
    x3Val2.append(xVector2[0, 3]/2**NFrac)
    x4Val2.append(xVector2[0, 4]/2**NFrac)

    y0Val.append(yVector[0, 0]/2**NFrac)
    y1Val.append(yVector[0, 1]/2**NFrac)
    y2Val.append(yVector[0, 2]/2**NFrac)
    y3Val.append(yVector[0, 3]/2**NFrac)
    y4Val.append(yVector[0, 4]/2**NFrac)
    y0Val2.append(yVector2[0, 0]/2**NFrac)
    y1Val2.append(yVector2[0, 1]/2**NFrac)
    y2Val2.append(yVector2[0, 2]/2**NFrac)
    y3Val2.append(yVector2[0, 3]/2**NFrac)
    y4Val2.append(yVector2[0, 4]/2**NFrac)

    temp = xVector2.copy()
    tempf = xVectorf.copy()
    xVectorf = np.add(xVectorf, Deltaf*yVectorf*deltaTf)
    xVector2 = np.add(xVector2, ((Delta*yVector2 >> shiftVect)*deltaT) >> shiftVect)
    tempVectorf = np.add(np.add(Kf*np.power(xVectorf, 3), (Deltaf-ptf)*xVectorf), xif*tempf*JMatrixf)
    tempVectorf += 2*xif*A0f*HVectorf
    tempVector2 = np.add(np.add(((np.multiply((np.multiply((K * xVector2) >> shiftVect, xVector2) >> shiftVect), xVector2) >> shiftVect)),((Delta - pt) * xVector2) >> shiftVect), temp * ((JMatrix * xi) >> shiftVect) >> shiftVect)
    tempVector2 += (((((int(2*2**NFrac)*HVector) >> shiftVect)*xi) >> shiftVect)*A02) >> shiftVect
    yVectorf = np.subtract(yVectorf,tempVectorf*deltaTf)
    yVector2 = np.subtract(yVector2, (tempVector2 * deltaT) >> shiftVect)
    ptf +=0.01   #100/numberSteps
    pt2 += ShapePt
    solutionf = np.sign(xVectorf)
    solution = np.sign(xVector2)
    valuef = np.add(np.matmul(np.matmul(solutionf, JMatrixf), np.transpose(solutionf)),np.matmul(HVectorf, np.transpose(solutionf)))
    value = np.add(np.matmul(np.matmul(solution, JMatrix), np.transpose(solution)), np.matmul(HVector, np.transpose(solution)))

    SumVect = ((xVector*((xi * JMatrix) >> shiftVect)) >> shiftVect)
    IntermidiateFile.write("SNS: In iteration " + format(i) + " gives: " + str(SumVect) + "\n")
    s1MaPE = Delta * yVector >> shiftVect
    s1AaPE = (Delta - pt)
    s1MbPE = ((((int(2*2**NFrac)*HVector) >> shiftVect)*xi) >> shiftVect)
    IntermidiateFile.write("PE: In iteration " + format(i) + " in the state1 Ma: " + str(s1MaPE) + " Aa: " + str(s1AaPE) + " Mb: " + str(s1MbPE) + "\n")

    s2MaPE = ((s1MaPE) * deltaT) >> shiftVect
    s2MbPE = (s1MbPE*A0) >> shiftVect
    IntermidiateFile.write("PE: In iteration " + format(i) + " in the state2 Ma: " + str(s2MaPE) + " Mb: " + str(s2MbPE) + "\n")

    s3AaPE = np.add(xVector, s2MaPE)
    IntermidiateFile.write("PE: In iteration " + format(i) + " in the state3 Aa: " + str(s3AaPE) + "\n")

    s4MaPE = np.multiply(s3AaPE, s3AaPE) >> shiftVect
    s4MbPE = np.multiply(s1AaPE, s3AaPE) >> shiftVect
    s4AaPE = SumVect + s2MbPE
    IntermidiateFile.write("PE: In iteration " + format(i) + " in the state4 Ma: " + str(s4MaPE) + " Aa: " + str(s4AaPE) + " Mb: " + str(s4MbPE) + "\n")

    s5AaPE = s4MbPE + s4AaPE
    s5MaPE = np.multiply(s4MaPE, s3AaPE) >> shiftVect
    IntermidiateFile.write("PE: In iteration " + format(i) + " in the state5 Ma: " + str(s5MaPE) + " Aa: " + str(s5AaPE) + "\n")

    s6MaPE = (K * s5MaPE) >> shiftVect
    IntermidiateFile.write("PE: In iteration " + format(i) + " in the state6 Aa: " + str(s6MaPE) + "\n")

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
        A0f = math.sqrt((ptf -Deltaf -4*Kf)/Kf)+1
    else:
        A0f = 2**((ptf -Deltaf -4*Kf)/Kf)

    if pt > (Delta + (int(4*2**NFrac)*K) >> NFrac):
        A02 = int((math.sqrt((pt -(Delta+(int(4*2**NFrac)*K) >> NFrac))/K))*2**NFrac) + int(1*2**NFrac)
    else:
        A02 = A0_start

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

    x2 = int(xVector.item(2))
    if x2 < 0:
        x2 = 2 ** NBit + x2

    y2 = int(yVector.item(2))
    if y2 < 0:
        y2 = 2 ** NBit + y2

    x3 = int(xVector.item(3))
    if x3 < 0:
        x3 = 2 ** NBit + x3

    y3 = int(yVector.item(3))
    if y3 < 0:
        y3 = 2 ** NBit + y3

    x4 = int(xVector.item(4))
    if x4 < 0:
        x4 = 2 ** NBit + x4

    y4 = int(yVector.item(4))
    if y4 < 0:
        y4 = 2 ** NBit + y4

    p.append(pt)
    XYFile.write(format(x0, 'b').zfill(NBit) + " " + format(x1, 'b').zfill(NBit) + " " + format(x2, 'b').zfill(NBit) + " " + format(x3, 'b').zfill(NBit) + " " + format(x4, 'b').zfill(NBit) + " " + format(y0, 'b').zfill(NBit) + " " + format(y1, 'b').zfill(NBit) +  " " + format(y2, 'b').zfill(NBit) +  " " + format(y3, 'b').zfill(NBit)+  " " + format(y4, 'b').zfill(NBit) +"\n")

IntermidiateFile.close()

plt.plot(time, x0Val, linewidth=2.0, color='r', label=r'\textit{x0}')
plt.plot(time, x1Val, linewidth=2.0, color='b', label=r'\textit{x1}')
plt.plot(time, x2Val, linewidth=2.0, color='g', label=r'\textit{x2}')
plt.plot(time, x3Val, linewidth=2.0, color='c', label=r'\textit{x3}')
plt.plot(time, x4Val, linewidth=2.0, color='m', label=r'\textit{x4}')
plt.plot(time, x0Val2, linewidth=2.0, color='r', linestyle='dashed', label=r'\textit{x02}')
plt.plot(time, x1Val2, linewidth=2.0, color='b', linestyle='dashed', label=r'\textit{x12}')
plt.plot(time, x2Val2, linewidth=2.0, color='g', linestyle='dashed', label=r'\textit{x22}')
plt.plot(time, x3Val2, linewidth=2.0, color='c', linestyle='dashed', label=r'\textit{x32}')
plt.plot(time, x4Val2, linewidth=2.0, color='m', linestyle='dashed', label=r'\textit{x42}')
plt.plot(time, asint1, linewidth=2.0, color='k', linestyle='dashed')
plt.plot(time, asint2, linewidth=2.0, color='k', linestyle='dashed')
plt.title(r'\textbf{Adiabatic Bifurcation}', fontsize=20)
plt.xlabel(r'\textit{t}', fontsize=20)
plt.ylabel(r'\textit{x0(t), x1(t), x2(t), x3(t), x4(t)}', fontsize=20)
leg = plt.legend(bbox_to_anchor=(1.05, 1.0), loc='upper left')
plt.tight_layout()
plt.grid(True)
plt.savefig('X5Spin_software.eps', format='eps')
plt.show()

plt.plot(time, y0Val, linewidth=2.0, color='r', label=r'\textit{y0}')
plt.plot(time, y1Val, linewidth=2.0, color='b', label=r'\textit{y1}')
plt.plot(time, y2Val, linewidth=2.0, color='g', label=r'\textit{y2}')
plt.plot(time, y3Val, linewidth=2.0, color='c', label=r'\textit{y3}')
plt.plot(time, y4Val, linewidth=2.0, color='m', label=r'\textit{y4}')
plt.plot(time, y0Val2, linewidth=2.0, color='r', linestyle='dashed', label=r'\textit{y02}')
plt.plot(time, y1Val2, linewidth=2.0, color='b', linestyle='dashed', label=r'\textit{y12}')
plt.plot(time, y2Val2, linewidth=2.0, color='g', linestyle='dashed', label=r'\textit{y22}')
plt.plot(time, y3Val2, linewidth=2.0, color='c', linestyle='dashed', label=r'\textit{y32}')
plt.plot(time, y4Val2, linewidth=2.0, color='m', linestyle='dashed', label=r'\textit{y42}')
plt.title(r'\textbf{Adiabatic Bifurcation}', fontsize=20)
plt.xlabel(r'\textit{t}', fontsize=20)
plt.ylabel(r'\textit{y0(t), y1(t), y2(t), y3(t), y4(t)}', fontsize=20)
leg = plt.legend(bbox_to_anchor=(1.05, 1.0), loc='upper left')
plt.tight_layout()
plt.grid(True)
plt.savefig('Y5Spin_software.eps', format='eps')
plt.show()

plt.plot(time, A0_val, linewidth=2.0, color='b', label=r'\textit{A0}')
plt.plot(time, A02_val, linewidth=2.0, color='r',label=r'\textit{A02}')
plt.title(r'\textbf{Adiabatic Bifurcation}', fontsize=20)
plt.xlabel(r'\textit{t}', fontsize=20)
plt.ylabel(r'\textit{A0(t), A02(t)}', fontsize=20)
leg = plt.legend(bbox_to_anchor=(1.05, 1.0), loc='upper left')
plt.tight_layout()
plt.grid(True)
plt.savefig('A0_software.eps', format='eps')
plt.show()



