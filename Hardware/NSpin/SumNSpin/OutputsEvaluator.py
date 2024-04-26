import sys
import math

nameFileExpected = "InputSum.txt"
try:
	fileExpected = open(nameFileExpected, 'r')
except:
	print("Error: it is not possible to open the file " + nameFileExpected + "\n")
	sys.exit()
	
nameFileObtained = "output_file.txt"
try:
	fileObtained = open(nameFileObtained, 'r')
except:
	print("Error: it is not possible to open the file " + nameFileObtained + "\n")
	sys.exit()
	
nameLogFile = "Verification.log"
try:
	fileLog = open(nameLogFile, 'w')
except:
	print("Error: it is not possible to open the file " + nameLogFile + "\n")
	sys.exit()

	
iteration = 0
nerr = 0
	
for line in fileExpected:

	lineObtained = fileObtained.readline()
	fields = line[:-1].split(" ")
	fields2 = lineObtained[:-1].split(" ")
	if(fields[0] != fields2[0]):
		print("Problem on the first column\n")
	if(fields[1] != fields2[1]):
		print("Problem on the second column\n")
	if(fields[2]!=fields2[2]):
		print("Problem on the third column\n")
	if lineObtained[:-1] != line[:-1]:
		fileLog.write("In the iteration " + format(iteration) + " the output obtained is " + lineObtained[:-1] + ", instead of " + line)
		nerr += 1
		
	iteration+=1

if nerr == 0:
	fileLog.write("No Problem, all ok!!!\n")
fileExpected.close()
fileObtained.close()
fileLog.close()		
		