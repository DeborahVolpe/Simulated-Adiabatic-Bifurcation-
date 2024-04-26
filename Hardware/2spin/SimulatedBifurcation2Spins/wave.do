onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/start
add wave -noupdate /testbench/s1
add wave -noupdate /testbench/s0
add wave -noupdate /testbench/reset
add wave -noupdate /testbench/done
add wave -noupdate /testbench/data_in
add wave -noupdate /testbench/clk
add wave -noupdate /testbench/dut/cu/state
add wave -noupdate /testbench/dut/dp/pe0/cu/state
add wave -noupdate /testbench/dut/dp/pe0/dp/ynew
add wave -noupdate /testbench/dut/dp/pe0/dp/xnew_out
add wave -noupdate /testbench/dut/dp/pe0/dp/mulcoutsample
add wave -noupdate /testbench/dut/dp/pe0/dp/mulcout
add wave -noupdate /testbench/dut/dp/pe0/dp/mulboutsample
add wave -noupdate /testbench/dut/dp/pe0/dp/mulbout
add wave -noupdate /testbench/dut/dp/pe0/dp/mulaoutsample
add wave -noupdate /testbench/dut/dp/pe0/dp/mulaout
add wave -noupdate /testbench/dut/dp/pe0/dp/adderasample
add wave -noupdate /testbench/dut/dp/pe0/dp/addera
add wave -noupdate /testbench/dut/dp/pe1/cu/state
add wave -noupdate /testbench/dut/dp/pe1/dp/ynew
add wave -noupdate /testbench/dut/dp/pe1/dp/xnew_out
add wave -noupdate /testbench/dut/dp/pe1/dp/xnew
add wave -noupdate /testbench/dut/dp/pe1/dp/mulcoutsample
add wave -noupdate /testbench/dut/dp/pe1/dp/mulcout
add wave -noupdate /testbench/dut/dp/pe1/dp/mulboutsample
add wave -noupdate /testbench/dut/dp/pe1/dp/mulbout
add wave -noupdate /testbench/dut/dp/pe1/dp/mulaoutsample
add wave -noupdate /testbench/dut/dp/pe1/dp/mulaout
add wave -noupdate /testbench/dut/dp/pe1/dp/adderasample
add wave -noupdate /testbench/dut/dp/pe1/dp/addera
add wave -noupdate /testbench/dut/dp/pa0/cu/state
add wave -noupdate /testbench/dut/dp/pa0/dp/pt_out
add wave -noupdate /testbench/dut/dp/pa0/dp/mulaoutsample
add wave -noupdate /testbench/dut/dp/pa0/dp/mulaout
add wave -noupdate /testbench/dut/dp/pa0/dp/adderasample
add wave -noupdate /testbench/dut/dp/pa0/dp/addera
add wave -noupdate /testbench/dut/dp/pa0/dp/a0_out
add wave -noupdate /testbench/dut/dp/s2s/cu/state
add wave -noupdate /testbench/dut/dp/s2s/dp/sum1
add wave -noupdate /testbench/dut/dp/s2s/dp/sum0
add wave -noupdate /testbench/dut/dp/c/counter_val
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9982435000 ps} 0}
configure wave -namecolwidth 327
configure wave -valuecolwidth 142
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
WaveRestoreZoom {0 ps} {42907729920 ps}