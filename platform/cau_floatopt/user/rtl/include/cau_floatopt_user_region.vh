/*****************/
/* Custom Region */
/*****************/

// wire clk_system;
// wire clk_core;
// wire clk_system_external;
// wire clk_system_debug;
// wire clk_local_access;
// wire clk_process_000;
// wire clk_noc;
// wire gclk_system;
// wire gclk_core;
// wire gclk_system_external;
// wire gclk_system_debug;
// wire gclk_local_access;
// wire gclk_process_000;
// wire gclk_noc;
// wire tick_1us;
// wire tick_62d5ms;
// wire global_rstnn;
// wire global_rstpp;
// wire [(5)-1:0] rstnn_seqeunce;
// wire [(5)-1:0] rstpp_seqeunce;
// wire rstnn_user;
// wire rstpp_user;
// wire i_test1_clk;
// wire i_test1_rstnn;
// wire i_test1_rpsel;
// wire i_test1_rpenable;
// wire i_test1_rpwrite;
// wire [(32)-1:0] i_test1_rpaddr;
// wire [(32)-1:0] i_test1_rpwdata;
// wire i_test1_rpready;
// wire [(32)-1:0] i_test1_rprdata;
// wire i_test1_rpslverr;

/* DO NOT MODIFY THE ABOVE */
/* MUST MODIFY THE BELOW   */



TEST1_APB
#(
	//.SIZE_OF_MEMORYMAP((32'h 1000)),
	.BW_ADDR(32),
	.BW_DATA(32)
)
i_test1
(
	.clk(i_test1_clk),
	.rstnn(i_test1_rstnn),
	.rpsel(i_test1_rpsel),
	.rpenable(i_test1_rpenable),
	.rpwrite(i_test1_rpwrite),
	.rpaddr(i_test1_rpaddr),
	.rpwdata(i_test1_rpwdata),
	.rpready(i_test1_rpready),
	.rprdata(i_test1_rprdata),
	.rpslverr(i_test1_rpslverr)
);

//assign `NOT_CONNECT = i_test1_clk;
//assign `NOT_CONNECT = i_test1_rstnn;
//assign `NOT_CONNECT = i_test1_rpsel;
//assign `NOT_CONNECT = i_test1_rpenable;
//assign `NOT_CONNECT = i_test1_rpwrite;
//assign `NOT_CONNECT = i_test1_rpaddr;
//assign `NOT_CONNECT = i_test1_rpwdata;
//assign i_test1_rpready = 0;
//assign i_test1_rprdata = 0;
//assign i_test1_rpslverr = 0;

