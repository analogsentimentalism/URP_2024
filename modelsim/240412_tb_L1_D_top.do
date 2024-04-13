onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_L1_D_top/u_L1_D_top/clk
add wave -noupdate /tb_L1_D_top/test_state
add wave -noupdate -radix hexadecimal /tb_L1_D_top/address
add wave -noupdate -expand -group {Top
} /tb_L1_D_top/u_L1_D_top/nrst
add wave -noupdate -expand -group {Top
} -radix hexadecimal /tb_L1_D_top/u_L1_D_top/tag_C_L1
add wave -noupdate -expand -group {Top
} -radix hexadecimal /tb_L1_D_top/u_L1_D_top/index_C_L1
add wave -noupdate -expand -group {Top
} -radix hexadecimal /tb_L1_D_top/u_L1_D_top/offset
add wave -noupdate -expand -group {Top
} /tb_L1_D_top/u_L1_D_top/write_C_L1
add wave -noupdate -expand -group {Top
} /tb_L1_D_top/u_L1_D_top/flush
add wave -noupdate -expand -group {Top
} /tb_L1_D_top/u_L1_D_top/stall
add wave -noupdate -expand -group {Top
} -radix unsigned /tb_L1_D_top/u_L1_D_top/write_data
add wave -noupdate -expand -group {Top
} -radix unsigned /tb_L1_D_top/u_L1_D_top/read_data_L1_C
add wave -noupdate -expand -group {Top
} -radix unsigned /tb_L1_D_top/u_L1_D_top/read_data_L2_L1
add wave -noupdate -expand -group {Top
} -radix unsigned /tb_L1_D_top/u_L1_D_top/write_data_L1_L2
add wave -noupdate -expand -group {Top
} /tb_L1_D_top/u_L1_D_top/write_L1_L2
add wave -noupdate -expand -group {Top
} /tb_L1_D_top/u_L1_D_top/read_L1_L2
add wave -noupdate -expand -group {Top
} /tb_L1_D_top/u_L1_D_top/ready_L2_L1
add wave -noupdate -expand -group {Top
} /tb_L1_D_top/u_L1_D_top/read_C_L1
add wave -noupdate -expand -group {Top
} -radix hexadecimal /tb_L1_D_top/u_L1_D_top/tag_L1_L2
add wave -noupdate -expand -group {Top
} -radix hexadecimal /tb_L1_D_top/u_L1_D_top/write_tag_L1_L2
add wave -noupdate -expand -group {Top
} -radix hexadecimal /tb_L1_D_top/u_L1_D_top/index_L1_L2
add wave -noupdate -expand -group {Top
} -radix hexadecimal /tb_L1_D_top/u_L1_D_top/write_index_L1_L2
add wave -noupdate -expand -group {Top
} /tb_L1_D_top/u_L1_D_top/refill
add wave -noupdate -expand -group {Top
} /tb_L1_D_top/u_L1_D_top/update
add wave -noupdate -expand -group {Top
} /tb_L1_D_top/u_L1_D_top/way
add wave -noupdate -expand -group {Controller
} /tb_L1_D_top/u_L1_D_top/u_L1_D_controller/clk
add wave -noupdate -expand -group {Controller
} /tb_L1_D_top/u_L1_D_top/u_L1_D_controller/nrst
add wave -noupdate -expand -group {Controller
} -radix hexadecimal /tb_L1_D_top/u_L1_D_top/u_L1_D_controller/tag_C_L1
add wave -noupdate -expand -group {Controller
} -radix hexadecimal /tb_L1_D_top/u_L1_D_top/u_L1_D_controller/index_C_L1
add wave -noupdate -expand -group {Controller
} /tb_L1_D_top/u_L1_D_top/u_L1_D_controller/read_C_L1
add wave -noupdate -expand -group {Controller
} /tb_L1_D_top/u_L1_D_top/u_L1_D_controller/flush
add wave -noupdate -expand -group {Controller
} /tb_L1_D_top/u_L1_D_top/u_L1_D_controller/ready_L2_L1
add wave -noupdate -expand -group {Controller
} /tb_L1_D_top/u_L1_D_top/u_L1_D_controller/write_C_L1
add wave -noupdate -expand -group {Controller
} /tb_L1_D_top/u_L1_D_top/u_L1_D_controller/stall
add wave -noupdate -expand -group {Controller
} /tb_L1_D_top/u_L1_D_top/u_L1_D_controller/refill
add wave -noupdate -expand -group {Controller
} /tb_L1_D_top/u_L1_D_top/u_L1_D_controller/update
add wave -noupdate -expand -group {Controller
} /tb_L1_D_top/u_L1_D_top/u_L1_D_controller/read_L1_L2
add wave -noupdate -expand -group {Controller
} /tb_L1_D_top/u_L1_D_top/u_L1_D_controller/write_L1_L2
add wave -noupdate -expand -group {Controller
} -radix hexadecimal /tb_L1_D_top/u_L1_D_top/u_L1_D_controller/index_L1_L2
add wave -noupdate -expand -group {Controller
} -radix hexadecimal /tb_L1_D_top/u_L1_D_top/u_L1_D_controller/tag_L1_L2
add wave -noupdate -expand -group {Controller
} -radix hexadecimal /tb_L1_D_top/u_L1_D_top/u_L1_D_controller/write_tag_L1_L2
add wave -noupdate -expand -group {Controller
} -radix hexadecimal /tb_L1_D_top/u_L1_D_top/u_L1_D_controller/write_index_L1_L2
add wave -noupdate -expand -group {Controller
} /tb_L1_D_top/u_L1_D_top/u_L1_D_controller/way
add wave -noupdate -expand -group {Controller
} /tb_L1_D_top/u_L1_D_top/u_L1_D_controller/valid
add wave -noupdate -expand -group {Controller
} /tb_L1_D_top/u_L1_D_top/u_L1_D_controller/dirty
add wave -noupdate -expand -group {Controller
} -radix unsigned /tb_L1_D_top/u_L1_D_top/u_L1_D_controller/state
add wave -noupdate -expand -group {Controller
} -radix unsigned /tb_L1_D_top/u_L1_D_top/u_L1_D_controller/next_state
add wave -noupdate -expand -group {Controller
} /tb_L1_D_top/u_L1_D_top/u_L1_D_controller/miss
add wave -noupdate -expand -group {Controller
} /tb_L1_D_top/u_L1_D_top/u_L1_D_controller/hit
add wave -noupdate -expand -group {Controller
} /tb_L1_D_top/u_L1_D_top/u_L1_D_controller/read_C_L1_reg
add wave -noupdate -expand -group {Controller
} /tb_L1_D_top/u_L1_D_top/u_L1_D_controller/refill_reg
add wave -noupdate -expand -group {Controller
} /tb_L1_D_top/u_L1_D_top/u_L1_D_controller/update_reg
add wave -noupdate -expand -group {Controller
} /tb_L1_D_top/u_L1_D_top/u_L1_D_controller/read_L1_L2_reg
add wave -noupdate -expand -group {Controller
} /tb_L1_D_top/u_L1_D_top/u_L1_D_controller/write_L1_L2_reg
add wave -noupdate -expand -group {Controller
} /tb_L1_D_top/u_L1_D_top/u_L1_D_controller/LRU_reg
add wave -noupdate -expand -group {Controller
} /tb_L1_D_top/u_L1_D_top/u_L1_D_controller/way_reg
add wave -noupdate -expand -group {Controller
} /tb_L1_D_top/u_L1_D_top/u_L1_D_controller/check
add wave -noupdate -expand -group {Controller
} -radix hexadecimal -childformat {{{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[63]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[62]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[61]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[60]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[59]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[58]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[57]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[56]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[55]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[54]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[53]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[52]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[51]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[50]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[49]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[48]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[47]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[46]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[45]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[44]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[43]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[42]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[41]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[40]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[39]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[38]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[37]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[36]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[35]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[34]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[33]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[32]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[31]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[30]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[29]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[28]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[27]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[26]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[25]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[24]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[23]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[22]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[21]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[20]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[19]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[18]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[17]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[16]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[15]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[14]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[13]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[12]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[11]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[10]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[9]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[8]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[7]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[6]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[5]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[4]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[3]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[2]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[1]} -radix hexadecimal} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[0]} -radix hexadecimal}} -subitemconfig {{/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[63]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[62]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[61]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[60]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[59]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[58]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[57]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[56]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[55]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[54]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[53]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[52]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[51]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[50]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[49]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[48]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[47]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[46]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[45]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[44]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[43]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[42]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[41]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[40]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[39]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[38]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[37]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[36]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[35]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[34]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[33]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[32]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[31]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[30]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[29]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[28]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[27]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[26]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[25]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[24]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[23]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[22]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[21]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[20]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[19]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[18]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[17]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[16]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[15]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[14]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[13]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[12]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[11]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[10]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[9]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[8]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[7]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[6]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[5]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[4]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[3]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[2]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[1]} {-radix hexadecimal} {/tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR[0]} {-radix hexadecimal}} /tb_L1_D_top/u_L1_D_top/u_L1_D_controller/TAG_ARR
add wave -noupdate -expand -group {data_array
} /tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/clk
add wave -noupdate -expand -group {data_array
} /tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/nrst
add wave -noupdate -expand -group {data_array
} -radix hexadecimal /tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/index_C_L1
add wave -noupdate -expand -group {data_array
} -radix hexadecimal /tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/offset
add wave -noupdate -expand -group {data_array
} -radix unsigned /tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/write_data_C_L1
add wave -noupdate -expand -group {data_array
} -radix unsigned /tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/read_data_L2_L1
add wave -noupdate -expand -group {data_array
} /tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/update
add wave -noupdate -expand -group {data_array
} /tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/refill
add wave -noupdate -expand -group {data_array
} /tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/way
add wave -noupdate -expand -group {data_array
} -radix unsigned /tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/read_data_L1_C
add wave -noupdate -expand -group {data_array
} -radix unsigned /tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/write_data_L1_L2
add wave -noupdate -expand -group {data_array
} -radix unsigned -childformat {{{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[63]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[62]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[61]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[60]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[59]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[58]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[57]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[56]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[55]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[54]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[53]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[52]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[51]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[50]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[49]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[48]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[47]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[46]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[45]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[44]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[43]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[42]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[41]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[40]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[39]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[38]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[37]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[36]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[35]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[34]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[33]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[32]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[31]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[30]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[29]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[28]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[27]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[26]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[25]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[24]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[23]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[22]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[21]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[20]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[19]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[18]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[17]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[16]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[15]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[14]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[13]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[12]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[11]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[10]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[9]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[8]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[7]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[6]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[5]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[4]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[3]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[2]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[1]} -radix unsigned} {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[0]} -radix unsigned}} -subitemconfig {{/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[63]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[62]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[61]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[60]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[59]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[58]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[57]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[56]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[55]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[54]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[53]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[52]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[51]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[50]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[49]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[48]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[47]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[46]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[45]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[44]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[43]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[42]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[41]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[40]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[39]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[38]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[37]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[36]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[35]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[34]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[33]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[32]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[31]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[30]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[29]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[28]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[27]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[26]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[25]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[24]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[23]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[22]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[21]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[20]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[19]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[18]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[17]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[16]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[15]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[14]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[13]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[12]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[11]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[10]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[9]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[8]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[7]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[6]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[5]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[4]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[3]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[2]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[1]} {-radix unsigned} {/tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR[0]} {-radix unsigned}} /tb_L1_D_top/u_L1_D_top/u_L1_D_data_array/DATA_ARR
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {15406 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 401
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
WaveRestoreZoom {12889 ns} {18149 ns}
