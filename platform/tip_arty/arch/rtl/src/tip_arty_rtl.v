// ****************************************************************************
// ****************************************************************************
// Copyright SoC Design Research Group, All rights reserved.
// Electronics and Telecommunications Research Institute (ETRI)
// 
// THESE DOCUMENTS CONTAIN CONFIDENTIAL INFORMATION AND KNOWLEDGE
// WHICH IS THE PROPERTY OF ETRI. NO PART OF THIS PUBLICATION IS
// TO BE USED FOR ANY OTHER PURPOSE, AND THESE ARE NOT TO BE
// REPRODUCED, COPIED, DISCLOSED, TRANSMITTED, STORED IN A RETRIEVAL
// SYSTEM OR TRANSLATED INTO ANY OTHER HUMAN OR COMPUTER LANGUAGE,
// IN ANY FORM, BY ANY MEANS, IN WHOLE OR IN PART, WITHOUT THE
// COMPLETE PRIOR WRITTEN PERMISSION OF ETRI.
// ****************************************************************************
// 2021-06-24
// Kyuseung Han (han@etri.re.kr)
// ****************************************************************************
// ****************************************************************************

`include "ervp_platform_controller_memorymap_offset.vh"
`include "memorymap_info.vh"
`include "platform_info.vh"
`include "munoc_network_include.vh"

module TIP_ARTY_RTL
(
	boot_mode,
	clk_system,
	clk_core,
	clk_system_external,
	clk_system_debug,
	clk_local_access,
	clk_process_000,
	clk_noc,
	gclk_system,
	gclk_core,
	gclk_system_external,
	gclk_system_debug,
	gclk_local_access,
	gclk_process_000,
	gclk_noc,
	tick_1us,
	tick_62d5ms,
	external_rstnn,
	global_rstnn,
	global_rstpp,
	rstnn_seqeunce,
	rstpp_seqeunce,
	rstnn_user,
	rstpp_user,
	led_list,
	i_pll0_clk_system,
	i_system_sram_clk,
	i_system_sram_rstnn,
	oled_sdcsel,
	oled_srstnn,
	oled_svbat,
	oled_svdd,
	pjtag_rtck,
	pjtag_rtrstnn,
	pjtag_rtms,
	pjtag_rtdi,
	pjtag_rtdo,
	uart_readymade_tx_list,
	uart_readymade_rx_list,
	printf_tx,
	printf_rx,
	spi_readymade_sclk_list,
	spi_readymade_scs_list,
	spi_readymade_sdq0_list,
	spi_readymade_sdq1_list,
	oled_sclk,
	oled_scs,
	oled_sdq0,
	oled_sdq1,
	spi_flash_sclk,
	spi_flash_scs,
	spi_flash_sdq0,
	spi_flash_sdq1,
	i2c_readymade_sclk_od_list,
	i2c_readymade_sclk_out_list,
	i2c_readymade_sclk_in_list,
	i2c_readymade_sdata_od_list,
	i2c_readymade_sdata_out_list,
	i2c_readymade_sdata_in_list,
	i_system_sram_sxawready,
	i_system_sram_sxawvalid,
	i_system_sram_sxawaddr,
	i_system_sram_sxawid,
	i_system_sram_sxawlen,
	i_system_sram_sxawsize,
	i_system_sram_sxawburst,
	i_system_sram_sxwready,
	i_system_sram_sxwvalid,
	i_system_sram_sxwid,
	i_system_sram_sxwdata,
	i_system_sram_sxwstrb,
	i_system_sram_sxwlast,
	i_system_sram_sxbready,
	i_system_sram_sxbvalid,
	i_system_sram_sxbid,
	i_system_sram_sxbresp,
	i_system_sram_sxarready,
	i_system_sram_sxarvalid,
	i_system_sram_sxaraddr,
	i_system_sram_sxarid,
	i_system_sram_sxarlen,
	i_system_sram_sxarsize,
	i_system_sram_sxarburst,
	i_system_sram_sxrready,
	i_system_sram_sxrvalid,
	i_system_sram_sxrid,
	i_system_sram_sxrdata,
	i_system_sram_sxrlast,
	i_system_sram_sxrresp
);

parameter BW_FNI_PHIT = `MAX_BW_FNI_PHIT;
parameter BW_BNI_PHIT = `MAX_BW_BNI_PHIT;

input wire [(`BW_BOOT_MODE)-1:0] boot_mode;
output wire clk_system;
output wire clk_core;
output wire clk_system_external;
output wire clk_system_debug;
output wire clk_local_access;
output wire clk_process_000;
output wire clk_noc;
output wire gclk_system;
output wire gclk_core;
output wire gclk_system_external;
output wire gclk_system_debug;
output wire gclk_local_access;
output wire gclk_process_000;
output wire gclk_noc;
output wire tick_1us;
output wire tick_62d5ms;
input wire external_rstnn;
output wire global_rstnn;
output wire global_rstpp;
output wire [(5)-1:0] rstnn_seqeunce;
output wire [(5)-1:0] rstpp_seqeunce;
output wire rstnn_user;
output wire rstpp_user;
output wire [((1)*(1))-1:0] led_list;
input wire i_pll0_clk_system;
output wire i_system_sram_clk;
output wire i_system_sram_rstnn;
output wire oled_sdcsel;
output wire oled_srstnn;
output wire oled_svbat;
output wire oled_svdd;
input wire pjtag_rtck;
input wire pjtag_rtrstnn;
input wire pjtag_rtms;
input wire pjtag_rtdi;
output wire pjtag_rtdo;
output wire [((1)*(1))-1:0] uart_readymade_tx_list;
input wire [((1)*(1))-1:0] uart_readymade_rx_list;
output wire printf_tx;
input wire printf_rx;
output wire [((1)*(1))-1:0] spi_readymade_sclk_list;
output wire [((1)*(1))-1:0] spi_readymade_scs_list;
output wire [((1)*(1))-1:0] spi_readymade_sdq0_list;
input wire [((1)*(1))-1:0] spi_readymade_sdq1_list;
output wire oled_sclk;
output wire oled_scs;
output wire oled_sdq0;
input wire oled_sdq1;
output wire spi_flash_sclk;
output wire spi_flash_scs;
output wire spi_flash_sdq0;
input wire spi_flash_sdq1;
output wire [((1)*(1))-1:0] i2c_readymade_sclk_od_list;
output wire [((1)*(1))-1:0] i2c_readymade_sclk_out_list;
input wire [((1)*(1))-1:0] i2c_readymade_sclk_in_list;
output wire [((1)*(1))-1:0] i2c_readymade_sdata_od_list;
output wire [((1)*(1))-1:0] i2c_readymade_sdata_out_list;
input wire [((1)*(1))-1:0] i2c_readymade_sdata_in_list;
input wire i_system_sram_sxawready;
output wire i_system_sram_sxawvalid;
output wire [(32)-1:0] i_system_sram_sxawaddr;
output wire [(`REQUIRED_BW_OF_SLAVE_TID)-1:0] i_system_sram_sxawid;
output wire [(8)-1:0] i_system_sram_sxawlen;
output wire [(3)-1:0] i_system_sram_sxawsize;
output wire [(2)-1:0] i_system_sram_sxawburst;
input wire i_system_sram_sxwready;
output wire i_system_sram_sxwvalid;
output wire [(`REQUIRED_BW_OF_SLAVE_TID)-1:0] i_system_sram_sxwid;
output wire [(32)-1:0] i_system_sram_sxwdata;
output wire [(32/8)-1:0] i_system_sram_sxwstrb;
output wire i_system_sram_sxwlast;
output wire i_system_sram_sxbready;
input wire i_system_sram_sxbvalid;
input wire [(`REQUIRED_BW_OF_SLAVE_TID)-1:0] i_system_sram_sxbid;
input wire [(2)-1:0] i_system_sram_sxbresp;
input wire i_system_sram_sxarready;
output wire i_system_sram_sxarvalid;
output wire [(32)-1:0] i_system_sram_sxaraddr;
output wire [(`REQUIRED_BW_OF_SLAVE_TID)-1:0] i_system_sram_sxarid;
output wire [(8)-1:0] i_system_sram_sxarlen;
output wire [(3)-1:0] i_system_sram_sxarsize;
output wire [(2)-1:0] i_system_sram_sxarburst;
output wire i_system_sram_sxrready;
input wire i_system_sram_sxrvalid;
input wire [(`REQUIRED_BW_OF_SLAVE_TID)-1:0] i_system_sram_sxrid;
input wire [(32)-1:0] i_system_sram_sxrdata;
input wire i_system_sram_sxrlast;
input wire [(2)-1:0] i_system_sram_sxrresp;


wire autoname_51;
wire rstnn_noc;
wire i_main_core_clk;
wire i_main_core_rstnn;
wire [(32)-1:0] i_main_core_interrupt_vector;
wire i_main_core_interrupt_out;
wire i_main_core_inst_sxawready;
wire i_main_core_inst_sxawvalid;
wire [(32)-1:0] i_main_core_inst_sxawaddr;
wire [(4)-1:0] i_main_core_inst_sxawid;
wire [(8)-1:0] i_main_core_inst_sxawlen;
wire [(3)-1:0] i_main_core_inst_sxawsize;
wire [(2)-1:0] i_main_core_inst_sxawburst;
wire i_main_core_inst_sxwready;
wire i_main_core_inst_sxwvalid;
wire [(4)-1:0] i_main_core_inst_sxwid;
wire [(32)-1:0] i_main_core_inst_sxwdata;
wire [(32/8)-1:0] i_main_core_inst_sxwstrb;
wire i_main_core_inst_sxwlast;
wire i_main_core_inst_sxbready;
wire i_main_core_inst_sxbvalid;
wire [(4)-1:0] i_main_core_inst_sxbid;
wire [(2)-1:0] i_main_core_inst_sxbresp;
wire i_main_core_inst_sxarready;
wire i_main_core_inst_sxarvalid;
wire [(32)-1:0] i_main_core_inst_sxaraddr;
wire [(4)-1:0] i_main_core_inst_sxarid;
wire [(8)-1:0] i_main_core_inst_sxarlen;
wire [(3)-1:0] i_main_core_inst_sxarsize;
wire [(2)-1:0] i_main_core_inst_sxarburst;
wire i_main_core_inst_sxrready;
wire i_main_core_inst_sxrvalid;
wire [(4)-1:0] i_main_core_inst_sxrid;
wire [(32)-1:0] i_main_core_inst_sxrdata;
wire i_main_core_inst_sxrlast;
wire [(2)-1:0] i_main_core_inst_sxrresp;
wire i_main_core_data_sxawready;
wire i_main_core_data_sxawvalid;
wire [(32)-1:0] i_main_core_data_sxawaddr;
wire [(4)-1:0] i_main_core_data_sxawid;
wire [(8)-1:0] i_main_core_data_sxawlen;
wire [(3)-1:0] i_main_core_data_sxawsize;
wire [(2)-1:0] i_main_core_data_sxawburst;
wire i_main_core_data_sxwready;
wire i_main_core_data_sxwvalid;
wire [(4)-1:0] i_main_core_data_sxwid;
wire [(32)-1:0] i_main_core_data_sxwdata;
wire [(32/8)-1:0] i_main_core_data_sxwstrb;
wire i_main_core_data_sxwlast;
wire i_main_core_data_sxbready;
wire i_main_core_data_sxbvalid;
wire [(4)-1:0] i_main_core_data_sxbid;
wire [(2)-1:0] i_main_core_data_sxbresp;
wire i_main_core_data_sxarready;
wire i_main_core_data_sxarvalid;
wire [(32)-1:0] i_main_core_data_sxaraddr;
wire [(4)-1:0] i_main_core_data_sxarid;
wire [(8)-1:0] i_main_core_data_sxarlen;
wire [(3)-1:0] i_main_core_data_sxarsize;
wire [(2)-1:0] i_main_core_data_sxarburst;
wire i_main_core_data_sxrready;
wire i_main_core_data_sxrvalid;
wire [(4)-1:0] i_main_core_data_sxrid;
wire [(32)-1:0] i_main_core_data_sxrdata;
wire i_main_core_data_sxrlast;
wire [(2)-1:0] i_main_core_data_sxrresp;
wire [(32)-1:0] i_main_core_spc;
wire [(32)-1:0] i_main_core_sinst;
wire i_led_clk;
wire i_led_tick_62d5ms;
wire i_led_rstnn;
wire i_led_app_finished;
wire [((1)*(1))-1:0] i_led_led_list;
wire common_peri_group_clk;
wire common_peri_group_rstnn;
wire [(1)-1:0] common_peri_group_lock_status_list;
wire [(64)-1:0] common_peri_group_real_clock;
wire [(1)-1:0] common_peri_group_global_tag_list;
wire common_peri_group_rpsel;
wire common_peri_group_rpenable;
wire common_peri_group_rpwrite;
wire [(32)-1:0] common_peri_group_rpaddr;
wire [(32)-1:0] common_peri_group_rpwdata;
wire common_peri_group_rpready;
wire [(32)-1:0] common_peri_group_rprdata;
wire common_peri_group_rpslverr;
wire autoname_50_clk;
wire autoname_50_rstnn;
wire autoname_50_tick_1us;
wire autoname_50_tick_62d5ms;
wire autoname_52_clk;
wire autoname_52_rstnn;
wire autoname_52_tick_1us;
wire [(64)-1:0] autoname_52_real_clock;
wire external_peri_group_clk;
wire external_peri_group_rstnn;
wire [(32)-1:0] external_peri_group_uart_interrupts;
wire external_peri_group_spi_interrupt;
wire [(32)-1:0] external_peri_group_i2c_interrupts;
wire [(32)-1:0] external_peri_group_gpio_interrupts;
wire external_peri_group_wifi_interrupt;
wire [(32)-1:0] external_peri_group_aioif_cfg_list;
wire external_peri_group_rpsel;
wire external_peri_group_rpenable;
wire external_peri_group_rpwrite;
wire [(32)-1:0] external_peri_group_rpaddr;
wire [(32)-1:0] external_peri_group_rpwdata;
wire external_peri_group_rpready;
wire [(32)-1:0] external_peri_group_rprdata;
wire external_peri_group_rpslverr;
wire [((1)*(2))-1:0] external_peri_group_uart_tx_list;
wire [((1)*(2))-1:0] external_peri_group_uart_rx_list;
wire [((1)*(3))-1:0] external_peri_group_spi_sclk_list;
wire [((1)*(3))-1:0] external_peri_group_spi_scs_list;
wire [((1)*(3))-1:0] external_peri_group_spi_sdq0_list;
wire [((1)*(3))-1:0] external_peri_group_spi_sdq1_list;
wire [((1)*(1))-1:0] external_peri_group_i2c_sclk_od_list;
wire [((1)*(1))-1:0] external_peri_group_i2c_sclk_out_list;
wire [((1)*(1))-1:0] external_peri_group_i2c_sclk_in_list;
wire [((1)*(1))-1:0] external_peri_group_i2c_sdata_od_list;
wire [((1)*(1))-1:0] external_peri_group_i2c_sdata_out_list;
wire [((1)*(1))-1:0] external_peri_group_i2c_sdata_in_list;
wire external_peri_group_oled_sdcsel;
wire external_peri_group_oled_srstnn;
wire external_peri_group_oled_svbat;
wire external_peri_group_oled_svdd;
wire external_peri_group_wifi_sitr;
wire external_peri_group_wifi_srstnn;
wire external_peri_group_wifi_swp;
wire external_peri_group_wifi_shibernate;
wire core_peri_group_clk;
wire core_peri_group_rstnn;
wire core_peri_group_tick_1us;
wire core_peri_group_delay_notice;
wire core_peri_group_plic_interrupt;
wire [(1)-1:0] core_peri_group_lock_status_list;
wire [(1)-1:0] core_peri_group_global_tag_list;
wire [(32)-1:0] core_peri_group_core_interrupt_vector;
wire core_peri_group_rpsel;
wire core_peri_group_rpenable;
wire core_peri_group_rpwrite;
wire [(32)-1:0] core_peri_group_rpaddr;
wire [(32)-1:0] core_peri_group_rpwdata;
wire core_peri_group_rpready;
wire [(32)-1:0] core_peri_group_rprdata;
wire core_peri_group_rpslverr;
wire core_peri_group_tcu_spsel;
wire core_peri_group_tcu_spenable;
wire core_peri_group_tcu_spwrite;
wire [(32)-1:0] core_peri_group_tcu_spaddr;
wire [(32)-1:0] core_peri_group_tcu_spwdata;
wire core_peri_group_tcu_spready;
wire [(32)-1:0] core_peri_group_tcu_sprdata;
wire core_peri_group_tcu_spslverr;
wire platform_controller_clk;
wire platform_controller_external_rstnn;
wire platform_controller_global_rstnn;
wire platform_controller_global_rstpp;
wire [(5)-1:0] platform_controller_rstnn_seqeunce;
wire [(5)-1:0] platform_controller_rstpp_seqeunce;
wire [(`BW_BOOT_MODE)-1:0] platform_controller_boot_mode;
wire platform_controller_jtag_select;
wire platform_controller_initialized;
wire platform_controller_app_finished;
wire platform_controller_rstnn;
wire platform_controller_shready;
wire [(32)-1:0] platform_controller_shaddr;
wire [(3)-1:0] platform_controller_shburst;
wire platform_controller_shmasterlock;
wire [(4)-1:0] platform_controller_shprot;
wire [(3)-1:0] platform_controller_shsize;
wire [(2)-1:0] platform_controller_shtrans;
wire platform_controller_shwrite;
wire [(32)-1:0] platform_controller_shwdata;
wire [(32)-1:0] platform_controller_shrdata;
wire platform_controller_shresp;
wire platform_controller_rpsel;
wire platform_controller_rpenable;
wire platform_controller_rpwrite;
wire [(32)-1:0] platform_controller_rpaddr;
wire [(32)-1:0] platform_controller_rpwdata;
wire platform_controller_rpready;
wire [(32)-1:0] platform_controller_rprdata;
wire platform_controller_rpslverr;
wire platform_controller_pjtag_rtck;
wire platform_controller_pjtag_rtrstnn;
wire platform_controller_pjtag_rtms;
wire platform_controller_pjtag_rtdi;
wire platform_controller_pjtag_rtdo;
wire platform_controller_noc_debug_spsel;
wire platform_controller_noc_debug_spenable;
wire platform_controller_noc_debug_spwrite;
wire [(32)-1:0] platform_controller_noc_debug_spaddr;
wire [(32)-1:0] platform_controller_noc_debug_spwdata;
wire platform_controller_noc_debug_spready;
wire [(32)-1:0] platform_controller_noc_debug_sprdata;
wire platform_controller_noc_debug_spslverr;
wire [((32)*(1))-1:0] platform_controller_rpc_list;
wire [((32)*(1))-1:0] platform_controller_rinst_list;
wire default_slave_clk_network;
wire default_slave_rstnn_network;
wire default_slave_clk_debug;
wire default_slave_rstnn_debug;
wire default_slave_comm_disable;
wire [(`BW_FNI_LINK(BW_FNI_PHIT))-1:0] default_slave_rfni_link;
wire default_slave_rfni_ready;
wire [(`BW_BNI_LINK(BW_BNI_PHIT))-1:0] default_slave_rbni_link;
wire default_slave_rbni_ready;
wire default_slave_debug_rpsel;
wire default_slave_debug_rpenable;
wire default_slave_debug_rpwrite;
wire [(32)-1:0] default_slave_debug_rpaddr;
wire [(32)-1:0] default_slave_debug_rpwdata;
wire default_slave_debug_rpready;
wire [(32)-1:0] default_slave_debug_rprdata;
wire default_slave_debug_rpslverr;
wire [(`BW_SVRING_LINK)-1:0] default_slave_svri_rlink;
wire default_slave_svri_rack;
wire [(`BW_SVRING_LINK)-1:0] default_slave_svri_slink;
wire default_slave_svri_sack;
wire i_mnim_i_main_core_inst_clk;
wire i_mnim_i_main_core_inst_rstnn;
wire i_mnim_i_main_core_inst_comm_disable;
wire i_mnim_i_main_core_inst_rxawready;
wire i_mnim_i_main_core_inst_rxawvalid;
wire [(32)-1:0] i_mnim_i_main_core_inst_rxawaddr;
wire [(4)-1:0] i_mnim_i_main_core_inst_rxawid;
wire [(8)-1:0] i_mnim_i_main_core_inst_rxawlen;
wire [(3)-1:0] i_mnim_i_main_core_inst_rxawsize;
wire [(2)-1:0] i_mnim_i_main_core_inst_rxawburst;
wire i_mnim_i_main_core_inst_rxwready;
wire i_mnim_i_main_core_inst_rxwvalid;
wire [(4)-1:0] i_mnim_i_main_core_inst_rxwid;
wire [(32)-1:0] i_mnim_i_main_core_inst_rxwdata;
wire [(32/8)-1:0] i_mnim_i_main_core_inst_rxwstrb;
wire i_mnim_i_main_core_inst_rxwlast;
wire i_mnim_i_main_core_inst_rxbready;
wire i_mnim_i_main_core_inst_rxbvalid;
wire [(4)-1:0] i_mnim_i_main_core_inst_rxbid;
wire [(2)-1:0] i_mnim_i_main_core_inst_rxbresp;
wire i_mnim_i_main_core_inst_rxarready;
wire i_mnim_i_main_core_inst_rxarvalid;
wire [(32)-1:0] i_mnim_i_main_core_inst_rxaraddr;
wire [(4)-1:0] i_mnim_i_main_core_inst_rxarid;
wire [(8)-1:0] i_mnim_i_main_core_inst_rxarlen;
wire [(3)-1:0] i_mnim_i_main_core_inst_rxarsize;
wire [(2)-1:0] i_mnim_i_main_core_inst_rxarburst;
wire i_mnim_i_main_core_inst_rxrready;
wire i_mnim_i_main_core_inst_rxrvalid;
wire [(4)-1:0] i_mnim_i_main_core_inst_rxrid;
wire [(32)-1:0] i_mnim_i_main_core_inst_rxrdata;
wire i_mnim_i_main_core_inst_rxrlast;
wire [(2)-1:0] i_mnim_i_main_core_inst_rxrresp;
wire [(`BW_FNI_LINK(BW_FNI_PHIT))-1:0] i_mnim_i_main_core_inst_sfni_link;
wire i_mnim_i_main_core_inst_sfni_ready;
wire [(`BW_BNI_LINK(BW_BNI_PHIT))-1:0] i_mnim_i_main_core_inst_sbni_link;
wire i_mnim_i_main_core_inst_sbni_ready;
wire [(`BW_SVRING_LINK)-1:0] i_mnim_i_main_core_inst_svri_rlink;
wire i_mnim_i_main_core_inst_svri_rack;
wire [(`BW_SVRING_LINK)-1:0] i_mnim_i_main_core_inst_svri_slink;
wire i_mnim_i_main_core_inst_svri_sack;
wire i_mnim_i_main_core_inst_local_spsel;
wire i_mnim_i_main_core_inst_local_spenable;
wire i_mnim_i_main_core_inst_local_spwrite;
wire [(32)-1:0] i_mnim_i_main_core_inst_local_spaddr;
wire [(32)-1:0] i_mnim_i_main_core_inst_local_spwdata;
wire i_mnim_i_main_core_inst_local_spready;
wire [(32)-1:0] i_mnim_i_main_core_inst_local_sprdata;
wire i_mnim_i_main_core_inst_local_spslverr;
wire i_mnim_i_main_core_data_clk;
wire i_mnim_i_main_core_data_rstnn;
wire i_mnim_i_main_core_data_comm_disable;
wire i_mnim_i_main_core_data_rxawready;
wire i_mnim_i_main_core_data_rxawvalid;
wire [(32)-1:0] i_mnim_i_main_core_data_rxawaddr;
wire [(4)-1:0] i_mnim_i_main_core_data_rxawid;
wire [(8)-1:0] i_mnim_i_main_core_data_rxawlen;
wire [(3)-1:0] i_mnim_i_main_core_data_rxawsize;
wire [(2)-1:0] i_mnim_i_main_core_data_rxawburst;
wire i_mnim_i_main_core_data_rxwready;
wire i_mnim_i_main_core_data_rxwvalid;
wire [(4)-1:0] i_mnim_i_main_core_data_rxwid;
wire [(32)-1:0] i_mnim_i_main_core_data_rxwdata;
wire [(32/8)-1:0] i_mnim_i_main_core_data_rxwstrb;
wire i_mnim_i_main_core_data_rxwlast;
wire i_mnim_i_main_core_data_rxbready;
wire i_mnim_i_main_core_data_rxbvalid;
wire [(4)-1:0] i_mnim_i_main_core_data_rxbid;
wire [(2)-1:0] i_mnim_i_main_core_data_rxbresp;
wire i_mnim_i_main_core_data_rxarready;
wire i_mnim_i_main_core_data_rxarvalid;
wire [(32)-1:0] i_mnim_i_main_core_data_rxaraddr;
wire [(4)-1:0] i_mnim_i_main_core_data_rxarid;
wire [(8)-1:0] i_mnim_i_main_core_data_rxarlen;
wire [(3)-1:0] i_mnim_i_main_core_data_rxarsize;
wire [(2)-1:0] i_mnim_i_main_core_data_rxarburst;
wire i_mnim_i_main_core_data_rxrready;
wire i_mnim_i_main_core_data_rxrvalid;
wire [(4)-1:0] i_mnim_i_main_core_data_rxrid;
wire [(32)-1:0] i_mnim_i_main_core_data_rxrdata;
wire i_mnim_i_main_core_data_rxrlast;
wire [(2)-1:0] i_mnim_i_main_core_data_rxrresp;
wire [(`BW_FNI_LINK(BW_FNI_PHIT))-1:0] i_mnim_i_main_core_data_sfni_link;
wire i_mnim_i_main_core_data_sfni_ready;
wire [(`BW_BNI_LINK(BW_BNI_PHIT))-1:0] i_mnim_i_main_core_data_sbni_link;
wire i_mnim_i_main_core_data_sbni_ready;
wire [(`BW_SVRING_LINK)-1:0] i_mnim_i_main_core_data_svri_rlink;
wire i_mnim_i_main_core_data_svri_rack;
wire [(`BW_SVRING_LINK)-1:0] i_mnim_i_main_core_data_svri_slink;
wire i_mnim_i_main_core_data_svri_sack;
wire i_mnim_i_main_core_data_local_spsel;
wire i_mnim_i_main_core_data_local_spenable;
wire i_mnim_i_main_core_data_local_spwrite;
wire [(32)-1:0] i_mnim_i_main_core_data_local_spaddr;
wire [(32)-1:0] i_mnim_i_main_core_data_local_spwdata;
wire i_mnim_i_main_core_data_local_spready;
wire [(32)-1:0] i_mnim_i_main_core_data_local_sprdata;
wire i_mnim_i_main_core_data_local_spslverr;
wire i_mnim_platform_controller_master_clk;
wire i_mnim_platform_controller_master_rstnn;
wire i_mnim_platform_controller_master_comm_disable;
wire i_mnim_platform_controller_master_rhready;
wire [(32)-1:0] i_mnim_platform_controller_master_rhaddr;
wire [(3)-1:0] i_mnim_platform_controller_master_rhburst;
wire i_mnim_platform_controller_master_rhmasterlock;
wire [(4)-1:0] i_mnim_platform_controller_master_rhprot;
wire [(3)-1:0] i_mnim_platform_controller_master_rhsize;
wire [(2)-1:0] i_mnim_platform_controller_master_rhtrans;
wire i_mnim_platform_controller_master_rhwrite;
wire [(32)-1:0] i_mnim_platform_controller_master_rhwdata;
wire [(32)-1:0] i_mnim_platform_controller_master_rhrdata;
wire i_mnim_platform_controller_master_rhresp;
wire [(`BW_FNI_LINK(BW_FNI_PHIT))-1:0] i_mnim_platform_controller_master_sfni_link;
wire i_mnim_platform_controller_master_sfni_ready;
wire [(`BW_BNI_LINK(BW_BNI_PHIT))-1:0] i_mnim_platform_controller_master_sbni_link;
wire i_mnim_platform_controller_master_sbni_ready;
wire [(`BW_SVRING_LINK)-1:0] i_mnim_platform_controller_master_svri_rlink;
wire i_mnim_platform_controller_master_svri_rack;
wire [(`BW_SVRING_LINK)-1:0] i_mnim_platform_controller_master_svri_slink;
wire i_mnim_platform_controller_master_svri_sack;
wire i_snim_i_system_sram_no_name_clk;
wire i_snim_i_system_sram_no_name_rstnn;
wire i_snim_i_system_sram_no_name_comm_disable;
wire i_snim_i_system_sram_no_name_sxawready;
wire i_snim_i_system_sram_no_name_sxawvalid;
wire [(32)-1:0] i_snim_i_system_sram_no_name_sxawaddr;
wire [(`REQUIRED_BW_OF_SLAVE_TID)-1:0] i_snim_i_system_sram_no_name_sxawid;
wire [(8)-1:0] i_snim_i_system_sram_no_name_sxawlen;
wire [(3)-1:0] i_snim_i_system_sram_no_name_sxawsize;
wire [(2)-1:0] i_snim_i_system_sram_no_name_sxawburst;
wire i_snim_i_system_sram_no_name_sxwready;
wire i_snim_i_system_sram_no_name_sxwvalid;
wire [(`REQUIRED_BW_OF_SLAVE_TID)-1:0] i_snim_i_system_sram_no_name_sxwid;
wire [(32)-1:0] i_snim_i_system_sram_no_name_sxwdata;
wire [(32/8)-1:0] i_snim_i_system_sram_no_name_sxwstrb;
wire i_snim_i_system_sram_no_name_sxwlast;
wire i_snim_i_system_sram_no_name_sxbready;
wire i_snim_i_system_sram_no_name_sxbvalid;
wire [(`REQUIRED_BW_OF_SLAVE_TID)-1:0] i_snim_i_system_sram_no_name_sxbid;
wire [(2)-1:0] i_snim_i_system_sram_no_name_sxbresp;
wire i_snim_i_system_sram_no_name_sxarready;
wire i_snim_i_system_sram_no_name_sxarvalid;
wire [(32)-1:0] i_snim_i_system_sram_no_name_sxaraddr;
wire [(`REQUIRED_BW_OF_SLAVE_TID)-1:0] i_snim_i_system_sram_no_name_sxarid;
wire [(8)-1:0] i_snim_i_system_sram_no_name_sxarlen;
wire [(3)-1:0] i_snim_i_system_sram_no_name_sxarsize;
wire [(2)-1:0] i_snim_i_system_sram_no_name_sxarburst;
wire i_snim_i_system_sram_no_name_sxrready;
wire i_snim_i_system_sram_no_name_sxrvalid;
wire [(`REQUIRED_BW_OF_SLAVE_TID)-1:0] i_snim_i_system_sram_no_name_sxrid;
wire [(32)-1:0] i_snim_i_system_sram_no_name_sxrdata;
wire i_snim_i_system_sram_no_name_sxrlast;
wire [(2)-1:0] i_snim_i_system_sram_no_name_sxrresp;
wire [(`BW_FNI_LINK(BW_FNI_PHIT))-1:0] i_snim_i_system_sram_no_name_rfni_link;
wire i_snim_i_system_sram_no_name_rfni_ready;
wire [(`BW_BNI_LINK(BW_BNI_PHIT))-1:0] i_snim_i_system_sram_no_name_rbni_link;
wire i_snim_i_system_sram_no_name_rbni_ready;
wire [(`BW_SVRING_LINK)-1:0] i_snim_i_system_sram_no_name_svri_rlink;
wire i_snim_i_system_sram_no_name_svri_rack;
wire [(`BW_SVRING_LINK)-1:0] i_snim_i_system_sram_no_name_svri_slink;
wire i_snim_i_system_sram_no_name_svri_sack;
wire i_snim_common_peri_group_no_name_clk;
wire i_snim_common_peri_group_no_name_rstnn;
wire i_snim_common_peri_group_no_name_comm_disable;
wire i_snim_common_peri_group_no_name_spsel;
wire i_snim_common_peri_group_no_name_spenable;
wire i_snim_common_peri_group_no_name_spwrite;
wire [(32)-1:0] i_snim_common_peri_group_no_name_spaddr;
wire [(32)-1:0] i_snim_common_peri_group_no_name_spwdata;
wire i_snim_common_peri_group_no_name_spready;
wire [(32)-1:0] i_snim_common_peri_group_no_name_sprdata;
wire i_snim_common_peri_group_no_name_spslverr;
wire [(`BW_FNI_LINK(BW_FNI_PHIT))-1:0] i_snim_common_peri_group_no_name_rfni_link;
wire i_snim_common_peri_group_no_name_rfni_ready;
wire [(`BW_BNI_LINK(BW_BNI_PHIT))-1:0] i_snim_common_peri_group_no_name_rbni_link;
wire i_snim_common_peri_group_no_name_rbni_ready;
wire [(`BW_SVRING_LINK)-1:0] i_snim_common_peri_group_no_name_svri_rlink;
wire i_snim_common_peri_group_no_name_svri_rack;
wire [(`BW_SVRING_LINK)-1:0] i_snim_common_peri_group_no_name_svri_slink;
wire i_snim_common_peri_group_no_name_svri_sack;
wire i_snim_external_peri_group_no_name_clk;
wire i_snim_external_peri_group_no_name_rstnn;
wire i_snim_external_peri_group_no_name_comm_disable;
wire i_snim_external_peri_group_no_name_spsel;
wire i_snim_external_peri_group_no_name_spenable;
wire i_snim_external_peri_group_no_name_spwrite;
wire [(32)-1:0] i_snim_external_peri_group_no_name_spaddr;
wire [(32)-1:0] i_snim_external_peri_group_no_name_spwdata;
wire i_snim_external_peri_group_no_name_spready;
wire [(32)-1:0] i_snim_external_peri_group_no_name_sprdata;
wire i_snim_external_peri_group_no_name_spslverr;
wire [(`BW_FNI_LINK(BW_FNI_PHIT))-1:0] i_snim_external_peri_group_no_name_rfni_link;
wire i_snim_external_peri_group_no_name_rfni_ready;
wire [(`BW_BNI_LINK(BW_BNI_PHIT))-1:0] i_snim_external_peri_group_no_name_rbni_link;
wire i_snim_external_peri_group_no_name_rbni_ready;
wire [(`BW_SVRING_LINK)-1:0] i_snim_external_peri_group_no_name_svri_rlink;
wire i_snim_external_peri_group_no_name_svri_rack;
wire [(`BW_SVRING_LINK)-1:0] i_snim_external_peri_group_no_name_svri_slink;
wire i_snim_external_peri_group_no_name_svri_sack;
wire i_snim_platform_controller_no_name_clk;
wire i_snim_platform_controller_no_name_rstnn;
wire i_snim_platform_controller_no_name_comm_disable;
wire i_snim_platform_controller_no_name_spsel;
wire i_snim_platform_controller_no_name_spenable;
wire i_snim_platform_controller_no_name_spwrite;
wire [(32)-1:0] i_snim_platform_controller_no_name_spaddr;
wire [(32)-1:0] i_snim_platform_controller_no_name_spwdata;
wire i_snim_platform_controller_no_name_spready;
wire [(32)-1:0] i_snim_platform_controller_no_name_sprdata;
wire i_snim_platform_controller_no_name_spslverr;
wire [(`BW_FNI_LINK(BW_FNI_PHIT))-1:0] i_snim_platform_controller_no_name_rfni_link;
wire i_snim_platform_controller_no_name_rfni_ready;
wire [(`BW_BNI_LINK(BW_BNI_PHIT))-1:0] i_snim_platform_controller_no_name_rbni_link;
wire i_snim_platform_controller_no_name_rbni_ready;
wire [(`BW_SVRING_LINK)-1:0] i_snim_platform_controller_no_name_svri_rlink;
wire i_snim_platform_controller_no_name_svri_rack;
wire [(`BW_SVRING_LINK)-1:0] i_snim_platform_controller_no_name_svri_slink;
wire i_snim_platform_controller_no_name_svri_sack;
wire i_system_router_clk;
wire i_system_router_rstnn;
wire [((`BW_FNI_LINK(BW_FNI_PHIT))*(3))-1:0] i_system_router_rfni_link_list;
wire [((1)*(3))-1:0] i_system_router_rfni_ready_list;
wire [((`BW_BNI_LINK(BW_BNI_PHIT))*(3))-1:0] i_system_router_rbni_link_list;
wire [((1)*(3))-1:0] i_system_router_rbni_ready_list;
wire [((`BW_FNI_LINK(BW_FNI_PHIT))*(5))-1:0] i_system_router_sfni_link_list;
wire [((1)*(5))-1:0] i_system_router_sfni_ready_list;
wire [((`BW_BNI_LINK(BW_BNI_PHIT))*(5))-1:0] i_system_router_sbni_link_list;
wire [((1)*(5))-1:0] i_system_router_sbni_ready_list;

RVC_ORCA
#(
	.RESET_VECTOR((32'h e0000000)),
	.ENABLE_EXCEPTIONS(1),
	.ENABLE_INTERRUPTS(1),
	.NUM_INTERRUPTS(32)
)
i_main_core
(
	.clk(i_main_core_clk),
	.rstnn(i_main_core_rstnn),
	.interrupt_vector(i_main_core_interrupt_vector),
	.interrupt_out(i_main_core_interrupt_out),
	.inst_sxawready(i_main_core_inst_sxawready),
	.inst_sxawvalid(i_main_core_inst_sxawvalid),
	.inst_sxawaddr(i_main_core_inst_sxawaddr),
	.inst_sxawid(i_main_core_inst_sxawid),
	.inst_sxawlen(i_main_core_inst_sxawlen),
	.inst_sxawsize(i_main_core_inst_sxawsize),
	.inst_sxawburst(i_main_core_inst_sxawburst),
	.inst_sxwready(i_main_core_inst_sxwready),
	.inst_sxwvalid(i_main_core_inst_sxwvalid),
	.inst_sxwid(i_main_core_inst_sxwid),
	.inst_sxwdata(i_main_core_inst_sxwdata),
	.inst_sxwstrb(i_main_core_inst_sxwstrb),
	.inst_sxwlast(i_main_core_inst_sxwlast),
	.inst_sxbready(i_main_core_inst_sxbready),
	.inst_sxbvalid(i_main_core_inst_sxbvalid),
	.inst_sxbid(i_main_core_inst_sxbid),
	.inst_sxbresp(i_main_core_inst_sxbresp),
	.inst_sxarready(i_main_core_inst_sxarready),
	.inst_sxarvalid(i_main_core_inst_sxarvalid),
	.inst_sxaraddr(i_main_core_inst_sxaraddr),
	.inst_sxarid(i_main_core_inst_sxarid),
	.inst_sxarlen(i_main_core_inst_sxarlen),
	.inst_sxarsize(i_main_core_inst_sxarsize),
	.inst_sxarburst(i_main_core_inst_sxarburst),
	.inst_sxrready(i_main_core_inst_sxrready),
	.inst_sxrvalid(i_main_core_inst_sxrvalid),
	.inst_sxrid(i_main_core_inst_sxrid),
	.inst_sxrdata(i_main_core_inst_sxrdata),
	.inst_sxrlast(i_main_core_inst_sxrlast),
	.inst_sxrresp(i_main_core_inst_sxrresp),
	.data_sxawready(i_main_core_data_sxawready),
	.data_sxawvalid(i_main_core_data_sxawvalid),
	.data_sxawaddr(i_main_core_data_sxawaddr),
	.data_sxawid(i_main_core_data_sxawid),
	.data_sxawlen(i_main_core_data_sxawlen),
	.data_sxawsize(i_main_core_data_sxawsize),
	.data_sxawburst(i_main_core_data_sxawburst),
	.data_sxwready(i_main_core_data_sxwready),
	.data_sxwvalid(i_main_core_data_sxwvalid),
	.data_sxwid(i_main_core_data_sxwid),
	.data_sxwdata(i_main_core_data_sxwdata),
	.data_sxwstrb(i_main_core_data_sxwstrb),
	.data_sxwlast(i_main_core_data_sxwlast),
	.data_sxbready(i_main_core_data_sxbready),
	.data_sxbvalid(i_main_core_data_sxbvalid),
	.data_sxbid(i_main_core_data_sxbid),
	.data_sxbresp(i_main_core_data_sxbresp),
	.data_sxarready(i_main_core_data_sxarready),
	.data_sxarvalid(i_main_core_data_sxarvalid),
	.data_sxaraddr(i_main_core_data_sxaraddr),
	.data_sxarid(i_main_core_data_sxarid),
	.data_sxarlen(i_main_core_data_sxarlen),
	.data_sxarsize(i_main_core_data_sxarsize),
	.data_sxarburst(i_main_core_data_sxarburst),
	.data_sxrready(i_main_core_data_sxrready),
	.data_sxrvalid(i_main_core_data_sxrvalid),
	.data_sxrid(i_main_core_data_sxrid),
	.data_sxrdata(i_main_core_data_sxrdata),
	.data_sxrlast(i_main_core_data_sxrlast),
	.data_sxrresp(i_main_core_data_sxrresp),
	.spc(i_main_core_spc),
	.sinst(i_main_core_sinst)
);

ERVP_LED_CHECKER
#(
	.NUM_LED(1)
)
i_led
(
	.clk(i_led_clk),
	.tick_62d5ms(i_led_tick_62d5ms),
	.rstnn(i_led_rstnn),
	.app_finished(i_led_app_finished),
	.led_list(i_led_led_list)
);

ERVP_COMMON_PERI_GROUP
#(
	.BW_ADDR(32),
	.BW_DATA(32),
	.NUM_LOCK(1),
	.NUM_GLOBAL_TAG(1),
	.NUM_AUTO_ID(1)
)
common_peri_group
(
	.clk(common_peri_group_clk),
	.rstnn(common_peri_group_rstnn),
	.lock_status_list(common_peri_group_lock_status_list),
	.real_clock(common_peri_group_real_clock),
	.global_tag_list(common_peri_group_global_tag_list),
	.rpsel(common_peri_group_rpsel),
	.rpenable(common_peri_group_rpenable),
	.rpwrite(common_peri_group_rpwrite),
	.rpaddr(common_peri_group_rpaddr),
	.rpwdata(common_peri_group_rpwdata),
	.rpready(common_peri_group_rpready),
	.rprdata(common_peri_group_rprdata),
	.rpslverr(common_peri_group_rpslverr)
);

ERVP_TICK_GENERATOR
#(
	.CLK_HZ(50000000)
)
autoname_50
(
	.clk(autoname_50_clk),
	.rstnn(autoname_50_rstnn),
	.tick_1us(autoname_50_tick_1us),
	.tick_62d5ms(autoname_50_tick_62d5ms)
);

ERVP_REAL_CLOCK
autoname_52
(
	.clk(autoname_52_clk),
	.rstnn(autoname_52_rstnn),
	.tick_1us(autoname_52_tick_1us),
	.real_clock(autoname_52_real_clock)
);

ERVP_EXTERNAL_PERI_GROUP
#(
	.BW_ADDR(32),
	.BW_DATA(32),
	.NUM_UART(2),
	.NUM_SPI(3),
	.NUM_I2C(1),
	.NUM_GPIO(0)
)
external_peri_group
(
	.clk(external_peri_group_clk),
	.rstnn(external_peri_group_rstnn),
	.uart_interrupts(external_peri_group_uart_interrupts),
	.spi_interrupt(external_peri_group_spi_interrupt),
	.i2c_interrupts(external_peri_group_i2c_interrupts),
	.gpio_interrupts(external_peri_group_gpio_interrupts),
	.wifi_interrupt(external_peri_group_wifi_interrupt),
	.aioif_cfg_list(external_peri_group_aioif_cfg_list),
	.rpsel(external_peri_group_rpsel),
	.rpenable(external_peri_group_rpenable),
	.rpwrite(external_peri_group_rpwrite),
	.rpaddr(external_peri_group_rpaddr),
	.rpwdata(external_peri_group_rpwdata),
	.rpready(external_peri_group_rpready),
	.rprdata(external_peri_group_rprdata),
	.rpslverr(external_peri_group_rpslverr),
	.uart_tx_list(external_peri_group_uart_tx_list),
	.uart_rx_list(external_peri_group_uart_rx_list),
	.spi_sclk_list(external_peri_group_spi_sclk_list),
	.spi_scs_list(external_peri_group_spi_scs_list),
	.spi_sdq0_list(external_peri_group_spi_sdq0_list),
	.spi_sdq1_list(external_peri_group_spi_sdq1_list),
	.i2c_sclk_od_list(external_peri_group_i2c_sclk_od_list),
	.i2c_sclk_out_list(external_peri_group_i2c_sclk_out_list),
	.i2c_sclk_in_list(external_peri_group_i2c_sclk_in_list),
	.i2c_sdata_od_list(external_peri_group_i2c_sdata_od_list),
	.i2c_sdata_out_list(external_peri_group_i2c_sdata_out_list),
	.i2c_sdata_in_list(external_peri_group_i2c_sdata_in_list),
	.oled_sdcsel(external_peri_group_oled_sdcsel),
	.oled_srstnn(external_peri_group_oled_srstnn),
	.oled_svbat(external_peri_group_oled_svbat),
	.oled_svdd(external_peri_group_oled_svdd),
	.wifi_sitr(external_peri_group_wifi_sitr),
	.wifi_srstnn(external_peri_group_wifi_srstnn),
	.wifi_swp(external_peri_group_wifi_swp),
	.wifi_shibernate(external_peri_group_wifi_shibernate)
);

ERVP_CORE_PERI_GROUP
#(
	.BW_ADDR(32),
	.BW_DATA(32),
	.PROCESS_ID(0),
	.NUM_LOCK(1),
	.NUM_GLOBAL_TAG(1)
)
core_peri_group
(
	.clk(core_peri_group_clk),
	.rstnn(core_peri_group_rstnn),
	.tick_1us(core_peri_group_tick_1us),
	.delay_notice(core_peri_group_delay_notice),
	.plic_interrupt(core_peri_group_plic_interrupt),
	.lock_status_list(core_peri_group_lock_status_list),
	.global_tag_list(core_peri_group_global_tag_list),
	.core_interrupt_vector(core_peri_group_core_interrupt_vector),
	.rpsel(core_peri_group_rpsel),
	.rpenable(core_peri_group_rpenable),
	.rpwrite(core_peri_group_rpwrite),
	.rpaddr(core_peri_group_rpaddr),
	.rpwdata(core_peri_group_rpwdata),
	.rpready(core_peri_group_rpready),
	.rprdata(core_peri_group_rprdata),
	.rpslverr(core_peri_group_rpslverr),
	.tcu_spsel(core_peri_group_tcu_spsel),
	.tcu_spenable(core_peri_group_tcu_spenable),
	.tcu_spwrite(core_peri_group_tcu_spwrite),
	.tcu_spaddr(core_peri_group_tcu_spaddr),
	.tcu_spwdata(core_peri_group_tcu_spwdata),
	.tcu_spready(core_peri_group_tcu_spready),
	.tcu_sprdata(core_peri_group_tcu_sprdata),
	.tcu_spslverr(core_peri_group_tcu_spslverr)
);

ERVP_PLATFORM_CONTROLLER
#(
	.BW_ADDR(32),
	.NUM_RESET(5),
	.NUM_AUTO_RESET(3),
	.NUM_CORE(1)
)
platform_controller
(
	.clk(platform_controller_clk),
	.external_rstnn(platform_controller_external_rstnn),
	.global_rstnn(platform_controller_global_rstnn),
	.global_rstpp(platform_controller_global_rstpp),
	.rstnn_seqeunce(platform_controller_rstnn_seqeunce),
	.rstpp_seqeunce(platform_controller_rstpp_seqeunce),
	.boot_mode(platform_controller_boot_mode),
	.jtag_select(platform_controller_jtag_select),
	.initialized(platform_controller_initialized),
	.app_finished(platform_controller_app_finished),
	.rstnn(platform_controller_rstnn),
	.shready(platform_controller_shready),
	.shaddr(platform_controller_shaddr),
	.shburst(platform_controller_shburst),
	.shmasterlock(platform_controller_shmasterlock),
	.shprot(platform_controller_shprot),
	.shsize(platform_controller_shsize),
	.shtrans(platform_controller_shtrans),
	.shwrite(platform_controller_shwrite),
	.shwdata(platform_controller_shwdata),
	.shrdata(platform_controller_shrdata),
	.shresp(platform_controller_shresp),
	.rpsel(platform_controller_rpsel),
	.rpenable(platform_controller_rpenable),
	.rpwrite(platform_controller_rpwrite),
	.rpaddr(platform_controller_rpaddr),
	.rpwdata(platform_controller_rpwdata),
	.rpready(platform_controller_rpready),
	.rprdata(platform_controller_rprdata),
	.rpslverr(platform_controller_rpslverr),
	.pjtag_rtck(platform_controller_pjtag_rtck),
	.pjtag_rtrstnn(platform_controller_pjtag_rtrstnn),
	.pjtag_rtms(platform_controller_pjtag_rtms),
	.pjtag_rtdi(platform_controller_pjtag_rtdi),
	.pjtag_rtdo(platform_controller_pjtag_rtdo),
	.noc_debug_spsel(platform_controller_noc_debug_spsel),
	.noc_debug_spenable(platform_controller_noc_debug_spenable),
	.noc_debug_spwrite(platform_controller_noc_debug_spwrite),
	.noc_debug_spaddr(platform_controller_noc_debug_spaddr),
	.noc_debug_spwdata(platform_controller_noc_debug_spwdata),
	.noc_debug_spready(platform_controller_noc_debug_spready),
	.noc_debug_sprdata(platform_controller_noc_debug_sprdata),
	.noc_debug_spslverr(platform_controller_noc_debug_spslverr),
	.rpc_list(platform_controller_rpc_list),
	.rinst_list(platform_controller_rinst_list)
);

MUNOC_DEFAULT_SNIM
#(
	.NODE_ID(`NODE_ID_DEFAULT_SLAVE),
	.BW_FNI_PHIT(BW_FNI_PHIT),
	.BW_BNI_PHIT(BW_BNI_PHIT),
	.BW_PLATFORM_ADDR(32),
	.USE_SW_INTERFACE(1),
	.USE_JTAG_INTERFACE(1),
	.NOC_CONTROLLER_BASEADDR(`NOC_CONTROLLER_BASEADDR)
)
default_slave
(
	.clk_network(default_slave_clk_network),
	.rstnn_network(default_slave_rstnn_network),
	.clk_debug(default_slave_clk_debug),
	.rstnn_debug(default_slave_rstnn_debug),
	.comm_disable(default_slave_comm_disable),
	.rfni_link(default_slave_rfni_link),
	.rfni_ready(default_slave_rfni_ready),
	.rbni_link(default_slave_rbni_link),
	.rbni_ready(default_slave_rbni_ready),
	.debug_rpsel(default_slave_debug_rpsel),
	.debug_rpenable(default_slave_debug_rpenable),
	.debug_rpwrite(default_slave_debug_rpwrite),
	.debug_rpaddr(default_slave_debug_rpaddr),
	.debug_rpwdata(default_slave_debug_rpwdata),
	.debug_rpready(default_slave_debug_rpready),
	.debug_rprdata(default_slave_debug_rprdata),
	.debug_rpslverr(default_slave_debug_rpslverr),
	.svri_rlink(default_slave_svri_rlink),
	.svri_rack(default_slave_svri_rack),
	.svri_slink(default_slave_svri_slink),
	.svri_sack(default_slave_svri_sack)
);

MUNOC_AXI_MASTER_NETWORK_INTERFACE_MODULE
#(
	.NODE_ID(`NODE_ID_I_MNIM_I_MAIN_CORE_INST),
	.BW_FNI_PHIT(BW_FNI_PHIT),
	.BW_BNI_PHIT(BW_BNI_PHIT),
	.BW_PLATFORM_ADDR(32),
	.BW_NODE_DATA(32),
	.NAME("i_main_core_inst"),
	.BW_AXI_MASTER_TID(4)
)
i_mnim_i_main_core_inst
(
	.clk(i_mnim_i_main_core_inst_clk),
	.rstnn(i_mnim_i_main_core_inst_rstnn),
	.comm_disable(i_mnim_i_main_core_inst_comm_disable),
	.rxawready(i_mnim_i_main_core_inst_rxawready),
	.rxawvalid(i_mnim_i_main_core_inst_rxawvalid),
	.rxawaddr(i_mnim_i_main_core_inst_rxawaddr),
	.rxawid(i_mnim_i_main_core_inst_rxawid),
	.rxawlen(i_mnim_i_main_core_inst_rxawlen),
	.rxawsize(i_mnim_i_main_core_inst_rxawsize),
	.rxawburst(i_mnim_i_main_core_inst_rxawburst),
	.rxwready(i_mnim_i_main_core_inst_rxwready),
	.rxwvalid(i_mnim_i_main_core_inst_rxwvalid),
	.rxwid(i_mnim_i_main_core_inst_rxwid),
	.rxwdata(i_mnim_i_main_core_inst_rxwdata),
	.rxwstrb(i_mnim_i_main_core_inst_rxwstrb),
	.rxwlast(i_mnim_i_main_core_inst_rxwlast),
	.rxbready(i_mnim_i_main_core_inst_rxbready),
	.rxbvalid(i_mnim_i_main_core_inst_rxbvalid),
	.rxbid(i_mnim_i_main_core_inst_rxbid),
	.rxbresp(i_mnim_i_main_core_inst_rxbresp),
	.rxarready(i_mnim_i_main_core_inst_rxarready),
	.rxarvalid(i_mnim_i_main_core_inst_rxarvalid),
	.rxaraddr(i_mnim_i_main_core_inst_rxaraddr),
	.rxarid(i_mnim_i_main_core_inst_rxarid),
	.rxarlen(i_mnim_i_main_core_inst_rxarlen),
	.rxarsize(i_mnim_i_main_core_inst_rxarsize),
	.rxarburst(i_mnim_i_main_core_inst_rxarburst),
	.rxrready(i_mnim_i_main_core_inst_rxrready),
	.rxrvalid(i_mnim_i_main_core_inst_rxrvalid),
	.rxrid(i_mnim_i_main_core_inst_rxrid),
	.rxrdata(i_mnim_i_main_core_inst_rxrdata),
	.rxrlast(i_mnim_i_main_core_inst_rxrlast),
	.rxrresp(i_mnim_i_main_core_inst_rxrresp),
	.sfni_link(i_mnim_i_main_core_inst_sfni_link),
	.sfni_ready(i_mnim_i_main_core_inst_sfni_ready),
	.sbni_link(i_mnim_i_main_core_inst_sbni_link),
	.sbni_ready(i_mnim_i_main_core_inst_sbni_ready),
	.svri_rlink(i_mnim_i_main_core_inst_svri_rlink),
	.svri_rack(i_mnim_i_main_core_inst_svri_rack),
	.svri_slink(i_mnim_i_main_core_inst_svri_slink),
	.svri_sack(i_mnim_i_main_core_inst_svri_sack),
	.local_spsel(i_mnim_i_main_core_inst_local_spsel),
	.local_spenable(i_mnim_i_main_core_inst_local_spenable),
	.local_spwrite(i_mnim_i_main_core_inst_local_spwrite),
	.local_spaddr(i_mnim_i_main_core_inst_local_spaddr),
	.local_spwdata(i_mnim_i_main_core_inst_local_spwdata),
	.local_spready(i_mnim_i_main_core_inst_local_spready),
	.local_sprdata(i_mnim_i_main_core_inst_local_sprdata),
	.local_spslverr(i_mnim_i_main_core_inst_local_spslverr)
);

MUNOC_AXI_MASTER_NETWORK_INTERFACE_MODULE
#(
	.NODE_ID(`NODE_ID_I_MNIM_I_MAIN_CORE_DATA),
	.BW_FNI_PHIT(BW_FNI_PHIT),
	.BW_BNI_PHIT(BW_BNI_PHIT),
	.BW_PLATFORM_ADDR(32),
	.BW_NODE_DATA(32),
	.LOCAL_ENABLE(1),
	.LOCAL_UPPER_ADDR(4'h F),
	.NAME("i_main_core_data"),
	.BW_AXI_MASTER_TID(4)
)
i_mnim_i_main_core_data
(
	.clk(i_mnim_i_main_core_data_clk),
	.rstnn(i_mnim_i_main_core_data_rstnn),
	.comm_disable(i_mnim_i_main_core_data_comm_disable),
	.rxawready(i_mnim_i_main_core_data_rxawready),
	.rxawvalid(i_mnim_i_main_core_data_rxawvalid),
	.rxawaddr(i_mnim_i_main_core_data_rxawaddr),
	.rxawid(i_mnim_i_main_core_data_rxawid),
	.rxawlen(i_mnim_i_main_core_data_rxawlen),
	.rxawsize(i_mnim_i_main_core_data_rxawsize),
	.rxawburst(i_mnim_i_main_core_data_rxawburst),
	.rxwready(i_mnim_i_main_core_data_rxwready),
	.rxwvalid(i_mnim_i_main_core_data_rxwvalid),
	.rxwid(i_mnim_i_main_core_data_rxwid),
	.rxwdata(i_mnim_i_main_core_data_rxwdata),
	.rxwstrb(i_mnim_i_main_core_data_rxwstrb),
	.rxwlast(i_mnim_i_main_core_data_rxwlast),
	.rxbready(i_mnim_i_main_core_data_rxbready),
	.rxbvalid(i_mnim_i_main_core_data_rxbvalid),
	.rxbid(i_mnim_i_main_core_data_rxbid),
	.rxbresp(i_mnim_i_main_core_data_rxbresp),
	.rxarready(i_mnim_i_main_core_data_rxarready),
	.rxarvalid(i_mnim_i_main_core_data_rxarvalid),
	.rxaraddr(i_mnim_i_main_core_data_rxaraddr),
	.rxarid(i_mnim_i_main_core_data_rxarid),
	.rxarlen(i_mnim_i_main_core_data_rxarlen),
	.rxarsize(i_mnim_i_main_core_data_rxarsize),
	.rxarburst(i_mnim_i_main_core_data_rxarburst),
	.rxrready(i_mnim_i_main_core_data_rxrready),
	.rxrvalid(i_mnim_i_main_core_data_rxrvalid),
	.rxrid(i_mnim_i_main_core_data_rxrid),
	.rxrdata(i_mnim_i_main_core_data_rxrdata),
	.rxrlast(i_mnim_i_main_core_data_rxrlast),
	.rxrresp(i_mnim_i_main_core_data_rxrresp),
	.sfni_link(i_mnim_i_main_core_data_sfni_link),
	.sfni_ready(i_mnim_i_main_core_data_sfni_ready),
	.sbni_link(i_mnim_i_main_core_data_sbni_link),
	.sbni_ready(i_mnim_i_main_core_data_sbni_ready),
	.svri_rlink(i_mnim_i_main_core_data_svri_rlink),
	.svri_rack(i_mnim_i_main_core_data_svri_rack),
	.svri_slink(i_mnim_i_main_core_data_svri_slink),
	.svri_sack(i_mnim_i_main_core_data_svri_sack),
	.local_spsel(i_mnim_i_main_core_data_local_spsel),
	.local_spenable(i_mnim_i_main_core_data_local_spenable),
	.local_spwrite(i_mnim_i_main_core_data_local_spwrite),
	.local_spaddr(i_mnim_i_main_core_data_local_spaddr),
	.local_spwdata(i_mnim_i_main_core_data_local_spwdata),
	.local_spready(i_mnim_i_main_core_data_local_spready),
	.local_sprdata(i_mnim_i_main_core_data_local_sprdata),
	.local_spslverr(i_mnim_i_main_core_data_local_spslverr)
);

MUNOC_AHB_MASTER_NETWORK_INTERFACE_MODULE
#(
	.NODE_ID(`NODE_ID_I_MNIM_PLATFORM_CONTROLLER_MASTER),
	.BW_FNI_PHIT(BW_FNI_PHIT),
	.BW_BNI_PHIT(BW_BNI_PHIT),
	.BW_PLATFORM_ADDR(32),
	.BW_NODE_DATA(32),
	.NAME("platform_controller_master")
)
i_mnim_platform_controller_master
(
	.clk(i_mnim_platform_controller_master_clk),
	.rstnn(i_mnim_platform_controller_master_rstnn),
	.comm_disable(i_mnim_platform_controller_master_comm_disable),
	.rhready(i_mnim_platform_controller_master_rhready),
	.rhaddr(i_mnim_platform_controller_master_rhaddr),
	.rhburst(i_mnim_platform_controller_master_rhburst),
	.rhmasterlock(i_mnim_platform_controller_master_rhmasterlock),
	.rhprot(i_mnim_platform_controller_master_rhprot),
	.rhsize(i_mnim_platform_controller_master_rhsize),
	.rhtrans(i_mnim_platform_controller_master_rhtrans),
	.rhwrite(i_mnim_platform_controller_master_rhwrite),
	.rhwdata(i_mnim_platform_controller_master_rhwdata),
	.rhrdata(i_mnim_platform_controller_master_rhrdata),
	.rhresp(i_mnim_platform_controller_master_rhresp),
	.sfni_link(i_mnim_platform_controller_master_sfni_link),
	.sfni_ready(i_mnim_platform_controller_master_sfni_ready),
	.sbni_link(i_mnim_platform_controller_master_sbni_link),
	.sbni_ready(i_mnim_platform_controller_master_sbni_ready),
	.svri_rlink(i_mnim_platform_controller_master_svri_rlink),
	.svri_rack(i_mnim_platform_controller_master_svri_rack),
	.svri_slink(i_mnim_platform_controller_master_svri_slink),
	.svri_sack(i_mnim_platform_controller_master_svri_sack)
);

MUNOC_AXI_SLAVE_NETWORK_INTERFACE_MODULE
#(
	.NODE_ID(`NODE_ID_I_SNIM_I_SYSTEM_SRAM_NO_NAME),
	.BW_FNI_PHIT(BW_FNI_PHIT),
	.BW_BNI_PHIT(BW_BNI_PHIT),
	.BW_PLATFORM_ADDR(32),
	.BW_NODE_DATA(32),
	.NAME("i_system_sram_no_name"),
	.BW_AXI_SLAVE_TID(`REQUIRED_BW_OF_SLAVE_TID)
)
i_snim_i_system_sram_no_name
(
	.clk(i_snim_i_system_sram_no_name_clk),
	.rstnn(i_snim_i_system_sram_no_name_rstnn),
	.comm_disable(i_snim_i_system_sram_no_name_comm_disable),
	.sxawready(i_snim_i_system_sram_no_name_sxawready),
	.sxawvalid(i_snim_i_system_sram_no_name_sxawvalid),
	.sxawaddr(i_snim_i_system_sram_no_name_sxawaddr),
	.sxawid(i_snim_i_system_sram_no_name_sxawid),
	.sxawlen(i_snim_i_system_sram_no_name_sxawlen),
	.sxawsize(i_snim_i_system_sram_no_name_sxawsize),
	.sxawburst(i_snim_i_system_sram_no_name_sxawburst),
	.sxwready(i_snim_i_system_sram_no_name_sxwready),
	.sxwvalid(i_snim_i_system_sram_no_name_sxwvalid),
	.sxwid(i_snim_i_system_sram_no_name_sxwid),
	.sxwdata(i_snim_i_system_sram_no_name_sxwdata),
	.sxwstrb(i_snim_i_system_sram_no_name_sxwstrb),
	.sxwlast(i_snim_i_system_sram_no_name_sxwlast),
	.sxbready(i_snim_i_system_sram_no_name_sxbready),
	.sxbvalid(i_snim_i_system_sram_no_name_sxbvalid),
	.sxbid(i_snim_i_system_sram_no_name_sxbid),
	.sxbresp(i_snim_i_system_sram_no_name_sxbresp),
	.sxarready(i_snim_i_system_sram_no_name_sxarready),
	.sxarvalid(i_snim_i_system_sram_no_name_sxarvalid),
	.sxaraddr(i_snim_i_system_sram_no_name_sxaraddr),
	.sxarid(i_snim_i_system_sram_no_name_sxarid),
	.sxarlen(i_snim_i_system_sram_no_name_sxarlen),
	.sxarsize(i_snim_i_system_sram_no_name_sxarsize),
	.sxarburst(i_snim_i_system_sram_no_name_sxarburst),
	.sxrready(i_snim_i_system_sram_no_name_sxrready),
	.sxrvalid(i_snim_i_system_sram_no_name_sxrvalid),
	.sxrid(i_snim_i_system_sram_no_name_sxrid),
	.sxrdata(i_snim_i_system_sram_no_name_sxrdata),
	.sxrlast(i_snim_i_system_sram_no_name_sxrlast),
	.sxrresp(i_snim_i_system_sram_no_name_sxrresp),
	.rfni_link(i_snim_i_system_sram_no_name_rfni_link),
	.rfni_ready(i_snim_i_system_sram_no_name_rfni_ready),
	.rbni_link(i_snim_i_system_sram_no_name_rbni_link),
	.rbni_ready(i_snim_i_system_sram_no_name_rbni_ready),
	.svri_rlink(i_snim_i_system_sram_no_name_svri_rlink),
	.svri_rack(i_snim_i_system_sram_no_name_svri_rack),
	.svri_slink(i_snim_i_system_sram_no_name_svri_slink),
	.svri_sack(i_snim_i_system_sram_no_name_svri_sack)
);

MUNOC_APB_SLAVE_NETWORK_INTERFACE_MODULE
#(
	.NODE_ID(`NODE_ID_I_SNIM_COMMON_PERI_GROUP_NO_NAME),
	.BW_FNI_PHIT(BW_FNI_PHIT),
	.BW_BNI_PHIT(BW_BNI_PHIT),
	.BW_PLATFORM_ADDR(32),
	.BW_NODE_DATA(32),
	.NAME("common_peri_group_no_name")
)
i_snim_common_peri_group_no_name
(
	.clk(i_snim_common_peri_group_no_name_clk),
	.rstnn(i_snim_common_peri_group_no_name_rstnn),
	.comm_disable(i_snim_common_peri_group_no_name_comm_disable),
	.spsel(i_snim_common_peri_group_no_name_spsel),
	.spenable(i_snim_common_peri_group_no_name_spenable),
	.spwrite(i_snim_common_peri_group_no_name_spwrite),
	.spaddr(i_snim_common_peri_group_no_name_spaddr),
	.spwdata(i_snim_common_peri_group_no_name_spwdata),
	.spready(i_snim_common_peri_group_no_name_spready),
	.sprdata(i_snim_common_peri_group_no_name_sprdata),
	.spslverr(i_snim_common_peri_group_no_name_spslverr),
	.rfni_link(i_snim_common_peri_group_no_name_rfni_link),
	.rfni_ready(i_snim_common_peri_group_no_name_rfni_ready),
	.rbni_link(i_snim_common_peri_group_no_name_rbni_link),
	.rbni_ready(i_snim_common_peri_group_no_name_rbni_ready),
	.svri_rlink(i_snim_common_peri_group_no_name_svri_rlink),
	.svri_rack(i_snim_common_peri_group_no_name_svri_rack),
	.svri_slink(i_snim_common_peri_group_no_name_svri_slink),
	.svri_sack(i_snim_common_peri_group_no_name_svri_sack)
);

MUNOC_APB_SLAVE_NETWORK_INTERFACE_MODULE
#(
	.NODE_ID(`NODE_ID_I_SNIM_EXTERNAL_PERI_GROUP_NO_NAME),
	.BW_FNI_PHIT(BW_FNI_PHIT),
	.BW_BNI_PHIT(BW_BNI_PHIT),
	.BW_PLATFORM_ADDR(32),
	.BW_NODE_DATA(32),
	.NAME("external_peri_group_no_name")
)
i_snim_external_peri_group_no_name
(
	.clk(i_snim_external_peri_group_no_name_clk),
	.rstnn(i_snim_external_peri_group_no_name_rstnn),
	.comm_disable(i_snim_external_peri_group_no_name_comm_disable),
	.spsel(i_snim_external_peri_group_no_name_spsel),
	.spenable(i_snim_external_peri_group_no_name_spenable),
	.spwrite(i_snim_external_peri_group_no_name_spwrite),
	.spaddr(i_snim_external_peri_group_no_name_spaddr),
	.spwdata(i_snim_external_peri_group_no_name_spwdata),
	.spready(i_snim_external_peri_group_no_name_spready),
	.sprdata(i_snim_external_peri_group_no_name_sprdata),
	.spslverr(i_snim_external_peri_group_no_name_spslverr),
	.rfni_link(i_snim_external_peri_group_no_name_rfni_link),
	.rfni_ready(i_snim_external_peri_group_no_name_rfni_ready),
	.rbni_link(i_snim_external_peri_group_no_name_rbni_link),
	.rbni_ready(i_snim_external_peri_group_no_name_rbni_ready),
	.svri_rlink(i_snim_external_peri_group_no_name_svri_rlink),
	.svri_rack(i_snim_external_peri_group_no_name_svri_rack),
	.svri_slink(i_snim_external_peri_group_no_name_svri_slink),
	.svri_sack(i_snim_external_peri_group_no_name_svri_sack)
);

MUNOC_APB_SLAVE_NETWORK_INTERFACE_MODULE
#(
	.NODE_ID(`NODE_ID_I_SNIM_PLATFORM_CONTROLLER_NO_NAME),
	.BW_FNI_PHIT(BW_FNI_PHIT),
	.BW_BNI_PHIT(BW_BNI_PHIT),
	.BW_PLATFORM_ADDR(32),
	.BW_NODE_DATA(32),
	.NAME("platform_controller_no_name")
)
i_snim_platform_controller_no_name
(
	.clk(i_snim_platform_controller_no_name_clk),
	.rstnn(i_snim_platform_controller_no_name_rstnn),
	.comm_disable(i_snim_platform_controller_no_name_comm_disable),
	.spsel(i_snim_platform_controller_no_name_spsel),
	.spenable(i_snim_platform_controller_no_name_spenable),
	.spwrite(i_snim_platform_controller_no_name_spwrite),
	.spaddr(i_snim_platform_controller_no_name_spaddr),
	.spwdata(i_snim_platform_controller_no_name_spwdata),
	.spready(i_snim_platform_controller_no_name_spready),
	.sprdata(i_snim_platform_controller_no_name_sprdata),
	.spslverr(i_snim_platform_controller_no_name_spslverr),
	.rfni_link(i_snim_platform_controller_no_name_rfni_link),
	.rfni_ready(i_snim_platform_controller_no_name_rfni_ready),
	.rbni_link(i_snim_platform_controller_no_name_rbni_link),
	.rbni_ready(i_snim_platform_controller_no_name_rbni_ready),
	.svri_rlink(i_snim_platform_controller_no_name_svri_rlink),
	.svri_rack(i_snim_platform_controller_no_name_svri_rack),
	.svri_slink(i_snim_platform_controller_no_name_svri_slink),
	.svri_sack(i_snim_platform_controller_no_name_svri_sack)
);

MUNOC_NETWORK_DUAL_ROUTER
#(
	.BW_FNI_PHIT(BW_FNI_PHIT),
	.BW_BNI_PHIT(BW_BNI_PHIT),
	.NUM_MASTER(3),
	.NUM_SLAVE(5),
	.ROUTER_ID(`ROUTER_ID_I_SYSTEM_ROUTER)
)
i_system_router
(
	.clk(i_system_router_clk),
	.rstnn(i_system_router_rstnn),
	.rfni_link_list(i_system_router_rfni_link_list),
	.rfni_ready_list(i_system_router_rfni_ready_list),
	.rbni_link_list(i_system_router_rbni_link_list),
	.rbni_ready_list(i_system_router_rbni_ready_list),
	.sfni_link_list(i_system_router_sfni_link_list),
	.sfni_ready_list(i_system_router_sfni_ready_list),
	.sbni_link_list(i_system_router_sbni_link_list),
	.sbni_ready_list(i_system_router_sbni_ready_list)
);

assign clk_core = clk_system;
assign clk_system_external = clk_system;
assign clk_system_debug = clk_system;
assign clk_local_access = clk_core;
assign clk_process_000 = clk_core;
assign clk_noc = clk_core;
assign gclk_system = clk_system;
assign gclk_core = clk_core;
assign gclk_system_external = clk_system_external;
assign gclk_system_debug = clk_system_debug;
assign gclk_local_access = clk_local_access;
assign gclk_process_000 = clk_process_000;
assign gclk_noc = clk_noc;
assign tick_1us = autoname_50_tick_1us;
assign tick_62d5ms = autoname_50_tick_62d5ms;
assign autoname_51 = tick_1us;
assign global_rstnn = platform_controller_global_rstnn;
assign global_rstpp = platform_controller_global_rstpp;
assign i_led_rstnn = rstnn_seqeunce[1];
assign autoname_50_rstnn = rstnn_seqeunce[1];
assign autoname_52_rstnn = rstnn_seqeunce[1];
assign platform_controller_rstnn = rstnn_seqeunce[1];
assign default_slave_rstnn_network = rstnn_seqeunce[1];
assign default_slave_rstnn_debug = rstnn_seqeunce[1];
assign rstnn_seqeunce = platform_controller_rstnn_seqeunce;
assign rstpp_seqeunce = platform_controller_rstpp_seqeunce;
assign i_system_sram_rstnn = rstnn_seqeunce[2];
assign common_peri_group_rstnn = rstnn_seqeunce[2];
assign external_peri_group_rstnn = rstnn_seqeunce[2];
assign core_peri_group_rstnn = rstnn_seqeunce[3];
assign i_main_core_rstnn = rstnn_seqeunce[4];
assign rstnn_user = rstnn_seqeunce[3];
assign rstpp_user = rstpp_seqeunce[3];
assign i_led_clk = gclk_system_external;
assign external_peri_group_clk = gclk_system_external;
assign clk_system = i_pll0_clk_system;
assign common_peri_group_clk = clk_system;
assign autoname_50_clk = clk_system;
assign autoname_52_clk = clk_system;
assign core_peri_group_clk = gclk_local_access;
assign platform_controller_clk = gclk_system_debug;
assign default_slave_clk_debug = gclk_system_debug;
assign i_main_core_clk = gclk_process_000;
assign rstnn_noc = rstnn_seqeunce[1];
assign i_system_router_rstnn = rstnn_noc;
assign i_system_router_clk = gclk_noc;
assign i_system_sram_clk = gclk_noc;
assign default_slave_clk_network = gclk_noc;
assign i_mnim_i_main_core_inst_clk = gclk_noc;
assign i_mnim_i_main_core_inst_rstnn = rstnn_noc;
assign i_mnim_i_main_core_data_clk = gclk_noc;
assign i_mnim_i_main_core_data_rstnn = rstnn_noc;
assign i_mnim_platform_controller_master_clk = gclk_noc;
assign i_mnim_platform_controller_master_rstnn = rstnn_noc;
assign i_snim_i_system_sram_no_name_clk = gclk_noc;
assign i_snim_i_system_sram_no_name_rstnn = rstnn_noc;
assign i_snim_common_peri_group_no_name_clk = gclk_noc;
assign i_snim_common_peri_group_no_name_rstnn = rstnn_noc;
assign i_snim_external_peri_group_no_name_clk = gclk_noc;
assign i_snim_external_peri_group_no_name_rstnn = rstnn_noc;
assign i_snim_platform_controller_no_name_clk = gclk_noc;
assign i_snim_platform_controller_no_name_rstnn = rstnn_noc;
assign i_led_tick_62d5ms = autoname_50_tick_62d5ms;
assign i_led_app_finished = platform_controller_app_finished;
assign core_peri_group_lock_status_list = common_peri_group_lock_status_list;
assign common_peri_group_real_clock = autoname_52_real_clock;
assign core_peri_group_global_tag_list = common_peri_group_global_tag_list;
assign autoname_52_tick_1us = autoname_50_tick_1us;
assign core_peri_group_tick_1us = autoname_51;
assign platform_controller_external_rstnn = external_rstnn;
assign platform_controller_boot_mode = boot_mode;
assign platform_controller_jtag_select = `JTAG_SELECT_NOC;
assign platform_controller_initialized = 1'b 1;
assign i_main_core_interrupt_vector = core_peri_group_core_interrupt_vector;
assign default_slave_comm_disable = 0;
assign core_peri_group_plic_interrupt = 0;
assign i_mnim_i_main_core_inst_comm_disable = 0;
assign i_mnim_i_main_core_data_comm_disable = 0;
assign i_mnim_platform_controller_master_comm_disable = 0;
assign i_snim_platform_controller_no_name_comm_disable = 0;
assign i_snim_i_system_sram_no_name_comm_disable = 0;
assign i_snim_common_peri_group_no_name_comm_disable = 0;
assign i_snim_external_peri_group_no_name_comm_disable = 0;
assign led_list[1*(0+1)-1 -:1] = i_led_led_list[1*(0+1)-1 -:1];
assign i_main_core_inst_sxawready = i_mnim_i_main_core_inst_rxawready;
assign i_mnim_i_main_core_inst_rxawvalid = i_main_core_inst_sxawvalid;
assign i_mnim_i_main_core_inst_rxawaddr = i_main_core_inst_sxawaddr;
assign i_mnim_i_main_core_inst_rxawid = i_main_core_inst_sxawid;
assign i_mnim_i_main_core_inst_rxawlen = i_main_core_inst_sxawlen;
assign i_mnim_i_main_core_inst_rxawsize = i_main_core_inst_sxawsize;
assign i_mnim_i_main_core_inst_rxawburst = i_main_core_inst_sxawburst;
assign i_main_core_inst_sxwready = i_mnim_i_main_core_inst_rxwready;
assign i_mnim_i_main_core_inst_rxwvalid = i_main_core_inst_sxwvalid;
assign i_mnim_i_main_core_inst_rxwid = i_main_core_inst_sxwid;
assign i_mnim_i_main_core_inst_rxwdata = i_main_core_inst_sxwdata;
assign i_mnim_i_main_core_inst_rxwstrb = i_main_core_inst_sxwstrb;
assign i_mnim_i_main_core_inst_rxwlast = i_main_core_inst_sxwlast;
assign i_mnim_i_main_core_inst_rxbready = i_main_core_inst_sxbready;
assign i_main_core_inst_sxbvalid = i_mnim_i_main_core_inst_rxbvalid;
assign i_main_core_inst_sxbid = i_mnim_i_main_core_inst_rxbid;
assign i_main_core_inst_sxbresp = i_mnim_i_main_core_inst_rxbresp;
assign i_main_core_inst_sxarready = i_mnim_i_main_core_inst_rxarready;
assign i_mnim_i_main_core_inst_rxarvalid = i_main_core_inst_sxarvalid;
assign i_mnim_i_main_core_inst_rxaraddr = i_main_core_inst_sxaraddr;
assign i_mnim_i_main_core_inst_rxarid = i_main_core_inst_sxarid;
assign i_mnim_i_main_core_inst_rxarlen = i_main_core_inst_sxarlen;
assign i_mnim_i_main_core_inst_rxarsize = i_main_core_inst_sxarsize;
assign i_mnim_i_main_core_inst_rxarburst = i_main_core_inst_sxarburst;
assign i_mnim_i_main_core_inst_rxrready = i_main_core_inst_sxrready;
assign i_main_core_inst_sxrvalid = i_mnim_i_main_core_inst_rxrvalid;
assign i_main_core_inst_sxrid = i_mnim_i_main_core_inst_rxrid;
assign i_main_core_inst_sxrdata = i_mnim_i_main_core_inst_rxrdata;
assign i_main_core_inst_sxrlast = i_mnim_i_main_core_inst_rxrlast;
assign i_main_core_inst_sxrresp = i_mnim_i_main_core_inst_rxrresp;
assign i_main_core_data_sxawready = i_mnim_i_main_core_data_rxawready;
assign i_mnim_i_main_core_data_rxawvalid = i_main_core_data_sxawvalid;
assign i_mnim_i_main_core_data_rxawaddr = i_main_core_data_sxawaddr;
assign i_mnim_i_main_core_data_rxawid = i_main_core_data_sxawid;
assign i_mnim_i_main_core_data_rxawlen = i_main_core_data_sxawlen;
assign i_mnim_i_main_core_data_rxawsize = i_main_core_data_sxawsize;
assign i_mnim_i_main_core_data_rxawburst = i_main_core_data_sxawburst;
assign i_main_core_data_sxwready = i_mnim_i_main_core_data_rxwready;
assign i_mnim_i_main_core_data_rxwvalid = i_main_core_data_sxwvalid;
assign i_mnim_i_main_core_data_rxwid = i_main_core_data_sxwid;
assign i_mnim_i_main_core_data_rxwdata = i_main_core_data_sxwdata;
assign i_mnim_i_main_core_data_rxwstrb = i_main_core_data_sxwstrb;
assign i_mnim_i_main_core_data_rxwlast = i_main_core_data_sxwlast;
assign i_mnim_i_main_core_data_rxbready = i_main_core_data_sxbready;
assign i_main_core_data_sxbvalid = i_mnim_i_main_core_data_rxbvalid;
assign i_main_core_data_sxbid = i_mnim_i_main_core_data_rxbid;
assign i_main_core_data_sxbresp = i_mnim_i_main_core_data_rxbresp;
assign i_main_core_data_sxarready = i_mnim_i_main_core_data_rxarready;
assign i_mnim_i_main_core_data_rxarvalid = i_main_core_data_sxarvalid;
assign i_mnim_i_main_core_data_rxaraddr = i_main_core_data_sxaraddr;
assign i_mnim_i_main_core_data_rxarid = i_main_core_data_sxarid;
assign i_mnim_i_main_core_data_rxarlen = i_main_core_data_sxarlen;
assign i_mnim_i_main_core_data_rxarsize = i_main_core_data_sxarsize;
assign i_mnim_i_main_core_data_rxarburst = i_main_core_data_sxarburst;
assign i_mnim_i_main_core_data_rxrready = i_main_core_data_sxrready;
assign i_main_core_data_sxrvalid = i_mnim_i_main_core_data_rxrvalid;
assign i_main_core_data_sxrid = i_mnim_i_main_core_data_rxrid;
assign i_main_core_data_sxrdata = i_mnim_i_main_core_data_rxrdata;
assign i_main_core_data_sxrlast = i_mnim_i_main_core_data_rxrlast;
assign i_main_core_data_sxrresp = i_mnim_i_main_core_data_rxrresp;
assign platform_controller_shready = i_mnim_platform_controller_master_rhready;
assign i_mnim_platform_controller_master_rhaddr = platform_controller_shaddr;
assign i_mnim_platform_controller_master_rhburst = platform_controller_shburst;
assign i_mnim_platform_controller_master_rhmasterlock = platform_controller_shmasterlock;
assign i_mnim_platform_controller_master_rhprot = platform_controller_shprot;
assign i_mnim_platform_controller_master_rhsize = platform_controller_shsize;
assign i_mnim_platform_controller_master_rhtrans = platform_controller_shtrans;
assign i_mnim_platform_controller_master_rhwrite = platform_controller_shwrite;
assign i_mnim_platform_controller_master_rhwdata = platform_controller_shwdata;
assign platform_controller_shrdata = i_mnim_platform_controller_master_rhrdata;
assign platform_controller_shresp = i_mnim_platform_controller_master_rhresp;
assign i_snim_i_system_sram_no_name_sxawready = i_system_sram_sxawready;
assign i_system_sram_sxawvalid = i_snim_i_system_sram_no_name_sxawvalid;
assign i_system_sram_sxawaddr = i_snim_i_system_sram_no_name_sxawaddr;
assign i_system_sram_sxawid = i_snim_i_system_sram_no_name_sxawid;
assign i_system_sram_sxawlen = i_snim_i_system_sram_no_name_sxawlen;
assign i_system_sram_sxawsize = i_snim_i_system_sram_no_name_sxawsize;
assign i_system_sram_sxawburst = i_snim_i_system_sram_no_name_sxawburst;
assign i_snim_i_system_sram_no_name_sxwready = i_system_sram_sxwready;
assign i_system_sram_sxwvalid = i_snim_i_system_sram_no_name_sxwvalid;
assign i_system_sram_sxwid = i_snim_i_system_sram_no_name_sxwid;
assign i_system_sram_sxwdata = i_snim_i_system_sram_no_name_sxwdata;
assign i_system_sram_sxwstrb = i_snim_i_system_sram_no_name_sxwstrb;
assign i_system_sram_sxwlast = i_snim_i_system_sram_no_name_sxwlast;
assign i_system_sram_sxbready = i_snim_i_system_sram_no_name_sxbready;
assign i_snim_i_system_sram_no_name_sxbvalid = i_system_sram_sxbvalid;
assign i_snim_i_system_sram_no_name_sxbid = i_system_sram_sxbid;
assign i_snim_i_system_sram_no_name_sxbresp = i_system_sram_sxbresp;
assign i_snim_i_system_sram_no_name_sxarready = i_system_sram_sxarready;
assign i_system_sram_sxarvalid = i_snim_i_system_sram_no_name_sxarvalid;
assign i_system_sram_sxaraddr = i_snim_i_system_sram_no_name_sxaraddr;
assign i_system_sram_sxarid = i_snim_i_system_sram_no_name_sxarid;
assign i_system_sram_sxarlen = i_snim_i_system_sram_no_name_sxarlen;
assign i_system_sram_sxarsize = i_snim_i_system_sram_no_name_sxarsize;
assign i_system_sram_sxarburst = i_snim_i_system_sram_no_name_sxarburst;
assign i_system_sram_sxrready = i_snim_i_system_sram_no_name_sxrready;
assign i_snim_i_system_sram_no_name_sxrvalid = i_system_sram_sxrvalid;
assign i_snim_i_system_sram_no_name_sxrid = i_system_sram_sxrid;
assign i_snim_i_system_sram_no_name_sxrdata = i_system_sram_sxrdata;
assign i_snim_i_system_sram_no_name_sxrlast = i_system_sram_sxrlast;
assign i_snim_i_system_sram_no_name_sxrresp = i_system_sram_sxrresp;
assign common_peri_group_rpsel = i_snim_common_peri_group_no_name_spsel;
assign common_peri_group_rpenable = i_snim_common_peri_group_no_name_spenable;
assign common_peri_group_rpwrite = i_snim_common_peri_group_no_name_spwrite;
assign common_peri_group_rpaddr = i_snim_common_peri_group_no_name_spaddr;
assign common_peri_group_rpwdata = i_snim_common_peri_group_no_name_spwdata;
assign i_snim_common_peri_group_no_name_spready = common_peri_group_rpready;
assign i_snim_common_peri_group_no_name_sprdata = common_peri_group_rprdata;
assign i_snim_common_peri_group_no_name_spslverr = common_peri_group_rpslverr;
assign external_peri_group_rpsel = i_snim_external_peri_group_no_name_spsel;
assign external_peri_group_rpenable = i_snim_external_peri_group_no_name_spenable;
assign external_peri_group_rpwrite = i_snim_external_peri_group_no_name_spwrite;
assign external_peri_group_rpaddr = i_snim_external_peri_group_no_name_spaddr;
assign external_peri_group_rpwdata = i_snim_external_peri_group_no_name_spwdata;
assign i_snim_external_peri_group_no_name_spready = external_peri_group_rpready;
assign i_snim_external_peri_group_no_name_sprdata = external_peri_group_rprdata;
assign i_snim_external_peri_group_no_name_spslverr = external_peri_group_rpslverr;
assign platform_controller_rpsel = i_snim_platform_controller_no_name_spsel;
assign platform_controller_rpenable = i_snim_platform_controller_no_name_spenable;
assign platform_controller_rpwrite = i_snim_platform_controller_no_name_spwrite;
assign platform_controller_rpaddr = i_snim_platform_controller_no_name_spaddr;
assign platform_controller_rpwdata = i_snim_platform_controller_no_name_spwdata;
assign i_snim_platform_controller_no_name_spready = platform_controller_rpready;
assign i_snim_platform_controller_no_name_sprdata = platform_controller_rprdata;
assign i_snim_platform_controller_no_name_spslverr = platform_controller_rpslverr;
assign i_system_router_rfni_link_list[`BW_FNI_LINK(BW_FNI_PHIT)*(0+1)-1 -:`BW_FNI_LINK(BW_FNI_PHIT)] = i_mnim_i_main_core_inst_sfni_link;
assign i_mnim_i_main_core_inst_sfni_ready = i_system_router_rfni_ready_list[1*(0+1)-1 -:1];
assign i_mnim_i_main_core_inst_sbni_link = i_system_router_rbni_link_list[`BW_BNI_LINK(BW_BNI_PHIT)*(0+1)-1 -:`BW_BNI_LINK(BW_BNI_PHIT)];
assign i_system_router_rbni_ready_list[1*(0+1)-1 -:1] = i_mnim_i_main_core_inst_sbni_ready;
assign i_system_router_rfni_link_list[`BW_FNI_LINK(BW_FNI_PHIT)*(1+1)-1 -:`BW_FNI_LINK(BW_FNI_PHIT)] = i_mnim_i_main_core_data_sfni_link;
assign i_mnim_i_main_core_data_sfni_ready = i_system_router_rfni_ready_list[1*(1+1)-1 -:1];
assign i_mnim_i_main_core_data_sbni_link = i_system_router_rbni_link_list[`BW_BNI_LINK(BW_BNI_PHIT)*(1+1)-1 -:`BW_BNI_LINK(BW_BNI_PHIT)];
assign i_system_router_rbni_ready_list[1*(1+1)-1 -:1] = i_mnim_i_main_core_data_sbni_ready;
assign i_system_router_rfni_link_list[`BW_FNI_LINK(BW_FNI_PHIT)*(2+1)-1 -:`BW_FNI_LINK(BW_FNI_PHIT)] = i_mnim_platform_controller_master_sfni_link;
assign i_mnim_platform_controller_master_sfni_ready = i_system_router_rfni_ready_list[1*(2+1)-1 -:1];
assign i_mnim_platform_controller_master_sbni_link = i_system_router_rbni_link_list[`BW_BNI_LINK(BW_BNI_PHIT)*(2+1)-1 -:`BW_BNI_LINK(BW_BNI_PHIT)];
assign i_system_router_rbni_ready_list[1*(2+1)-1 -:1] = i_mnim_platform_controller_master_sbni_ready;
assign i_snim_i_system_sram_no_name_rfni_link = i_system_router_sfni_link_list[`BW_FNI_LINK(BW_FNI_PHIT)*(0+1)-1 -:`BW_FNI_LINK(BW_FNI_PHIT)];
assign i_system_router_sfni_ready_list[1*(0+1)-1 -:1] = i_snim_i_system_sram_no_name_rfni_ready;
assign i_system_router_sbni_link_list[`BW_BNI_LINK(BW_BNI_PHIT)*(0+1)-1 -:`BW_BNI_LINK(BW_BNI_PHIT)] = i_snim_i_system_sram_no_name_rbni_link;
assign i_snim_i_system_sram_no_name_rbni_ready = i_system_router_sbni_ready_list[1*(0+1)-1 -:1];
assign i_snim_common_peri_group_no_name_rfni_link = i_system_router_sfni_link_list[`BW_FNI_LINK(BW_FNI_PHIT)*(1+1)-1 -:`BW_FNI_LINK(BW_FNI_PHIT)];
assign i_system_router_sfni_ready_list[1*(1+1)-1 -:1] = i_snim_common_peri_group_no_name_rfni_ready;
assign i_system_router_sbni_link_list[`BW_BNI_LINK(BW_BNI_PHIT)*(1+1)-1 -:`BW_BNI_LINK(BW_BNI_PHIT)] = i_snim_common_peri_group_no_name_rbni_link;
assign i_snim_common_peri_group_no_name_rbni_ready = i_system_router_sbni_ready_list[1*(1+1)-1 -:1];
assign i_snim_external_peri_group_no_name_rfni_link = i_system_router_sfni_link_list[`BW_FNI_LINK(BW_FNI_PHIT)*(2+1)-1 -:`BW_FNI_LINK(BW_FNI_PHIT)];
assign i_system_router_sfni_ready_list[1*(2+1)-1 -:1] = i_snim_external_peri_group_no_name_rfni_ready;
assign i_system_router_sbni_link_list[`BW_BNI_LINK(BW_BNI_PHIT)*(2+1)-1 -:`BW_BNI_LINK(BW_BNI_PHIT)] = i_snim_external_peri_group_no_name_rbni_link;
assign i_snim_external_peri_group_no_name_rbni_ready = i_system_router_sbni_ready_list[1*(2+1)-1 -:1];
assign i_snim_platform_controller_no_name_rfni_link = i_system_router_sfni_link_list[`BW_FNI_LINK(BW_FNI_PHIT)*(3+1)-1 -:`BW_FNI_LINK(BW_FNI_PHIT)];
assign i_system_router_sfni_ready_list[1*(3+1)-1 -:1] = i_snim_platform_controller_no_name_rfni_ready;
assign i_system_router_sbni_link_list[`BW_BNI_LINK(BW_BNI_PHIT)*(3+1)-1 -:`BW_BNI_LINK(BW_BNI_PHIT)] = i_snim_platform_controller_no_name_rbni_link;
assign i_snim_platform_controller_no_name_rbni_ready = i_system_router_sbni_ready_list[1*(3+1)-1 -:1];
assign default_slave_rfni_link = i_system_router_sfni_link_list[`BW_FNI_LINK(BW_FNI_PHIT)*(4+1)-1 -:`BW_FNI_LINK(BW_FNI_PHIT)];
assign i_system_router_sfni_ready_list[1*(4+1)-1 -:1] = default_slave_rfni_ready;
assign i_system_router_sbni_link_list[`BW_BNI_LINK(BW_BNI_PHIT)*(4+1)-1 -:`BW_BNI_LINK(BW_BNI_PHIT)] = default_slave_rbni_link;
assign default_slave_rbni_ready = i_system_router_sbni_ready_list[1*(4+1)-1 -:1];
assign platform_controller_rpc_list[32*(0+1)-1 -:32] = i_main_core_spc;
assign platform_controller_rinst_list[32*(0+1)-1 -:32] = i_main_core_sinst;
assign default_slave_debug_rpsel = platform_controller_noc_debug_spsel;
assign default_slave_debug_rpenable = platform_controller_noc_debug_spenable;
assign default_slave_debug_rpwrite = platform_controller_noc_debug_spwrite;
assign default_slave_debug_rpaddr = platform_controller_noc_debug_spaddr;
assign default_slave_debug_rpwdata = platform_controller_noc_debug_spwdata;
assign platform_controller_noc_debug_spready = default_slave_debug_rpready;
assign platform_controller_noc_debug_sprdata = default_slave_debug_rprdata;
assign platform_controller_noc_debug_spslverr = default_slave_debug_rpslverr;
assign core_peri_group_rpsel = i_mnim_i_main_core_data_local_spsel;
assign core_peri_group_rpenable = i_mnim_i_main_core_data_local_spenable;
assign core_peri_group_rpwrite = i_mnim_i_main_core_data_local_spwrite;
assign core_peri_group_rpaddr = i_mnim_i_main_core_data_local_spaddr;
assign core_peri_group_rpwdata = i_mnim_i_main_core_data_local_spwdata;
assign i_mnim_i_main_core_data_local_spready = core_peri_group_rpready;
assign i_mnim_i_main_core_data_local_sprdata = core_peri_group_rprdata;
assign i_mnim_i_main_core_data_local_spslverr = core_peri_group_rpslverr;
assign oled_sdcsel = external_peri_group_oled_sdcsel;
assign oled_srstnn = external_peri_group_oled_srstnn;
assign oled_svbat = external_peri_group_oled_svbat;
assign oled_svdd = external_peri_group_oled_svdd;
assign platform_controller_pjtag_rtck = pjtag_rtck;
assign platform_controller_pjtag_rtrstnn = pjtag_rtrstnn;
assign platform_controller_pjtag_rtms = pjtag_rtms;
assign platform_controller_pjtag_rtdi = pjtag_rtdi;
assign pjtag_rtdo = platform_controller_pjtag_rtdo;
assign external_peri_group_wifi_sitr = 0;
assign i_mnim_i_main_core_inst_local_spready = 0;
assign i_mnim_i_main_core_inst_local_sprdata = 0;
assign i_mnim_i_main_core_inst_local_spslverr = 0;
assign default_slave_svri_rlink = 0;
assign default_slave_svri_sack = 0;
assign i_mnim_i_main_core_inst_svri_rlink = 0;
assign i_mnim_i_main_core_inst_svri_sack = 0;
assign i_mnim_i_main_core_data_svri_rlink = 0;
assign i_mnim_i_main_core_data_svri_sack = 0;
assign i_mnim_platform_controller_master_svri_rlink = 0;
assign i_mnim_platform_controller_master_svri_sack = 0;
assign i_snim_i_system_sram_no_name_svri_rlink = 0;
assign i_snim_i_system_sram_no_name_svri_sack = 0;
assign i_snim_common_peri_group_no_name_svri_rlink = 0;
assign i_snim_common_peri_group_no_name_svri_sack = 0;
assign i_snim_external_peri_group_no_name_svri_rlink = 0;
assign i_snim_external_peri_group_no_name_svri_sack = 0;
assign i_snim_platform_controller_no_name_svri_rlink = 0;
assign i_snim_platform_controller_no_name_svri_sack = 0;
assign core_peri_group_tcu_spready = 0;
assign core_peri_group_tcu_sprdata = 0;
assign core_peri_group_tcu_spslverr = 0;
assign uart_readymade_tx_list[1*(0+1)-1 -:1] = external_peri_group_uart_tx_list[1*(0+1)-1 -:1];
assign external_peri_group_uart_rx_list[1*(0+1)-1 -:1] = uart_readymade_rx_list[1*(0+1)-1 -:1];
assign printf_tx = external_peri_group_uart_tx_list[1*(`UART_INDEX_FOR_UART_PRINTF+1)-1 -:1];
assign external_peri_group_uart_rx_list[1*(`UART_INDEX_FOR_UART_PRINTF+1)-1 -:1] = printf_rx;
assign spi_readymade_sclk_list[1*(0+1)-1 -:1] = external_peri_group_spi_sclk_list[1*(0+1)-1 -:1];
assign spi_readymade_scs_list[1*(0+1)-1 -:1] = external_peri_group_spi_scs_list[1*(0+1)-1 -:1];
assign spi_readymade_sdq0_list[1*(0+1)-1 -:1] = external_peri_group_spi_sdq0_list[1*(0+1)-1 -:1];
assign external_peri_group_spi_sdq1_list[1*(0+1)-1 -:1] = spi_readymade_sdq1_list[1*(0+1)-1 -:1];
assign oled_sclk = external_peri_group_spi_sclk_list[1*(`SPI_INDEX_FOR_OLED+1)-1 -:1];
assign oled_scs = external_peri_group_spi_scs_list[1*(`SPI_INDEX_FOR_OLED+1)-1 -:1];
assign oled_sdq0 = external_peri_group_spi_sdq0_list[1*(`SPI_INDEX_FOR_OLED+1)-1 -:1];
assign external_peri_group_spi_sdq1_list[1*(`SPI_INDEX_FOR_OLED+1)-1 -:1] = oled_sdq1;
assign spi_flash_sclk = external_peri_group_spi_sclk_list[1*(`SPI_INDEX_FOR_SPI_FLASH+1)-1 -:1];
assign spi_flash_scs = external_peri_group_spi_scs_list[1*(`SPI_INDEX_FOR_SPI_FLASH+1)-1 -:1];
assign spi_flash_sdq0 = external_peri_group_spi_sdq0_list[1*(`SPI_INDEX_FOR_SPI_FLASH+1)-1 -:1];
assign external_peri_group_spi_sdq1_list[1*(`SPI_INDEX_FOR_SPI_FLASH+1)-1 -:1] = spi_flash_sdq1;
assign i2c_readymade_sclk_od_list[1*(0+1)-1 -:1] = external_peri_group_i2c_sclk_od_list[1*(0+1)-1 -:1];
assign i2c_readymade_sclk_out_list[1*(0+1)-1 -:1] = external_peri_group_i2c_sclk_out_list[1*(0+1)-1 -:1];
assign external_peri_group_i2c_sclk_in_list[1*(0+1)-1 -:1] = i2c_readymade_sclk_in_list[1*(0+1)-1 -:1];
assign i2c_readymade_sdata_od_list[1*(0+1)-1 -:1] = external_peri_group_i2c_sdata_od_list[1*(0+1)-1 -:1];
assign i2c_readymade_sdata_out_list[1*(0+1)-1 -:1] = external_peri_group_i2c_sdata_out_list[1*(0+1)-1 -:1];
assign external_peri_group_i2c_sdata_in_list[1*(0+1)-1 -:1] = i2c_readymade_sdata_in_list[1*(0+1)-1 -:1];


endmodule