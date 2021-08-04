
module distance(
   x_data,
   y_data,
   x_mean_0,
   y_mean_0,
   x_mean_1,
   y_mean_1,
   x_mean_2,
   y_mean_2,
  
   input_xd_stb,
   input_xm_stb,
   input_yd_stb,
   input_ym_stb,
   clk,
   rst,
   k,
   dist_calculation_end,
   output_z1_stb,
   go_next
   );
   
input [31:0]x_data;
input [31:0]y_data;
input [31:0]x_mean_0;
input [31:0]y_mean_0;
input [31:0]x_mean_1;
input [31:0]y_mean_1;
input [31:0]x_mean_2;
input [31:0]y_mean_2;
input clk;
input rst;

reg go1, go2, go3;
wire go2_one, go3_one;
output go_next;
reg go_next_to;
reg complete_mean1, complete_mean2;
reg [2:0] cccount;


input input_xd_stb, input_xm_stb, input_yd_stb, input_ym_stb;
output [31:0] k;
output dist_calculation_end,output_z1_stb;

reg s_dist_calculation_end;
reg [31:0] temp_k;
reg output_dis0_stb_o, output_dis1_stb_o, output_dis2_stb_o;
reg output_z1_ack, output_z2_ack, output_sqc1_ack, output_sqc2_ack, output_dis_ack;
reg [31:0] output_dis1,output_dis2, output_dis0_0;

wire [31:0] output_z1, output_sqc1, output_z2, output_sqc2, output_dis0;

wire output_z1_stb, input_xd_ack, input_xm_ack, output_sqc1_stb, input_z1_ack, input_z1_d_ack;
wire output_z2_stb, input_yd_ack, input_ym_ack, output_sqc2_stb, input_z2_ack, input_z2_d_ack;

wire output_dis0_stb;
wire input_sqc1_ack, input_sqc2_ack; 
reg [31:0] x_mean_c, y_mean_c;
wire catch1; 
reg output_sqc1_stb_u,output_sqc2_stb_u; 

always @(posedge clk, negedge rst)  begin
	if (rst == 0 || output_dis0_stb == 1) begin 
	output_sqc1_stb_u <= 0;
	output_sqc2_stb_u <= 0;
	end
	else begin
	if(output_sqc1_stb) output_sqc1_stb_u <= 1;
	if(output_sqc2_stb) output_sqc2_stb_u <= 1;
	end
end

assign catch1 = (output_sqc1_stb_u && output_sqc2_stb_u);


	always@(posedge clk, negedge rst) begin
		if(rst == 0 || output_sqc1_stb == 1) output_z1_ack <= 0; 
		else if(input_xd_stb) output_z1_ack <= 1;  
	end
	
	always@(posedge clk, negedge rst) begin
		if(rst == 0 || output_sqc2_stb == 1) output_z2_ack <= 0; 
		else if(input_yd_stb) output_z2_ack <= 1;  
	end
	
	always@(posedge clk, negedge rst) begin
		if(rst == 0 || output_dis0_stb == 1) begin output_sqc1_ack <= 0; output_sqc2_ack <= 0; end
		else begin
		if(output_z1_stb) output_sqc1_ack <= 1;  
		if(output_z2_stb) output_sqc2_ack <= 1;
		end
	end
	
	always@(posedge clk, negedge rst) begin
		if(rst == 0 || dist_calculation_end == 1) output_dis_ack <= 0; 
		else if(catch1) output_dis_ack <= 1;  
	end
	
assign go_next = go_next_to;
assign go2_one = go2 && (~complete_mean1);	
assign go3_one = go3 && (~complete_mean2);
	
	always@(posedge clk, negedge rst) begin
		if(rst == 0||cccount == 3'd3) begin 
		x_mean_c <=32'd0;
		y_mean_c <=32'd0;
		complete_mean1 <= 0; complete_mean2 <= 0; end 
		
		else begin
			if(go1) begin
				x_mean_c <= x_mean_0;  
				y_mean_c <= y_mean_0;
			end
			 if(go2) begin 
				x_mean_c <= x_mean_1;  
				y_mean_c <= y_mean_1;
				complete_mean1 <= 1;
			end
			
			else if(go3) begin
				x_mean_c <= x_mean_2;  
				y_mean_c <= y_mean_2;
				complete_mean2 <= 1;
				
			end
			
		end	
	end
	
	
	always@(posedge clk, negedge rst) begin
		if(rst == 0 ||cccount == 3'd3) go_next_to <= 0;
		else begin
			if(go2_one||go3_one) begin
				go_next_to <= 1;
				
			end
			else go_next_to <= 0;
		end
	end
	

	

   sub u1(x_data,
         x_mean_c,
         input_xd_stb,
         input_xm_stb,
         output_z1_ack,
         clk,
         rst,
         output_z1,
         output_z1_stb,
         input_xd_ack,
         input_xm_ack);
         
   multiplier u2(output_z1,
            output_z1,
            output_z1_stb,
            output_z1_stb,
            output_sqc1_ack,
            clk,
            rst,
            output_sqc1,
            output_sqc1_stb,
            input_z1_ack,
            input_z1_d_ack);
            
   sub u3(y_data,
         y_mean_c,
         input_yd_stb,
         input_ym_stb,
         output_z2_ack,
         clk,
         rst,
         output_z2,
         output_z2_stb, 
         input_yd_ack,
         input_ym_ack);
         
   multiplier u4(output_z2,
            output_z2,
            output_z2_stb,
            output_z2_stb,
            output_sqc2_ack,
            clk,
            rst,
            output_sqc2,
            output_sqc2_stb,
            input_z2_ack,
            input_z2_d_ack);         
            
   adder u5(output_sqc1,
         output_sqc2,
         catch1,
         catch1,
         output_dis_ack,
         clk,
         rst,
         output_dis0,
         output_dis0_stb, 
         input_sqc1_ack,
         input_sqc2_ack);
   

always @(posedge clk, negedge rst)  begin
if (rst == 0||s_dist_calculation_end == 1) begin cccount <= 3'd0; go1 <= 1; go2 <= 0; go3 <= 0; end

else begin
	if(cccount == 3'd0) begin
		if(output_dis0_stb_o) begin
			go2 <= 1;
			go1 <= 0;
			cccount <= 3'd1;
		end
	end
	else if(cccount==3'd1) begin
		if(output_dis1_stb_o) begin
			go3 <= 1;
			go2 <= 0;
			cccount <= 3'd2;
		end
	end
	else if(cccount == 3'd2) begin
		if(output_dis2_stb_o) cccount <= 3'd3;
	end

	
end
end

always @(posedge clk, negedge rst) 
begin
if (rst == 0) begin
output_dis0_stb_o <= 0;
output_dis1_stb_o <= 0;
output_dis2_stb_o <= 0;
end

else if(s_dist_calculation_end)begin
	output_dis0_stb_o <= 0;
	output_dis1_stb_o <= 0;
	output_dis2_stb_o <= 0; 
end
	
else begin
	if(go2) begin
		if(output_dis0_stb) begin 
			output_dis1_stb_o <= 1;
			output_dis1 <= output_dis0;  
		end
	end
	else if(go3) begin
		if(output_dis0_stb) begin 
			output_dis2_stb_o <= 1;
			output_dis2 <= output_dis0;  
		end
	end
	else if(go1) begin
		if(output_dis0_stb) begin
		output_dis0_stb_o <= 1;   
		output_dis0_0 <= output_dis0; 
		end
	end
		
end
end
			


			  
always @(posedge clk, negedge rst)  begin
	if (rst == 0) begin 
		temp_k <= 32'd7;
		s_dist_calculation_end <= 0;
	end
	else begin
		if (s_dist_calculation_end == 1) begin
			s_dist_calculation_end <= 0;
		end
		else if (output_dis0_stb_o && output_dis1_stb_o && output_dis2_stb_o) begin
			s_dist_calculation_end <= 1;
			if(output_dis0_0 < output_dis1) begin
				if(output_dis0_0 < output_dis2) temp_k <= 32'd0;
				else if(output_dis0_0 > output_dis2) temp_k <= 32'd2;
				else if(output_dis0_0 == output_dis2) temp_k <=32'd3;
			end
			else if (output_dis0_0 > output_dis1) begin
				if(output_dis1 < output_dis2) temp_k <= 32'd1;
				else if(output_dis1 > output_dis2) temp_k <= 32'd2;
				else if(output_dis1 == output_dis2) temp_k <= 32'd4;
			end
			else if (output_dis0_0 == output_dis1) begin
				if(output_dis0_0 > output_dis2) begin temp_k <= 32'd2; end
				else begin temp_k <= 32'd5; end
			end
			else temp_k <= 32'd6; 
		end
	end
end

		
assign k = temp_k;
assign dist_calculation_end = s_dist_calculation_end;

endmodule

