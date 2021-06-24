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

##Pmod Header JB Upper
set_property -dict { PACKAGE_PIN E15 IOSTANDARD LVCMOS33 } [get_ports { arducam_spi_scs }]; # pin 1
set_property -dict { PACKAGE_PIN E16 IOSTANDARD LVCMOS33 } [get_ports { arducam_spi_sdq0 }]; # pin 2 (MOSI)
set_property -dict { PACKAGE_PIN D15 IOSTANDARD LVCMOS33 } [get_ports { arducam_spi_sdq1 }]; # pin 3 (MISO)
set_property -dict { PACKAGE_PIN C15 IOSTANDARD LVCMOS33 } [get_ports { arducam_spi_sclk }]; # pin 4

##Pmod Header JB Lower
set_property -dict { PACKAGE_PIN K15   IOSTANDARD LVCMOS33 } [get_ports { arducam_i2c_sclk }]; #IO_L24P_T3_RS1_15 Sch=jb_p[4]
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { arducam_i2c_sdata }]; #IO_L24N_T3_RS0_15 Sch=jb_n[4]

set_property PULLUP true [get_ports arducam_i2c_sclk ]
set_property PULLUP true [get_ports arducam_i2c_sdata ]
