import numpy as np
import random
import math
import matplotlib.pyplot as plt
from matplotlib import rc

rc('text', usetex=True)
plt.rc('text', usetex=True)

# Number of spin
numberSpin = 2

# Number of steps
numberSteps = 200

# Adiacent Matrix
JMatrix = np.matrix([[0, 1], [1, 0]])


# H vector
HVector = np.matrix([0, 0])

# constant definition
K = 1#2# Common value, but can be tuned
Delta = 0.5#10*0.07 / (math.sqrt(numberSpin) * JMatrix.std()) #0.23# Common value, but can be tuned
deltaT = 0.5#The algorithm is stable when deltaT < 0.5
xi = 0.1#Delta * 0.7 / (math.sqrt(numberSpin) * JMatrix.std())#Delta * 0.07 / (math.sqrt(numberSpin) * JMatrix.std())

numTest = 100


# constant definition
#K = 2  # Common value, but can be tuned
#print(K)
#pt = 0
#deltaT = 0.004  #The algorithm is stable when deltaT < 0.5
#avg = 0
#for i in range(numberSpin):
#	Deltai = 0
#	for j in range(numberSpin):
#		Deltai += JMatrix.item((i, j))
#	avg += abs(Deltai)
#avg = avg / (numberSpin)

#print(avg)
#Delta = avg * K * 0.5
#print(Delta)
#xi = K * 0.5
#print(xi)



finalValues = []
x0Val = []
x1Val = []
asint1 = []
asint2 = []
asint3 = []
asint4 = []

Values = []
y0Val = []
y1Val = []
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

ptVal=[]


time = []

for j in range(numTest):
    # inizialization of x and y
    xVector = np.matrix([0,0], dtype=float)
    pt = 0
    yVector = np.matrix([0,random.choice([-0.1,0.1])], dtype=float)


    for i in range(numberSteps):
        xVector = np.add(xVector,Delta*yVector*deltaT)
        tempVector = np.add(np.add(K*np.power(xVector, 3), (Delta-pt)*xVector), xi*xVector*JMatrix)
        yVector = np.subtract(yVector,tempVector*deltaT)
        pt = pt + 0.01#*deltaT # 1/numberSteps#+ 0.06*deltaT #100/numberSteps
        solution = np.sign(xVector)
        value = np.matmul(np.matmul(xVector, JMatrix), np.transpose(xVector))

        if j == (numTest-1):
            time.append(i)
            ptVal.append(pt)

            x0Val.append(xVector[0, 0])
            x1Val.append(xVector[0, 1])

            y0Val.append(yVector[0, 0])
            y1Val.append(yVector[0, 1])
            Values.append(value[0, 0])
            t0.append((xi * xVector)[0, 0])
            t.append((xi*xVector*JMatrix)[0,0])
            t1.append(((Delta-pt)*xVector)[0,0])
            t2.append((K*np.power(xVector, 3))[0,0])
            t3.append((tempVector*deltaT)[0,0])
            t4.append((Delta*yVector*deltaT)[0,0])
            tb.append((xi*xVector*JMatrix)[0,1])
            t0b.append((xi * xVector)[0, 1])
            t1b.append(((Delta-pt)*xVector)[0,1])
            t2b.append((K*np.power(xVector, 3))[0,1])
            t3b.append((tempVector*deltaT)[0,1])
            t4b.append((Delta*yVector*deltaT)[0,1])

            if pt < (Delta-xi):
                asint1.append(0)
                asint2.append(0)
            else:
                asint1.append(math.sqrt((pt-Delta+xi)/K))
                asint2.append(-math.sqrt((pt - Delta + xi) / K))

            if pt < (Delta+xi):
                asint3.append(0)
                asint4.append(0)
            else:
                asint3.append(math.sqrt((pt-Delta-xi)/K))
                asint4.append(-math.sqrt((pt - Delta - xi) / K))

    finalValues.append(np.matmul(np.matmul(solution, JMatrix), np.transpose(solution))[0,0])


print(j)

print(len(finalValues))

plt.plot(time, x0Val, linewidth=2.0, color='b', label=r'\textit{x0}')
plt.plot(time, y0Val, linewidth=2.0, color='r', label=r'\textit{y0}')
plt.plot(time, x1Val, linewidth=2.0, color='c', label=r'\textit{x1}')
plt.plot(time, y1Val, linewidth=2.0, color='m', label=r'\textit{y1}')
plt.plot(time, asint1, linewidth=2.0, color='k', linestyle='dashed')
plt.plot(time, asint2, linewidth=2.0, color='k', linestyle='dashed')
plt.plot(time, asint3, linewidth=2.0, color='k', linestyle='dashed')
plt.plot(time, asint4, linewidth=2.0, color='k', linestyle='dashed')
#plt.title(r'\textbf{Simulated Adiabatic Bifurcation}',fontsize=20)
plt.xlabel(r'\textit{t}', fontsize=20)
plt.ylabel(r'\textit{x0(t), x1(t)}', fontsize=20)
leg = plt.legend(loc='upper left', frameon=True,fontsize=15)
#plt.grid(True)
plt.savefig('x0_x1_y0_y1_problem.eps', format='eps')
plt.savefig('x0_x1_y0_y1_problem.pdf', format='pdf')
plt.savefig('x0_x1_y0_y1_problem.png', format='png')
plt.show()


plt.plot(time, t, linewidth=2.0, color='b', label=r'\textit{xi*xVector*JMatrix}')
plt.plot(time, t0, linewidth=2.0, color='y', label=r'\textit{xi*xVector}')
plt.plot(time, t1, linewidth=2.0, color='r', label=r'\textit{(Delta-pt)*xVector}')
plt.plot(time, t2, linewidth=2.0, color='c', label=r'\textit{K*np.power(xVector, 3)}')
plt.plot(time, t3, linewidth=2.0, color='m', label=r'\textit{tempVector*deltaT}')
plt.plot(time, t4, linewidth=2.0, color='k', label=r'\textit{Delta*yVector*deltaT}')
plt.title(r'\textbf{Adiabatic Bifurcation}',fontsize=20)
plt.xlabel(r'\textit{t}', fontsize=20)
plt.ylabel(r'\textit{Variables}', fontsize=20)
leg = plt.legend(loc='upper left', frameon=True,fontsize=15)
#plt.grid(True)
plt.savefig('intermediate1.eps', format='eps')
plt.savefig('intermediate1.pdf', format='pdf')
plt.savefig('intermediate1.png', format='png')
plt.show()


plt.plot(time, tb, linewidth=2.0, color='b', label=r'\textit{xi*xVector*JMatrix}')
plt.plot(time, t0b, linewidth=2.0, color='y', label=r'\textit{xi*xVector}')
plt.plot(time, t1b, linewidth=2.0, color='r', label=r'\textit{(Delta-pt)*xVector}')
plt.plot(time, t2b, linewidth=2.0, color='c', label=r'\textit{K*np.power(xVector, 3)}')
plt.plot(time, t3b, linewidth=2.0, color='m', label=r'\textit{tempVector*deltaT}')
plt.plot(time, t4b, linewidth=2.0, color='k', label=r'\textit{Delta*yVector*deltaT}')
plt.title(r'\textbf{Adiabatic Bifurcation}',fontsize=20)
plt.xlabel(r'\textit{Number of iterations}', fontsize=20)
plt.ylabel(r'\textit{Variable}', fontsize=20)
leg = plt.legend(loc='upper left', frameon=True,fontsize=15)
plt.grid(True)
plt.savefig('intermediate2.eps', format='eps')
plt.savefig('intermediate2.pdf', format='pdf')
plt.savefig('intermediate2.png', format='png')
plt.show()


plt.plot(x0Val, y0Val, linewidth=2.0, color='b')
plt.show

plt.plot(time, x0Val, linewidth=2.0, color='b', label=r'\textit{x0}')
plt.plot(time, y0Val, linewidth=2.0, color='r', label=r'\textit{y0}')
plt.plot(time, asint1, linewidth=2.0, color='k', linestyle='dashed')
plt.plot(time, asint2, linewidth=2.0, color='k', linestyle='dashed')
plt.plot(time, asint3, linewidth=2.0, color='k', linestyle='dashed')
plt.plot(time, asint4, linewidth=2.0, color='k', linestyle='dashed')
#plt.title(r'\textbf{Adiabatic Bifurcation}',fontsize=20)
plt.xlabel(r'\textit{t}',fontsize=20)
plt.ylabel(r'\textit{x0(t), y0(t)}',fontsize=20)
leg = plt.legend(loc='upper left', frameon=True,fontsize=15)
#plt.grid(True)
plt.savefig('x0_y0.eps', format='eps')
plt.savefig('x0_y0.pdf', format='pdf')
plt.savefig('x0_y0.png', format='png')
plt.show()


plt.plot(time, x1Val, linewidth=2.0, color='c', label=r'\textit{x1}')
plt.plot(time, y1Val, linewidth=2.0, color='m', label=r'\textit{y1}')
plt.plot(time, asint1, linewidth=2.0, color='k', linestyle='dashed')
plt.plot(time, asint2, linewidth=2.0, color='k', linestyle='dashed')
plt.plot(time, asint3, linewidth=2.0, color='k', linestyle='dashed')
plt.plot(time, asint4, linewidth=2.0, color='k', linestyle='dashed')
plt.title(r'\textbf{Adiabatic Bifurcation}',fontsize=20)
plt.xlabel(r'\textit{t}',fontsize=20)
plt.ylabel(r'\textit{x1(t), y1(t)}',fontsize=20)
leg = plt.legend(loc='upper left', frameon=True,fontsize=15)
plt.grid(True)
plt.savefig('x1_y1.eps', format='eps')
plt.savefig('x1_y1.pdf', format='pdf')
plt.savefig('x1_y1.png', format='png')
plt.show()

plt.plot(time, ptVal, linewidth=2.0, color='b', label=r'\textit{p(t)}')
#plt.title(r'\textbf{Adiabatic Bifurcation}',fontsize=20)
plt.xlabel(r'\textit{t}',fontsize=20)
plt.ylabel(r'\textit{p(t)}',fontsize=20)
leg = plt.legend(loc='upper left', frameon=True,fontsize=15)
#plt.grid(True)
plt.savefig('p.eps', format='eps')
plt.savefig('p.pdf', format='pdf')
plt.savefig('p.png', format='png')
plt.show()


plt.plot(time, Values, linewidth=2.0, color='b')
#plt.title(r'\textbf{Adiabatic Bifurcation performance for maxCut problems}',fontsize=20)
plt.xlabel(r'\textit{t}',fontsize=20)
plt.ylabel(r'\textit{Value}', fontsize=20)
plt.grid(True)
plt.savefig('value.eps', format='eps')
plt.savefig('value.pdf', format='pdf')
plt.savefig('value.png', format='png')
plt.show()



n, bins, patches = plt.hist(finalValues, bins = 20)
plt.title(r'\textbf{Adiabatic  bifurcation values found occurrence}',fontsize=20)
plt.xlabel(r'\textit{Values obtained}',fontsize=20)
plt.ylabel(r'\textit{Occurrence}',fontsize=20)
plt.savefig('occurrence.eps', format='eps')
plt.savefig('occurrence.png', format='png')
plt.savefig('occurrence.pdf', format='pdf')
plt.show()