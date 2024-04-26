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
add wave -noupdate /testbench/start
add wave -noupdate /testbench/x0
add wave -noupdate /testbench/x1
add wave -noupdate /testbench/x2
add wave -noupdate /testbench/x3
add wave -noupdate /testbench/x4
add wave -noupdate /testbench/x_out
add wave -noupdate /testbench/xready
add wave -noupdate /testbench/y0
add wave -noupdate /testbench/y1
add wave -noupdate /testbench/y2
add wave -noupdate /testbench/y3
add wave -noupdate /testbench/y4
add wave -noupdate /testbench/y_out
add wave -noupdate /testbench/yready
add wave -noupdate /testbench/dut/cu/state
add wave -noupdate /testbench/dut/dp/pe_g(0)/pes/cu/state
add wave -noupdate /testbench/dut/dp/hvector_out
add wave -noupdate /testbench/dut/dp/enableupdateh
add wave -noupdate /testbench/dut/dp/pe_g(0)/pes/cu/state
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/aa_mux_a_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/aa_mux_b_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/aa_mux_b_out_c
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/addera
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/adderasample
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/adderasample2d
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/delta_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/deltat_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/epsilon_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/epsilon_out_shifted
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/k_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/ma_mux_a_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/ma_mux_b_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/mb_mux_a_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/mb_mux_b_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/mulaout
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/mulaoutsample
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/mulbout
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/mulboutsample
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/p_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/sum_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/xnew
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/xnew_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/xold
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/yold
add wave -noupdate /testbench/dut/dp/g_sum(0)/summers/cu/state
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(0)/summers/dp/carryb
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(0)/summers/dp/carrysample
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(0)/summers/dp/carrysampletosum
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(0)/summers/dp/j_in
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(0)/summers/dp/maoutsample
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(0)/summers/dp/mulaout
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(0)/summers/dp/mulbout
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(0)/summers/dp/out_r1
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(0)/summers/dp/out_r2
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(0)/summers/dp/suma
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(0)/summers/dp/sumb
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(0)/summers/dp/sumfinal
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(0)/summers/dp/sumsample
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(0)/summers/dp/x1_in
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(0)/summers/dp/x2_in
add wave -noupdate /testbench/dut/dp/pe_g(4)/pes/cu/state
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(4)/pes/dp/aa_mux_a_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(4)/pes/dp/aa_mux_b_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(4)/pes/dp/aa_mux_b_out_c
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(4)/pes/dp/addera
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(4)/pes/dp/adderasample
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(4)/pes/dp/adderasample2d
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(4)/pes/dp/ma_mux_a_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(4)/pes/dp/ma_mux_b_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(4)/pes/dp/mb_mux_a_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(4)/pes/dp/mb_mux_b_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(4)/pes/dp/mulaout
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(4)/pes/dp/mulaoutsample
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(4)/pes/dp/mulbout
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(4)/pes/dp/mulboutsample
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(4)/pes/dp/p
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(4)/pes/dp/p_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(4)/pes/dp/sum
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(4)/pes/dp/sum_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(4)/pes/dp/xnew
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(4)/pes/dp/xnew_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(4)/pes/dp/xold
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(4)/pes/dp/xold_in
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(4)/pes/dp/xoldtemp
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(4)/pes/dp/ynew
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(4)/pes/dp/yold
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(4)/pes/dp/yold_in
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(4)/pes/dp/yoldtemp
add wave -noupdate /testbench/dut/dp/pe_g(3)/pes/cu/state
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/aa_mux_a_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/aa_mux_b_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/aa_mux_b_out_c
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/addera
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/adderasample
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(3)/pes/dp/adderasample2d
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
add wave -noupdate -radix unsigned /testbench/dut/dp/counter_val_iteration
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
add wave -noupdate -radix unsigned /testbench/dut/dp/g_sum(3)/summers/dp/rd_r1
add wave -noupdate -radix unsigned /testbench/dut/dp/g_sum(3)/summers/dp/rd_r2
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(3)/summers/dp/suma
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(3)/summers/dp/sumb
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(3)/summers/dp/sumfinal
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(3)/summers/dp/sumsample
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(3)/summers/dp/x1_in
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(3)/summers/dp/x2_in
add wave -noupdate -radix unsigned /testbench/dut/dp/g_sum(3)/summers/dp/xsel
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3790846 ps} 0}
configure wave -namecolwidth 393
configure wave -valuecolwidth 249
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
WaveRestoreZoom {3731356 ps} {3827126 ps}
