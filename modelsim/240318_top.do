onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_L1_D_top/clk
add wave -noupdate /tb_L1_D_top/address
add wave -noupdate /tb_L1_D_top/read_data_L2_L1
add wave -noupdate /tb_L1_D_top/read_data_L1_C
add wave -noupdate /tb_L1_D_top/stall
add wave -noupdate /tb_L1_D_top/ready_L2_L1
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {408 ns}
