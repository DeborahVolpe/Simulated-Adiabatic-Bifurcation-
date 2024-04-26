import sys
import math

nome_file_in = "input_file.txt"

# opening of the data input at the simulation
try:
	file_input = open(nome_file_in, 'r')
except:
	print("errore impossibile aprire il file" + nome_file_in + "\n")
	sys.exit()

nome_file_log = "log.txt"

# log.txt file reports error
try:
	file_log = open(nome_file_log, 'w')
except:
	print("impossibile aprire il file" + nome_file_log + "\n")
	sys.exit()


nome_file_out = "output_file.txt"

# opening files produced by the simulation
try:
	file_out = open(nome_file_out, 'r')
except:
	print("impossibile aprire il file" + nome_file_out + "\n")
	sys.exit()

# I put the number of errors to zero
n_errori = 0

# I scroll through the input file
for line in file_input:
	#I extract the input and convert it to decimal
	P_int = int(line[:-1], base = 2)
	# expected output calculation
	U_expect = int(math.floor(math.sqrt(P_int)))
	R_expect = P_int - U_expect**2
	# read output file line
	line_out = file_out.readline()
	res = line_out.split()
	# conversion output to decimal
	U = int(res[0], base = 2)
	R = int(res[1], base = 2)
	# error check
	if U != U_expect or R != R_expect:
		n_errori +=1
		file_log.write("Errore con input " + line + " output ottenuto: " + line_out + " output atteso: " + format(U_expect, 'b').zfill(16) + " " + format(R_expect, 'b').zfill(18) + "\n")		
	

# if there are no errors, I write to the log file
if n_errori == 0:
	file_log.write("nessun errore\n")

# close all files
file_log.close()
file_out.close()
file_input.close()




