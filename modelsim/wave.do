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
add wave -noupdate -expand -group {u_signals} /tb_L1_D_controller/u_L1_D_controller/clk
add wave -noupdate -expand -group {u_signals} /tb_L1_D_controller/u_L1_D_controller/flush
add wave -noupdate -expand -group {u_signals} /tb_L1_D_controller/u_L1_D_controller/hit
add wave -noupdate -expand -group {u_signals} /tb_L1_D_controller/u_L1_D_controller/index
add wave -noupdate -expand -group {u_signals} /tb_L1_D_controller/u_L1_D_controller/miss
add wave -noupdate -expand -group {u_signals} /tb_L1_D_controller/u_L1_D_controller/nrst
add wave -noupdate -expand -group {u_signals} /tb_L1_D_controller/u_L1_D_controller/read_C_L1
add wave -noupdate -expand -group {u_signals} /tb_L1_D_controller/u_L1_D_controller/read_C_L1_reg
add wave -noupdate -expand -group {u_signals} /tb_L1_D_controller/u_L1_D_controller/read_L1_L2
add wave -noupdate -expand -group {u_signals} /tb_L1_D_controller/u_L1_D_controller/read_L1_L2_reg
add wave -noupdate -expand -group {u_signals} /tb_L1_D_controller/u_L1_D_controller/ready_L2_L1
add wave -noupdate -expand -group {u_signals} /tb_L1_D_controller/u_L1_D_controller/refill
add wave -noupdate -expand -group {u_signals} /tb_L1_D_controller/u_L1_D_controller/refill_reg
add wave -noupdate -expand -group {u_signals} /tb_L1_D_controller/u_L1_D_controller/stall
add wave -noupdate -expand -group {u_signals} /tb_L1_D_controller/u_L1_D_controller/stall_reg
add wave -noupdate -expand -group {u_signals} /tb_L1_D_controller/u_L1_D_controller/tag
add wave -noupdate -expand -group {u_signals} /tb_L1_D_controller/u_L1_D_controller/update
add wave -noupdate -expand -group {u_signals} /tb_L1_D_controller/u_L1_D_controller/write_C_L1
add wave -noupdate -expand -group {u_signals} /tb_L1_D_controller/u_L1_D_controller/write_L1_L2
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_0
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_1
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_10
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_11
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_12
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_13
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_14
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_15
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_16
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_17
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_18
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_19
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_2
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_20
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_21
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_22
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_23
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_24
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_25
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_26
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_27
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_28
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_29
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_3
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_30
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_31
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_32
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_33
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_34
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_35
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_36
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_37
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_38
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_39
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_4
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_40
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_41
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_42
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_43
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_44
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_45
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_46
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_47
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_48
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_49
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_5
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_50
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_51
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_52
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_53
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_54
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_55
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_56
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_57
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_58
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_59
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_6
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_60
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_61
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_62
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_63
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_7
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_8
add wave -noupdate -expand -group {TAG_ARR} /tb_L1_D_controller/u_L1_D_controller/TAG_ARR_9
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
