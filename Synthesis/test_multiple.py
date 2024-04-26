import numpy as np
import math
import matplotlib.pyplot as plt
import random
from matplotlib import rc
import time
import os
import sys
from numpy.random import randint
import neal
import subprocess
from LanchMySynthesis import Synthesis


NSpins =range(28, 40)#range(3, 40)
NBits = range(16, 24, 4)

for NSpin in NSpins:
    for NBit in NBits: 
        print("Start Speed sythesis for " + format(NBit) + " bits and " + format(NSpin) + "...\n")
        PathSpeed = r'./NSpin/NSpinSolver/ProgettiNuovi/Speed/SpinMachine' + format(NBit) + "_" + format(NSpin) + "/"
        Sythetizer = Synthesis()
        Sythetizer.QuartusSynthesis(NumberOfBits=NBit, NumberOfSpin=NSpin, TypeOfCompilation="S", path=PathSpeed)
        print("Finish Speed sythesis for " + format(NBit) + " bits and " + format(NSpin) + "\n")
        print("Start Balanced sythesis for " + format(NBit) + " bits and " + format(NSpin) + "...\n")
        PathBalanced = r'./NSpin/NSpinSolver/ProgettiNuovi/TradeOff/SpinMachine' + format(NBit) + "_" + format(NSpin) + "/"
        Sythetizer = Synthesis()
        Sythetizer.QuartusSynthesis(NumberOfBits=NBit, NumberOfSpin=NSpin, TypeOfCompilation="B", path=PathBalanced)
        print("Finish Balanced sythesis for " + format(NBit) + " bits and " + format(NSpin) + "\n")
        print("Start Area sythesis for " + format(NBit) + " bits and " + format(NSpin) + "...\n")
        PathArea = r'./NSpin/NSpinSolver/ProgettiNuovi/Area/SpinMachine' + format(NBit) + "_" + format(NSpin) + "/"
        Sythetizer = Synthesis()
        Sythetizer.QuartusSynthesis(NumberOfBits=NBit, NumberOfSpin=NSpin, TypeOfCompilation="A", path=PathArea)
        print("Finish Area sythesis for " + format(NBit) + " bits and " + format(NSpin) + "\n")
