set_property -dict {PACKAGE_PIN C9 IOSTANDARD LVCMOS33} [get_ports rst]
set_property -dict {PACKAGE_PIN A10 IOSTANDARD LVCMOS33} [get_ports enb]
set_property -dict {PACKAGE_PIN H5 IOSTANDARD LVCMOS33} [get_ports test_led[0]]
set_property -dict { PACKAGE_PIN J5    IOSTANDARD LVCMOS33 } [get_ports { test_led[1] }]; #IO_25_35 Sch=led[5]
set_property -dict { PACKAGE_PIN T9    IOSTANDARD LVCMOS33 } [get_ports { test_led[2] }]; #IO_L24P_T3_A01_D17_14 Sch=led[6]
set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { test_led[3] }]; #IO_L24N_T3_A00_D16_14 Sch=led[7]
set_property -dict {PACKAGE_PIN D10 IOSTANDARD LVCMOS33} [get_ports tx_data]
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports clk_mem]
create_clock -period 1000.000 -name clk_mem [get_ports clk_mem]
set_property -dict {PACKAGE_PIN F4 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -period 8000.000 -name clk [get_ports clk]
# create_generated_clock -source [get_ports clk_mem] -name clk -divide_by 8 [get_ports clk]