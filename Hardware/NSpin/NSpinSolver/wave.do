onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/clk
add wave -noupdate /tb/data_in
add wave -noupdate /tb/X_out
add wave -noupdate /tb/Y_out
add wave -noupdate /tb/S
add wave -noupdate /tb/DUT/DP/Data_in
add wave -noupdate -radix unsigned /tb/DUT/DP/counter_val_iteration
add wave -noupdate /tb/DUT/CU/state
add wave -noupdate /tb/DUT/DP/PE_g(0)/PEs/CU/state
add wave -noupdate /tb/DUT/DP/PA/CU/state
add wave -noupdate /tb/DUT/DP/g_Sum(0)/Summers/CU/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {81399593 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 259
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {81216331 ps} {81682424 ps}
