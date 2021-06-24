## ****************************************************************************
## ****************************************************************************
## Copyright SoC Design Research Group, All rights reserved.
## Electronics and Telecommunications Research Institute (ETRI)
##
## THESE DOCUMENTS CONTAIN CONFIDENTIAL INFORMATION AND KNOWLEDGE
## WHICH IS THE PROPERTY OF ETRI. NO PART OF THIS PUBLICATION IS
## TO BE USED FOR ANY OTHER PURPOSE, AND THESE ARE NOT TO BE
## REPRODUCED, COPIED, DISCLOSED, TRANSMITTED, STORED IN A RETRIEVAL
## SYSTEM OR TRANSLATED INTO ANY OTHER HUMAN OR COMPUTER LANGUAGE,
## IN ANY FORM, BY ANY MEANS, IN WHOLE OR IN PART, WITHOUT THE
## COMPLETE PRIOR WRITTEN PERMISSION OF ETRI.
## ****************************************************************************
## 2018-03 : Sukho Lee (shlee99@etri.re.kr)
## ****************************************************************************
## ****************************************************************************

#Pmod Header JD
set_property -dict { PACKAGE_PIN D4    IOSTANDARD LVCMOS33 } [get_ports { pjtag_rtdo }]; #IO_L11N_T1_SRCC_35 Sch=jd[1]
set_property -dict { PACKAGE_PIN D3    IOSTANDARD LVCMOS33 } [get_ports { pjtag_rtrstnn }]; #IO_L11N_T1_SRCC_35 Sch=jd[2]
set_property -dict { PACKAGE_PIN F4    IOSTANDARD LVCMOS33 } [get_ports { pjtag_rtck }]; #IO_L13P_T2_MRCC_35 Sch=jd[3]
set_property -dict { PACKAGE_PIN E2    IOSTANDARD LVCMOS33 } [get_ports { pjtag_rtdi }]; #IO_L14P_T2_SRCC_35 Sch=jd[7]
set_property -dict { PACKAGE_PIN D2    IOSTANDARD LVCMOS33 } [get_ports { pjtag_rtms }]; #IO_L14N_T2_SRCC_35 Sch=jd[8]

set_property PULLUP true [get_ports pjtag_rtck]
set_property PULLUP true [get_ports pjtag_rtrstnn]
set_property PULLUP true [get_ports pjtag_rtdi]
set_property PULLUP true [get_ports pjtag_rtms]

create_clock -period 100 -waveform {0 50} -name pjtag_rclk [get_ports pjtag_rtck]

set_input_delay -clock pjtag_rclk 25.000 [get_ports pjtag_rtdi]
set_input_delay -clock pjtag_rclk 25.000 [get_ports pjtag_rtms]
set_output_delay -clock pjtag_rclk 25.000 [get_ports pjtag_rtdo]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets pjtag_rtck]

