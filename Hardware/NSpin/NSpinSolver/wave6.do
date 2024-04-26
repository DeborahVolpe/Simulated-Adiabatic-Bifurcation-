onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/dut/dp/data_in
add wave -noupdate /testbench/dut/dp/s
add wave -noupdate -radix decimal /testbench/dut/dp/x_out
add wave -noupdate -radix decimal /testbench/dut/dp/y_out
add wave -noupdate -radix decimal /testbench/dut/dp/k_out
add wave -noupdate /testbench/dut/dp/enableupdateh
add wave -noupdate /testbench/dut/dp/start_sample_sum
add wave -noupdate -radix decimal /testbench/dut/dp/xnew
add wave -noupdate -radix decimal /testbench/dut/dp/ynew
add wave -noupdate -radix decimal /testbench/dut/dp/xnew_out
add wave -noupdate /testbench/dut/dp/a0ready
add wave -noupdate -radix decimal /testbench/dut/dp/counter_val_iteration
add wave -noupdate /testbench/dut/dp/counter_val_column
add wave -noupdate /testbench/dut/dp/counter_val_row
add wave -noupdate /testbench/dut/dp/ce_count_iteration
add wave -noupdate /testbench/dut/dp/ce_count_row
add wave -noupdate /testbench/dut/dp/ce_count_column
add wave -noupdate -radix decimal /testbench/dut/dp/hvector_out
add wave -noupdate /testbench/dut/dp/pa/cu/state
add wave -noupdate /testbench/dut/dp/pa/dp/rst_parameter
add wave -noupdate /testbench/dut/dp/pa/dp/clean
add wave -noupdate /testbench/dut/dp/pa/dp/enableupdateshapept
add wave -noupdate /testbench/dut/dp/pa/dp/enableupdatedelta4k
add wave -noupdate /testbench/dut/dp/pa/dp/enableupdatek_1
add wave -noupdate /testbench/dut/dp/pa/dp/enableupdateoffset
add wave -noupdate /testbench/dut/dp/pa/dp/enableupdatea0
add wave -noupdate /testbench/dut/dp/pa/dp/enableupdatept
add wave -noupdate /testbench/dut/dp/pa/dp/enableupdatemula
add wave -noupdate /testbench/dut/dp/pa/dp/enableupdateadda
add wave -noupdate /testbench/dut/dp/pa/dp/enableupdatesqa
add wave -noupdate /testbench/dut/dp/pa/dp/sub_add_n
add wave -noupdate /testbench/dut/dp/pa/dp/startsquare
add wave -noupdate /testbench/dut/dp/pa/dp/sela0out
add wave -noupdate /testbench/dut/dp/pa/dp/selaa_mux_a
add wave -noupdate /testbench/dut/dp/pa/dp/selaa_mux_b
add wave -noupdate -radix decimal /testbench/dut/dp/pa/dp/shapept
add wave -noupdate -radix decimal /testbench/dut/dp/pa/dp/delta4k
add wave -noupdate -radix decimal /testbench/dut/dp/pa/dp/k_1
add wave -noupdate -radix decimal /testbench/dut/dp/pa/dp/offset
add wave -noupdate /testbench/dut/dp/pa/dp/readysquare
add wave -noupdate /testbench/dut/dp/pa/dp/inv
add wave -noupdate -radix decimal /testbench/dut/dp/pa/dp/pt_out
add wave -noupdate -radix decimal /testbench/dut/dp/pa/dp/a0_out
add wave -noupdate -radix decimal /testbench/dut/dp/pa/dp/shapept_out
add wave -noupdate -radix decimal /testbench/dut/dp/pa/dp/delta4k_out
add wave -noupdate -radix decimal /testbench/dut/dp/pa/dp/k_1_out
add wave -noupdate -radix decimal /testbench/dut/dp/pa/dp/offset_out
add wave -noupdate -radix decimal /testbench/dut/dp/pa/dp/mulaoutsample
add wave -noupdate -radix decimal /testbench/dut/dp/pa/dp/mulaout
add wave -noupdate -radix decimal /testbench/dut/dp/pa/dp/adderasample
add wave -noupdate /testbench/dut/dp/pa/dp/aa_mux_a_out
add wave -noupdate /testbench/dut/dp/pa/dp/aa_mux_b_out
add wave -noupdate /testbench/dut/dp/pa/dp/aa_mux_b_out_c
add wave -noupdate -radix decimal /testbench/dut/dp/pa/dp/addera
add wave -noupdate -radix decimal /testbench/dut/dp/pa/dp/squareainput
add wave -noupdate -radix decimal /testbench/dut/dp/pa/dp/squarea
add wave -noupdate -radix decimal /testbench/dut/dp/pa/dp/squareasample
add wave -noupdate -radix decimal /testbench/dut/dp/pa/dp/squareasamplein
add wave -noupdate -radix decimal /testbench/dut/dp/pa/dp/remainder
add wave -noupdate -radix decimal /testbench/dut/dp/pa/dp/ptold
add wave -noupdate -radix decimal /testbench/dut/dp/pa/dp/a0old
add wave -noupdate -radix decimal /testbench/dut/dp/pa/dp/zeros
add wave -noupdate /testbench/dut/dp/pe_g(1)/pes/cu/state
add wave -noupdate /testbench/dut/dp/pe_g(1)/pes/dp/rst_parameter
add wave -noupdate /testbench/dut/dp/pe_g(1)/pes/dp/enableupdatea0
add wave -noupdate /testbench/dut/dp/pe_g(1)/pes/dp/enableupdatep
add wave -noupdate /testbench/dut/dp/pe_g(1)/pes/dp/enableupdatek
add wave -noupdate /testbench/dut/dp/pe_g(1)/pes/dp/enableupdatedelta
add wave -noupdate /testbench/dut/dp/pe_g(1)/pes/dp/enableupdateepsilon
add wave -noupdate /testbench/dut/dp/pe_g(1)/pes/dp/enableupdatedeltat
add wave -noupdate /testbench/dut/dp/pe_g(1)/pes/dp/enableupdatesum
add wave -noupdate /testbench/dut/dp/pe_g(1)/pes/dp/enableupdatehveectori
add wave -noupdate /testbench/dut/dp/pe_g(1)/pes/dp/enableupdatemula
add wave -noupdate /testbench/dut/dp/pe_g(1)/pes/dp/enableupdatemulb
add wave -noupdate /testbench/dut/dp/pe_g(1)/pes/dp/enableupdateadda
add wave -noupdate /testbench/dut/dp/pe_g(1)/pes/dp/enableupdateadda2
add wave -noupdate /testbench/dut/dp/pe_g(1)/pes/dp/enableupdatex
add wave -noupdate /testbench/dut/dp/pe_g(1)/pes/dp/enableupdatey
add wave -noupdate /testbench/dut/dp/pe_g(1)/pes/dp/enableupdatexnew
add wave -noupdate /testbench/dut/dp/pe_g(1)/pes/dp/sub_add_n
add wave -noupdate /testbench/dut/dp/pe_g(1)/pes/dp/selx
add wave -noupdate /testbench/dut/dp/pe_g(1)/pes/dp/sely
add wave -noupdate /testbench/dut/dp/pe_g(1)/pes/dp/selma_mux_a
add wave -noupdate /testbench/dut/dp/pe_g(1)/pes/dp/selma_mux_b
add wave -noupdate /testbench/dut/dp/pe_g(1)/pes/dp/selmb_mux_a
add wave -noupdate /testbench/dut/dp/pe_g(1)/pes/dp/selmb_mux_b
add wave -noupdate /testbench/dut/dp/pe_g(1)/pes/dp/selaa_mux_a
add wave -noupdate /testbench/dut/dp/pe_g(1)/pes/dp/selaa_mux_b
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(1)/pes/dp/a0
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(1)/pes/dp/p
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(1)/pes/dp/k
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(1)/pes/dp/delta
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(1)/pes/dp/epsilon
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(1)/pes/dp/deltat
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(1)/pes/dp/sum
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(1)/pes/dp/hvectori
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(1)/pes/dp/xold_in
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(1)/pes/dp/yold_in
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(1)/pes/dp/xnew
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(1)/pes/dp/ynew
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(1)/pes/dp/a0_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(1)/pes/dp/p_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(1)/pes/dp/delta_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(1)/pes/dp/hvectori_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(1)/pes/dp/epsilon_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(1)/pes/dp/deltat_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(1)/pes/dp/sum_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(1)/pes/dp/k_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(1)/pes/dp/epsilon_out_shifted
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(1)/pes/dp/xold
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(1)/pes/dp/yold
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(1)/pes/dp/xoldtemp
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(1)/pes/dp/yoldtemp
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(1)/pes/dp/xnew_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(1)/pes/dp/mulaoutsample
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(1)/pes/dp/mulaout
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(1)/pes/dp/ma_mux_a_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(1)/pes/dp/ma_mux_b_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(1)/pes/dp/mulboutsample
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(1)/pes/dp/mulbout
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(1)/pes/dp/mb_mux_a_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(1)/pes/dp/mb_mux_b_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(1)/pes/dp/adderasample
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(1)/pes/dp/adderasample2d
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(1)/pes/dp/aa_mux_a_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(1)/pes/dp/aa_mux_b_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(1)/pes/dp/aa_mux_b_out_c
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(1)/pes/dp/addera
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(2)/pes/cu/state
add wave -noupdate /testbench/dut/dp/pe_g(2)/pes/dp/rst_parameter
add wave -noupdate /testbench/dut/dp/pe_g(2)/pes/dp/enableupdatea0
add wave -noupdate /testbench/dut/dp/pe_g(2)/pes/dp/enableupdatep
add wave -noupdate /testbench/dut/dp/pe_g(2)/pes/dp/enableupdatek
add wave -noupdate /testbench/dut/dp/pe_g(2)/pes/dp/enableupdatedelta
add wave -noupdate /testbench/dut/dp/pe_g(2)/pes/dp/enableupdateepsilon
add wave -noupdate /testbench/dut/dp/pe_g(2)/pes/dp/enableupdatedeltat
add wave -noupdate /testbench/dut/dp/pe_g(2)/pes/dp/enableupdatesum
add wave -noupdate /testbench/dut/dp/pe_g(2)/pes/dp/enableupdatehveectori
add wave -noupdate /testbench/dut/dp/pe_g(2)/pes/dp/enableupdatemula
add wave -noupdate /testbench/dut/dp/pe_g(2)/pes/dp/enableupdatemulb
add wave -noupdate /testbench/dut/dp/pe_g(2)/pes/dp/enableupdateadda
add wave -noupdate /testbench/dut/dp/pe_g(2)/pes/dp/enableupdateadda2
add wave -noupdate /testbench/dut/dp/pe_g(2)/pes/dp/enableupdatex
add wave -noupdate /testbench/dut/dp/pe_g(2)/pes/dp/enableupdatey
add wave -noupdate /testbench/dut/dp/pe_g(2)/pes/dp/enableupdatexnew
add wave -noupdate /testbench/dut/dp/pe_g(2)/pes/dp/sub_add_n
add wave -noupdate /testbench/dut/dp/pe_g(2)/pes/dp/selx
add wave -noupdate /testbench/dut/dp/pe_g(2)/pes/dp/sely
add wave -noupdate /testbench/dut/dp/pe_g(2)/pes/dp/selma_mux_a
add wave -noupdate /testbench/dut/dp/pe_g(2)/pes/dp/selma_mux_b
add wave -noupdate /testbench/dut/dp/pe_g(2)/pes/dp/selmb_mux_a
add wave -noupdate /testbench/dut/dp/pe_g(2)/pes/dp/selmb_mux_b
add wave -noupdate /testbench/dut/dp/pe_g(2)/pes/dp/selaa_mux_a
add wave -noupdate /testbench/dut/dp/pe_g(2)/pes/dp/selaa_mux_b
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(2)/pes/dp/a0
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(2)/pes/dp/p
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(2)/pes/dp/k
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(2)/pes/dp/delta
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(2)/pes/dp/epsilon
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(2)/pes/dp/deltat
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(2)/pes/dp/sum
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(2)/pes/dp/hvectori
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(2)/pes/dp/xold_in
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(2)/pes/dp/yold_in
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(2)/pes/dp/xnew
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(2)/pes/dp/ynew
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(2)/pes/dp/a0_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(2)/pes/dp/p_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(2)/pes/dp/delta_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(2)/pes/dp/hvectori_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(2)/pes/dp/epsilon_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(2)/pes/dp/deltat_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(2)/pes/dp/sum_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(2)/pes/dp/k_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(2)/pes/dp/epsilon_out_shifted
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(2)/pes/dp/xold
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(2)/pes/dp/yold
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(2)/pes/dp/xoldtemp
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(2)/pes/dp/yoldtemp
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(2)/pes/dp/xnew_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(2)/pes/dp/mulaoutsample
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(2)/pes/dp/mulaout
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(2)/pes/dp/ma_mux_a_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(2)/pes/dp/ma_mux_b_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(2)/pes/dp/mulboutsample
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(2)/pes/dp/mulbout
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(2)/pes/dp/mb_mux_a_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(2)/pes/dp/mb_mux_b_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(2)/pes/dp/adderasample
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(2)/pes/dp/adderasample2d
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(2)/pes/dp/aa_mux_a_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(2)/pes/dp/aa_mux_b_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(2)/pes/dp/aa_mux_b_out_c
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(2)/pes/dp/addera
add wave -noupdate /testbench/dut/dp/pe_g(0)/pes/cu/state
add wave -noupdate /testbench/dut/dp/pe_g(0)/pes/dp/rst_parameter
add wave -noupdate /testbench/dut/dp/pe_g(0)/pes/dp/enableupdatea0
add wave -noupdate /testbench/dut/dp/pe_g(0)/pes/dp/enableupdatep
add wave -noupdate /testbench/dut/dp/pe_g(0)/pes/dp/enableupdatek
add wave -noupdate /testbench/dut/dp/pe_g(0)/pes/dp/enableupdatedelta
add wave -noupdate /testbench/dut/dp/pe_g(0)/pes/dp/enableupdateepsilon
add wave -noupdate /testbench/dut/dp/pe_g(0)/pes/dp/enableupdatedeltat
add wave -noupdate /testbench/dut/dp/pe_g(0)/pes/dp/enableupdatesum
add wave -noupdate /testbench/dut/dp/pe_g(0)/pes/dp/enableupdatehveectori
add wave -noupdate /testbench/dut/dp/pe_g(0)/pes/dp/enableupdatemula
add wave -noupdate /testbench/dut/dp/pe_g(0)/pes/dp/enableupdatemulb
add wave -noupdate /testbench/dut/dp/pe_g(0)/pes/dp/enableupdateadda
add wave -noupdate /testbench/dut/dp/pe_g(0)/pes/dp/enableupdateadda2
add wave -noupdate /testbench/dut/dp/pe_g(0)/pes/dp/enableupdatex
add wave -noupdate /testbench/dut/dp/pe_g(0)/pes/dp/enableupdatey
add wave -noupdate /testbench/dut/dp/pe_g(0)/pes/dp/enableupdatexnew
add wave -noupdate /testbench/dut/dp/pe_g(0)/pes/dp/sub_add_n
add wave -noupdate /testbench/dut/dp/pe_g(0)/pes/dp/selx
add wave -noupdate /testbench/dut/dp/pe_g(0)/pes/dp/sely
add wave -noupdate /testbench/dut/dp/pe_g(0)/pes/dp/selma_mux_a
add wave -noupdate /testbench/dut/dp/pe_g(0)/pes/dp/selma_mux_b
add wave -noupdate /testbench/dut/dp/pe_g(0)/pes/dp/selmb_mux_a
add wave -noupdate /testbench/dut/dp/pe_g(0)/pes/dp/selmb_mux_b
add wave -noupdate /testbench/dut/dp/pe_g(0)/pes/dp/selaa_mux_a
add wave -noupdate /testbench/dut/dp/pe_g(0)/pes/dp/selaa_mux_b
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/a0
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/p
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/k
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/delta
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/epsilon
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/deltat
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/sum
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/hvectori
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/xold_in
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/yold_in
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/xnew
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/ynew
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/a0_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/p_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/delta_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/hvectori_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/epsilon_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/deltat_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/sum_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/k_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/epsilon_out_shifted
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/xold
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/yold
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/xoldtemp
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/yoldtemp
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/xnew_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/mulaoutsample
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/mulaout
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/ma_mux_a_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/ma_mux_b_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/mulboutsample
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/mulbout
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/mb_mux_a_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/mb_mux_b_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/adderasample
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/adderasample2d
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/aa_mux_a_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/aa_mux_b_out
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/aa_mux_b_out_c
add wave -noupdate -radix decimal /testbench/dut/dp/pe_g(0)/pes/dp/addera
add wave -noupdate /testbench/dut/dp/g_sum(0)/summers/cu/state
add wave -noupdate /testbench/dut/dp/g_sum(0)/summers/dp/rst_parameter
add wave -noupdate /testbench/dut/dp/g_sum(0)/summers/dp/rst_csa
add wave -noupdate /testbench/dut/dp/g_sum(0)/summers/dp/rst
add wave -noupdate /testbench/dut/dp/g_sum(0)/summers/dp/enablecsab
add wave -noupdate /testbench/dut/dp/g_sum(0)/summers/dp/enableaddera
add wave -noupdate /testbench/dut/dp/g_sum(0)/summers/dp/write_enable
add wave -noupdate /testbench/dut/dp/g_sum(0)/summers/dp/ce
add wave -noupdate /testbench/dut/dp/g_sum(0)/summers/dp/selwrite
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(0)/summers/dp/j_in
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(0)/summers/dp/x1_in
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(0)/summers/dp/x2_in
add wave -noupdate /testbench/dut/dp/g_sum(0)/summers/dp/tc
add wave -noupdate /testbench/dut/dp/g_sum(0)/summers/dp/odd_even_n
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(0)/summers/dp/sumfinal
add wave -noupdate /testbench/dut/dp/g_sum(0)/summers/dp/xsel
add wave -noupdate /testbench/dut/dp/g_sum(0)/summers/dp/rd_r1
add wave -noupdate /testbench/dut/dp/g_sum(0)/summers/dp/rd_r2
add wave -noupdate /testbench/dut/dp/g_sum(0)/summers/dp/wr_reg
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(0)/summers/dp/out_r1
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(0)/summers/dp/out_r2
add wave -noupdate /testbench/dut/dp/g_sum(0)/summers/dp/counter_val
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(0)/summers/dp/mulaout
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(0)/summers/dp/maoutsample
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(0)/summers/dp/mulbout
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(0)/summers/dp/suma
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(0)/summers/dp/carrya
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(0)/summers/dp/carryatosum
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(0)/summers/dp/sumb
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(0)/summers/dp/carryb
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(0)/summers/dp/sumsample
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(0)/summers/dp/carrysample
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(0)/summers/dp/carrysampletosum
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(0)/summers/dp/aout
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(0)/summers/dp/aoutsample
add wave -noupdate /testbench/dut/dp/g_sum(0)/summers/dp/odd_even_n_temp
add wave -noupdate /testbench/dut/dp/g_sum(1)/summers/cu/state
add wave -noupdate /testbench/dut/dp/g_sum(1)/summers/dp/rst_parameter
add wave -noupdate /testbench/dut/dp/g_sum(1)/summers/dp/rst_csa
add wave -noupdate /testbench/dut/dp/g_sum(1)/summers/dp/rst
add wave -noupdate /testbench/dut/dp/g_sum(1)/summers/dp/enablecsab
add wave -noupdate /testbench/dut/dp/g_sum(1)/summers/dp/enableaddera
add wave -noupdate /testbench/dut/dp/g_sum(1)/summers/dp/write_enable
add wave -noupdate /testbench/dut/dp/g_sum(1)/summers/dp/ce
add wave -noupdate /testbench/dut/dp/g_sum(1)/summers/dp/selwrite
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(1)/summers/dp/j_in
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(1)/summers/dp/x1_in
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(1)/summers/dp/x2_in
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(1)/summers/dp/tc
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(1)/summers/dp/odd_even_n
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(1)/summers/dp/sumfinal
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(1)/summers/dp/xsel
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(1)/summers/dp/rd_r1
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(1)/summers/dp/rd_r2
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(1)/summers/dp/wr_reg
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(1)/summers/dp/out_r1
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(1)/summers/dp/out_r2
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(1)/summers/dp/counter_val
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(1)/summers/dp/mulaout
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(1)/summers/dp/maoutsample
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(1)/summers/dp/mulbout
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(1)/summers/dp/suma
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(1)/summers/dp/carrya
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(1)/summers/dp/carryatosum
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(1)/summers/dp/sumb
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(1)/summers/dp/carryb
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(1)/summers/dp/sumsample
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(1)/summers/dp/carrysample
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(1)/summers/dp/carrysampletosum
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(1)/summers/dp/aout
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(1)/summers/dp/aoutsample
add wave -noupdate /testbench/dut/dp/g_sum(1)/summers/dp/odd_even_n_temp
add wave -noupdate /testbench/dut/dp/g_sum(2)/summers/cu/state
add wave -noupdate /testbench/dut/dp/g_sum(2)/summers/dp/rst_parameter
add wave -noupdate /testbench/dut/dp/g_sum(2)/summers/dp/rst_csa
add wave -noupdate /testbench/dut/dp/g_sum(2)/summers/dp/rst
add wave -noupdate /testbench/dut/dp/g_sum(2)/summers/dp/enablecsab
add wave -noupdate /testbench/dut/dp/g_sum(2)/summers/dp/enableaddera
add wave -noupdate /testbench/dut/dp/g_sum(2)/summers/dp/write_enable
add wave -noupdate /testbench/dut/dp/g_sum(2)/summers/dp/ce
add wave -noupdate /testbench/dut/dp/g_sum(2)/summers/dp/selwrite
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(2)/summers/dp/j_in
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(2)/summers/dp/x1_in
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(2)/summers/dp/x2_in
add wave -noupdate /testbench/dut/dp/g_sum(2)/summers/dp/tc
add wave -noupdate /testbench/dut/dp/g_sum(2)/summers/dp/odd_even_n
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(2)/summers/dp/sumfinal
add wave -noupdate /testbench/dut/dp/g_sum(2)/summers/dp/xsel
add wave -noupdate /testbench/dut/dp/g_sum(2)/summers/dp/rd_r1
add wave -noupdate /testbench/dut/dp/g_sum(2)/summers/dp/rd_r2
add wave -noupdate /testbench/dut/dp/g_sum(2)/summers/dp/wr_reg
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(2)/summers/dp/out_r1
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(2)/summers/dp/out_r2
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(2)/summers/dp/counter_val
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(2)/summers/dp/mulaout
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(2)/summers/dp/maoutsample
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(2)/summers/dp/mulbout
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(2)/summers/dp/suma
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(2)/summers/dp/carrya
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(2)/summers/dp/carryatosum
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(2)/summers/dp/sumb
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(2)/summers/dp/carryb
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(2)/summers/dp/sumsample
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(2)/summers/dp/carrysample
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(2)/summers/dp/carrysampletosum
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(2)/summers/dp/aout
add wave -noupdate -radix decimal /testbench/dut/dp/g_sum(2)/summers/dp/aoutsample
add wave -noupdate /testbench/dut/dp/g_sum(2)/summers/dp/odd_even_n_temp
add wave -noupdate /testbench/dut/dp/row_counter/last_val
add wave -noupdate /testbench/dut/dp/row_counter/counter_val
add wave -noupdate /testbench/dut/dp/row_counter/tc
add wave -noupdate /testbench/dut/dp/row_counter/counter_val_unsigned
add wave -noupdate /testbench/dut/dp/row_counter/onesunsigned
add wave -noupdate /testbench/dut/dp/row_counter/ones
add wave -noupdate /testbench/dut/dp/row_counter/zerosunsigned
add wave -noupdate /testbench/dut/dp/row_counter/zeros
add wave -noupdate /testbench/dut/dp/row_counter/ands
add wave -noupdate /testbench/dut/cu/state
add wave -noupdate /testbench/dut/dp/row_counter/tc_in
add wave -noupdate /testbench/dut/dp/tc_iteration
add wave -noupdate /testbench/dut/cu/xready_out
add wave -noupdate /testbench/dut/cu/yready_out
add wave -noupdate /testbench/dut/cu/ptready
add wave -noupdate /testbench/dut/cu/a0ready
add wave -noupdate /testbench/dut/cu/sumready_out
add wave -noupdate /testbench/dut/dp/g_sum(0)/summers/cu/start
add wave -noupdate /testbench/dut/dp/g_sum(1)/summers/cu/start
add wave -noupdate /testbench/dut/dp/g_sum(2)/summers/cu/start
add wave -noupdate /testbench/dut/dp/g_sum(2)/summers/cu/sumready
add wave -noupdate /testbench/dut/dp/g_sum(1)/summers/cu/sumready
add wave -noupdate /testbench/dut/dp/g_sum(0)/summers/cu/sumready
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {159733 ps} 0}
configure wave -namecolwidth 341
configure wave -valuecolwidth 206
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
WaveRestoreZoom {0 ps} {303108 ps}
