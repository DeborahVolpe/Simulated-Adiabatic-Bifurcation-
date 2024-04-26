import random
import sys
import math

# apro il file di input
nome_file_in = "input_file14.txt"

try:
	file_input = open(nome_file_in, 'r')
except:
	print("errore impossibile aprire il file" + nome_file_in + "\n")
	sys.exit()

# apre il log file
nome_file_log = "log.txt"

try:
	file_log = open(nome_file_log, 'w')
except:
	print("impossibile aprire il file" + nome_file_log + "\n")
	sys.exit()

# apro i due file prodotti dalla simulazione
nome_file_out = "output_file14.txt"

try:
	file_out = open(nome_file_out, 'r')
except:
	print("impossibile aprire il file " + nome_file_out + "\n")
	sys.exit()

# metto a zero il numero di errori
n_errori = 0
flag = False
nPipe = 4
nline = 0
# per il numero di righe dei due file di output
for line in file_input:
	P_int = int(line[:-1], base = 2)
	U_expect = int(math.floor(math.sqrt(P_int)))
	R_expect = P_int - U_expect**2
	# leggo le righe dei file di output
	if flag == False:
		for i in range(nPipe):
			line_out = file_out.readline()
			res = line_out.split()
		flag = True

	line_out = file_out.readline()
	res = line_out.split()
	nline += 1

	U = int(res[0], base = 2)
	R = int(res[1], base = 2)
	inv = int(res[2])
	if (U != U_expect or R != R_expect) and inv == 0 :
		n_errori +=1
		print("New")
		print(P_int)
		print(R)
		print(U)
		print(inv)
		print(U_expect)
		print(R_expect)
		file_log.write("Errore con input " + line[:-1] + " output ottenuto: " + line_out + " output atteso: " + format(U_expect, 'b').zfill(7) + " " + format(R_expect, 'b').zfill(8) + "\n")

# se non ci sono errori, scrivo sul file di log
if n_errori == 0:
	file_log.write("nessun errore\n")

# chiusura tutti i file
file_log.close()
file_out.close()
file_input.close()




