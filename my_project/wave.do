onerror {resume}
quietly set dataset_list [list sim vsim]
if {[catch {datasetcheck $dataset_list}]} {abort}
quietly WaveActivateNextPane {} 0
add wave -noupdate sim:/uvvm_tb/t_rst
add wave -noupdate sim:/uvvm_tb/t_clk
add wave -noupdate sim:/uvvm_tb/t_dut_input
add wave -noupdate sim:/uvvm_tb/t_dut_output
add wave -noupdate sim:/uvvm_tb/t_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {126 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 267
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
WaveRestoreZoom {0 ps} {862 ps}
