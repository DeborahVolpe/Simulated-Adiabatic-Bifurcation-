onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/dut/dp/g_mux(0)/muxs_1/m
add wave -noupdate /testbench/dut/dp/g_mux(0)/muxs_1/sel
add wave -noupdate /testbench/dut/dp/g_mux(0)/muxs_1/n
add wave -noupdate /testbench/dut/dp/g_mux(0)/muxs_1/s
add wave -noupdate /testbench/dut/dp/g_mux(0)/muxs_1/output
add wave -noupdate /testbench/dut/dp/g_mux(0)/muxs_1/x
add wave -noupdate /testbench/dut/dp/g_mux(0)/muxs_2/m
add wave -noupdate /testbench/dut/dp/g_mux(0)/muxs_2/sel
add wave -noupdate /testbench/dut/dp/g_mux(0)/muxs_2/n
add wave -noupdate /testbench/dut/dp/g_mux(0)/muxs_2/s
add wave -noupdate /testbench/dut/dp/g_mux(0)/muxs_2/output
add wave -noupdate -expand /testbench/dut/dp/g_mux(0)/muxs_2/x
add wave -noupdate /testbench/dut/dp/g_mux(1)/muxs_1/s
add wave -noupdate /testbench/dut/dp/g_mux(1)/muxs_1/output
add wave -noupdate /testbench/dut/dp/g_mux(1)/muxs_1/x
add wave -noupdate /testbench/dut/dp/g_mux(1)/muxs_2/sel
add wave -noupdate /testbench/dut/dp/g_mux(1)/muxs_2/n
add wave -noupdate /testbench/dut/dp/g_mux(1)/muxs_2/s
add wave -noupdate /testbench/dut/dp/g_mux(1)/muxs_2/output
add wave -noupdate /testbench/dut/dp/g_mux(1)/muxs_2/x
add wave -noupdate /testbench/dut/dp/g_mux(2)/muxs_1/s
add wave -noupdate /testbench/dut/dp/g_mux(2)/muxs_1/output
add wave -noupdate /testbench/dut/dp/g_mux(2)/muxs_1/x
add wave -noupdate /testbench/dut/dp/g_mux(2)/muxs_2/sel
add wave -noupdate /testbench/dut/dp/g_mux(2)/muxs_2/n
add wave -noupdate /testbench/dut/dp/g_mux(2)/muxs_2/s
add wave -noupdate /testbench/dut/dp/g_mux(2)/muxs_2/output
add wave -noupdate /testbench/dut/dp/g_mux(2)/muxs_2/x
add wave -noupdate -expand -subitemconfig {/testbench/dut/dp/x1_mux_inputs(2) -expand /testbench/dut/dp/x1_mux_inputs(1) -expand /testbench/dut/dp/x1_mux_inputs(0) -expand} /testbench/dut/dp/x1_mux_inputs
add wave -noupdate -expand -subitemconfig {/testbench/dut/dp/x2_mux_inputs(2) -expand /testbench/dut/dp/x2_mux_inputs(1) -expand /testbench/dut/dp/x2_mux_inputs(0) -expand} /testbench/dut/dp/x2_mux_inputs
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {24805000 ps} 0}
configure wave -namecolwidth 311
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
WaveRestoreZoom {0 ps} {62357504 ps}
