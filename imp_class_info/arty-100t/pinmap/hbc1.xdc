set_property -dict { PACKAGE_PIN D5   IOSTANDARD LVCMOS33 } [get_ports { clk_hbc1 }]; # A5
set_property -dict { PACKAGE_PIN A3    IOSTANDARD LVCMOS33 } [get_ports { hbc1_rx_data }]; # A11

set_property -dict { PACKAGE_PIN U11   IOSTANDARD LVCMOS33 } [get_ports { hbc1_tx_clk_out }]; # IO26
set_property -dict { PACKAGE_PIN V15    IOSTANDARD LVCMOS33 } [get_ports { hbc1_tx_data }]; # IO0

create_clock -period 20.000 [get_ports clk_hbc1]
set_input_jitter [get_clocks -of_objects [get_ports clk_hbc1]] 0.100
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets clk_hbc1]
