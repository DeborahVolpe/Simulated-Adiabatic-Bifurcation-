import numpy as np
import random
import math
import sys
import matplotlib.pyplot as plt
from matplotlib import rc

rc('text', usetex=True)
plt.rc('text', usetex=True)

#obtained output X Y
nome_file_X_Y = "output_file_X_Y.txt"

#opening input file
try:
	XYFile = open(nome_file_X_Y, 'r')
except:
	print("Error: it is not possible to open the file" + nome_file_X_Y + "\n")
	sys.exit()


#obtained output X Y
nome_file_X_Y_Exact = "InputX_Y.txt"

#opening input file
try:
	XYFileExact = open(nome_file_X_Y_Exact, 'r')
except:
	print("Error: it is not possible to open the file" + nome_file_X_Y_Exact + "\n")
	sys.exit()
	
time = []
X0_l = []
Y0_l = []
X1_l = []
Y1_l = []
X0_l_e = []
Y0_l_e = []
X1_l_e = []
Y1_l_e = []

i = 0

NFrac = 9
Nbit = NFrac + 5

print("Untill here all ok\n")
for line in XYFile:
	l = line[:-1]
	print(line)
	field = l.split(" ");
	x0_to_convert = field[0]
	if x0_to_convert[0] == '1':
		x0 = int(x0_to_convert[1:], 2) - 2**(len(x0_to_convert)-1)
	else:
		x0 = int(x0_to_convert[1:], 2)
		
	X0_l.append(x0/2**NFrac)
	
	x1_to_convert = field[1]
	if x1_to_convert[0] == '1':
		x1 = int(x1_to_convert[1:], 2) - 2**(len(x1_to_convert)-1)
	else:
		x1 = int(x1_to_convert[1:], 2)
		
	X1_l.append(x1/2**NFrac)
	
	y0_to_convert = field[2]
	if y0_to_convert[0] == '1':
		y0 = int(y0_to_convert[1:], 2) - 2**(len(y0_to_convert)-1)
	else:
		y0 = int(y0_to_convert[1:], 2)
		
	Y0_l.append(y0/2 ** NFrac)
	
	y1_to_convert = field[3]
	if y1_to_convert[0] == '1':
		y1 = int(y1_to_convert[1:], 2) - 2**(len(y1_to_convert)-1)
	else:
		y1 = int(y1_to_convert[1:], 2)
		
	Y1_l.append(y1/2**NFrac)
	
	time.append(i)
	i = i+1

for line2 in XYFileExact:
	l2 = line2[:-1]
	print(line2)
	field2 = l2.split(" ")
	x0_to_convert2 = field2[0]
	if x0_to_convert2[0] == '1':
		x02 = int(x0_to_convert2[1:], 2) - 2 ** (len(x0_to_convert2) - 1)
	else:
		x02 = int(x0_to_convert2[1:], 2)

	X0_l_e.append(x02 / 2 ** NFrac)

	x1_to_convert2 = field2[1]
	if x1_to_convert2[0] == '1':
		x12 = int(x1_to_convert2[1:], 2) - 2 ** (len(x1_to_convert2) - 1)
	else:
		x12 = int(x1_to_convert2[1:], 2)

	X1_l_e.append(x12 / 2 ** NFrac)

	y0_to_convert2 = field2[2]
	if y0_to_convert2[0] == '1':
		y02 = int(y0_to_convert2[1:], 2) - 2 ** (len(y0_to_convert2) - 1)
	else:
		y02 = int(y0_to_convert2[1:], 2)

	Y0_l_e.append(y02 / 2 ** NFrac)

	y1_to_convert2 = field2[3]
	if y1_to_convert2[0] == '1':
		y12 = int(y1_to_convert2[1:], 2) - 2 ** (len(y1_to_convert2) - 1)
	else:
		y12 = int(y1_to_convert2[1:], 2)

	Y1_l_e.append(y12 / 2 ** NFrac)



plt.plot(time, X0_l, linewidth=2.0, color='b', label=r'\textit{x0 hardware}')
plt.plot(time, Y0_l, linewidth=2.0, color='r', label=r'\textit{y0 hardware}')
plt.plot(time, X1_l, linewidth=2.0, color='c', label=r'\textit{x1 hardware}')
plt.plot(time, Y1_l, linewidth=2.0, color='m', label=r'\textit{y1 hardware}')
#plt.title("Adiabatic Bifurcation",fontsize=18)
plt.xlabel(r'\textit{t}', fontsize=20)
plt.ylabel(r'\textit{x0(t), y0(t), x1(t), y1(t)}', fontsize=20)
leg = plt.legend(loc='upper left', frameon=True,fontsize=10)
plt.savefig('x0_x1_y0_y1_h.eps', format='eps')
plt.savefig('x0_x1_y0_y1_h.pdf', format='pdf')
plt.savefig('x0_x1_y0_y1_h.png', format='png')
plt.show()
	
	