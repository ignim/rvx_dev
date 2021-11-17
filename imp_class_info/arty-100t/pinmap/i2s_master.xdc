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
## 2021-09-24 Kyuseung Han (han@etri.re.kr)
## ****************************************************************************
## ****************************************************************************

#Pmod Header JA Upper
set_property -dict { PACKAGE_PIN G13   IOSTANDARD LVCMOS33 } [get_ports { i2s_tx_mclk }]; # pin 1
set_property -dict { PACKAGE_PIN B11   IOSTANDARD LVCMOS33 } [get_ports { i2s_tx_lrck }]; # pin 2
set_property -dict { PACKAGE_PIN A11   IOSTANDARD LVCMOS33 } [get_ports { i2s_tx_sclk }]; # pin 3
set_property -dict { PACKAGE_PIN D12   IOSTANDARD LVCMOS33 } [get_ports { i2s_tx_dout }]; # pin 4
#Pmod Header JA Lower
set_property -dict { PACKAGE_PIN D13   IOSTANDARD LVCMOS33 } [get_ports { i2s_rx_mclk }]; # pin 7
set_property -dict { PACKAGE_PIN B18   IOSTANDARD LVCMOS33 } [get_ports { i2s_rx_lrck }]; # pin 8
set_property -dict { PACKAGE_PIN A18   IOSTANDARD LVCMOS33 } [get_ports { i2s_rx_sclk }]; # pin 9
set_property -dict { PACKAGE_PIN K16   IOSTANDARD LVCMOS33 } [get_ports { i2s_rx_din }]; # pin 10
