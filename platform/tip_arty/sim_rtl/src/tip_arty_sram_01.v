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

`include "timescale.vh"
`include "ervp_global.vh"
`include "ervp_axi_define.vh"
`include "ervp_misc_util.vh"
`include "munoc_network_include.vh"

module TIP_ARTY_SRAM_01
(
	clk,
	rstnn,

	rxawid,
	rxawaddr,
	rxawlen,
	rxawsize,
	rxawburst,
	rxawvalid,
	rxawready,

	rxwid,
	rxwdata,
	rxwstrb,
	rxwlast,
	rxwvalid,
	rxwready,

	rxbid,
	rxbresp,
	rxbvalid,
	rxbready,

	rxarid,
	rxaraddr,
	rxarlen,
	rxarsize,
	rxarburst,
	rxarvalid,
	rxarready,

	rxrid,
	rxrdata,
	rxrresp,
	rxrlast,
	rxrvalid,
	rxrready
);

////////////////////////////
/* parameter input output */
////////////////////////////

localparam CAPACITY = 131072;  // in bytes
localparam BW_ADDR = 32;
localparam BW_DATA = 32;
localparam BW_AXI_TID = `REQUIRED_BW_OF_SLAVE_TID;
localparam CELL_SIZE = 131072;  // in bytes

localparam CELL_WIDTH = BW_DATA;
localparam NUM_BYTE = `NUM_OF_BYTE(CELL_WIDTH);
localparam CELL_DEPTH = `DIVIDERU(CELL_SIZE,NUM_BYTE);
localparam BW_CELL_INDEX = BW_ADDR; // LOG2RU(CELL_DEPTH)

localparam NUM_CELL = `DIVIDERU(CAPACITY,CELL_SIZE);

input wire clk, rstnn;

//AW Channel
input wire [BW_AXI_TID-1:0] rxawid;
input wire [BW_ADDR-1:0] rxawaddr;
input wire [`BW_AXI_ALEN-1:0] rxawlen;
input wire [`BW_AXI_ASIZE-1:0] rxawsize;
input wire [`BW_AXI_ABURST-1:0] rxawburst;
input wire rxawvalid;
output wire rxawready;

//W Channel
input wire [BW_AXI_TID-1:0] rxwid;
input wire [BW_DATA-1:0] rxwdata;
input wire [`BW_AXI_WSTRB(BW_DATA)-1:0] rxwstrb;
input wire rxwlast;
input wire rxwvalid;
output wire rxwready;

//B Channel
output wire [BW_AXI_TID-1:0] rxbid;
output wire [`BW_AXI_BRESP-1:0] rxbresp;
output wire rxbvalid;
input wire rxbready;

//AR Channel
input wire [BW_AXI_TID-1:0] rxarid;
input wire [BW_ADDR-1:0] rxaraddr;
input wire [`BW_AXI_ALEN-1:0] rxarlen;
input wire [`BW_AXI_ASIZE-1:0] rxarsize;
input wire [`BW_AXI_ABURST-1:0] rxarburst;
input wire rxarvalid;
output wire rxarready;

//R Channel
output wire [BW_AXI_TID-1:0] rxrid;
output wire [BW_DATA-1:0] rxrdata;
output wire [`BW_AXI_RRESP-1:0] rxrresp;
output wire rxrlast;
output wire rxrvalid;
input wire rxrready;

/////////////
/* signals */
/////////////

genvar i;

wire [NUM_CELL-1:0] cell_select;
wire [BW_CELL_INDEX*NUM_CELL-1:0] cell_index_list;
wire [NUM_CELL-1:0] cell_write_enable_list;
wire [NUM_BYTE*NUM_CELL-1:0] cell_write_enable_byte_list;
wire [BW_DATA*NUM_CELL-1:0] cell_write_enable_bit_list;
wire [BW_DATA*NUM_CELL-1:0] cell_wdata_list;
wire [NUM_CELL-1:0] cell_read_enable_list;
wire [BW_DATA*NUM_CELL-1:0] cell_rdata_list;

wire [BW_CELL_INDEX-1:0] cell_index [NUM_CELL-1:0];
wire cell_write_enable [NUM_CELL-1:0];
wire [NUM_BYTE-1:0] cell_write_enable_byte [NUM_CELL-1:0];
wire [BW_DATA-1:0] cell_write_enable_bit [NUM_CELL-1:0];
wire [BW_DATA-1:0] cell_wdata [NUM_CELL-1:0];
wire cell_read_enable [NUM_CELL-1:0];
wire [BW_DATA-1:0] cell_rdata [NUM_CELL-1:0];

////////////
/* logics */
////////////

ERVP_SRAM_CONTROLLER_AXI
#(
	.BW_ADDR(BW_ADDR),
	.BW_DATA(BW_DATA),
	.BW_AXI_TID(BW_AXI_TID),
	.BASE_ADDR(0),
	.CELL_SIZE(CELL_SIZE),
	.BW_CELL_INDEX(BW_CELL_INDEX),
	.NUM_CELL(NUM_CELL)
)
i_controller
(
	.clk(clk),
	.rstnn(rstnn),

	.rxawid(rxawid),
	.rxawaddr(rxawaddr),
	.rxawlen(rxawlen),
	.rxawsize(rxawsize),
	.rxawburst(rxawburst),
	.rxawvalid(rxawvalid),
	.rxawready(rxawready),

	.rxwid(rxwid),
	.rxwdata(rxwdata),
	.rxwstrb(rxwstrb),
	.rxwlast(rxwlast),
	.rxwvalid(rxwvalid),
	.rxwready(rxwready),

	.rxbid(rxbid),
	.rxbresp(rxbresp),
	.rxbvalid(rxbvalid),
	.rxbready(rxbready),

	.rxarid(rxarid),
	.rxaraddr(rxaraddr),
	.rxarlen(rxarlen),
	.rxarsize(rxarsize),
	.rxarburst(rxarburst),
	.rxarvalid(rxarvalid),
	.rxarready(rxarready),

	.rxrid(rxrid),
	.rxrdata(rxrdata),
	.rxrresp(rxrresp),
	.rxrlast(rxrlast),
	.rxrvalid(rxrvalid),
	.rxrready(rxrready),

	.cell_select(cell_select),
	.cell_index_list(cell_index_list),
	.cell_write_enable_list(cell_write_enable_list),
	.cell_write_enable_byte_list(cell_write_enable_byte_list),
	.cell_write_enable_bit_list(cell_write_enable_bit_list),
	.cell_wdata_list(cell_wdata_list),
	.cell_read_enable_list(cell_read_enable_list),
	.cell_rdata_list(cell_rdata_list)
);

generate
for(i=0; i<NUM_CELL; i=i+1)
	begin : generate_cell_signals
		assign cell_index[i] = cell_index_list[BW_CELL_INDEX*(i+1)-1 -:BW_CELL_INDEX];
		assign cell_write_enable[i] = cell_write_enable_list[i];
		assign cell_write_enable_byte[i] = cell_write_enable_byte_list[NUM_BYTE*(i+1)-1 -:NUM_BYTE];
		assign cell_write_enable_bit[i] = cell_write_enable_bit_list[BW_DATA*(i+1)-1 -:BW_DATA];
		assign cell_wdata[i] = cell_wdata_list[BW_DATA*(i+1)-1 -:BW_DATA];
		assign cell_read_enable[i] = cell_read_enable_list[i];
		assign cell_rdata_list[BW_DATA*(i+1)-1 -:BW_DATA] = cell_rdata[i];
	end
endgenerate

generate
for(i=0; i<NUM_CELL; i=i+1)
	begin : generate_cell
		ERVP_MEMORY_CELL_1R1W
		#(
			.DEPTH(CELL_DEPTH),
			.WIDTH(CELL_WIDTH),
			.BW_INDEX(BW_CELL_INDEX),
			.USE_SINGLE_INDEX(1),
			.USE_BYTE_ENABLE(1)
			)
			i_cell
			(
				.clk(clk),
				.rstnn(rstnn),
				.index(cell_index[i]),
				.windex(cell_index[i]),
				.wenable(cell_write_enable[i]),
				.wbyteenable(cell_write_enable_byte[i]),
				.wdata(cell_wdata[i]),
				.rindex(cell_index[i]),
				.rdata_asynch(),
				.renable(cell_read_enable[i]),
				.rdata_synch(cell_rdata[i])
			);
	end
endgenerate


endmodule
