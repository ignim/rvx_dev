`include "ervp_global.vh"

module TEST1_APB
(
	clk,
	rstnn,

	rpsel,
	rpenable,
	rpaddr,
	rpwrite,
	rpwdata,
	rprdata,
	rpready,
	rpslverr
);

////////////////////////////
/* parameter input output */
////////////////////////////

parameter BW_ADDR = 1;
parameter BW_DATA = 1;

input wire clk, rstnn;
input wire rpsel;
input wire rpenable;
input wire [BW_ADDR-1:0] rpaddr;
input wire rpwrite;
input wire [BW_DATA-1:0] rpwdata;
output reg [BW_DATA-1:0] rprdata;
output wire rpready;
output reg rpslverr;

/////////////
/* signals */
/////////////

genvar i;

wire [8-1:0] addr_offset = rpaddr;
reg is_valid_addr;
wire dist_calculation_end0, dist_calculation_end1, dist_calculation_end2, dist_calculation_end3;
wire [31:0] k0, k1, k2, k3;

wire dis_act0, dis_act1, dis_act2, dis_act3;

reg [31:0] k_0, k_1, k_2, k_3;
reg [32-1:0] x_save_0,x_save_1,x_save_2,x_save_3,x_mean_0,x_mean_1,x_mean_2,y_save_0,y_save_1,y_save_2,y_save_3,y_mean_0,y_mean_1,y_mean_2;
reg we_x0, we_x1, we_x2,we_x3,we_xm0,we_xm1,we_xm2,we_y0,we_y1,we_y2,we_y3,we_ym0,we_ym1,we_ym2;
reg get_datasheet_end;
reg get_datasheet_end_delay;

reg dist_calculation_end_finish,dist_calculation_end_finish0,dist_calculation_end_finish1,dist_calculation_end_finish2,dist_calculation_end_finish3;
reg rpready_set;

reg input_xd_stb, input_xm_stb, input_yd_stb, input_ym_stb;
reg rst;
wire go_next0, go_next1, go_next2,go_next3;
reg soplease;
reg c_go_next0, c_go_next1, c_go_next2, c_go_next3;

//numsum
reg dist_cal_inv;
wire dist_calculation_one;
reg new_means_calculation_end, flag_check_end;  
wire num_sum_of_k_end;
reg [32-1:0] started;
reg we_k0, we_k1, we_k2, we_k3;
reg we_start, we_new, we_start_check;

reg out_finish;
//reg jn_ready_set;

reg out_start_signal;
/*
wire [31:0] iteration;	
wire out_start;
wire goto_loop;*/

wire [31:0] x_new_k0_mean, y_new_k0_mean, x_new_k1_mean, y_new_k1_mean, x_new_k2_mean, y_new_k2_mean;


wire [31:0] k0_count, k1_count, k2_count;
wire [31:0] k0_sum_x, k1_sum_x, k2_sum_x, k0_sum_y, k1_sum_y, k2_sum_y;
reg [31:0] x_k0_mean, y_k0_mean, x_k1_mean, y_k1_mean, x_k2_mean, y_k2_mean;



reg we_k0_count, we_k1_count, we_k2_count;
reg we_k0_sum_x, we_k0_sum_y, we_k1_sum_x, we_k1_sum_y, we_k2_sum_x, we_k2_sum_y;

wire [31:0] k0_count_float, k1_count_float, k2_count_float;


// only for div
wire output_z_stb_00, output_z_stb_01, output_z_stb_10, output_z_stb_11, output_z_stb_20, output_z_stb_21;

reg input_a_stb_00, input_b_stb_00, output_z_ack_00, output_z_00_done;
reg input_a_stb_01, input_b_stb_01, output_z_ack_01, output_z_01_done;
reg input_a_stb_10, input_b_stb_10, output_z_ack_10, output_z_10_done;
reg input_a_stb_11, input_b_stb_11, output_z_ack_11, output_z_11_done;
reg input_a_stb_20, input_b_stb_20, output_z_ack_20, output_z_20_done;
reg input_a_stb_21, input_b_stb_21, output_z_ack_21, output_z_21_done;
// fp
wire signal_fp;
//wire output_var_fp_ack0, output_var_fp_ack1, output_var_fp_ack2; 

// flag
reg flag;

	reg s_input_a_stb_00, s_input_b_stb_00, s_output_z_ack_00;
	reg s_input_a_stb_01, s_input_b_stb_01, s_output_z_ack_01;
	reg s_input_a_stb_10, s_input_b_stb_10, s_output_z_ack_10;
	reg s_input_a_stb_11, s_input_b_stb_11, s_output_z_ack_11;
	reg s_input_a_stb_20, s_input_b_stb_20, s_output_z_ack_20;
	reg s_input_a_stb_21, s_input_b_stb_21, s_output_z_ack_21;
	wire s_output_z_stb_00, s_output_z_stb_01, s_output_z_stb_10, s_output_z_stb_11, s_output_z_stb_20, s_output_z_stb_21;
	reg s_output_z_00_done, s_output_z_01_done, s_output_z_10_done, s_output_z_11_done, s_output_z_20_done, s_output_z_21_done;
	wire[31:0] diff00, diff01, diff10, diff11, diff20, diff21;

reg [31:0] data_threshold;
wire [7:0] threshold;
reg we_threshold;

reg we_end_of_data;
reg end_of_data;
reg [31:0] last_data_num;

////////////
/* logics */
////////////

always@(*)
begin
	rprdata = 0;
	is_valid_addr = 0;
	we_x0 = 0;
	we_x1 = 0;
	we_x2 = 0;
	we_x3 = 0;
	we_xm0 = 0;
	we_xm1 = 0;
	we_xm2 = 0;
	we_y0 = 0;
	we_y1 = 0;
	we_y2 = 0;
	we_y3 = 0;
	we_ym0 = 0;
	we_ym1 = 0;
	we_ym2 = 0;
	
	we_k0 = 0;
	we_k1 = 0;
	we_k2 = 0;
	we_k3 = 0;
	we_start = 0;
	we_new = 0;
	we_k0_count = 0;
	we_k1_count = 0;
	we_k2_count = 0;
	we_k0_sum_x = 0;
	we_k0_sum_y = 0;
	we_k1_sum_x = 0;
	we_k1_sum_y = 0;
	we_k2_sum_x = 0;
	we_k2_sum_y = 0;
	we_start_check = 0;
	
	we_threshold = 0;
	we_end_of_data = 0;

	if(rpsel==1'b 1)
	begin
		if(rpenable==1'b 1)
		begin
			case(addr_offset)
				8'h 0:
				begin
					is_valid_addr = 1;
					rprdata = x_mean_0;
					we_xm0 = rpwrite;
				end
				8'h 4:
				begin
				
					is_valid_addr = 1;
					rprdata = y_mean_0;
					 we_ym0 = rpwrite;
				end
				8'h 8:
				begin
					is_valid_addr = 1;
					rprdata = x_mean_1;
					we_xm1 = rpwrite;
				end
				8'h C:
				begin
					is_valid_addr = 1;
					rprdata = y_mean_1;
					we_ym1 = rpwrite;
				end
				8'h 10:
				begin
					is_valid_addr = 1;
					rprdata = x_mean_2;
					we_xm2 = rpwrite;
				end
				8'h 14:
				begin
					is_valid_addr = 1;
					rprdata = y_mean_2;
					we_ym2 = rpwrite;
				end
				8'h 18: //out start
				begin
					is_valid_addr = 1;
					rprdata = out_start_signal;
				end
				8'h 1C: //start_signal_pre
				begin
					is_valid_addr = 1;
					we_new = rpwrite;
					//rprdata = jn_ready_set;
				end
				8'h 20:  //start_signal
				begin
					is_valid_addr = 1;
					we_start = rpwrite;
					rprdata = started;
				end
				8'h 24:
				begin
					is_valid_addr = 1;
					rprdata = x_save_0;
					 we_x0 = rpwrite;
				end
				8'h 28:
				begin
					is_valid_addr = 1;
					rprdata = y_save_0;
					we_y0 = rpwrite;
				end
				8'h 2C:
				begin
					is_valid_addr = 1;
					rprdata = x_save_1;
					 we_x1 = rpwrite;
				end
				8'h 30:
				begin
					is_valid_addr = 1;
					rprdata = y_save_1;
					we_y1 = rpwrite;
				end
				8'h 34:
				begin
					is_valid_addr = 1;
					rprdata = x_save_2;
					we_x2 = rpwrite;
				end
				
				8'h 38:
				begin
					is_valid_addr = 1;
					rprdata = y_save_2;
					we_y2 = rpwrite;
				end
				
				8'h 3C:
				begin
					is_valid_addr = 1;
					rprdata = x_save_3;
					we_x3 = rpwrite;	
				end
				
				8'h 40:
				begin
					is_valid_addr = 1;
					rprdata = y_save_3;
					we_y3 = rpwrite;
				end
				//k_print
				8'h 44:
				begin
					is_valid_addr = 1;
					we_k0 = rpwrite;
					rprdata = k_0;
				end
				
				8'h 48:
				begin
					is_valid_addr = 1;
					we_k1 = rpwrite;
					rprdata = k_1;
				end
				
				8'h 4C:
				begin
					is_valid_addr = 1;
					we_k2 = rpwrite;
					rprdata = k_2;
				end
				
				8'h 50:
				begin
					is_valid_addr = 1;
					we_k3 = rpwrite;
					rprdata = k_3;
				end	
				
				8'h 54:
				begin
					is_valid_addr = 1;
					we_k0_count = rpwrite;
					rprdata = k0_count;
				end
				
				8'h 58:
				begin
					is_valid_addr = 1;
					we_k1_count = rpwrite;
					rprdata = k1_count;
				end
				
				8'h 5C:
				begin
					is_valid_addr = 1;
					we_k2_count = rpwrite;
					rprdata = k2_count;
				end
				
				8'h 60:
				begin
					is_valid_addr = 1;
					we_k0_sum_x = rpwrite;
					rprdata = k0_sum_x;
				end
				
				8'h 64:
				begin
					is_valid_addr = 1;
					we_k0_sum_y = rpwrite;
					rprdata = k0_sum_y;
				end
				
				8'h 68:
				begin
					is_valid_addr = 1;
					we_k1_sum_x = rpwrite;
					rprdata = k1_sum_x;
				end
				
				8'h 6C:
				begin
					is_valid_addr = 1;
					we_k1_sum_y = rpwrite;
					rprdata = k1_sum_y;
				end
				
				8'h 70:
				begin
					is_valid_addr = 1;
					we_k2_sum_x = rpwrite;
					rprdata = k2_sum_x;
				end
				
				8'h 74:
				begin
					is_valid_addr = 1;
					we_k2_sum_y = rpwrite;
					rprdata = k2_sum_y;
				end
				
				8'h 94:
				begin
					is_valid_addr = 1;
					rprdata = k0_count_float;
				end
				8'h 98:
				begin
					is_valid_addr = 1;
					rprdata = k1_count_float;
				end
				8'h 9C:
				begin
					is_valid_addr = 1;
					rprdata = k2_count_float;
				end
				
				8'h A0: // start_signal
				begin
					is_valid_addr = 1;
					we_start_check = rpwrite;
					rprdata = started;
				end
				
				8'h A4: // threshold
				begin
					is_valid_addr = 1;
					we_threshold = rpwrite;
					rprdata = data_threshold;
				end
				
				8'h A8: // end of data
				begin
					is_valid_addr = 1;
					we_end_of_data = rpwrite;
					//rprdata = data_threshold;
				end
				
				default:
					is_valid_addr = 0;			
			endcase
		end
	end
end

assign rpready = rpready_set;




always@(posedge clk, negedge rstnn) begin
	if(rstnn==0) end_of_data <= 0;
		
	else begin
		if (we_end_of_data) end_of_data <= 1;
		if (we_new) end_of_data <= 0;
	end 
end


always@(posedge clk, negedge rstnn) begin
	if(rstnn==0) last_data_num <= 0;
		
	else begin
		if (we_end_of_data) last_data_num <= rpwdata; 
		if (we_new) last_data_num <= 0;
	end 
end




always@(posedge clk, negedge rstnn)
begin
	if(rstnn==0) begin
		x_save_0 <= 0; x_save_1 <= 0; x_save_2 <= 0;  x_save_3 <= 0;  x_mean_0 <= 0;
		x_mean_1 <= 0;	x_mean_2 <= 0; y_save_0 <= 0; y_save_1 <= 0;  y_save_2 <= 0;
		y_mean_0 <= 0;  y_save_3 <= 0; y_mean_1 <= 0; y_mean_2 <= 0;  get_datasheet_end<= 0; data_threshold <= 0;	end
	else begin
		if(we_x0==1'b 1) x_save_0 <= rpwdata;
		if(we_x1==1'b 1) x_save_1 <= rpwdata;
		if(we_x2==1'b 1) x_save_2 <= rpwdata;
		if(we_x3==1'b 1) x_save_3 <= rpwdata;
		if(we_xm0==1'b 1) x_mean_0 <= rpwdata;
		if(we_xm1==1'b 1) x_mean_1 <= rpwdata;
		if(we_xm2==1'b 1) x_mean_2 <= rpwdata;
		if(we_y0==1'b 1) y_save_0 <= rpwdata;
		if(we_y1==1'b 1) y_save_1 <= rpwdata;
		if(we_y2==1'b 1) y_save_2 <= rpwdata; 
		if(we_y3==1'b 1) begin y_save_3 <= rpwdata; get_datasheet_end <= 1; end  //looooook!!!
		if(we_ym0==1'b 1) y_mean_0 <= rpwdata;
		if(we_ym1==1'b 1) y_mean_1 <= rpwdata;
		if(we_ym2==1'b 1) y_mean_2 <= rpwdata;  
		
		if(we_threshold==1'b 1) data_threshold <= rpwdata;  
		
		else if(get_datasheet_end)  get_datasheet_end <= 0;
		
		if(out_finish) begin
			x_mean_0 <= x_new_k0_mean;
			x_mean_1 <= x_new_k1_mean;
			x_mean_2 <= x_new_k2_mean;
			y_mean_0 <= y_new_k0_mean;
			y_mean_1 <= y_new_k1_mean;
			y_mean_2 <= y_new_k2_mean;
		end
	end 
end



distance w1(x_save_0,y_save_0,x_mean_0,y_mean_0,x_mean_1,y_mean_1,x_mean_2,y_mean_2,input_xd_stb,input_xm_stb,input_yd_stb,input_ym_stb,clk,rst,k0,dist_calculation_end0,dis_act0,go_next0);
distance w2(x_save_1,y_save_1,x_mean_0,y_mean_0,x_mean_1,y_mean_1,x_mean_2,y_mean_2,input_xd_stb,input_xm_stb,input_yd_stb,input_ym_stb,clk,rst,k1,dist_calculation_end1,dis_act1,go_next1);
distance w3(x_save_2,y_save_2,x_mean_0,y_mean_0,x_mean_1,y_mean_1,x_mean_2,y_mean_2,input_xd_stb,input_xm_stb,input_yd_stb,input_ym_stb,clk,rst,k2,dist_calculation_end2,dis_act2,go_next2);
distance w4(x_save_3,y_save_3,x_mean_0,y_mean_0,x_mean_1,y_mean_1,x_mean_2,y_mean_2,input_xd_stb,input_xm_stb,input_yd_stb,input_ym_stb,clk,rst,k3,dist_calculation_end3,dis_act3,go_next3);


	always@(posedge clk, negedge rstnn) begin   
		if(rstnn==0) begin k_0 <= 0; k_1 <= 0; k_2 <= 0; k_3 <= 0; end
		else if (dist_calculation_end_finish)  begin
			if (end_of_data) begin
				if (last_data_num == 32'd1) begin 
					k_0 <= k0; k_1 <= 32'd5; k_2 <= 32'd5; k_3 <= 32'd5; 
					end
				else if (last_data_num == 32'd2) begin 
					k_0 <= k0; k_1 <= k1; k_2 <= 32'd5; k_3 <= 32'd5; 
					end	
				else if (last_data_num == 32'd3) begin 
					k_0 <= k0; k_1 <= k1; k_2 <= k2; k_3 <= 32'd5; 
					end
				else if (last_data_num == 32'd4) begin 
					k_0 <= k0; k_1 <= k1; k_2 <= k2; k_3 <= k3; 
					end	
				
				end
			else begin
				k_0 <= k0; k_1 <= k1; k_2 <= k2; k_3 <= k3; 
			end
		end
	end
	
	always@(posedge clk, negedge rstnn) begin
		if(rstnn==0)
			rpready_set <= 1;
		else begin
			if(get_datasheet_end_delay) rpready_set <= 0; 
			else if(num_sum_of_k_end) rpready_set <= 1;
			else if(we_start) rpready_set <= 0;
			else if(out_finish) rpready_set <= 1;
			//else rpready_set <= 1;
		end 
	end
	
/*
always@(posedge clk, negedge rstnn) begin
	if(rstnn==0) jn_ready_set <= 0;

	else begin
		//if(get_datasheet_end) rpready_set <= 0;
		//if(num_sum_of_k_end) rpready_set <= 1;
		if (we_k0_sum_x) jn_ready_set <= 0;
		if(we_start) jn_ready_set <= 0;
		else if(out_finish) jn_ready_set <= 1;
		end
end*/


	
	//assign rpready = (~get_datasheet_end) |  dist_calculation_end_finish;   //*********************************
	always@(posedge clk, negedge rstnn) begin
		if(rstnn == 0||input_xd_stb == 1) begin
		c_go_next0 <= 0;
		c_go_next1 <= 0;
		c_go_next2 <= 0;
		c_go_next3 <= 0; end
		else begin
			if(go_next0) c_go_next0 <= 1;
			if(go_next1) c_go_next1 <= 1;
			if(go_next2) c_go_next2 <= 1;
			if(go_next3) c_go_next3 <= 1;
		end
	end
	
	//k_out consideration
	always@(posedge clk, negedge rstnn) begin
		if(rstnn == 0 || input_xd_stb==1)
			soplease <= 0;
		else if(c_go_next0 && c_go_next1 && c_go_next2 && c_go_next3)
			soplease <= 1;
		end



	always@(posedge clk, negedge rstnn) begin
		if(rstnn == 0 || dis_act0 == 1 || dis_act1 == 1|| dis_act2 == 1|| dis_act3 == 1) begin
			input_xd_stb <= 0; input_xm_stb <= 0;
			input_yd_stb <= 0; input_ym_stb <= 0; 
		end
		
		else if(get_datasheet_end||soplease) begin  
				input_xd_stb <= 1; input_xm_stb <= 1;
				input_yd_stb <= 1; input_ym_stb <= 1;
				
		end
	end
	


	always@(posedge clk, negedge rstnn) begin
		if(rstnn==0) begin
		dist_calculation_end_finish0 <= 0; 
		dist_calculation_end_finish1 <= 0; 
		dist_calculation_end_finish2 <= 0; 
		dist_calculation_end_finish3 <= 0; end
		
		else begin 
			if(dist_calculation_end0) dist_calculation_end_finish0 <= 1;
			if(dist_calculation_end1) dist_calculation_end_finish1 <= 1;
			if(dist_calculation_end2) dist_calculation_end_finish2 <= 1;
			if(dist_calculation_end3) dist_calculation_end_finish3 <= 1;
			else if(we_x0==1'b 1) begin 
				dist_calculation_end_finish0 <= 0;
				dist_calculation_end_finish1 <= 0;
				dist_calculation_end_finish2 <= 0;
				dist_calculation_end_finish3 <= 0;
			end
		end
	end

	always@(posedge clk, negedge rstnn)begin
		if(rstnn==0 || we_x0 == 1) rst <= 0;
		else  rst <= 1;
	end

	always@(posedge clk, negedge rstnn) begin
	if(rstnn == 0 || we_x0==1'b 1) dist_calculation_end_finish <= 0;
	else begin 
		if(dist_calculation_end_finish0 && dist_calculation_end_finish1&&dist_calculation_end_finish2 && dist_calculation_end_finish3) begin
		 dist_calculation_end_finish <= 1; end
	end
	end
	

	always@(posedge clk, negedge rstnn) begin
		if(rstnn==0 ||dist_calculation_end_finish == 1'b1 ) begin get_datasheet_end_delay <= 0; end
		else begin 
			if(get_datasheet_end) get_datasheet_end_delay <= 1;
		end
	end
////////////////num_sum+new_means///////////////////
assign dist_calculation_one = dist_calculation_end_finish && (~dist_cal_inv);

always@(posedge clk, negedge rstnn) begin
if(rstnn == 0) dist_cal_inv <= 0;
else dist_cal_inv <= dist_calculation_end_finish;
end


//addr_offset 8'h A0
always@(posedge clk, negedge rstnn)
begin
	if(rstnn==0) begin
		started <= 0;
	end
	else begin
		if(we_start_check) started <= rpwdata;
		if(we_start) started <= 1;
	end	
end


always@(posedge clk, negedge rstnn)
begin
	if(rstnn==0)out_finish <= 0;
	
	else begin
		if(flag_check_end) out_finish <= 1; 
		else out_finish <= 0; 
	end	
end

always@(posedge clk, negedge rstnn) begin
	if(rstnn==0) out_start_signal = 0;
	else if(flag == 1) out_start_signal = 1;
end







assign signal_fp = 1;




num_sum_of_k u1( x_save_0, x_save_1,x_save_2,x_save_3,y_save_0,y_save_1,y_save_2,y_save_3, k0, k1, k2, k3,
					dist_calculation_one, clk, rstnn,
					k0_sum_x, k0_sum_y, k1_sum_x, k1_sum_y, k2_sum_x, k2_sum_y, k0_count, k1_count, k2_count,
					num_sum_of_k_end, we_new, end_of_data, last_data_num
					);



	fp_change f0(clk, rstnn, k0_count, signal_fp, k0_count_float, output_var_fp_ack0);
	fp_change f1(clk, rstnn, k1_count, signal_fp, k1_count_float, output_var_fp_ack1);
	fp_change f2(clk, rstnn, k2_count, signal_fp, k2_count_float, output_var_fp_ack2);
	
	
	div d00(k0_sum_x, k0_count_float, input_a_stb_00, input_b_stb_00, output_z_ack_00, clk, rstnn, x_new_k0_mean, output_z_stb_00, input_a_ack00, input_b_ack00);
	div d01(k0_sum_y, k0_count_float, input_a_stb_01, input_b_stb_01, output_z_ack_01, clk, rstnn, y_new_k0_mean, output_z_stb_01, input_a_ack01, input_b_ack01);


	div d10(k1_sum_x, k1_count_float, input_a_stb_10, input_b_stb_10, output_z_ack_10, clk, rstnn, x_new_k1_mean, output_z_stb_10, input_a_ack10, input_b_ack10);
	div d11(k1_sum_y, k1_count_float, input_a_stb_11, input_b_stb_11, output_z_ack_11, clk, rstnn, y_new_k1_mean, output_z_stb_11, input_a_ack11, input_b_ack11);


	div d20(k2_sum_x, k2_count_float, input_a_stb_20, input_b_stb_20, output_z_ack_21, clk, rstnn, x_new_k2_mean, output_z_stb_20, input_a_ack20, input_b_ack20);
	div d21(k2_sum_y, k2_count_float, input_a_stb_21, input_b_stb_21, output_z_ack_21, clk, rstnn, y_new_k2_mean, output_z_stb_21, input_a_ack21, input_b_ack21);
	


sub s00
(
   x_new_k0_mean,
    x_k0_mean,
    s_input_a_stb_00,
    s_input_b_stb_00,
    s_output_z_ack_00,
    clk,
    rstnn,
    diff00,
    s_output_z_stb_00,
    s_input_a_ack00,
    s_input_b_ack00);

sub s01
(
   y_new_k0_mean,
    y_k0_mean,
    s_input_a_stb_01,
    s_input_b_stb_01,
    s_output_z_ack_01,
    clk,
    rstnn,
    diff01,
    s_output_z_stb_01,
    s_input_a_ack01,
    s_input_b_ack01);

sub s10
(
   x_new_k1_mean,
    x_k1_mean,
    s_input_a_stb_10,
    s_input_b_stb_10,
    s_output_z_ack_10,
    clk,
    rstnn,
    diff10,
    s_output_z_stb_10,
    s_input_a_ack10,
    s_input_b_ack10);
	
sub s11
(
   y_new_k1_mean,
    y_k1_mean,
    s_input_a_stb_11,
    s_input_b_stb_11,
    s_output_z_ack_11,
    clk,
    rstnn,
    diff11,
    s_output_z_stb_11,
    s_input_a_ack11,
    s_input_b_ack11);

sub s20
(
   x_new_k2_mean,
    x_k2_mean,
    s_input_a_stb_20,
    s_input_b_stb_20,
    s_output_z_ack_20,
    clk,
    rstnn,
    diff20,
    s_output_z_stb_20,
    s_input_a_ack20,
    s_input_b_ack20);
	
sub s21
(
   y_new_k1_mean,
    y_k1_mean,
    s_input_a_stb_21,
    s_input_b_stb_21,
    s_output_z_ack_21,
    clk,
    rstnn,
    diff21,
    s_output_z_stb_21,
    s_input_a_ack21,
    s_input_b_ack21);



	always@(posedge clk, negedge rstnn) begin
		if(rstnn==0)  begin
				input_a_stb_00 <= 0; input_b_stb_00 <= 0; 
				input_a_stb_01 <= 0; input_b_stb_01 <= 0; 
				input_a_stb_10 <= 0; input_b_stb_10 <= 0; 
				input_a_stb_11 <= 0; input_b_stb_11 <= 0; 
				input_a_stb_20 <= 0; input_b_stb_20 <= 0; 
				input_a_stb_21 <= 0; input_b_stb_21 <= 0; 
		end
		
		else if (we_start) begin 
				input_a_stb_00 <= 1; input_a_stb_01 <= 1; input_a_stb_10 <= 1; 
				input_a_stb_11 <= 1; input_a_stb_20 <= 1; input_a_stb_21 <= 1;
				input_b_stb_00 <= 1; input_b_stb_01 <= 1; input_b_stb_10 <= 1; 
				input_b_stb_11 <= 1; input_b_stb_20 <= 1; input_b_stb_21 <= 1;
		end
		else begin
			if(output_z_stb_00) begin input_a_stb_00 <= 0; input_b_stb_00 <= 0; end
			if(output_z_stb_01) begin input_a_stb_01 <= 0; input_b_stb_01 <= 0; end
			if(output_z_stb_10) begin input_a_stb_10 <= 0; input_b_stb_10 <= 0; end
			if(output_z_stb_11) begin input_a_stb_11 <= 0; input_b_stb_11 <= 0; end
			if(output_z_stb_20) begin input_a_stb_20 <= 0; input_b_stb_20 <= 0; end
			if(output_z_stb_21) begin input_a_stb_21 <= 0; input_b_stb_21 <= 0; end
		end
	end


	always@(posedge clk, negedge rstnn) begin
		if(rstnn==0)  begin
			output_z_ack_00 <= 0; output_z_ack_01 <= 0; output_z_ack_10 <= 0; 
			output_z_ack_11 <= 0; output_z_ack_20 <= 0; output_z_ack_21 <= 0;
		end
		else if(we_start) begin
			output_z_ack_00 <= 1; output_z_ack_01 <= 1; output_z_ack_10 <= 1; 
			output_z_ack_11 <= 1; output_z_ack_20 <= 1; output_z_ack_21 <= 1;
		end
		else if (new_means_calculation_end) begin
			output_z_ack_00 <= 0; output_z_ack_01 <= 0; output_z_ack_10 <= 0; 
			output_z_ack_11 <= 0; output_z_ack_20 <= 0; output_z_ack_21 <= 0;
		end
	end

	always@(posedge clk, negedge rstnn) begin
		if(rstnn==0)  begin
			output_z_00_done <= 0; output_z_01_done <= 0; output_z_10_done <= 0; 
			output_z_11_done <= 0; output_z_20_done <= 0; output_z_21_done <= 0;
		end
		else if(new_means_calculation_end) begin
			output_z_00_done <= 0; output_z_01_done <= 0; output_z_10_done <= 0; 
			output_z_11_done <= 0; output_z_20_done <= 0; output_z_21_done <= 0;
		end
		else begin
			if(output_z_stb_00) output_z_00_done <= 1; 
			if(output_z_stb_01) output_z_01_done <= 1; 
			if(output_z_stb_10) output_z_10_done <= 1; 
			if(output_z_stb_11) output_z_11_done <= 1; 
			if(output_z_stb_20) output_z_20_done <= 1; 
			if(output_z_stb_21) output_z_21_done <= 1; 	
		end
			//if(state == NEW_MEANS_CALCULATION) begin
	end
	
	
	always@(posedge clk, negedge rstnn) begin
	if (rstnn == 0) new_means_calculation_end <= 0;
	else begin
		if(output_z_00_done && output_z_01_done && output_z_10_done && output_z_11_done && output_z_20_done && output_z_21_done) new_means_calculation_end <= 1;
	else new_means_calculation_end <= 0;
	end
	end
	
//new_means_end
		
		
always @(posedge clk, negedge rstnn) begin
	if (rstnn == 0) begin
		x_k0_mean <= 0; y_k0_mean <= 0;
		x_k1_mean <= 0; y_k1_mean <= 0;
		x_k2_mean <= 0; y_k2_mean <= 0;
		//num_sum_of_k_end <= 0;
		end
	else begin
	if (get_datasheet_end) begin
		x_k0_mean <= x_mean_0; y_k0_mean <= y_mean_0;
		x_k1_mean <= x_mean_1; y_k1_mean <= y_mean_1;
		x_k2_mean <= x_mean_2; y_k2_mean <= y_mean_2;
		//num_sum_of_k_end <= 1;
		end	
	//else num_sum_of_k_end <= 0;
	end
end








// flag

	always@(posedge clk, negedge rstnn) begin
		if(rstnn==0)  begin
				s_input_a_stb_00 <= 0; s_input_b_stb_00 <= 0;
				s_input_a_stb_01 <= 0; s_input_b_stb_01 <= 0; 
				s_input_a_stb_10 <= 0; s_input_b_stb_10 <= 0; 
				s_input_a_stb_11 <= 0; s_input_b_stb_11 <= 0; 
				s_input_a_stb_20 <= 0; s_input_b_stb_20 <= 0; 
				s_input_a_stb_21 <= 0; s_input_b_stb_21 <= 0;
		end
		
		else if (new_means_calculation_end) begin 
				s_input_a_stb_00 <= 1; s_input_b_stb_00 <= 1;
				s_input_a_stb_01 <= 1; s_input_b_stb_01 <= 1; 
				s_input_a_stb_10 <= 1; s_input_b_stb_10 <= 1; 
				s_input_a_stb_11 <= 1; s_input_b_stb_11 <= 1; 
				s_input_a_stb_20 <= 1; s_input_b_stb_20 <= 1;
				s_input_a_stb_21 <= 1; s_input_b_stb_21 <= 1;
		end
		else begin
			if(s_output_z_stb_00) begin s_input_a_stb_00 <= 0; s_input_b_stb_00 <= 0; end
			if(s_output_z_stb_01) begin s_input_a_stb_01 <= 0; s_input_b_stb_01 <= 0; end
			if(s_output_z_stb_10) begin s_input_a_stb_10 <= 0; s_input_b_stb_10 <= 0; end
			if(s_output_z_stb_11) begin s_input_a_stb_11 <= 0; s_input_b_stb_11 <= 0; end
			if(s_output_z_stb_20) begin s_input_a_stb_20 <= 0; s_input_b_stb_20 <= 0; end
			if(s_output_z_stb_21) begin s_input_a_stb_21 <= 0; s_input_b_stb_21 <= 0; end
		end
	end
	
	always@(posedge clk, negedge rstnn) begin
		if(rstnn==0)  begin
			s_output_z_ack_00 <= 0; s_output_z_ack_01 <= 0; s_output_z_ack_10 <= 0; 
			s_output_z_ack_11 <= 0; s_output_z_ack_20 <= 0; s_output_z_ack_21 <= 0;
		end
		else if(new_means_calculation_end) begin
			s_output_z_ack_00 <= 1; s_output_z_ack_01 <= 1; s_output_z_ack_10 <= 1; 
			s_output_z_ack_11 <= 1; s_output_z_ack_20 <= 1; s_output_z_ack_21 <= 1;
		end
		else if (out_finish) begin
			s_output_z_ack_00 <= 0; s_output_z_ack_01 <= 0; s_output_z_ack_10 <= 0; 
			s_output_z_ack_11 <= 0; s_output_z_ack_20 <= 0; s_output_z_ack_21 <= 0;
		end
	end


	always@(posedge clk, negedge rstnn) begin
		if(rstnn==0)  begin
			s_output_z_00_done <= 0; s_output_z_01_done <= 0; s_output_z_10_done <= 0; 
			s_output_z_11_done <= 0; s_output_z_20_done <= 0; s_output_z_21_done <= 0;
		end
		else if(out_finish) begin
			s_output_z_00_done <= 0; s_output_z_01_done <= 0; s_output_z_10_done <= 0; 
			s_output_z_11_done <= 0; s_output_z_20_done <= 0; s_output_z_21_done <= 0;
		end
		else begin
			if(s_output_z_stb_00) s_output_z_00_done <= 1; 
			if(s_output_z_stb_01) s_output_z_01_done <= 1; 
			if(s_output_z_stb_10) s_output_z_10_done <= 1; 
			if(s_output_z_stb_11) s_output_z_11_done <= 1; 
			if(s_output_z_stb_20) s_output_z_20_done <= 1; 
			if(s_output_z_stb_21) s_output_z_21_done <= 1; 	
		end
	end

assign threshold = data_threshold[30:23];

	always@(posedge clk, negedge rstnn) begin
	if (rstnn == 0) flag <= 0;
	else begin
	if (new_means_calculation_end) flag <= 0;
	if (s_output_z_00_done && s_output_z_01_done && s_output_z_10_done && s_output_z_11_done && s_output_z_20_done && s_output_z_21_done) begin
		/*
			if (diff00[30:23]< 8'b0111_0001) begin
				if (diff01[30:23]< 8'b0111_0001) begin
					if (diff10[30:23]< 8'b0111_0001) begin
						if (diff11[30:23]< 8'b0111_0001) begin
							if (diff20[30:23]< 8'b0111_0001) begin
								if (diff21[30:23]< 8'b0111_0001) begin flag <= 1; end
							end 
						end 
					end 
				end 
			end*/
			
			if (diff00[30:23]< threshold) begin
				if (diff01[30:23]< threshold) begin
					if (diff10[30:23]< threshold) begin
						if (diff11[30:23]< threshold) begin
							if (diff20[30:23]< threshold) begin
								if (diff21[30:23]< threshold) begin flag <= 1; end
							end 
						end 
					end 
				end 
			end
		flag_check_end <= 1;
	end 
	else flag_check_end <= 0;
	end
	end

	always@(posedge clk, negedge rstnn)
	begin
		if(rstnn==0)
			rpslverr<= 0;
		else if(rpsel==1'b 1)
		begin
			if(rpenable==1'b 0)
				rpslverr <= 0;
			else
				rpslverr <= ~is_valid_addr;
		end
	end


endmodule



