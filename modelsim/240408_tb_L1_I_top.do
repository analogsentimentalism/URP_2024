onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_L1_I_top/test_state
add wave -noupdate -radix hexadecimal /tb_L1_I_top/address
add wave -noupdate /tb_L1_I_top/index_L1_L2
add wave -noupdate /tb_L1_I_top/read_C_L1
add wave -noupdate /tb_L1_I_top/read_L1_L2
add wave -noupdate /tb_L1_I_top/read_data_L1_C
add wave -noupdate /tb_L1_I_top/read_data_L2_L1
add wave -noupdate /tb_L1_I_top/ready_L2_L1
add wave -noupdate /tb_L1_I_top/stall
add wave -noupdate -radix hexadecimal /tb_L1_I_top/tag_L1_L2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1244 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 268
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
WaveRestoreZoom {1226 ns} {1274 ns}
onfinish final
run -all