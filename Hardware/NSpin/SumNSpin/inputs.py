import numpy as np
import random
import math
import sys

# In this file the input parameter to considered are reported
nome_file = "InputParameter.txt"

# opening input file
try:
    ParameterFile = open(nome_file, 'w')
except:
    print("Error: it is not possible to open or create the file" + nome_file + "\n")
    sys.exit()

# In this file the sum expected output
nome_file_sum = "InputSum.txt"

# opening input file
try:
    SumFile = open(nome_file_sum, 'w')
except:
    print("Error: it is not possible to open or create the file" + nome_file_sum + "\n")
    sys.exit()

# In this file the X inputs are reported
nome_file_X = "InputX.txt"

# opening input file
try:
    XFile = open(nome_file_X, 'w')
except:
    print("Error: it is not possible to open or create the file" + nome_file_X + "\n")
    sys.exit()

# Data file for verification
nome_file_Verification = "DataInter.txt"

# opening input file
try:
    VerificationFile = open(nome_file_Verification, 'w')
except:
    print("Error: it is not possible to open or create the file" + nome_file_Verification + "\n")
    sys.exit()

# Number of spin
numberSpin = 3

NFrac = 11
NBit = NFrac + 11


# Number of steps
numberSteps = 20

# Adiacent Matrix
JMatrixf = np.matrix([[0, -1.5, -2], [-1.5, 0, -2.5], [-2, -2.5, 0]])
JMatrix = np.matrix([[0, int(-1.5*2**NFrac), int(-2*2**NFrac)], [int(-1.5*2**NFrac), 0, int(-2.5*2**NFrac)], [int(-2*2**NFrac), int(-2.5*2**NFrac), 0]], dtype=np.int32)

# constant definition
Kf = 2  # Common value, but can be tuned
print(Kf)
K = int(Kf*2**NFrac)
print(K)
ptf = 0
deltaTf = 0.004  #The algorithm is stable when deltaT < 0.5
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
avg = avg / (numberSpin)

shiftVect = np.int32(NFrac) * np.ones((1,numberSpin), dtype=np.int32)

print(avg)
Deltaf = avg * Kf * 0.5
#Deltaf = 10*0.07 / (math.sqrt(numberSpin) * JMatrixf.std())
print(Deltaf)
Delta = int(Deltaf*2**NFrac)
print(Delta)
xif = Kf * 0.5
#xif = 0.07 / (math.sqrt(numberSpin) * JMatrixf.std())
print(xif)
xi = int(xif*2**NFrac)
print(xi)

xVectorf = np.matrix([0, 0, 0])
xVector = np.matrix([0, 0, 0], dtype=np.int32)
# xVector =np.random.choice([-0.1, 0.1] , size=(1, numberSpin))
yVectorf = np.matrix([0, 0, random.choice([-0.1, +0.1])])
yVector = np.matrix([0, 0, np.int32(random.choice([-0.1 * 2 ** NFrac, +0.1 * 2 ** NFrac]))], dtype=np.int32)
pt = 0
ptf = 0
A0 = 0
A0f = 0


J21 = int(JMatrix.item(1, 0)*xi >> NFrac)
if J21 < 0:
    J21 = 2 ** NBit + J21

J31 = int(JMatrix.item(2, 0)*xi >> NFrac)
if J31 < 0:
    J31 = 2 ** NBit + J31

J12 = int(JMatrix.item(0, 1)*xi >> NFrac)
if J12 < 0:
    J12 = 2 ** NBit + J12

J32 = int(JMatrix.item(2, 1)*xi >> NFrac)
if J32 < 0:
    J32 = 2 ** NBit + J32

J13 = int(JMatrix.item(0, 2)*xi >> NFrac)
if J13 < 0:
    J13 = 2 ** NBit + J13

J23 = int(JMatrix.item(1, 2)*xi >> NFrac)
if J23 < 0:
    J23 = 2 ** NBit + J23

HVectorf = np.matrix([10, 0, -3])
HVector = np.matrix([int(10*2**NFrac), 0, int(-3*2**NFrac)])

ParameterFile.write(format(J21, 'b').zfill(NBit) + "\n" + format(J31, 'b').zfill(NBit) + "\n" + format(J12, 'b').zfill(NBit)+ "\n" + format(J32, 'b').zfill(NBit) +  "\n" + format(J13, 'b').zfill(NBit) + "\n" + format(J23, 'b').zfill(NBit) + "\n")

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
    SumVect = ((xVector*((xi * JMatrix) >> shiftVect)) >> shiftVect)
    VerificationFile.write(format(xVector) + " " + format(JMatrix) + " " + format(xVector * JMatrix) + " " + format((xVector * JMatrix) >> shiftVect) + " " + format((((xVector * JMatrix) >> shiftVect) * xi)) + " " + format(((xVector * JMatrix) >> shiftVect * xi) >> shiftVect) + "\n")
    sum0 = int(SumVect.item(0))
    if sum0 < 0:
        sum0 = 2 ** NBit + sum0

    sum1 = int(SumVect.item(1))
    if sum1 < 0:
        sum1 = 2 ** NBit + sum1

    sum2 = int(SumVect.item(2))
    if sum2 < 0:
        sum2 = 2 ** NBit + sum2

    SumFile.write(format(sum0, 'b').zfill(NBit) + " " + format(sum1, 'b').zfill(NBit) + " " + format(sum2, 'b').zfill(
        NBit) + "\n")

    temp = xVector.copy()
    tempf = xVectorf.copy()
    xVectorf = np.add(xVectorf, Deltaf * yVectorf * deltaTf)
    xVector = np.add(xVector, ((Delta * yVector >> shiftVect) * deltaT) >> shiftVect)
    tempVectorf = np.add(np.add(Kf * np.power(xVectorf, 3), (Deltaf - ptf) * xVectorf), xif * tempf * JMatrixf)
    tempVectorf += 2 * xif * A0f * HVectorf
    tempVector = np.add(
        np.add(((np.multiply((np.multiply((K * xVector) >> shiftVect, xVector) >> shiftVect), xVector) >> shiftVect)),
               ((Delta - pt) * xVector) >> shiftVect), temp * ((JMatrix * xi) >> shiftVect) >> shiftVect)
    tempVector += (((((int(2 * 2 ** NFrac) * HVector) >> shiftVect) * xi) >> shiftVect) * A0) >> shiftVect
    yVectorf = np.subtract(yVectorf, tempVectorf * deltaTf)
    yVector = np.subtract(yVector, (tempVector * deltaT) >> shiftVect)
    ptf += 7 * Kf / numberSteps  # 100/numberSteps
    pt += (int(7 * 2 ** NFrac) * int((float(K) / float(2000)))) >> NFrac
    # pt += np.int32(0.014 * 2 ** NFrac)
    # ptf = ptf + 0.014  # 100/numberSteps
    solutionf = np.sign(xVectorf)
    solution = np.sign(xVector)
    print(temp * ((JMatrix * xi) >> shiftVect) >> shiftVect)

    valuef = np.add(np.matmul(np.matmul(solutionf, JMatrixf), np.transpose(solutionf)),
                    np.matmul(HVectorf, np.transpose(solutionf)))
    value = np.add(np.matmul(np.matmul(solution, JMatrix), np.transpose(solution)),
                   np.matmul(HVector, np.transpose(solution)))

    if ptf > (Deltaf + 4 * Kf):
        A0f = math.sqrt((ptf - Deltaf - 4 * Kf) / Kf) + 1
    else:
        A0f = 2 ** ((ptf - Deltaf - 4 * Kf) / Kf)

    if pt > (Delta + (int(4 * 2 ** NFrac) * K) >> NFrac):
        A0 = int((math.sqrt((pt - (Delta + (int(4 * 2 ** NFrac) * K) >> NFrac)) / K)) * 2 ** NFrac) + int(
            1 * 2 ** NFrac)
    else:
        A0 = int((2 ** ((pt - Delta - (int(4 * 2 ** NFrac) * K) >> NFrac) / K)) * 2 ** NFrac)