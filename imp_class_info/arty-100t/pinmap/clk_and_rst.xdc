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
## 2017-01 : Kyuseung Han (han@etri.re.kr)
## ****************************************************************************
## ****************************************************************************

###########
## reset ##
###########

set_property -dict { PACKAGE_PIN C2    IOSTANDARD LVCMOS33 } [get_ports { external_rstnn }]; #IO_L16P_T2_35 Sch=ck_rst

###########
## clock ##
###########

set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { external_clk_0 }]; #IO_L12P_T1_MRCC_35 Sch=gclk[100]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { external_clk_0 }];
set_input_jitter [get_clocks -of_objects [get_ports external_clk_0]] 0.100
