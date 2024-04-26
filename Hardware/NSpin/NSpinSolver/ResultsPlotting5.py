import numpy as np
import random
import math
import sys
import matplotlib.pyplot as plt
from matplotlib import rc

rc('text', usetex=True)
plt.rc('text', usetex=True)


#obtained output X Y
nome_file_X_Y = "output_file_X_Y5.txt"

#opening input file
try:
	XYFile = open(nome_file_X_Y, 'r')
except:
	print("Error: it is not possible to open the file" + nome_file_X_Y + "\n")
	sys.exit()

# obtained output X Y
nome_file_X_Y_Exact = "InputX_Y5.txt"

# opening input file
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
X2_l = []
Y2_l = []
X3_l = []
Y3_l = []
X4_l = []
Y4_l = []

X0_l_e = []
Y0_l_e = []
X1_l_e = []
Y1_l_e = []
X2_l_e = []
Y2_l_e = []
X3_l_e = []
Y3_l_e = []
X4_l_e = []
Y4_l_e = []

i = 0

NFrac = 9
Nbit = NFrac + 11

print("Untill here all ok\n")
for line in XYFile:
	l = line[:-1]
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

	x2_to_convert = field[2]
	if x2_to_convert[0] == '1':
		x2 = int(x2_to_convert[1:], 2) - 2 ** (len(x2_to_convert) - 1)
	else:
		x2 = int(x2_to_convert[1:], 2)

	X2_l.append(x2 / 2 ** NFrac)
	
	x3_to_convert = field[3]
	if x3_to_convert[0] == '1':
		x3 = int(x3_to_convert[1:], 2) - 2 ** (len(x3_to_convert) - 1)
	else:
		x3 = int(x3_to_convert[1:], 2)

	X3_l.append(x3 / 2 ** NFrac)
	
	x4_to_convert = field[4]
	if x4_to_convert[0] == '1':
		x4 = int(x4_to_convert[1:], 2) - 2 ** (len(x4_to_convert) - 1)
	else:
		x4 = int(x4_to_convert[1:], 2)

	X4_l.append(x4 / 2 ** NFrac)
	
	y0_to_convert = field[5]
	if y0_to_convert[0] == '1':
		y0 = int(y0_to_convert[1:], 2) - 2**(len(y0_to_convert)-1)
	else:
		y0 = int(y0_to_convert[1:], 2)
		
	Y0_l.append(y0/2 ** NFrac)
	
	y1_to_convert = field[6]
	if y1_to_convert[0] == '1':
		y1 = int(y1_to_convert[1:], 2) - 2**(len(y1_to_convert)-1)
	else:
		y1 = int(y1_to_convert[1:], 2)
		
	Y1_l.append(y1/2**NFrac)

	y2_to_convert = field[7]
	if y2_to_convert[0] == '1':
		y2 = int(y2_to_convert[1:], 2) - 2 ** (len(y2_to_convert) - 1)
	else:
		y2 = int(y2_to_convert[1:], 2)

	Y2_l.append(y2 / 2 ** NFrac)
	
	y3_to_convert = field[8]
	if y3_to_convert[0] == '1':
		y3 = int(y3_to_convert[1:], 2) - 2 ** (len(y3_to_convert) - 1)
	else:
		y3 = int(y3_to_convert[1:], 2)

	Y3_l.append(y3 / 2 ** NFrac)
	
	y4_to_convert = field[9]
	if y4_to_convert[0] == '1':
		y4 = int(y4_to_convert[1:], 2) - 2 ** (len(y4_to_convert) - 1)
	else:
		y4 = int(y4_to_convert[1:], 2)

	Y4_l.append(y4 / 2 ** NFrac)
	
	time.append(i)
	i = i+1

	line2 = XYFileExact.readline()
	l2 = line2[:-1]
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

	x2_to_convert2 = field2[2]
	if x2_to_convert2[0] == '1':
		x22 = int(x2_to_convert2[1:], 2) - 2 ** (len(x2_to_convert2) - 1)
	else:
		x22 = int(x2_to_convert2[1:], 2)

	X2_l_e.append(x22 / 2 ** NFrac)

	x3_to_convert2 = field2[3]
	if x3_to_convert2[0] == '1':
		x32 = int(x3_to_convert2[1:], 2) - 2 ** (len(x3_to_convert2) - 1)
	else:
		x32 = int(x3_to_convert2[1:], 2)

	X3_l_e.append(x32 / 2 ** NFrac)

	x4_to_convert2 = field2[4]
	if x4_to_convert2[0] == '1':
		x42 = int(x4_to_convert2[1:], 2) - 2 ** (len(x4_to_convert2) - 1)
	else:
		x42 = int(x4_to_convert2[1:], 2)

	X4_l_e.append(x42 / 2 ** NFrac)

	y0_to_convert2 = field2[5]
	if y0_to_convert2[0] == '1':
		y02 = int(y0_to_convert2[1:], 2) - 2 ** (len(y0_to_convert2) - 1)
	else:
		y02 = int(y0_to_convert2[1:], 2)

	Y0_l_e.append(y02 / 2 ** NFrac)

	y1_to_convert2 = field2[6]
	if y1_to_convert2[0] == '1':
		y12 = int(y1_to_convert2[1:], 2) - 2 ** (len(y1_to_convert2) - 1)
	else:
		y12 = int(y1_to_convert2[1:], 2)

	Y1_l_e.append(y12 / 2 ** NFrac)

	y2_to_convert2 = field2[7]
	if y2_to_convert2[0] == '1':
		y22 = int(y2_to_convert2[1:], 2) - 2 ** (len(y2_to_convert2) - 1)
	else:
		y22 = int(y2_to_convert2[1:], 2)

	Y2_l_e.append(y22 / 2 ** NFrac)

	y3_to_convert2 = field2[8]
	if y3_to_convert2[0] == '1':
		y32 = int(y3_to_convert2[1:], 2) - 2 ** (len(y3_to_convert2) - 1)
	else:
		y32 = int(y3_to_convert2[1:], 2)

	Y3_l_e.append(y32 / 2 ** NFrac)

	y4_to_convert2 = field2[9]
	if y4_to_convert2[0] == '1':
		y42 = int(y4_to_convert2[1:], 2) - 2 ** (len(y4_to_convert2) - 1)
	else:
		y42 = int(y4_to_convert2[1:], 2)

	Y4_l_e.append(y42 / 2 ** NFrac)

	if line != line2 :
		if x0 != x02:
			print("In iteration " + format(i) + " problem with x0. Obtain " + format(x0) + " instead of " + format(x02))

		if x1 != x12:
			print("In iteration " + format(i) + "problem with x1. Obtain " + format(x1) + " instead of " + format(x12))

		if x2 != x22:
			print("In iteration " + format(i) + "problem with x2. Obtain " + format(x2) + " instead of " + format(x22))

		if x3 != x32:
			print("In iteration " + format(i) + "problem with x3. Obtain " + format(x3) + " instead of " + format(x32))

		if x4 != x42:
			print("In iteration " + format(i) + "problem with x4. Obtain " + format(x4) + " instead of " + format(x42))

		if y0 != y02:
			print("In iteration " + format(i) + "problem with y0. Obtain " + format(y0) + " instead of " + format(y02))

		if y1 != y12:
			print("In iteration " + format(i) + "problem with y1. Obtain " + format(y1) + " instead of " + format(y12))

		if y2 != y22:
			print("In iteration " + format(i) + "problem with y2. Obtain " + format(y2) + " instead of " + format(y22))

		if y3 != y32:
			print("In iteration " + format(i) + "problem with y3. Obtain " + format(y3) + " instead of " + format(y32))

		if y4 != y42:
			print("In iteration " + format(i) + "problem with y4. Obtain " + format(y4) + " instead of " + format(y42))

		print("\n")

		i = i + 1


plt.plot(time, X0_l, linewidth=2.0, color='r', label=r'\textit{x0}')
plt.plot(time, X1_l, linewidth=2.0, color='b', label=r'\textit{x1}')
plt.plot(time, X2_l, linewidth=2.0, color='g', label=r'\textit{x2}')
plt.plot(time, X3_l, linewidth=2.0, color='c', label=r'\textit{x3}')
plt.plot(time, X4_l, linewidth=2.0, color='m', label=r'\textit{x4}')
plt.title(r'\textbf{Adiabatic Bifurcation}', fontsize=20)
plt.xlabel(r'\textit{t}', fontsize=20)
plt.ylabel(r'\textit{x0(t), x1(t), x2(t), x3(t), x4(t)}', fontsize=20)
leg = plt.legend(loc='upper left',bbox_to_anchor=(1.05, 1.0),frameon=True, fontsize=15)
plt.tight_layout()
plt.grid(True)
plt.savefig('X5Spin_herdware.png', format='png', bbox_inches='tight')
plt.savefig('X5Spin_herdware.eps', format='eps', bbox_inches='tight')

plt.show()
		
	
	