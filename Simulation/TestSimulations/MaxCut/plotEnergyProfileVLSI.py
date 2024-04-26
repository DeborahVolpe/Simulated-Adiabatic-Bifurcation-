from create_Q_matrix import create_Q_matrix
import matplotlib.pyplot as plt
from qubovert.sim import anneal_quso, anneal_qubo
import numpy as np
from matplotlib import rc


def plotEnergyProfile(qubo, Print=False, fileName="", ProblemType=""):
    
    NVar, Q, offset = create_Q_matrix(qubo)
    if NVar > 20:
        print("The problem under analysis is too large\n\n")
        return False
    
    combination = range(2**NVar)
    Energy = []

    for i in combination:
        comb = format(i, 'b').zfill(NVar)
        sol = np.ones(NVar)
        for index in range(len(comb)):
            sol.itemset(index, int(comb[index]))
            
        Energy.append(np.matmul(sol, np.transpose(np.matmul(Q, np.transpose(sol)))) + offset)
        
    rc('text', usetex=True)
    plt.rc('text', usetex=True)

    plt.plot(combination,Energy, linewidth=2.0, color='b')
    plt.title(r'\textbf{' + ProblemType + '}', fontsize=20)
    plt.xlabel(r'\textit{Combinations}', fontsize=20)
    plt.ylabel(r'\textit{Energy}', fontsize=20)
    plt.tight_layout()
    #plt.grid(True)
    if Print:
        plt.savefig(fileName + ".eps", format='eps')
        plt.savefig(fileName + ".png", format='png')    
        plt.savefig(fileName + ".pdf", format='pdf')    
        plt.close()
    else:
        plt.show()