#create work library
vlib work

source compile.do


#launch simulation
vsim -c work.tb

#run time from, to
run 20ms

#quit modelsim
quit -f

