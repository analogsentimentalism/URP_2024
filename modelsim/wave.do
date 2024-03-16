onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_L1_D_controller/clk
add wave -noupdate -expand -group {Input
} -radix hexadecimal /tb_L1_D_controller/address
add wave -noupdate -expand -group {Input
} /tb_L1_D_controller/nrst
add wave -noupdate -expand -group {Input
} /tb_L1_D_controller/flush
add wave -noupdate -expand -group {Input
} /tb_L1_D_controller/read_C_L1
add wave -noupdate -expand -group {Input
} /tb_L1_D_controller/write_C_L1
add wave -noupdate -expand -group {Input
} /tb_L1_D_controller/ready_L2_L1
add wave -noupdate -expand -group {Output
} /tb_L1_D_controller/read_L1_L2
add wave -noupdate -expand -group {Output
} /tb_L1_D_controller/refill
add wave -noupdate -expand -group {Output
} /tb_L1_D_controller/stall
add wave -noupdate -expand -group {Output
} /tb_L1_D_controller/update
add wave -noupdate -expand -group {Output
} /tb_L1_D_controller/write_L1_L2
add wave -noupdate -expand -group {u_signals
add wave -noupdate -expand -group {u_signals
add wave -noupdate -expand -group {u_signals
add wave -noupdate -expand -group {u_signals
add wave -noupdate -expand -group {u_signals
add wave -noupdate -expand -group {u_signals
add wave -noupdate -expand -group {u_signals
add wave -noupdate -expand -group {u_signals
add wave -noupdate -expand -group {u_signals
add wave -noupdate -expand -group {u_signals
add wave -noupdate -expand -group {u_signals
add wave -noupdate -expand -group {u_signals
add wave -noupdate -expand -group {u_signals
add wave -noupdate -expand -group {u_signals
add wave -noupdate -expand -group {u_signals
add wave -noupdate -expand -group {u_signals
add wave -noupdate -expand -group {u_signals
add wave -noupdate -expand -group {u_signals
add wave -noupdate -expand -group {u_signals
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
add wave -noupdate -expand -group {TAG_ARR
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {11 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 310
configure wave -valuecolwidth 107
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
WaveRestoreZoom {0 ns} {125 ns}