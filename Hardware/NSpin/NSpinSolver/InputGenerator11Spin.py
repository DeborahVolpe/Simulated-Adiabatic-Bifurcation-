import numpy as np
import random
import math
import sys
import matplotlib.pyplot as plt
from matplotlib import rc
from matplotlib import colors as mcolors

rc('text', usetex=True)
plt.rc('text', usetex=True)
colors = dict(mcolors.BASE_COLORS, **mcolors.CSS4_COLORS)

# In this file the input parameter to considered are reported
nome_file = "InputParameter11.txt"

# opening input file
try:
    ParameterFile = open(nome_file, 'w')
except:
    print("Error: it is not possible to open or create the file" + nome_file + "\n")
    sys.exit()

# In this file the XVector[0] and YVector[0] expected are reported
nome_file_X_Y = "InputX_Y11.txt"

# opening input file
try:
    XYFile = open(nome_file_X_Y, 'w')
except:
    print("Error: it is not possible to open or create the file" + nome_file_X_Y + "\n")
    sys.exit()

nome_file_intermidiate = "IntermediateResults11.txt"

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
x5Val = []
x6Val = []
x7Val = []
x8Val = []
x9Val = []
x10Val = []
x0Val2 = []
x1Val2 = []
x2Val2 = []
x3Val2 = []
x4Val2 = []
x5Val2 = []
x6Val2 = []
x7Val2 = []
x8Val2 = []
x9Val2 = []
x10Val2 = []
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
y5Val = []
y6Val = []
y7Val = []
y8Val = []
y9Val = []
y10Val = []
y0Val2 = []
y1Val2 = []
y2Val2 = []
y3Val2 = []
y4Val2 = []
y5Val2 = []
y6Val2 = []
y7Val2 = []
y8Val2 = []
y9Val2 = []
y10Val2 = []
p = []
time = []
A0_val =[]
A02_val =[]
pt_val = []
pt2_val = []

# Number of spin
numberSpin = 11

NFrac = 12
NBit = NFrac + 12

# Number of steps
numberSteps = 1000

# Adiacent Matrix
JMatrixf = np.matrix([[0, 0.5, 0, 0, 0, 0, 0, 1, 0, 0, 0], [0.5, 0, 0.25, 0, 0, 0, 0, 1.25, 0, 0, 0], [0, 0.25, 0, 2, 0, 0, 0, 2.25, 1.75, 2.75, 0],[0, 0, 2, 0, 0.75, 0, 0, 0, 0, 0, 1.75], [0, 0, 0, 0.75, 0, 2.25, 0, 0, 0, 0, 0],[0, 0, 0, 0, 2.25, 0, 1.5, 0, 3, 0, 1.5],[0, 0, 0, 0, 0, 1.5, 0, 3.5, 0, 0, 0], [1, 1.25, 2.25, 0, 0, 0, 3.5, 0, 0, 0, 0], [0, 0, 1.75, 0, 0, 3, 0, 0, 0, 0, 0], [0, 0, 2.75, 0, 0, 0, 0, 0, 0, 0, 0.25], [0, 0, 0, 1.75, 0, 1.5, 0, 0, 0, 0.25, 0]])
#JMatrixf = np.matrix([[0, 0.75, 0, 0.75, 0.25], [0.75, 0, 0.5, 0, 0], [0, 0.5, 0, 0.5, 0], [0.75, 0, 0.5, 0, 0.75], [0.25, 0, 0, 0.75, 0]])
JMatrix = (JMatrixf * (2 ** NFrac)).astype(np.int32)

# H vector
HVectorf = np.matrix([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
HVector = np.matrix([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
#HVectorf = np.matrix([10, 0, -3])
#HVector = np.matrix([int(10*2**NFrac), 0, int(-3*2**NFrac)])

Kf= 4# Common value, but can be tuned
print(Kf)
K = int(Kf*2**NFrac)
print(K)
pt2 = 0
deltaTf = 0.004 #The algorithm is stable when deltaT < 0.5
#deltaTf = 0.5#The algorithm is stable when deltaT < 0.5
print(deltaTf)
deltaT = int(deltaTf*2**NFrac)
print(deltaT)
avg = 0
for i in range(numberSpin):
    Deltai = 0
    for j in range(numberSpin):
        Deltai += JMatrixf.item((i, j))
    avg += abs(Deltai)

avg = avg/(numberSpin)
pt = 0
Deltaf = avg*0.5*Kf
print(Deltaf)
Delta = int(Deltaf*2**NFrac)
print(Delta)
xif = 0.5*Kf
xi = int(xif*2**NFrac)
ShapePt = int((7*Kf/10000)*2**NFrac)
A0_start =int((2**((pt-Delta-(int(4*2**NFrac)*K) >> NFrac)/K))*2**NFrac)
Delta4K	= (Delta + (int(4*2**NFrac)*K) >> NFrac)
K_1 = int(2**NFrac/Kf)
offset =int(1*2**NFrac)
# inizialization of x and y
xVector = np.matrix([[0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0]],dtype=np.int32)
xVector2 = np.matrix([[0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0]],dtype=np.int32)
yVector = np.matrix([[0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  np.int32(random.choice([ 0.1])*2**NFrac)]],dtype=np.int32)
yVector2 = np.matrix([[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, np.int32(random.choice([+0.1])*2**NFrac)]],dtype=np.int32)

xVectorf = np.matrix([0,0,0, 0, 0, 0, 0, 0, 0, 0, 0])
ptf = 0
yVectorf = np.matrix([0,0, 0, 0, 0, 0, 0, 0, 0, 0, random.choice([-0.1, 0.1])])

y = int(yVector.item(10))
if y < 0:
	y = 2**NBit + y


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
ParameterFile.write(format(int(0), 'b').zfill(NBit) + "\n") #HVector1
print("HVector5= " + format(0) + "\n")
ParameterFile.write(format(0, 'b').zfill(NBit) + "\n") #HVector1
print("HVector6= " + format(0) + "\n")
ParameterFile.write(format(int(0), 'b').zfill(NBit) + "\n") #HVector1
print("HVector7= " + format(0) + "\n")
ParameterFile.write(format(int(0), 'b').zfill(NBit) + "\n") #HVector1
print("HVector8= " + format(0) + "\n")
ParameterFile.write(format(int(0), 'b').zfill(NBit) + "\n") #HVector1
print("HVector9= " + format(0) + "\n")
ParameterFile.write(format(int(0), 'b').zfill(NBit) + "\n") #HVector1
print("HVector10= " + format(0) + "\n")
ParameterFile.write(format(y, 'b').zfill(NBit) + "\n")
print("y= " + format(y))
for i in range(numberSpin):
    for j in range(numberSpin):
        if i != j:
            J = int(JMatrix.item(i, j)*xi >> NFrac)
            if J < 0:
                J = 2 ** NBit + J
            ParameterFile.write(format(J, 'b').zfill(NBit) + "\n") #J12
            print("J" + format(j) + format(i) + "= " + format(J) + "\n")
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
    x5Val.append(xVector[0, 5] / 2 ** NFrac)
    x6Val.append(xVector[0, 5]/2**NFrac)
    x7Val.append(xVector[0, 7]/2**NFrac)
    x8Val.append(xVector[0, 8]/2**NFrac)
    x9Val.append(xVector[0, 9]/2**NFrac)
    x10Val.append(xVector[0, 10] / 2 ** NFrac)
    x0Val2.append(xVector2[0, 0]/2**NFrac)
    x1Val2.append(xVector2[0, 1]/2**NFrac)
    x2Val2.append(xVector2[0, 2]/2**NFrac)
    x3Val2.append(xVector2[0, 3]/2**NFrac)
    x4Val2.append(xVector2[0, 4]/2**NFrac)
    x5Val2.append(xVector2[0, 5] / 2 ** NFrac)
    x6Val2.append(xVector2[0, 6]/2**NFrac)
    x7Val2.append(xVector2[0, 7]/2**NFrac)
    x8Val2.append(xVector2[0, 8]/2**NFrac)
    x9Val2.append(xVector2[0, 9]/2**NFrac)
    x10Val2.append(xVector2[0, 10] / 2 ** NFrac)

    y0Val.append(yVector[0, 0]/2**NFrac)
    y1Val.append(yVector[0, 1]/2**NFrac)
    y2Val.append(yVector[0, 2]/2**NFrac)
    y3Val.append(yVector[0, 3]/2**NFrac)
    y4Val.append(yVector[0, 4]/2**NFrac)
    y5Val.append(yVector[0, 5] / 2 ** NFrac)
    y6Val.append(yVector[0, 6]/2**NFrac)
    y7Val.append(yVector[0, 7]/2**NFrac)
    y8Val.append(yVector[0, 8]/2**NFrac)
    y9Val.append(yVector[0, 9]/2**NFrac)
    y10Val.append(yVector[0, 10] / 2 ** NFrac)
    y0Val2.append(yVector2[0, 0]/2**NFrac)
    y1Val2.append(yVector2[0, 1]/2**NFrac)
    y2Val2.append(yVector2[0, 2]/2**NFrac)
    y3Val2.append(yVector2[0, 3]/2**NFrac)
    y4Val2.append(yVector2[0, 4]/2**NFrac)
    y5Val2.append(yVector2[0, 5] / 2 ** NFrac)
    y6Val2.append(yVector2[0, 6]/2**NFrac)
    y7Val2.append(yVector2[0, 7]/2**NFrac)
    y8Val2.append(yVector2[0, 8]/2**NFrac)
    y9Val2.append(yVector2[0, 9]/2**NFrac)
    y10Val2.append(yVector2[0, 10] / 2 ** NFrac)

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

    x5 = int(xVector.item(5))
    if x5 < 0:
        x5 = 2 ** NBit + x5

    y5 = int(yVector.item(5))
    if y5 < 0:
        y5 = 2 ** NBit + y5

    x6 = int(xVector.item(6))
    if x6 < 0:
        x6 = 2 ** NBit + x6

    y6 = int(yVector.item(6))
    if y6 < 0:
        y6 = 2 ** NBit + y6

    x7 = int(xVector.item(7))
    if x7 < 0:
        x7 = 2 ** NBit + x7

    y7 = int(yVector.item(7))
    if y7 < 0:
        y7 = 2 ** NBit + y7

    x8 = int(xVector.item(8))
    if x8 < 0:
        x8 = 2 ** NBit + x8

    y8 = int(yVector.item(8))
    if y8 < 0:
        y8 = 2 ** NBit + y8

    x9 = int(xVector.item(9))
    if x9 < 0:
        x9 = 2 ** NBit + x9

    y9 = int(yVector.item(9))
    if y9 < 0:
        y9 = 2 ** NBit + y9

    x10 = int(xVector.item(10))
    if x10 < 0:
        x10 = 2 ** NBit + x10

    y10 = int(yVector.item(10))
    if y10 < 0:
        y10 = 2 ** NBit + y10

    p.append(pt)
    XYFile.write(format(x0, 'b').zfill(NBit) + " " + format(x1, 'b').zfill(NBit) + " " + format(x2, 'b').zfill(NBit) + " " + format(x3, 'b').zfill(NBit) + " " + format(x4, 'b').zfill(NBit) + " " + format(x5, 'b').zfill(NBit) + " " + format(x6, 'b').zfill(NBit) + " " + format(x7, 'b').zfill(NBit) + " " + format(x8, 'b').zfill(NBit) + " " + format(x9, 'b').zfill(NBit) + " " + format(x10, 'b').zfill(NBit) + " " + format(y0, 'b').zfill(NBit) + " " + format(y1, 'b').zfill(NBit) +  " " + format(y2, 'b').zfill(NBit) +  " " + format(y3, 'b').zfill(NBit)+  " " + format(y4, 'b').zfill(NBit) +  " " + format(y5, 'b').zfill(NBit) + " " + format(y6, 'b').zfill(NBit) +  " " + format(y7, 'b').zfill(NBit) +  " " + format(y8, 'b').zfill(NBit)+  " " + format(y9, 'b').zfill(NBit) +  " " + format(y10, 'b').zfill(NBit)+"\n")


IntermidiateFile.close()

plt.plot(time, x0Val, linewidth=2.0, color='r', label=r'\textit{x0}')
plt.plot(time, x1Val, linewidth=2.0, color='b', label=r'\textit{x1}')
plt.plot(time, x2Val, linewidth=2.0, color='g', label=r'\textit{x2}')
plt.plot(time, x3Val, linewidth=2.0, color='c', label=r'\textit{x3}')
plt.plot(time, x4Val, linewidth=2.0, color='m', label=r'\textit{x4}')
plt.plot(time, x5Val, linewidth=2.0, color='y', label=r'\textit{x5}')
plt.plot(time, x6Val, linewidth=2.0,  color=colors['blueviolet'], label=r'\textit{x6}')
plt.plot(time, x7Val, linewidth=2.0, color=colors['lightblue'], label=r'\textit{x7}')
plt.plot(time, x8Val, linewidth=2.0, color=colors['pink'], label=r'\textit{x8}')
plt.plot(time, x9Val, linewidth=2.0,color=colors['orange'], label=r'\textit{x9}')
plt.plot(time, x10Val, linewidth=2.0, color=colors['greenyellow'], label=r'\textit{x10}')
plt.plot(time, x0Val2, linewidth=2.0, color='r', linestyle='dashed', label=r'\textit{x02}')
plt.plot(time, x1Val2, linewidth=2.0, color='b', linestyle='dashed', label=r'\textit{x12}')
plt.plot(time, x2Val2, linewidth=2.0, color='g', linestyle='dashed', label=r'\textit{x22}')
plt.plot(time, x3Val2, linewidth=2.0, color='c', linestyle='dashed', label=r'\textit{x32}')
plt.plot(time, x4Val2, linewidth=2.0, color='m', linestyle='dashed', label=r'\textit{x42}')
plt.plot(time, x5Val2, linewidth=2.0, color='y', linestyle='dashed', label=r'\textit{x52}')
plt.plot(time, x6Val2, linewidth=2.0,  color=colors['blueviolet'],linestyle='dashed', label=r'\textit{x62}')
plt.plot(time, x7Val2, linewidth=2.0, color=colors['lightblue'], linestyle='dashed',label=r'\textit{x72}')
plt.plot(time, x8Val2, linewidth=2.0, color=colors['pink'], linestyle='dashed',label=r'\textit{x82}')
plt.plot(time, x9Val2, linewidth=2.0,color=colors['orange'], linestyle='dashed',label=r'\textit{x92}')
plt.plot(time, x10Val2, linewidth=2.0, color=colors['greenyellow'], linestyle='dashed', label=r'\textit{x102}')
plt.title(r'\textbf{Adiabatic Bifurcation}', fontsize=20)
plt.xlabel(r'\textit{t}', fontsize=20)
plt.ylabel(r'\textit{x(t)}', fontsize=20)
leg = plt.legend(loc='upper left',bbox_to_anchor=(1.05, 1.0),frameon=True, fontsize=8)
plt.tight_layout()
plt.grid(True)
plt.savefig('X11Spin_software.eps', format='eps', bbox_inches='tight')
plt.savefig('X11Spin_software.png', format='png', bbox_inches='tight')
plt.show()

plt.plot(time, y0Val, linewidth=2.0, color='r', label=r'\textit{y0}')
plt.plot(time, y1Val, linewidth=2.0, color='b', label=r'\textit{y1}')
plt.plot(time, y2Val, linewidth=2.0, color='g', label=r'\textit{y2}')
plt.plot(time, y3Val, linewidth=2.0, color='c', label=r'\textit{y3}')
plt.plot(time, y4Val, linewidth=2.0, color='m', label=r'\textit{y4}')
plt.plot(time, y5Val, linewidth=2.0, color='m', label=r'\textit{y5}')
plt.plot(time, y6Val, linewidth=2.0,  color=colors['blueviolet'], label=r'\textit{y6}')
plt.plot(time, y7Val, linewidth=2.0, color=colors['lightblue'], label=r'\textit{y7}')
plt.plot(time, y8Val, linewidth=2.0, color=colors['pink'], label=r'\textit{y8}')
plt.plot(time, y9Val, linewidth=2.0,color=colors['orange'], label=r'\textit{y9}')
plt.plot(time, y10Val, linewidth=2.0, color=colors['greenyellow'], label=r'\textit{x10}')
plt.plot(time, y0Val2, linewidth=2.0, color='r', linestyle='dashed', label=r'\textit{y02}')
plt.plot(time, y1Val2, linewidth=2.0, color='b', linestyle='dashed', label=r'\textit{y12}')
plt.plot(time, y2Val2, linewidth=2.0, color='g', linestyle='dashed', label=r'\textit{y22}')
plt.plot(time, y3Val2, linewidth=2.0, color='c', linestyle='dashed', label=r'\textit{y32}')
plt.plot(time, y4Val2, linewidth=2.0, color='m', linestyle='dashed', label=r'\textit{y42}')
plt.plot(time, y5Val2, linewidth=2.0, color='m', linestyle='dashed', label=r'\textit{y52}')
plt.plot(time, y6Val2, linewidth=2.0,  color=colors['blueviolet'],linestyle='dashed', label=r'\textit{y62}')
plt.plot(time, y7Val2, linewidth=2.0, color=colors['lightblue'], linestyle='dashed',label=r'\textit{y72}')
plt.plot(time, y8Val2, linewidth=2.0, color=colors['pink'], linestyle='dashed',label=r'\textit{y82}')
plt.plot(time, y9Val2, linewidth=2.0,color=colors['orange'], linestyle='dashed',label=r'\textit{y92}')
plt.plot(time, y10Val2, linewidth=2.0, color=colors['greenyellow'], linestyle='dashed', label=r'\textit{y102}')
plt.title(r'\textbf{Adiabatic Bifurcation}', fontsize=20)
plt.xlabel(r'\textit{t}', fontsize=20)
plt.ylabel(r'\textit{y(t)}', fontsize=20)
leg = plt.legend(loc='upper left',bbox_to_anchor=(1.05, 1.0),frameon=True, fontsize=8)
plt.tight_layout()
plt.grid(True)
plt.savefig('Y11Spin_software.eps', format='eps', bbox_inches='tight')
plt.show()

plt.plot(time, A0_val, linewidth=2.0, color='b', label=r'\textit{A0}')
plt.plot(time, A02_val, linewidth=2.0, color='r',label=r'\textit{A02}')
plt.title(r'\textbf{Adiabatic Bifurcation}', fontsize=20)
plt.xlabel(r'\textit{t}', fontsize=20)
plt.ylabel(r'\textit{A0(t), A02(t)}', fontsize=20)
leg = plt.legend(loc='upper left',bbox_to_anchor=(1.05, 1.0),frameon=True, fontsize=8)
plt.tight_layout()
plt.grid(True)
plt.savefig('A0_software.eps', format='eps', bbox_inches='tight')
plt.show()


print(solution)
print(value/(2**NFrac))
