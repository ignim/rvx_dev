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
## 2021-03-23
## Kyuseung Han (han@etri.re.kr)
## ****************************************************************************
## ****************************************************************************

ifdef RVX_MINI_HOME
	include ${RVX_MINI_HOME}/rvx_config.mh
else
	include ${RVX_DEVKIT_HOME}/rvx_config.mh
endif

ENGINE_WS=../platform
PLATFORM_NAME=None
-include ${RVX_ENV}/dev/rvx_dev_util.mh

TEMPLATE_FILE = ${RVX_ENV}/makefile/Makefile.imp_class_info.template
include ${RVX_UTIL_HOME}/template_makefile.mh

FPGA_LIST = $(shell ${PYTHON3_CMD} ${RVX_UTIL_HOME}/os_util.py dir_list ${CURDIR} )

reimport: $(addsuffix .reimport, $(FPGA_LIST))

$(addsuffix .reimport, $(FPGA_LIST)):%.reimport:
ifdef RVX_ETRI_HOME
	if [ -d ${RVX_ETRI_HOME}/imp_class_info/$(*) ] ;	\
	then \
		rm -rf $(*); \
		cp -r ${RVX_ETRI_HOME}/imp_class_info/$(*) .; \
	fi
else
	@echo "RVX_ETRI_HOME" does NOT exist
endif

