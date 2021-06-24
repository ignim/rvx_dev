set_property -dict { PACKAGE_PIN U11   IOSTANDARD LVCMOS33 } [get_ports { clk_hbc1 }]; # IO26
set_property -dict { PACKAGE_PIN V15    IOSTANDARD LVCMOS33 } [get_ports { hbc1_rx_data }]; # IO0

set_property -dict { PACKAGE_PIN P15   IOSTANDARD LVCMOS33 } [get_ports { hbc1_tx_clk_out }]; # IO33
set_property -dict { PACKAGE_PIN T16    IOSTANDARD LVCMOS33 } [get_ports { hbc1_tx_data }]; # IO7

create_clock -period 20.000 [get_ports clk_hbc1]
set_input_jitter [get_clocks -of_objects [get_ports clk_hbc1]] 0.100
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets clk_hbc1]
