set xci_list [concat_file_list $xci_list ${PLATFORM_DIR}/user/fpga/common/xci/*/*.{xci,xcix}]
set xci_list [concat_file_list $xci_list ${PLATFORM_DIR}/user/fpga/${FPGA_NAME}/xci/*/*.{xci,xcix}]
set verilog_module_list [concat_file_list $verilog_module_list ${PLATFORM_DIR}/user/fpga/common/src/*.v]
lappend verilog_include_list ${PLATFORM_DIR}/user/fpga/common/include
set verilog_module_list [concat_file_list $verilog_module_list ${PLATFORM_DIR}/user/fpga/common/src/*.sv]
lappend verilog_include_list ${PLATFORM_DIR}/user/fpga/common/include
set vhdl_module_list [concat_file_list $vhdl_module_list ${PLATFORM_DIR}/user/fpga/common/src/*.{vhd,vhdl}]
