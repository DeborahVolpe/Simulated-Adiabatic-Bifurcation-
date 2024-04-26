import random
import sys

nome_file_in = "input_file14.txt"

#opening input file
try:
	file_input = open(nome_file_in, 'w')
except:
	print("errore impossibile aprire il file" + nome_file_in + "\n")
	sys.exit()

#number of input combinations
N_data_test = 10000

for n in range (N_data_test):
	P = random.randrange(0, 2**14)
	P_str = format(P, 'b').zfill(14)
	file_input.write(P_str + "\n")

file_input.close()


	
