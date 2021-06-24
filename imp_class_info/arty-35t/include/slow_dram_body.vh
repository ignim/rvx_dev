/////////////
/* signals */
/////////////

wire sys_clk_i;
wire clk_ref_i;
wire ui_clk;
wire ui_clk_sync_rst;
wire aresetn;
//
wire mmcm_locked;
wire app_sr_req;
wire app_ref_req;
wire app_zq_req;
wire app_sr_active;
wire app_ref_ack;
wire app_zq_ack;
//
wire [15:0]s_axi_awid;
wire [27:0]s_axi_awaddr;
wire [7:0]s_axi_awlen;
wire [2:0]s_axi_awsize;
wire [1:0]s_axi_awburst;
wire [0:0]s_axi_awlock;
wire [3:0]s_axi_awcache;
wire [2:0]s_axi_awprot;
wire [3:0]s_axi_awqos;
wire s_axi_awvalid;
wire s_axi_awready;
//
wire [31:0]s_axi_wdata;
wire [3:0]s_axi_wstrb;
wire s_axi_wlast;
wire s_axi_wvalid;
wire s_axi_wready;
//
wire s_axi_bready;
wire [15:0]s_axi_bid;
wire [1:0]s_axi_bresp;
wire s_axi_bvalid;
//
wire [15:0]s_axi_arid;
wire [27:0]s_axi_araddr;
wire [7:0]s_axi_arlen;
wire [2:0]s_axi_arsize;
wire [1:0]s_axi_arburst;
wire [0:0]s_axi_arlock;
wire [3:0]s_axi_arcache;
wire [2:0]s_axi_arprot;
wire [3:0]s_axi_arqos;
wire s_axi_arvalid;
wire s_axi_arready;
//
wire s_axi_rready;
wire [15:0]s_axi_rid;
wire [31:0]s_axi_rdata;
wire [1:0]s_axi_rresp;
wire s_axi_rlast;
wire s_axi_rvalid;
//
wire init_calib_complete;
wire [11:0]device_temp;
wire sys_rst;

////////////
/* logics */
////////////

xilinx_ddr3_ctrl_axi32
(
	.sys_clk_i(sys_clk_i),
	.clk_ref_i(clk_ref_i),
	.ui_clk(ui_clk),
	.ui_clk_sync_rst(ui_clk_sync_rst),
	.mmcm_locked(mmcm_locked),
	.aresetn(aresetn),
	.app_sr_req(app_sr_req),
	.app_ref_req(app_ref_req),
	.app_zq_req(app_zq_req),
	.app_sr_active(app_sr_active),
	.app_ref_ack(app_ref_ack),
	.app_zq_ack(app_zq_ack),
	.s_axi_awid(s_axi_awid),
	.s_axi_awaddr(s_axi_awaddr),
	.s_axi_awlen(s_axi_awlen),
	.s_axi_awsize(s_axi_awsize),
	.s_axi_awburst(s_axi_awburst),
	.s_axi_awlock(s_axi_awlock),
	.s_axi_awcache(s_axi_awcache),
	.s_axi_awprot(s_axi_awprot),
	.s_axi_awqos(s_axi_awqos),
	.s_axi_awvalid(s_axi_awvalid),
	.s_axi_awready(s_axi_awready),
	.s_axi_wdata(s_axi_wdata),
	.s_axi_wstrb(s_axi_wstrb),
	.s_axi_wlast(s_axi_wlast),
	.s_axi_wvalid(s_axi_wvalid),
	.s_axi_wready(s_axi_wready),
	.s_axi_bready(s_axi_bready),
	.s_axi_bid(s_axi_bid),
	.s_axi_bresp(s_axi_bresp),
	.s_axi_bvalid(s_axi_bvalid),
	.s_axi_arid(s_axi_arid),
	.s_axi_araddr(s_axi_araddr),
	.s_axi_arlen(s_axi_arlen),
	.s_axi_arsize(s_axi_arsize),
	.s_axi_arburst(s_axi_arburst),
	.s_axi_arlock(s_axi_arlock),
	.s_axi_arcache(s_axi_arcache),
	.s_axi_arprot(s_axi_arprot),
	.s_axi_arqos(s_axi_arqos),
	.s_axi_arvalid(s_axi_arvalid),
	.s_axi_arready(s_axi_arready),
	.s_axi_rready(s_axi_rready),
	.s_axi_rid(s_axi_rid),
	.s_axi_rdata(s_axi_rdata),
	.s_axi_rresp(s_axi_rresp),
	.s_axi_rlast(s_axi_rlast),
	.s_axi_rvalid(s_axi_rvalid),
	.init_calib_complete(init_calib_complete),
	.device_temp(device_temp),
	.ddr3_dq(ddr3_dq),
	.ddr3_dqs_n(ddr3_dqs_n),
	.ddr3_dqs_p(ddr3_dqs_p),
	.ddr3_addr(ddr3_addr),
  .ddr3_ba(ddr3_ba),
	.ddr3_ras_n(ddr3_ras_n),
	.ddr3_cas_n(ddr3_cas_n),
	.ddr3_we_n(ddr3_we_n),
	.ddr3_reset_n(ddr3_reset_n),
	.ddr3_ck_p(ddr3_ck_p),
	.ddr3_ck_n(ddr3_ck_n),
	.ddr3_cke(ddr3_cke),
  .ddr3_cs_n(ddr3_cs_n),
	.ddr3_dm(ddr3_dm),
	.ddr3_odt(ddr3_odt),
	.sys_rst(sys_rst)
);

assign s_axi_awid = $unsigned(rxawid);
assign s_axi_awaddr = $unsigned(rxawaddr);
assign s_axi_awlen = $unsigned(rxawlen);
assign s_axi_awsize = $unsigned(rxawsize);
assign s_axi_awburst = $unsigned(rxawburst);
assign s_axi_awlock = 0;
assign s_axi_awcache = 0;
assign s_axi_awprot = 0;
assign s_axi_awqos = 0;
assign s_axi_awvalid = $unsigned(rxawvalid);
assign rxawready = $unsigned(s_axi_awready);

assign s_axi_wdata = $unsigned(rxwdata);
assign s_axi_wstrb = $unsigned(rxwstrb);
assign s_axi_wlast = $unsigned(rxwlast);
assign s_axi_wvalid = $unsigned(rxwvalid);
assign rxwready = $unsigned(s_axi_wready);

assign rxbid = $unsigned(s_axi_bid);
assign rxbresp = $unsigned(s_axi_bresp);
assign rxbvalid = $unsigned(s_axi_bvalid);
assign s_axi_bready = $unsigned(rxbready);

assign s_axi_arid = $unsigned(rxarid);
assign s_axi_araddr = $unsigned(rxaraddr);
assign s_axi_arlen = $unsigned(rxarlen);
assign s_axi_arsize = $unsigned(rxarsize);
assign s_axi_arburst = $unsigned(rxarburst);
assign s_axi_arlock = 0;
assign s_axi_arcache = 0;
assign s_axi_arprot = 0;
assign s_axi_arqos = 0;
assign s_axi_arvalid = $unsigned(rxarvalid);
assign rxarready = $unsigned(s_axi_arready);

assign rxrid = $unsigned(s_axi_rid);
assign rxrdata = $unsigned(s_axi_rdata);
assign rxrresp = $unsigned(s_axi_rresp);
assign rxrlast = $unsigned(s_axi_rlast);
assign rxrvalid = $unsigned(s_axi_rvalid);
assign s_axi_rready = $unsigned(rxrready);

assign clk_ref_i = clk_ref;

assign sys_clk_i = clk_sys;
assign sys_rst = rstnn_sys;

assign clk_dram_if = ui_clk;
assign aresetn = rstnn_dram_if;

assign app_sr_req = 0;
assign app_ref_req = 0;
assign app_zq_req = 0;

assign initialized = init_calib_complete;

