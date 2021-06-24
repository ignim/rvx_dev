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
## 2017-07-18 Kyuseung Han (han@etri.re.kr)
## ****************************************************************************
## ****************************************************************************

#Pmod Header JC Upper
set_property -dict { PACKAGE_PIN U12   IOSTANDARD LVCMOS33 } [get_ports { wifi_spi_scs }]; # pin 1
set_property -dict { PACKAGE_PIN V12   IOSTANDARD LVCMOS33 } [get_ports { wifi_spi_sdq0 }]; # pin 2 (MOSI)
set_property -dict { PACKAGE_PIN V10   IOSTANDARD LVCMOS33 } [get_ports { wifi_spi_sdq1 }]; # pin 3 (MISO)
set_property -dict { PACKAGE_PIN V11   IOSTANDARD LVCMOS33 } [get_ports { wifi_spi_sclk }]; # pin 4

#Pmod Header JC Lower
set_property -dict { PACKAGE_PIN U14   IOSTANDARD LVCMOS33 } [get_ports { wifi_sitr }]; # pin 7
set_property -dict { PACKAGE_PIN V14   IOSTANDARD LVCMOS33 } [get_ports { wifi_srstnn }]; # pin 8
set_property -dict { PACKAGE_PIN T13   IOSTANDARD LVCMOS33 } [get_ports { wifi_swp }]; # pin 9 
set_property -dict { PACKAGE_PIN U13   IOSTANDARD LVCMOS33 } [get_ports { wifi_shibernate }]; # pin 10
