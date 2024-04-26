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


#obtained output X Y
nome_file_X_Y = "output_file_X_Y11.txt"

#opening input file
try:
	XYFile = open(nome_file_X_Y, 'r')
except:
	print("Error: it is not possible to open the file" + nome_file_X_Y + "\n")
	sys.exit()

# obtained output X Y
nome_file_X_Y_Exact = "InputX_Y11.txt"

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
X5_l = []
Y5_l = []
X6_l = []
Y6_l = []
X7_l = []
Y7_l = []
X8_l = []
Y8_l = []
X9_l = []
Y9_l = []
X10_l = []
Y10_l = []

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
X5_l_e = []
Y5_l_e = []
X6_l_e = []
Y6_l_e = []
X7_l_e = []
Y7_l_e = []
X8_l_e = []
Y8_l_e = []
X9_l_e = []
Y9_l_e = []
X10_l_e = []
Y10_l_e = []

i = 0

NFrac = 12
Nbit = NFrac + 13

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
	
	x5_to_convert = field[5]
	if x5_to_convert[0] == '1':
		x5 = int(x5_to_convert[1:], 2) - 2 ** (len(x5_to_convert) - 1)
	else:
		x5 = int(x5_to_convert[1:], 2)

	X5_l.append(x5 / 2 ** NFrac)
	
	x6_to_convert = field[6]
	if x6_to_convert[0] == '1':
		x6 = int(x6_to_convert[1:], 2) - 2 ** (len(x6_to_convert) - 1)
	else:
		x6 = int(x6_to_convert[1:], 2)

	X6_l.append(x6 / 2 ** NFrac)
	
	x7_to_convert = field[7]
	if x7_to_convert[0] == '1':
		x7 = int(x7_to_convert[1:], 2) - 2 ** (len(x7_to_convert) - 1)
	else:
		x7 = int(x7_to_convert[1:], 2)

	X7_l.append(x7 / 2 ** NFrac)
	
	x8_to_convert = field[8]
	if x8_to_convert[0] == '1':
		x8 = int(x8_to_convert[1:], 2) - 2 ** (len(x8_to_convert) - 1)
	else:
		x8 = int(x8_to_convert[1:], 2)

	X8_l.append(x8 / 2 ** NFrac)
	
	x9_to_convert = field[9]
	if x9_to_convert[0] == '1':
		x9 = int(x9_to_convert[1:], 2) - 2 ** (len(x9_to_convert) - 1)
	else:
		x9 = int(x9_to_convert[1:], 2)

	X9_l.append(x9 / 2 ** NFrac)
	
	x10_to_convert = field[10]
	if x10_to_convert[0] == '1':
		x10 = int(x10_to_convert[1:], 2) - 2 ** (len(x10_to_convert) - 1)
	else:
		x10 = int(x10_to_convert[1:], 2)

	X10_l.append(x10 / 2 ** NFrac)
	
	y0_to_convert = field[11]
	if y0_to_convert[0] == '1':
		y0 = int(y0_to_convert[1:], 2) - 2**(len(y0_to_convert)-1)
	else:
		y0 = int(y0_to_convert[1:], 2)
		
	Y0_l.append(y0/2 ** NFrac)
	
	y1_to_convert = field[12]
	if y1_to_convert[0] == '1':
		y1 = int(y1_to_convert[1:], 2) - 2**(len(y1_to_convert)-1)
	else:
		y1 = int(y1_to_convert[1:], 2)
		
	Y1_l.append(y1/2**NFrac)

	y2_to_convert = field[13]
	if y2_to_convert[0] == '1':
		y2 = int(y2_to_convert[1:], 2) - 2 ** (len(y2_to_convert) - 1)
	else:
		y2 = int(y2_to_convert[1:], 2)

	Y2_l.append(y2 / 2 ** NFrac)
	
	y3_to_convert = field[14]
	if y3_to_convert[0] == '1':
		y3 = int(y3_to_convert[1:], 2) - 2 ** (len(y3_to_convert) - 1)
	else:
		y3 = int(y3_to_convert[1:], 2)

	Y3_l.append(y3 / 2 ** NFrac)
	
	y4_to_convert = field[15]
	if y4_to_convert[0] == '1':
		y4 = int(y4_to_convert[1:], 2) - 2 ** (len(y4_to_convert) - 1)
	else:
		y4 = int(y4_to_convert[1:], 2)

	Y4_l.append(y4 / 2 ** NFrac)
	
	y5_to_convert = field[16]
	if y5_to_convert[0] == '1':
		y5 = int(y5_to_convert[1:], 2) - 2 ** (len(y5_to_convert) - 1)
	else:
		y5 = int(y5_to_convert[1:], 2)

	Y5_l.append(y5 / 2 ** NFrac)
	
	
	y6_to_convert = field[17]
	if y6_to_convert[0] == '1':
		y6 = int(y6_to_convert[1:], 2) - 2 ** (len(y6_to_convert) - 1)
	else:
		y6 = int(y6_to_convert[1:], 2)

	Y6_l.append(y6 / 2 ** NFrac)
	
	y7_to_convert = field[18]
	if y7_to_convert[0] == '1':
		y7 = int(y7_to_convert[1:], 2) - 2 ** (len(y7_to_convert) - 1)
	else:
		y7 = int(y7_to_convert[1:], 2)

	Y7_l.append(y7 / 2 ** NFrac)
	
	y8_to_convert = field[19]
	if y8_to_convert[0] == '1':
		y8 = int(y8_to_convert[1:], 2) - 2 ** (len(y8_to_convert) - 1)
	else:
		y8 = int(y8_to_convert[1:], 2)

	Y8_l.append(y8 / 2 ** NFrac)
	
	y9_to_convert = field[20]
	if y9_to_convert[0] == '1':
		y9 = int(y9_to_convert[1:], 2) - 2 ** (len(y9_to_convert) - 1)
	else:
		y9 = int(y9_to_convert[1:], 2)

	Y9_l.append(y9 / 2 ** NFrac)
	
	y10_to_convert = field[21]
	if y10_to_convert[0] == '1':
		y10 = int(y10_to_convert[1:], 2) - 2 ** (len(y10_to_convert) - 1)
	else:
		y10 = int(y10_to_convert[1:], 2)

	Y10_l.append(y10 / 2 ** NFrac)
	
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
	
	x5_to_convert2 = field2[5]
	if x5_to_convert2[0] == '1':
		x52 = int(x5_to_convert2[1:], 2) - 2 ** (len(x5_to_convert2) - 1)
	else:
		x52 = int(x5_to_convert2[1:], 2)

	X5_l_e.append(x52 / 2 ** NFrac)
	
	x6_to_convert2 = field2[6]
	if x6_to_convert2[0] == '1':
		x62 = int(x1_to_convert2[1:], 2) - 2 ** (len(x6_to_convert2) - 1)
	else:
		x62 = int(x6_to_convert2[1:], 2)

	X6_l_e.append(x62 / 2 ** NFrac)

	x7_to_convert2 = field2[7]
	if x7_to_convert2[0] == '1':
		x72 = int(x7_to_convert2[1:], 2) - 2 ** (len(x7_to_convert2) - 1)
	else:
		x72 = int(x7_to_convert2[1:], 2)

	X7_l_e.append(x72 / 2 ** NFrac)

	x8_to_convert2 = field2[8]
	if x8_to_convert2[0] == '1':
		x82 = int(x8_to_convert2[1:], 2) - 2 ** (len(x8_to_convert2) - 1)
	else:
		x82 = int(x8_to_convert2[1:], 2)

	X8_l_e.append(x82 / 2 ** NFrac)

	x9_to_convert2 = field2[9]
	if x9_to_convert2[0] == '1':
		x92 = int(x9_to_convert2[1:], 2) - 2 ** (len(x9_to_convert2) - 1)
	else:
		x92 = int(x9_to_convert2[1:], 2)

	X9_l_e.append(x92 / 2 ** NFrac)
	
	x10_to_convert2 = field2[10]
	if x10_to_convert2[0] == '1':
		x102 = int(x10_to_convert2[1:], 2) - 2 ** (len(x10_to_convert2) - 1)
	else:
		x102 = int(x10_to_convert2[1:], 2)

	X10_l_e.append(x102 / 2 ** NFrac)

	y0_to_convert2 = field2[11]
	if y0_to_convert2[0] == '1':
		y02 = int(y0_to_convert2[1:], 2) - 2 ** (len(y0_to_convert2) - 1)
	else:
		y02 = int(y0_to_convert2[1:], 2)

	Y0_l_e.append(y02 / 2 ** NFrac)

	y1_to_convert2 = field2[12]
	if y1_to_convert2[0] == '1':
		y12 = int(y1_to_convert2[1:], 2) - 2 ** (len(y1_to_convert2) - 1)
	else:
		y12 = int(y1_to_convert2[1:], 2)

	Y1_l_e.append(y12 / 2 ** NFrac)

	y2_to_convert2 = field2[13]
	if y2_to_convert2[0] == '1':
		y22 = int(y2_to_convert2[1:], 2) - 2 ** (len(y2_to_convert2) - 1)
	else:
		y22 = int(y2_to_convert2[1:], 2)

	Y2_l_e.append(y22 / 2 ** NFrac)

	y3_to_convert2 = field2[14]
	if y3_to_convert2[0] == '1':
		y32 = int(y3_to_convert2[1:], 2) - 2 ** (len(y3_to_convert2) - 1)
	else:
		y32 = int(y3_to_convert2[1:], 2)

	Y3_l_e.append(y32 / 2 ** NFrac)

	y4_to_convert2 = field2[15]
	if y4_to_convert2[0] == '1':
		y42 = int(y4_to_convert2[1:], 2) - 2 ** (len(y4_to_convert2) - 1)
	else:
		y42 = int(y4_to_convert2[1:], 2)

	Y4_l_e.append(y42 / 2 ** NFrac)
	
	y5_to_convert2 = field2[16]
	if y5_to_convert2[0] == '1':
		y52 = int(y5_to_convert2[1:], 2) - 2 ** (len(y5_to_convert2) - 1)
	else:
		y52 = int(y5_to_convert2[1:], 2)

	Y5_l_e.append(y52 / 2 ** NFrac)
	
	y6_to_convert2 = field2[17]
	if y6_to_convert2[0] == '1':
		y62 = int(y6_to_convert2[1:], 2) - 2 ** (len(y6_to_convert2) - 1)
	else:
		y62 = int(y6_to_convert2[1:], 2)

	Y6_l_e.append(y62 / 2 ** NFrac)

	y7_to_convert2 = field2[18]
	if y7_to_convert2[0] == '1':
		y72 = int(y7_to_convert2[1:], 2) - 2 ** (len(y7_to_convert2) - 1)
	else:
		y72 = int(y7_to_convert2[1:], 2)

	Y7_l_e.append(y72 / 2 ** NFrac)

	y8_to_convert2 = field2[19]
	if y8_to_convert2[0] == '1':
		y82 = int(y8_to_convert2[1:], 2) - 2 ** (len(y8_to_convert2) - 1)
	else:
		y82 = int(y8_to_convert2[1:], 2)

	Y8_l_e.append(y82 / 2 ** NFrac)

	y9_to_convert2 = field2[20]
	if y9_to_convert2[0] == '1':
		y92 = int(y9_to_convert2[1:], 2) - 2 ** (len(y9_to_convert2) - 1)
	else:
		y92 = int(y9_to_convert2[1:], 2)

	Y9_l_e.append(y92 / 2 ** NFrac)
	
	y10_to_convert2 = field2[21]
	if y10_to_convert2[0] == '1':
		y102 = int(y10_to_convert2[1:], 2) - 2 ** (len(y10_to_convert2) - 1)
	else:
		y102 = int(y10_to_convert2[1:], 2)

	Y10_l_e.append(y102 / 2 ** NFrac)

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

		if x5 != x52:
			print("In iteration " + format(i) + "problem with x5. Obtain " + format(x5) + " instead of " + format(x52))
			
		if x6 != x62:
			print("In iteration " + format(i) + "problem with x6. Obtain " + format(x6) + " instead of " + format(x62))

		if x7 != x72:
			print("In iteration " + format(i) + "problem with x7. Obtain " + format(x7) + " instead of " + format(x72))

		if x8 != x82:
			print("In iteration " + format(i) + "problem with x8. Obtain " + format(x8) + " instead of " + format(x82))

		if x9 != x92:
			print("In iteration " + format(i) + "problem with x9. Obtain " + format(x9) + " instead of " + format(x92))

		if x10!= x102:
			print("In iteration " + format(i) + "problem with x5. Obtain " + format(x10) + " instead of " + format(x102))
        
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
			
		
		if y5 != y52:
			print("In iteration " + format(i) + "problem with y5. Obtain " + format(y5) + " instead of " + format(y52))
			
		if y6 != y62:
			print("In iteration " + format(i) + "problem with y6. Obtain " + format(y6) + " instead of " + format(y62))

		if y7 != y72:
			print("In iteration " + format(i) + "problem with y7. Obtain " + format(y7) + " instead of " + format(y72))

		if y8 != y82:
			print("In iteration " + format(i) + "problem with y8. Obtain " + format(y8) + " instead of " + format(y82))

		if y9 != y92:
			print("In iteration " + format(i) + "problem with y9. Obtain " + format(y9) + " instead of " + format(y92))
			
		
		if y10 != y102:
			print("In iteration " + format(i) + "problem with y10. Obtain " + format(y10) + " instead of " + format(y102))
			
		

		print("\n")

		i = i + 1


plt.plot(time, X0_l, linewidth=2.0, color='r', label=r'\textit{x0}')
plt.plot(time, X1_l, linewidth=2.0, color='b', label=r'\textit{x1}')
plt.plot(time, X2_l, linewidth=2.0, color='g', label=r'\textit{x2}')
plt.plot(time, X3_l, linewidth=2.0, color='c', label=r'\textit{x3}')
plt.plot(time, X4_l, linewidth=2.0, color='m', label=r'\textit{x4}')
plt.plot(time, X5_l, linewidth=2.0, color='y', label=r'\textit{x5}')
plt.plot(time, X6_l, linewidth=2.0, color=colors['blueviolet'], label=r'\textit{x6}')
plt.plot(time, X7_l, linewidth=2.0, color=colors['lightblue'], label=r'\textit{x7}')
plt.plot(time, X8_l, linewidth=2.0, color=colors['pink'], label=r'\textit{x8}')
plt.plot(time, X9_l, linewidth=2.0,color=colors['orange'], label=r'\textit{x9}')
plt.plot(time, X10_l, linewidth=2.0, color=colors['greenyellow'], label=r'\textit{x10}')
plt.title(r'\textbf{Adiabatic Bifurcation}', fontsize=20)
plt.xlabel(r'\textit{t}', fontsize=20)
plt.ylabel(r'\textit{x(t)}', fontsize=20)
leg = plt.legend(loc='upper left',bbox_to_anchor=(1.05, 1.0),frameon=True, fontsize=8)
plt.tight_layout()
plt.grid(True)
plt.savefig('X11Spin_herdware.png', format='png', bbox_inches='tight')
plt.savefig('X11Spin_herdware.eps', format='eps', bbox_inches='tight')
plt.show()
		
	
	