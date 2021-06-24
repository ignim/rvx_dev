`include "ervp_global.vh"
`include "ervp_endian.vh"
`include "ervp_axi_define.vh"
`include "ervp_ahb_define.vh"

`include "ervp_platform_controller_memorymap_offset.vh"
`include "ervp_jtag_memorymap_offset.vh"

`include "platform_info.vh"
`include "sim_info.vh"
`include "hex_size.vh"

`include "timescale.vh"


module TIP_ARTY_SIM
();
///////////
/* clock */
///////////

wire clk, rstnn;

CLOCK_GENERATOR
#(
	.CLK_PERIOD((10.0**9)/`SYSTEM_CLK_HZ)
)
clock_gen
(
	.clk(clk),
	.rstnn(rstnn),
	.rst()
);

wire external_rstnn = rstnn;

wire external_clk = clk;

/////////////
/* signals */
/////////////

wire [`BW_BOOT_MODE-1:0] boot_mode;
wire app_finished = i_platform.i_rtl.platform_controller.app_finished;

wire ncsim_uart_rx;
wire ncsim_uart_tx;

//////////
// JTAG //
//////////

reg pjtag_rtck;
reg pjtag_rtrstnn;
reg pjtag_rtms;
reg pjtag_rtdi;
wire pjtag_rtdo;
//wire pjtag_rtdo_en = i_platform.i_rtl.platform_controller.pjtag_rtdo_en;
reg pjtag_rfinished;

`ifdef INCLUDE_CORE_JTAG

wire core_jtag_tck;
reg core_jtag_trstnn;
wire core_jtag_tms;
wire core_jtag_tdi;
wire core_jtag_tdo;
wire core_jtag_tdo_en;

wire jtag_rflash_clk = 0;
wire [3:0] jtag_rflash_dq_out;
wire [3:0] jtag_rflash_dq_in = 0;
wire [3:0] jtag_rflash_dq_oe;
wire jtag_rflash_cs;

wire rstnn_from_core_jtag;

jtag_ri jtag_rif();
adv_dbg_if_t adv_dbg_if = new(jtag_rif);

initial
begin
	adv_dbg_if.jtag_rreset();
	adv_dbg_if.jtag_rsoftreset();
	adv_dbg_if.init();
	adv_dbg_if.axi4_write32(32'h9401_0000, 1, 32'h1234_5678);
end

initial
begin
	core_jtag_trstnn = 1;
end

always@(*)
begin
	core_jtag_trstnn = jtag_rif.trstn & rstnn;
end

assign core_jtag_tck = jtag_rif.tck;
assign core_jtag_tms = jtag_rif.tms;
assign core_jtag_tdi = jtag_rif.tdi;
assign jtag_rif.tdo = core_jtag_tdo_en? core_jtag_tdo : 1'b 0;

`endif

//////////
// UART //
//////////

`ifdef UART_INDEX_FOR_UART_PRINTF
	wire printf_tx, printf_rx;
`endif

`ifdef INCLUDE_UART_USER
	wire [`NUM_UART_USER-1:0] uart_rx_list;
	wire [`NUM_UART_USER-1:0] uart_tx_list;
`endif

/////////
// SPI //
/////////

`ifdef INCLUDE_SPI_USER
	wire [`NUM_SPI_USER-1:0] spi_sclk_list;
	wire [`NUM_SPI_USER-1:0] spi_scs_list;
	wire [`NUM_SPI_USER-1:0] spi_sdq0_list;
	wire [`NUM_SPI_USER-1:0] spi_sdq1_list;

	genvar iter_spi;	

	/*
	generate	
	for(iter_spi=0; iter_spi<`NUM_SPI_USER; iter_spi=iter_spi+1)
	begin : gen_spi
		SPI_SLAVE_MODEL
		i_virtual_spi
		(
        .csn   (spi_scs_list[iter_spi]),
        .sck   (spi_sclk_list[iter_spi]),
        .din   (spi_sdq0_list[iter_spi]),
        .dout  (spi_sdq1_list[iter_spi])
		);
	end
	endgenerate
	*/

`endif

/*
`ifdef INCLUDE_SPI_USER
	wire [`NUM_SPI_USER-1:0] spi_sclk_list;
	wire [`NUM_SPI_USER-1:0] spi_scs_list;
	wire [`NUM_SPI_USER-1:0] spi_sdq0_in_list;
	wire [`NUM_SPI_USER-1:0] spi_sdq0_out_list;
	wire [`NUM_SPI_USER-1:0] spi_sdq0_oe_list;
	wire [`NUM_SPI_USER-1:0] spi_sdq1_in_list;
	wire [`NUM_SPI_USER-1:0] spi_sdq1_out_list;
	wire [`NUM_SPI_USER-1:0] spi_sdq1_oe_list;
	wire [`NUM_SPI_USER-1:0] spi_sdq2_in_list;
	wire [`NUM_SPI_USER-1:0] spi_sdq2_out_list;
	wire [`NUM_SPI_USER-1:0] spi_sdq2_oe_list;
	wire [`NUM_SPI_USER-1:0] spi_sdq3_in_list;
	wire [`NUM_SPI_USER-1:0] spi_sdq3_out_list;
	wire [`NUM_SPI_USER-1:0] spi_sdq3_oe_list;

	genvar iter_spi;	

	generate	
	for(iter_spi=0; iter_spi<`NUM_SPI_USER; iter_spi=iter_spi+1)
	begin : gen_spi
		SPI_SLAVE_MODEL
		i_virtual_spi
		(
        .csn   (spi_scs_list[iter_spi]),
        .sck   (spi_sclk_list[iter_spi]),
        .din   (spi_sdq0_out_list[iter_spi]),
        .dout  (spi_sdq1_in_list[iter_spi])
		);
	end
	endgenerate

`endif

`ifdef INCLUDE_OLED
	wire oled_dc_sel;
	wire oled_rstnn;
	wire oled_vbat;
	wire oled_vdd;
`endif

`ifdef USE_SPI_FLASH

	wire spi_sflash_clk;
	wire spi_sflash_cs;
	wire [3:0] spi_sflash_dq;

`ifndef DISABLE_SPI_FLASH
	assign spi_sflash_clk = spi_sclk[`SPI_INDEX_FOR_SPI_FLASH];
	assign spi_sflash_cs = spi_scs[`SPI_INDEX_FOR_SPI_FLASH];

	TRI_STATE_BUFFER
	i_spi_flash_dq0
	(
		.output_enable(spi_sdq0_oe[`SPI_INDEX_FOR_SPI_FLASH]),
		.in_value(spi_sdq0_out[`SPI_INDEX_FOR_SPI_FLASH]),
		.out_value(spi_sdq0_in[`SPI_INDEX_FOR_SPI_FLASH]),
		.tri_value(spi_sflash_dq[0])
	);

	TRI_STATE_BUFFER
	i_spi_flash_dq1
	(
		.output_enable(spi_sdq1_oe[`SPI_INDEX_FOR_SPI_FLASH]),
		.in_value(spi_sdq1_out[`SPI_INDEX_FOR_SPI_FLASH]),
		.out_value(spi_sdq1_in[`SPI_INDEX_FOR_SPI_FLASH]),
		.tri_value(spi_sflash_dq[1])
	);

	TRI_STATE_BUFFER
	i_spi_flash_dq2
	(
		.output_enable(spi_sdq2_oe[`SPI_INDEX_FOR_SPI_FLASH]),
		.in_value(spi_sdq2_out[`SPI_INDEX_FOR_SPI_FLASH]),
		.out_value(spi_sdq2_in[`SPI_INDEX_FOR_SPI_FLASH]),
		.tri_value(spi_sflash_dq[2])
	);

	TRI_STATE_BUFFER
	i_spi_flash_dq3
	(
		.output_enable(spi_sdq3_oe[`SPI_INDEX_FOR_SPI_FLASH]),
		.in_value(spi_sdq3_out[`SPI_INDEX_FOR_SPI_FLASH]),
		.out_value(spi_sdq3_in[`SPI_INDEX_FOR_SPI_FLASH]),
		.tri_value(spi_sflash_dq[3])
	);

	N25Qxxx i_flash_model
	(
		.S(spi_sflash_cs), 
		.C_(spi_sflash_clk), 
		.DQ0(spi_sflash_dq[0]), 
		.DQ1(spi_sflash_dq[1]),
		.Vpp_W_DQ2(spi_sflash_dq[2]),
		.HOLD_DQ3(spi_sflash_dq[3]),
		.Vcc(32'h00000bb8) 
	);
`endif
`endif
*/

/////////
// I2C //
/////////

`ifdef INCLUDE_I2C_USER
	wire [`NUM_I2C_USER-1:0] i2c_sclk_list;
	wire [`NUM_I2C_USER-1:0] i2c_sdata_list;	

	genvar iter_i2c;

	/*
	generate
	for(iter_i2c=0; iter_i2c<`NUM_I2C_USER; iter_i2c=iter_i2c+1)
	begin : i_gen_i2c
		pullup i_pulllup_i2c_data (i2c_sdata_list[iter_i2c]);

		I2C_SLAVE_MODEL
		#(
			.I2C_ADR(7'h48)
		)
		i_virtual_i2c
		(
			.scl(i2c_sclk_list[iter_i2c]),
			.sda(i2c_sdata_list[iter_i2c])
		);
	end
	endgenerate
	*/

`endif

//////////
// GPIO //
//////////

`ifdef INCLUDE_GPIO_USER
	wire [`NUM_GPIO_USER-1:0] gpio_list;
`endif

//////////
// WIFI //
//////////

`ifdef INCLUDE_WIFI

reg wifi_sitr;

assign i_platform.wifi_sitr = wifi_sitr;

initial
begin
	wifi_sitr = 1;
	#1000000;
	wifi_sitr = 0;
end

`endif

//////////
// HBC1 //
//////////

`ifdef INCLUDE_HBC1_TX
	`ifdef INCLUDE_HBC1_RX
		wire hbc1_tx_clk;
		wire hbc1_tx_data;
		wire hbc1_rx_clk;
		wire hbc1_rx_data;

		assign hbc1_tx_clk = i_platform.i_rtl.clk_hbc1_tx;
		assign hbc1_tx_data = i_platform.hbc1_tx_data;
		assign hbc1_rx_clk = hbc1_tx_clk;
		assign hbc1_rx_data = hbc1_tx_data;
		assign i_platform.clk_hbc1 = hbc1_rx_clk;
		assign i_platform.hbc1_rx_data = hbc1_rx_data;
	`endif
`endif

////////////
// SWITCH //
////////////

`ifdef INCLUDE_SWITCH_SLIDE_READYMADE
	wire [3-1:0] switch_slide_list;

	assign switch_slide_list = 3'b 101;
	assign i_platform.switch_slide_list = switch_slide_list;
`endif

///////////
/* ncsim */
///////////

`ifdef PRINTF_USING_UART
	assign ncsim_uart_rx = printf_tx;
	assign printf_rx = ncsim_uart_tx;
`else
	assign ncsim_uart_rx = 0;
`endif

NCSIM_MANAGER
#(
	.TOP_NAME(`PLATFORM_NAME),
	.NUM_END(1),
	.UART_CLK_HZ(`UART_CLK_HZ),
	.USE_UART_FINISH(1)
)
i_ncsim_manager
(
	.record_start(pjtag_rfinished),
	.record_enable(1'b 1),
	.finished(1'b 1),
	.uart_rx(ncsim_uart_rx),
	.uart_tx(ncsim_uart_tx)
);

TIP_ARTY
i_platform
(
	.external_rstnn(external_rstnn),
	.pjtag_rtck(pjtag_rtck),
	.pjtag_rtrstnn(pjtag_rtrstnn),
	.pjtag_rtms(pjtag_rtms),
	.pjtag_rtdi(pjtag_rtdi),
	.pjtag_rtdo(pjtag_rtdo),
	.external_clk(external_clk),
	.boot_mode(boot_mode),
	.printf_tx(printf_tx),
	.printf_rx(printf_rx)
);

//////////
/* jtag */
//////////

assign boot_mode = `BOOT_MODE_OCD;

`include "ervp_endian.vf"
`include "ervp_jtag_util.vf"
`include "ervp_platform_controller_util.vf"

`ifndef SRAM_HEX_FILE
`define SRAM_HEX_FILE "sram.hex"
`endif

`ifndef SRAM_OFFSET
`define SRAM_OFFSET 32'h 0
`endif

`ifndef CRM_HEX_FILE
`define CRM_HEX_FILE "crm.hex"
`endif

`ifndef CRM_OFFSET
`define CRM_OFFSET 32'h 0
`endif

`ifndef DRAM_HEX_FILE
`define DRAM_HEX_FILE "dram.hex"
`endif

`ifndef DRAM_OFFSET
`define DRAM_OFFSET 32'h 0
`endif

`ifndef MEMORY_ENDIAN
`define MEMORY_ENDIAN `LITTLE_ENDIAN
`endif

`define DRAM_CELL i_platform.`DRAM_IP_INSTANCE.i_cell.memory

`define BW_WORD 32
`define SRAM_CELL_SIZE_IN_WORD (`SRAM_CELL_SIZE/(`BW_WORD/`BW_BYTE))

integer reset_cycle;
reg first_reset_is_complete;

reg app_load_request;
reg app_is_loaded;

integer i;
integer word_index;
integer cell_index;
integer word_index_in_cell;
integer word_index_in_wordline;
integer wordline_index_in_cell;
integer direct_memory_load;
integer addr;
integer num_word_in_wordline;
integer ddr_file;
integer error;

reg [32-1:0] hex_memory [`HEX_SIZE-1:0];

initial
begin
	pjtag_rfinished = 0;
	app_load_request = 0;
	#1
	wait(rstnn==0);
	wait(rstnn==1);
	if(boot_mode==`BOOT_MODE_STAND_ALONE)
	begin
		$display("[JTAG:INFO] do NOTHING");
	end
	else if(boot_mode==`BOOT_MODE_OCD)
	begin
		wait(first_reset_is_complete==1);
		init_jtag();
		release_all_reset();
		app_load_request = 1;
		wait(app_is_loaded==1);
		set_sim_env();
		set_all_ready();
	end
	else
	begin
		$display("[JTAG:ERROR] undefined boot mode");
		$finish;
	end
	#1
	$display("[JTAG:INFO] finished");
	pjtag_rfinished = 1;
end

initial
begin
	first_reset_is_complete = 0;
	reset_cycle = 0;
	#1
	wait(rstnn==0);
	wait(rstnn==1);
	while(1)
	begin
		wait(clk==0);
		wait(clk==1);
		if(reset_cycle==300)
			break;
		else
			reset_cycle = reset_cycle + 1;
	end
	first_reset_is_complete = 1;
end

initial
begin
	app_is_loaded = 0;
	direct_memory_load = 0;
	#1
	wait(rstnn==0);
	wait(rstnn==1);
	if(boot_mode==`BOOT_MODE_OCD)
	begin
		wait(app_load_request==1);
		#1
		// sram
		`ifndef USE_SRAM
			$finish;
		`endif
		$readmemh(`SRAM_HEX_FILE, hex_memory);
		addr = `SRAM_ADDR;
		num_word_in_wordline = `SRAM_WIDTH/`BW_WORD;
		`ifdef FAST_APP_LOAD
			direct_memory_load = 1;
			$display("[JTAG:INFO] fast SRAM load start");
			for(i=0; i<`SRAM_HEX_SIZE; i=i+1)
			begin
				word_index = `SRAM_OFFSET + i;
				cell_index = word_index / `SRAM_CELL_SIZE_IN_WORD;
				word_index_in_cell = word_index % `SRAM_CELL_SIZE_IN_WORD;
				wordline_index_in_cell = word_index_in_cell / num_word_in_wordline;
				word_index_in_wordline = word_index_in_cell % num_word_in_wordline;

				case(cell_index)

					0:
					begin
						`define SRAM_CELL i_platform.`SRAM_IP_INSTANCE.generate_cell[0].i_cell.memory
						`SRAM_CELL[wordline_index_in_cell][(word_index_in_wordline+1)*32-1-:32] = CHANGE_ENDIAN_HEX2MAN(32,`MEMORY_ENDIAN,hex_memory[i]);
					end

				endcase
			end
			direct_memory_load = 0;
		`else
			$display("[JTAG:INFO] slow SRAM load start");
			write_memory_using_jtag(addr, CHANGE_ENDIAN_HEX2MAN(32,`MEMORY_ENDIAN,hex_memory[0]));
			print_memory_using_jtag(addr);
			for(i=0; i<`SRAM_HEX_SIZE; i=i+1)
			begin
				if((i&32'h FF)==32'h FF)
				begin
					$display("[JTAG:INFO] slow SRAM load is processing... %8d", i);
				end
				write_memory_using_jtag(addr, CHANGE_ENDIAN_HEX2MAN(32,`MEMORY_ENDIAN,hex_memory[i]));
				addr = addr + 4;
			end
		`endif
		$display("[JTAG:INFO] SRAM load end");

		// dram
		`ifdef USE_DRAM
			$readmemh(`DRAM_HEX_FILE, hex_memory);
			addr = `DRAM_ADDR;
			num_word_in_wordline = `DRAM_WIDTH/32;
			`ifdef FAST_APP_LOAD
				direct_memory_load = 1;
				$display("[JTAG:INFO] fast DRAM load start");
				for(i=0; i<`DRAM_HEX_SIZE; i=i+1)
				begin
					word_index = `DRAM_OFFSET + i;
					word_index_in_wordline = word_index % num_word_in_wordline;
					wordline_index_in_cell = word_index / num_word_in_wordline;
					`DRAM_CELL[wordline_index_in_cell][(word_index_in_wordline+1)*32-1-:32] = CHANGE_ENDIAN_HEX2MAN(32,`MEMORY_ENDIAN,hex_memory[i]);
					//$display("%8x : %8x", word_index, hex_memory[i]);
				end
				direct_memory_load = 0;
			`else
				$display("[JTAG:INFO] slow DRAM load start");
				for(i=0; i<`DRAM_HEX_SIZE; i=i+1)
				begin
					write_memory_using_jtag(addr, CHANGE_ENDIAN_HEX2MAN(32,`MEMORY_ENDIAN,hex_memory[i]));
					addr = addr + 4;
				end
			`endif
			$display("[JTAG:INFO] DRAM load end");
		`endif
		#1
		app_is_loaded = 1;
	end
end


endmodule