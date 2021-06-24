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
## 2017-02 : Kyuseung Han (han@etri.re.kr)
## ****************************************************************************
## ****************************************************************************

##########
## UART ##
##########

##Pmod Header JB
set_property -dict { PACKAGE_PIN E16   IOSTANDARD LVCMOS33  } [get_ports { uart_readymade_tx_list[0] }]; #pin 2
set_property -dict { PACKAGE_PIN D15    IOSTANDARD LVCMOS33  } [get_ports { uart_readymade_rx_list[0] }]; #pin 3
