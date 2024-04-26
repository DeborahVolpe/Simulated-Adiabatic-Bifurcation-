onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/clk
add wave -noupdate -radix decimal /testbench/data_in
add wave -noupdate /testbench/done
add wave -noupdate /testbench/reset
add wave -noupdate /testbench/s
add wave -noupdate /testbench/s0
add wave -noupdate /testbench/s1
add wave -noupdate /testbench/s2
add wave -noupdate /testbench/s3
add wave -noupdate /testbench/s4
add wave -noupdate /testbench/s5
add wave -noupdate /testbench/start
add wave -noupdate -radix decimal /testbench/x0
add wave -noupdate -radix decimal /testbench/x1
add wave -noupdate -radix decimal /testbench/x2
add wave -noupdate -radix decimal /testbench/x3
add wave -noupdate -radix decimal /testbench/x4
add wave -noupdate -radix decimal /testbench/x5
add wave -noupdate -radix decimal /testbench/x_out
add wave -noupdate /testbench/xready
add wave -noupdate -radix decimal /testbench/y0
add wave -noupdate -radix decimal /testbench/y1
add wave -noupdate -radix decimal /testbench/y2
add wave -noupdate -radix decimal /testbench/y3
add wave -noupdate -radix decimal /testbench/y4
add wave -noupdate -radix decimal /testbench/y5
add wave -noupdate -radix decimal /testbench/y_out
add wave -noupdate /testbench/yready
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/cu/state
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/a0
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/a0_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/aa_mux_a_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/aa_mux_b_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/aa_mux_b_out_c
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/addera
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/adderasample
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/adderasample2d
add wave -noupdate /testbench/dut/dp/pe_g(3)/pes/dp/clk
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/delta
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/delta_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/deltat
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/deltat_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/epsilon
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/epsilon_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/epsilon_out_shifted
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/hvectori
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/hvectori_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/k
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/k_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/ma_mux_a_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/ma_mux_b_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/mb_mux_a_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/mb_mux_b_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/mulaout
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/mulaoutsample
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/mulbout
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/mulboutsample
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/p
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/p_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/sum
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/sum_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/xnew
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/xnew_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/xold
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/xold_in
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/xoldtemp
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/ynew
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/yold
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/yold_in
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/yoldtemp
add wave -noupdate /testbench/dut/dp/g_sum(3)/summers/cu/state
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(3)/summers/dp/aout
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(3)/summers/dp/aoutsample
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(3)/summers/dp/carrya
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(3)/summers/dp/carryatosum
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(3)/summers/dp/carryb
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(3)/summers/dp/carrysample
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(3)/summers/dp/carrysampletosum
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(3)/summers/dp/j_in
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(3)/summers/dp/maoutsample
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(3)/summers/dp/mulaout
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(3)/summers/dp/mulbout
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(3)/summers/dp/out_r1
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(3)/summers/dp/out_r2
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(3)/summers/dp/suma
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(3)/summers/dp/sumb
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(3)/summers/dp/sumfinal
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(3)/summers/dp/sumsample
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(3)/summers/dp/x1_in
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(3)/summers/dp/x2_in
add wave -noupdate -radix unsigned /testbench/dut/dp/counter_val_iteration
add wave -noupdate /testbench/dut/dp/g_sum(3)/summers/dp/counter_val
add wave -noupdate /testbench/dut/dp/g_sum(3)/summers/dp/odd_even_n
add wave -noupdate /testbench/dut/dp/g_sum(3)/summers/dp/tc
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {339806 ps} 0}
configure wave -namecolwidth 327
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
WaveRestoreZoom {245160 ps} {426778 ps}
