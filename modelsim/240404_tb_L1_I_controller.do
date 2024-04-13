onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_L1_I_controller/clk
add wave -noupdate /tb_L1_I_controller/test_state
add wave -noupdate -radix hexadecimal /tb_L1_I_controller/address
add wave -noupdate /tb_L1_I_controller/read_C_L1
add wave -noupdate /tb_L1_I_controller/read_L1_L2
add wave -noupdate /tb_L1_I_controller/ready_L2_L1
add wave -noupdate /tb_L1_I_controller/stall
add wave -noupdate -radix hexadecimal /tb_L1_I_controller/index_L1_L2
add wave -noupdate -expand -group {Controller
add wave -noupdate -expand -group {Controller
add wave -noupdate -expand -group {Controller
add wave -noupdate -expand -group {Controller
add wave -noupdate -expand -group {Controller
add wave -noupdate -expand -group {Controller
add wave -noupdate -expand -group {Controller
add wave -noupdate -expand -group {Controller
add wave -noupdate -expand -group {Controller
add wave -noupdate -expand -group {Controller
add wave -noupdate -expand -group {state
add wave -noupdate -expand -group {state
add wave -noupdate -expand -group Params /tb_L1_I_controller/INIT
add wave -noupdate -expand -group Params /tb_L1_I_controller/INUM
add wave -noupdate -expand -group Params /tb_L1_I_controller/L1_CLK
add wave -noupdate -expand -group Params /tb_L1_I_controller/L2_CLK
add wave -noupdate -expand -group Params /tb_L1_I_controller/TNUM
add wave -noupdate -expand -group Params /tb_L1_I_controller/TOTAL
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {294 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 400
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
WaveRestoreZoom {0 ns} {2583 ns}
onfinish final
run -all