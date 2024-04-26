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

# Number of steps
numberSteps = 50

# Adiacent Matrix
JMatrix = np.matrix([[0, 1.5, 2], [1.5, 0, 2.5], [2, 2.5, 0]])

# H vector
#HVector = np.matrix([0, 0, 0])

# constant definition
K = 1# Common value, but can be tuned

temp = 0
for i in range(3):
    for j in range(3):
        temp += JMatrix.item(i,j)**2
J_dev = math.sqrt(temp/(3*(2)))
Delta =1 # Common value, but can be tuned
xi = 0.5/(math.sqrt(3) * J_dev)
print(xi)
pt = 0
deltaT = 0.5#The algorithm is stable when deltaT < 0.5


finalValues = []
x0Val = []
x1Val = []
x2Val =[]
pVal = []
y0Val = []
y1Val = []
y2Val = []


time = []

for j in range(numTest):
    # inizialization of x and y
    xVector = np.matrix([0,0,0])
    #xVector =np.random.choice([-0.1, 0.1] , size=(1, numberSpin))
    yVector =np.matrix([random.choice([-0.1, 0.1]), random.choice([-0.1, 0.1]), random.choice([-0.1, 0.1])])

    pt = 0
    #yVector = np.matrix([0.1,0.1,0.1])

    #iteration = []
    #output = []

    for i in range(numberSteps):
        xVector = np.add(xVector, Delta*yVector*deltaT)
        tempVector = np.add(np.add(K*np.power(xVector, 3), (Delta-pt)*xVector), xi*xVector*JMatrix)
        yVector = np.subtract(yVector,tempVector*deltaT)
        pt = pt + 1/20  #100/numberSteps
        solution = np.sign(xVector)
        print(solution)
        print(xVector)
        #print(solution)
        value = np.matmul(np.matmul(solution, JMatrix), np.transpose(solution))
        #iteration.append(i)
        #output.append(value[0,0])

        #plt.plot(iteration, output)
        #plt.xlabel('Iteration')
        #plt.ylabel('Output')
        #plt.show()

        if j == (numTest-1):
            time.append(i)

            x0Val.append(xVector[0, 0])
            x1Val.append(xVector[0, 1])
            x2Val.append(xVector[0, 2])

            y0Val.append(yVector[0, 0])
            y1Val.append(yVector[0, 1])
            y2Val.append(yVector[0, 2])
            pVal.append(pt)

    finalValues.append(value[0, 0])


plt.plot(time, x0Val, linewidth=2.0, color='r', label=r'\textit{x0}')
plt.plot(time, x1Val, linewidth=2.0, color='b', label=r'\textit{x1}')
plt.plot(time, x2Val, linewidth=2.0, color='g', label=r'\textit{x2}')
plt.title(r'\textbf{Adiabatic Bifurcation}', fontsize=20)
plt.xlabel(r'\textit{t}', fontsize=20)
plt.ylabel(r'\textit{x0(t), x1(t), x2(t)}', fontsize=20)
leg = plt.legend(loc='upper left', frameon=True, fontsize=15)
plt.grid(True)
plt.savefig('x3Spin.eps', format='eps')
plt.show()

plt.plot(time, y0Val, linewidth=2.0, color='r', label=r'\textit{y0}')
plt.plot(time, y1Val, linewidth=2.0, color='b', label=r'\textit{y1}')
plt.plot(time, y2Val, linewidth=2.0, color='g', label=r'\textit{y2}')
plt.title(r'\textbf{Adiabatic Bifurcation}', fontsize=20)
plt.xlabel(r'\textit{t}', fontsize=20)
plt.ylabel(r'\textit{y0(t), y1(t), y2(t)}', fontsize=20)
leg = plt.legend(loc='upper left', frameon=True, fontsize=15)
plt.grid(True)
plt.savefig('y3SpinFixed.eps', format='eps')
plt.show()

n, bins, patches = plt.hist(finalValues, bins = 100)
plt.title(r'\textbf{Adiabatic  Bifurcation}',fontsize=20)
plt.xlabel(r'\textit{Values obtained}',fontsize=20)
plt.ylabel(r'\textit{Occurrence}',fontsize=20)
plt.savefig('occurrence3Spin.eps', format='eps')
plt.show()

plt.plot(time, pVal, linewidth=2.0, color='b')
#plt.title(r'\textbf{Adiabatic Bifurcation}', fontsize=20)
plt.xlabel(r'\textit{t}', fontsize=20)
plt.ylabel(r'\textit{p(t)}', fontsize=20)
#leg = plt.legend(loc='upper left', frameon=True, fontsize=15)
plt.grid(True)
plt.savefig('pt.png', format='png')
plt.show()





