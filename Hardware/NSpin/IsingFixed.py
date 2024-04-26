import numpy as np
import random
import math
import matplotlib.pyplot as plt
from matplotlib import rc

rc('text', usetex=True)
plt.rc('text', usetex=True)

# Number of test on the algorithm
numTest = 100

# Number of spin
numberSpin = 3

NFrac = 9

# Number of steps
numberSteps = 50

# Adiacent Matrix
power = 2**NFrac
JMatrixf = np.matrix([[0, 1.5, 2], [1.5, 0, 2.5], [2, 2.5, 0]])
JMatrix = np.matrix([[0, int(1.5*power), int(2*power)], [int(1.5*power), 0, int(2.5*power)], [int(2*power), int(2.5*power), 0]], dtype=np.int32)
print(JMatrix)

# H vector
#HVector = np.matrix([0, 0, 0])

# constant definition
Kf = 1  # Common value, but can be tuned
print(Kf)
K = int(Kf*power)
print(K)
ptf = 0
temp = 0
for i in range(3):
    for j in range(3):
        temp += JMatrixf.item(i,j)**2
J_dev = math.sqrt(temp/(3*(2)))
deltaTf = 0.5 #The algorithm is stable when deltaT < 0.5
#deltaTf = 0.5#The algorithm is stable when deltaT < 0.5
print(deltaTf)
deltaT = int(deltaTf*2**NFrac)
print(deltaT)

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

JMatrixf_xi = np.matrix([[0, 1.5*xif, 2*xif], [1.5*xif, 0, 2.5*xif], [2*xif, 2.5*xif, 0]])
JMatrix_xi = np.matrix([[0, int(1.5*xif*2**NFrac), int(2*xif*2**NFrac)], [int(1.5*xif*2**NFrac), 0, int(2.5*xif*2**NFrac)], [int(2*xif*2**NFrac), int(2.5*xif*2**NFrac), 0]], dtype=np.int32)
shiftVect = np.int32(NFrac) * np.ones((1,numberSpin), dtype=np.int32)

finalValues = []
x0Val = []
x1Val = []
x2Val =[]
Valuesf = []

y0Val = []
y1Val = []
y2Val = []
p = []
pf = []
y0Temp = []
y1Temp = []

t = []
t0 = []
t1 = []
t2 = []
t3 = []
t4 =[]
t0b = []
tb = []
t1b = []
t2b = []
t3b = []
t4b =[]
t0c = []
tc = []
t1c = []
t2c = []
t3c = []
t4c =[]

finalValuesf = []
x0Valf = []
x1Valf = []
x2Valf =[]

y0Valf = []
y1Valf = []
y2Valf = []
tf = []
t0f = []
t1f = []
t2f = []
t3f = []
t4f =[]
t0bf = []
tbf = []
t1bf = []
t2bf = []
t3bf = []
t4bf =[]
t0cf = []
tcf = []
t1cf = []
t2cf = []
t3cf = []
t4cf =[]

Values = []


time = []

for j in range(numTest):
    # inizialization of x and y
    xVectorf = np.matrix([0,0,0])
    xVector = np.matrix([0,0, 0],dtype=np.int32)
    #xVector =np.random.choice([-0.1, 0.1] , size=(1, numberSpin))
    yVectorf =np.matrix([random.choice([-0.1, 0.1]), random.choice([-0.1, 0.1]), random.choice([-0.1, 0.1])])
    yVector =np.matrix([np.int32(random.choice([-0.1*2**NFrac, 0.1*2**NFrac])), np.int32(random.choice([-0.1*2**NFrac, 0.1*2**NFrac])), np.int32(random.choice([-0.1*2**NFrac, 0.1*2**NFrac]))],dtype=np.int32)
    pt = 0
    ptf = 0

    for i in range(numberSteps):
        xVectorf = np.add(xVectorf, Deltaf*yVectorf*deltaTf)
        xVector = np.add(xVector, (((Delta*yVector) >> shiftVect)*deltaT) >> shiftVect)
        tempVectorf = np.add(np.add(Kf*np.power(xVectorf, 3), (Deltaf-ptf)*xVectorf), xif*xVectorf*JMatrixf)
        tempVector = np.add(np.add(((np.multiply((np.multiply((K*xVector)>> shiftVect, xVector) >> shiftVect), xVector)>> shiftVect)), ((Delta - pt) * xVector) >> shiftVect), (xVector*JMatrix_xi) >> shiftVect)
        yVectorf = np.subtract(yVectorf,tempVectorf*deltaTf)
        yVector = np.subtract(yVector, (tempVector * deltaT) >> shiftVect)
        ptf += 1/20 #100/numberSteps
        pt += int((1/20)* 2 **NFrac) 
        #pt += np.int32(0.014 * 2 ** NFrac)
        #ptf = ptf + 0.014  # 100/numberSteps
        solutionf = np.sign(xVectorf)
        solution = np.sign(xVector)

        valuef = np.matmul(np.matmul(solution, JMatrixf), np.transpose(solution))
        value = np.matmul(np.matmul(solution, JMatrix), np.transpose(solution))


        if j == (numTest-1):
            time.append(i)

            x0Valf.append(xVectorf[0, 0])
            x1Valf.append(xVectorf[0, 1])
            x2Valf.append(xVectorf[0, 2])

            y0Valf.append(yVectorf[0, 0])
            y1Valf.append(yVectorf[0, 1])
            y2Valf.append(yVectorf[0, 2])
			
            x0Val.append(xVector[0, 0]/2**NFrac)
            x1Val.append(xVector[0, 1]/2**NFrac)
            x2Val.append(xVector[0, 2]/2**NFrac)

            y0Val.append(yVector[0, 0]/2**NFrac)
            y1Val.append(yVector[0, 1]/2**NFrac)
            y2Val.append(yVector[0, 2]/2**NFrac)
            Values.append(value[0, 0]/2**NFrac)
            y0Temp.append(tempVector[0, 0]/2**NFrac)
            y1Temp.append(tempVector[0, 1]/2 ** NFrac)
            t0.append(((xi*xVector) >> shiftVect)[0, 0]/2**NFrac)
            t.append((xVector*((JMatrix* xi) >> shiftVect) >> shiftVect)[0, 0]/2**NFrac)
            t1.append((((Delta - pt) * xVector) >> shiftVect)[0, 0]/2**NFrac)
            t2.append((np.multiply((np.multiply((K*xVector)>> shiftVect, xVector) >> shiftVect), xVector)>> shiftVect)[0, 0]/2**NFrac)
            t3.append(((tempVector * deltaT) >> shiftVect)[0, 0]/2**NFrac)
            t4.append((((Delta*yVector >> shiftVect)*deltaT) >> shiftVect)[0, 0]/2**NFrac)
            tb.append((xVector*((JMatrix* xi) >> shiftVect) >> shiftVect)[0, 1]/2**NFrac)
            t0b.append(((xi*xVector) >> shiftVect)[0, 1]/2**NFrac)
            t1b.append((((Delta - pt) * xVector) >> shiftVect)[0, 1]/2**NFrac)
            t2b.append((np.multiply((np.multiply((K*xVector)>> shiftVect, xVector) >> shiftVect), xVector)>> shiftVect)[0, 1]/2**NFrac)
            t3b.append(((tempVector * deltaT) >> shiftVect)[0, 1]/2**NFrac)
            t4b.append((((Delta*yVector >> shiftVect)*deltaT) >> shiftVect)[0, 1]/2**NFrac)
            tc.append((xVector*((JMatrix* xi) >> shiftVect) >> shiftVect)[0, 2]/2**NFrac)
            t0c.append(((xi*xVector) >> shiftVect)[0, 2]/2**NFrac)
            t1c.append((((Delta - pt) * xVector) >> shiftVect)[0, 2]/2**NFrac)
            t2c.append((np.multiply((np.multiply((K*xVector)>> shiftVect, xVector) >> shiftVect), xVector)>> shiftVect)[0, 2]/2**NFrac)
            t3c.append(((tempVector * deltaT) >> shiftVect)[0, 2]/2**NFrac)
            t4c.append((((Delta*yVector >> shiftVect)*deltaT) >> shiftVect)[0, 2]/2**NFrac)
            p.append(pt/2**NFrac)
            pf.append(ptf)
            Valuesf.append(valuef[0, 0])
            t0f.append((xif * xVectorf)[0, 0])
            tf.append((xif * xVectorf * JMatrixf)[0, 0])
            t1f.append(((Deltaf - ptf) * xVectorf)[0, 0])
            t2f.append((Kf * np.power(xVectorf, 3))[0, 0])
            t3f.append((tempVectorf * deltaTf)[0, 0])
            t4f.append((Deltaf * yVectorf * deltaTf)[0, 0])
            tbf.append((xif * xVectorf * JMatrixf)[0, 1])
            t0bf.append((xif * xVectorf)[0, 1])
            t1bf.append(((Deltaf - ptf) * xVectorf)[0, 1])
            t2bf.append((Kf * np.power(xVectorf, 3))[0, 1])
            t3bf.append((tempVectorf * deltaTf)[0, 1])
            t4bf.append((Deltaf * yVectorf * deltaTf)[0, 1])
            tcf.append((xif * xVectorf * JMatrixf)[0, 2])
            t0cf.append((xif * xVectorf)[0, 2])
            t1cf.append(((Deltaf - ptf) * xVectorf)[0, 2])
            t2cf.append((Kf * np.power(xVectorf, 3))[0, 2])
            t3cf.append((tempVectorf * deltaTf)[0, 2])
            t4cf.append((Deltaf * yVectorf * deltaTf)[0, 2])



    finalValuesf.append(valuef[0, 0])
    finalValues.append(value[0, 0]/2**NFrac)


plt.plot(time, x0Val, linewidth=2.0, color='r', label=r'\textit{x0}')
plt.plot(time, x0Valf, linewidth=2.0, color='r', linestyle='dashed', label=r'\textit{x0f}')
plt.plot(time, x1Val, linewidth=2.0, color='b', label=r'\textit{x1}')
plt.plot(time, x1Valf, linewidth=2.0, color='b', linestyle='dashed', label=r'\textit{x1f}')
plt.plot(time, x2Val, linewidth=2.0, color='g', label=r'\textit{x2}')
plt.plot(time, x2Valf, linewidth=2.0, color='g', linestyle='dashed', label=r'\textit{x2f}')
plt.title(r'\textbf{Adiabatic Bifurcation Fixed}', fontsize=20)
plt.xlabel(r'\textit{t}', fontsize=20)
plt.ylabel(r'\textit{x(t)}', fontsize=20)
leg = plt.legend(loc='upper left', frameon=True, fontsize=15)
plt.grid(True)
plt.savefig("3SpinXComparison.eps", format='eps', bbox_inches='tight')
plt.show()

plt.plot(time, y0Val, linewidth=2.0, color='r', label=r'\textit{y0}')
plt.plot(time, y0Valf, linewidth=2.0, color='r', linestyle='dashed', label=r'\textit{y0f}')
plt.plot(time, y1Val, linewidth=2.0, color='b', label=r'\textit{y1}')
plt.plot(time, y1Valf, linewidth=2.0, color='b', linestyle='dashed', label=r'\textit{y1f}')
plt.plot(time, y2Val, linewidth=2.0, color='g', label=r'\textit{y2}')
plt.plot(time, y2Valf, linewidth=2.0, color='g', linestyle='dashed', label=r'\textit{y2f}')
plt.title(r'\textbf{Adiabatic Bifurcation Fixed}', fontsize=20)
plt.xlabel(r'\textit{t}', fontsize=20)
plt.ylabel(r'\textit{y(t)}', fontsize=20)
leg = plt.legend(loc='upper left', frameon=True, fontsize=15)
plt.grid(True)
plt.savefig("3SpinY.eps", format='eps', bbox_inches='tight')
plt.show()

plt.plot(time, Values, linewidth=2.0, color='b', label=r'\textit{Fixed}')
plt.plot(time, Valuesf, linewidth=2.0, linestyle='dashed', color='b', label=r'\textit{Floating}')
plt.title(r'\textbf{Adiabatic Bifurcation Fixed}', fontsize=20)
plt.xlabel(r'\textit{t}', fontsize=20)
plt.ylabel(r'\textit{Value(t)}', fontsize=20)
leg = plt.legend(loc='upper left', frameon=True, fontsize=15)
plt.grid(True)
plt.savefig("3SpinValue.eps", format='eps', bbox_inches='tight')
plt.show()

plt.plot(time, t, linewidth=2.0, color='b', label=r'\textit{xi*xVector*JMatrix}')
plt.plot(time, t0, linewidth=2.0, color='y', label=r'\textit{xi*xVector}')
plt.plot(time, t1, linewidth=2.0, color='r', label=r'\textit{(Delta-pt)*xVector}')
plt.plot(time, t2, linewidth=2.0, color='c', label=r'\textit{K*np.power(xVector, 3)}')
plt.plot(time, t3, linewidth=2.0, color='m', label=r'\textit{tempVector*deltaT}')
plt.plot(time, t4, linewidth=2.0, color='k', label=r'\textit{Delta*yVector*deltaT}')
plt.plot(time, tf, linewidth=2.0, color='b', linestyle='dashed', label=r'\textit{xi*xVector*JMatrixf}')
plt.plot(time, t0f, linewidth=2.0, color='y', linestyle='dashed', label=r'\textit{xi*xVectorf}')
plt.plot(time, t1f, linewidth=2.0, color='r', linestyle='dashed', label=r'\textit{(Delta-pt)*xVectorf}')
plt.plot(time, t2f, linewidth=2.0, color='c', linestyle='dashed', label=r'\textit{K*np.power(xVector, 3)f}')
plt.plot(time, t3f, linewidth=2.0, color='m', linestyle='dashed', label=r'\textit{tempVector*deltaTf}')
plt.plot(time, t4f, linewidth=2.0, color='k', linestyle='dashed', label=r'\textit{Delta*yVector*deltaTf}')
plt.title(r'\textbf{Adiabatic Bifurcation Fixed}', fontsize=20)
plt.xlabel(r'\textit{t}', fontsize=20)
plt.ylabel(r'\textit{Variable(t)}', fontsize=20)
leg = plt.legend(loc='upper left', frameon=True, fontsize=15)
plt.grid(True)
plt.savefig("3SpinVariable.eps", format='eps', bbox_inches='tight')
plt.show()

plt.plot(time, tb, linewidth=2.0, color='b', label=r'\textit{xi*xVector*JMatrix}')
plt.plot(time, t0b, linewidth=2.0, color='y', label=r'\textit{xi*xVector}')
plt.plot(time, t1b, linewidth=2.0, color='r', label=r'\textit{(Delta-pt)*xVector}')
plt.plot(time, t2b, linewidth=2.0, color='c', label=r'\textit{K*np.power(xVector, 3)}')
plt.plot(time, t3b, linewidth=2.0, color='m', label=r'\textit{tempVector*deltaT}')
plt.plot(time, t4b, linewidth=2.0, color='k', label=r'\textit{Delta*yVector*deltaT}')
plt.plot(time, tbf, linewidth=2.0, color='b', linestyle='dashed', label=r'\textit{xi*xVector*JMatrixf}')
plt.plot(time, t0bf, linewidth=2.0, color='y', linestyle='dashed', label=r'\textit{xi*xVectorf}')
plt.plot(time, t1bf, linewidth=2.0, color='r', linestyle='dashed', label=r'\textit{(Delta-pt)*xVectorf}')
plt.plot(time, t2bf, linewidth=2.0, color='c', linestyle='dashed', label=r'\textit{K*np.power(xVector, 3)f}')
plt.plot(time, t3bf, linewidth=2.0, color='m', linestyle='dashed', label=r'\textit{tempVector*deltaTf}')
plt.plot(time, t4bf, linewidth=2.0, color='k', linestyle='dashed', label=r'\textit{Delta*yVector*deltaTf}')
plt.title(r'\textbf{Adiabatic Bifurcation Fixed}', fontsize=20)
plt.xlabel(r'\textit{t}', fontsize=20)
plt.ylabel(r'\textit{Variable(t)}', fontsize=20)
leg = plt.legend(loc='upper left', frameon=True, fontsize=15)
plt.grid(True)
plt.savefig("3SpinVariable2.eps", format='eps', bbox_inches='tight')
plt.show()

plt.plot(time, tc, linewidth=2.0, color='b', label=r'\textit{xi*xVector*JMatrix}')
plt.plot(time, t0c, linewidth=2.0, color='y', label=r'\textit{xi*xVector}')
plt.plot(time, t1c, linewidth=2.0, color='r', label=r'\textit{(Delta-pt)*xVector}')
plt.plot(time, t2c, linewidth=2.0, color='c', label=r'\textit{K*np.power(xVector, 3)}')
plt.plot(time, t3c, linewidth=2.0, color='m', label=r'\textit{tempVector*deltaT}')
plt.plot(time, t4c, linewidth=2.0, color='k', label=r'\textit{Delta*yVector*deltaT}')
plt.plot(time, tcf, linewidth=2.0, color='b', linestyle='dashed', label=r'\textit{xi*xVector*JMatrixf}')
plt.plot(time, t0cf, linewidth=2.0, color='y', linestyle='dashed', label=r'\textit{xi*xVectorf}')
plt.plot(time, t1cf, linewidth=2.0, color='r', linestyle='dashed', label=r'\textit{(Delta-pt)*xVectorf}')
plt.plot(time, t2cf, linewidth=2.0, color='c', linestyle='dashed', label=r'\textit{K*np.power(xVector, 3)f}')
plt.plot(time, t3cf, linewidth=2.0, color='m', linestyle='dashed', label=r'\textit{tempVector*deltaTf}')
plt.plot(time, t4cf, linewidth=2.0, color='k', linestyle='dashed', label=r'\textit{Delta*yVector*deltaTf}')
plt.title(r'\textbf{Adiabatic Bifurcation Fixed}', fontsize=20)
plt.xlabel(r'\textit{t}', fontsize=20)
plt.ylabel(r'\textit{Variable(t)}', fontsize=20)
leg = plt.legend(loc='upper left', frameon=True, fontsize=15)
plt.grid(True)
plt.savefig("3SpinVariable3.eps", format='eps', bbox_inches='tight')
plt.show()

plt.plot(time, p, linewidth=2.0, color='b', label=r'\textit{Fixed}')
plt.plot(time, pf, linewidth=2.0, color='b',  linestyle='dashed', label=r'\textit{Floating}')
plt.title(r'\textbf{Adiabatic Bifurcation Fixed}',fontsize=20)
plt.xlabel(r'\textit{t}',fontsize=20)
plt.ylabel(r'\textit{p}', fontsize=20)
plt.grid(True)
leg = plt.legend(loc='upper left', frameon=True, fontsize=15)
plt.savefig("3SpinP.eps", format='eps', bbox_inches='tight')
plt.show()



n, bins, patches = plt.hist(finalValues, bins = 100, label=r'\textit{Fixed}')
n, bins, patches = plt.hist(finalValuesf, bins = 100, label=r'\textit{Floating}')
plt.title(r'\textbf{Adiabatic Bifurcation Fixed}',fontsize=20)
plt.xlabel(r'\textit{Values obtained}',fontsize=20)
plt.ylabel(r'\textit{Occurrence}',fontsize=20)
leg = plt.legend(loc='upper right', frameon=True, fontsize=15)
plt.savefig("3SpinOccurrence.eps", format='eps', bbox_inches='tight')
plt.show()

#print(len(x0Val))
#print(len(time))





