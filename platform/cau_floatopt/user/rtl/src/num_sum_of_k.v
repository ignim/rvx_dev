


module num_sum_of_k( x_save_0, x_save_1,x_save_2,x_save_3,y_save_0,y_save_1,y_save_2,y_save_3, k0, k1, k2, k3,
					dist_calculation_end, clk, rstnn,
					k0_sum_x, k0_sum_y, k1_sum_x, k1_sum_y, k2_sum_x, k2_sum_y, k0_count, k1_count, k2_count,
					num_sum_of_k_end, we_new, end_of_data, last_data_num
					);


input wire dist_calculation_end, we_new;
input wire clk, rstnn;

input wire [32-1:0] x_save_0, x_save_1, x_save_2, x_save_3; 
input wire [32-1:0] y_save_0, y_save_1, y_save_2, y_save_3; 
input wire [32-1:0] k0,k1,k2,k3;

reg [31:0] k_0, k_1, k_2, k_3;

output reg [32-1:0] k0_count,k1_count,k2_count; 
output reg num_sum_of_k_end = 0;
output reg [32-1:0] k0_sum_x,k0_sum_y, k1_sum_x,k1_sum_y, k2_sum_x,k2_sum_y;

reg dist_calculation_end_receive;

reg [32-1:0] k_sum_x,k_sum_y;
reg [2:0] add_state;

reg input_a_stb_0x, input_b_stb_0x, output_z_ack_0x, input_a_stb_1x, input_b_stb_1x, output_z_ack_1x;
reg input_a_stb_2x, input_b_stb_2x, output_z_ack_2x, input_a_stb_3x, input_b_stb_3x, output_z_ack_3x;
reg input_a_stb_0y, input_b_stb_0y, output_z_ack_0y, input_a_stb_1y, input_b_stb_1y, output_z_ack_1y;
reg input_a_stb_2y, input_b_stb_2y, output_z_ack_2y, input_a_stb_3y, input_b_stb_3y, output_z_ack_3y;

wire output_z_stb_0x,output_z_stb_0y,output_z_stb_1x,output_z_stb_1y, 
     output_z_stb_2x,output_z_stb_2y,output_z_stb_3x,output_z_stb_3y;
reg output_z_stb_0x_done, output_z_stb_0y_done, output_z_stb_1x_done, output_z_stb_1y_done;
reg output_z_stb_2x_done, output_z_stb_2y_done, output_z_stb_3x_done, output_z_stb_3y_done;

wire [31:0] output_z_0x, output_z_0y, output_z_1x, output_z_1y, 
            output_z_2x, output_z_2y, output_z_3x, output_z_3y;

input end_of_data;
input [31:0] last_data_num;


	always@(posedge clk, negedge rstnn) begin   
		if(rstnn==0) begin k_0 <= 0; k_1 <= 0; k_2 <= 0; k_3 <= 0; end
		else if (end_of_data) begin
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



always@(posedge clk, negedge rstnn) begin
	if (rstnn == 0) begin
		output_z_stb_0x_done <= 0; output_z_stb_0y_done <= 0;
		output_z_stb_1x_done <= 0; output_z_stb_1y_done <= 0;
		output_z_stb_2x_done <= 0; output_z_stb_2y_done <= 0;
		output_z_stb_3x_done <= 0; output_z_stb_3y_done <= 0; end
	else begin
	if(dist_calculation_end_receive == 1) begin
		if(output_z_stb_0x) output_z_stb_0x_done <= 1; 
		if(output_z_stb_0y) output_z_stb_0y_done <= 1; 
		if(output_z_stb_1x) output_z_stb_1x_done <= 1;
		if(output_z_stb_1y) output_z_stb_1y_done <= 1;
		if(output_z_stb_2x) output_z_stb_2x_done <= 1; 
		if(output_z_stb_2y) output_z_stb_2y_done <= 1; 
		if(output_z_stb_3x) output_z_stb_3x_done <= 1;
		if(output_z_stb_3y) output_z_stb_3y_done <= 1;
       
         else if (num_sum_of_k_end == 1) begin
		output_z_stb_0x_done <= 0; output_z_stb_0y_done <= 0;
		output_z_stb_1x_done <= 0; output_z_stb_1y_done <= 0;
		output_z_stb_2x_done <= 0; output_z_stb_2y_done <= 0;
		output_z_stb_3x_done <= 0; output_z_stb_3y_done <= 0;
          end end
	end
	end
 
always @(posedge clk, negedge rstnn) begin
		if (rstnn == 0) dist_calculation_end_receive <= 0; 
		else begin
		if(dist_calculation_end) dist_calculation_end_receive <= 1;  
		if(num_sum_of_k_end) dist_calculation_end_receive <= 0; end 
		end



always@(posedge clk, negedge rstnn) begin
	if (rstnn == 0 || we_new) begin
		add_state <= 3'b000; k0_count <= 32'd0; k1_count <= 32'd0; k2_count <= 32'd0; 
		k0_sum_x <=32'd0; k1_sum_x <=32'd0; k2_sum_x <=32'd0;
		k0_sum_y <=32'd0; k1_sum_y <=32'd0; k2_sum_y <=32'd0; end
		
	else if (dist_calculation_end_receive == 0) add_state <= 3'b000; 
	
	else if (dist_calculation_end_receive) begin  

			  case(add_state)
	
				  3'b000:
					  begin add_state<=3'b001; num_sum_of_k_end <=0; end 

			  3'b001:
			  begin 
                        
				if (k_0 ==32'b00) begin 
					k_sum_x <= k0_sum_x; 
					k_sum_y <= k0_sum_y;
					input_a_stb_0x<=1; input_b_stb_0x<=1; output_z_ack_0x<=1;
					input_a_stb_0y<=1; input_b_stb_0y<=1; output_z_ack_0y<=1;
					
					
					if(output_z_stb_0x_done) begin input_a_stb_0x <= 0; input_b_stb_0x <= 0; output_z_ack_0x <= 0; end
					if(output_z_stb_0y_done) begin input_a_stb_0y <= 0; input_b_stb_0y <= 0; output_z_ack_0y <= 0; end
					
					if(output_z_stb_0x_done && output_z_stb_0y_done) begin 
						k0_sum_x<=output_z_0x; k0_sum_y<=output_z_0y;
						k0_count <= k0_count + 32'b1;  
						//k0_count <= k0_count + 32'b100;  
						add_state <= 3'b010; end end
						
				else if(k_0 == 32'b01) begin
					k_sum_x <= k1_sum_x; 
					k_sum_y <= k1_sum_y;
					input_a_stb_0x<=1; input_b_stb_0x<=1; output_z_ack_0x<=1;
					input_a_stb_0y<=1; input_b_stb_0y<=1; output_z_ack_0y<=1;
					
					if(output_z_stb_0x_done) begin input_a_stb_0x <= 0; input_b_stb_0x <= 0; output_z_ack_0x <= 0; end
					if(output_z_stb_0y_done) begin input_a_stb_0y <= 0; input_b_stb_0y <= 0; output_z_ack_0y <= 0; end
					
					if(output_z_stb_0x_done && output_z_stb_0y_done) begin 
						k1_sum_x<=output_z_0x; k1_sum_y<=output_z_0y;
						k1_count <= k1_count + 32'b1; 
						//k1_count <= k1_count + 32'b010;  
						add_state <= 3'b010; end end
						
				else if(k_0 == 32'b10) begin 
					k_sum_x <= k2_sum_x; 
					k_sum_y <= k2_sum_y;
					input_a_stb_0x<=1; input_b_stb_0x<=1; output_z_ack_0x<=1;
					input_a_stb_0y<=1; input_b_stb_0y<=1; output_z_ack_0y<=1;
					
					if(output_z_stb_0x_done) begin input_a_stb_0x <= 0; input_b_stb_0x <= 0; output_z_ack_0x <= 0; end
					if(output_z_stb_0y_done) begin input_a_stb_0y <= 0; input_b_stb_0y <= 0; output_z_ack_0y <= 0; end

					if(output_z_stb_0x_done && output_z_stb_0y_done) begin 
						k2_sum_x<=output_z_0x; k2_sum_y <= output_z_0y;
						k2_count <= k2_count + 32'b1; 
						//k2_count <= k2_count + 32'b001;  
						add_state <= 3'b010; end end
				else if (k_0 == 32'b101) add_state <= 3'b010;
			  end
			  3'b010:
			  begin 
				 if (k_1 ==32'b00) begin 
					 k_sum_x <= k0_sum_x; 
					k_sum_y <= k0_sum_y;
					
					input_a_stb_1x<=1; input_b_stb_1x<=1; output_z_ack_1x<=1;
					input_a_stb_1y<=1; input_b_stb_1y<=1; output_z_ack_1y<=1;
					
					if(output_z_stb_1x_done) begin input_a_stb_1x <= 0; input_b_stb_1x <= 0; output_z_ack_1x <= 0; end
					if(output_z_stb_1y_done) begin input_a_stb_1y <= 0; input_b_stb_1y <= 0; output_z_ack_1y <= 0; end
					
				
					if(output_z_stb_1x_done && output_z_stb_1y_done) begin 
						k0_sum_x<=output_z_1x; k0_sum_y<=output_z_1y;
						k0_count <= k0_count + 32'b1; 
						//k0_count <= k0_count + 1'b100000;  
						add_state <= 3'b011; end end
				
					else if(k_1 == 32'b01) begin
					k_sum_x <= k1_sum_x; 
					k_sum_y <= k1_sum_y;
					input_a_stb_1x<=1; input_b_stb_1x<=1; output_z_ack_1x<=1;
					input_a_stb_1y<=1; input_b_stb_1y<=1; output_z_ack_1y<=1;
					
					if(output_z_stb_1x_done) begin input_a_stb_1x <= 0; input_b_stb_1x <= 0; output_z_ack_1x <= 0; end
					if(output_z_stb_1y_done) begin input_a_stb_1y <= 0; input_b_stb_1y <= 0; output_z_ack_1y <= 0; end
					
					if(output_z_stb_1x_done && output_z_stb_1y_done) begin 
						k1_sum_x<=output_z_1x; k1_sum_y<=output_z_1y;
						k1_count <= k1_count + 32'b1; 
						//k1_count <= k1_count + 1'b010000;  
						add_state <= 3'b011; end end
				
				  else if(k_1 == 32'b10) begin 
					k_sum_x <= k2_sum_x; 
					k_sum_y <= k2_sum_y;
					
					input_a_stb_1x<=1; input_b_stb_1x<=1; output_z_ack_1x<=1;
					input_a_stb_1y<=1; input_b_stb_1y<=1; output_z_ack_1y<=1;
					
					if(output_z_stb_1x_done) begin input_a_stb_1x <= 0; input_b_stb_1x <= 0; output_z_ack_1x <= 0; end
					if(output_z_stb_1y_done) begin input_a_stb_1y <= 0; input_b_stb_1y <= 0; output_z_ack_1y <= 0; end

					if(output_z_stb_1x_done && output_z_stb_1y_done) begin 
						k2_sum_x<=output_z_1x; k2_sum_y<=output_z_1y;
						k2_count <= k2_count + 32'b1;  
						//k2_count <= k2_count + 1'b001000;  
						add_state <= 3'b011; end end
						
				else if (k_1 == 32'b101) add_state <= 3'b011;
				end
				
				3'b011:
				begin 
				  if (k_2 ==32'b00) begin 
					k_sum_x <= k0_sum_x; 
					k_sum_y <= k0_sum_y;
					input_a_stb_2x<=1; input_b_stb_2x<=1; output_z_ack_2x<=1;
					input_a_stb_2y<=1; input_b_stb_2y<=1; output_z_ack_2y<=1;
					
					if(output_z_stb_2x_done) begin input_a_stb_2x <= 0; input_b_stb_2x <= 0; output_z_ack_2x <= 0; end
					if(output_z_stb_2y_done) begin input_a_stb_2y <= 0; input_b_stb_2y <= 0; output_z_ack_2y <= 0; end
					
					if(output_z_stb_2x_done && output_z_stb_2y_done) begin 
						k0_sum_x<=output_z_2x; k0_sum_y<=output_z_2y;
						k0_count <= k0_count + 32'b1; 
						//k0_count <= k0_count + 1'b100000000;  
						add_state <= 3'b100; end end
					
				else if(k_2 == 32'b01) begin
					k_sum_x <= k1_sum_x; 
					k_sum_y <= k1_sum_y;
					input_a_stb_2x<=1; input_b_stb_2x<=1; output_z_ack_2x<=1;
					input_a_stb_2y<=1; input_b_stb_2y<=1; output_z_ack_2y<=1;
					
					if(output_z_stb_2x_done) begin input_a_stb_2x <= 0; input_b_stb_2x <= 0; output_z_ack_2x <= 0; end
					if(output_z_stb_2y_done) begin input_a_stb_2y <= 0; input_b_stb_2y <= 0; output_z_ack_2y <= 0; end
					
					if(output_z_stb_2x_done && output_z_stb_2y_done) begin 
						k1_sum_x<=output_z_2x; k1_sum_y<=output_z_2y;
						k1_count <= k1_count + 32'b1;
						//k1_count <= k1_count + 1'b010000000;  
						add_state <= 3'b100; end end
				else if(k_2 == 32'b10) begin 
					k_sum_x <= k2_sum_x; 
					k_sum_y <= k2_sum_y;
					input_a_stb_2x<=1; input_b_stb_2x<=1; output_z_ack_2x<=1;
					input_a_stb_2y<=1; input_b_stb_2y<=1; output_z_ack_2y<=1;
					
					if(output_z_stb_2x_done) begin input_a_stb_2x <= 0; input_b_stb_2x <= 0; output_z_ack_2x <= 0; end
					if(output_z_stb_2y_done) begin input_a_stb_2y <= 0; input_b_stb_2y <= 0; output_z_ack_2y <= 0; end
					
					if(output_z_stb_2x_done && output_z_stb_2y_done) begin 
						k2_sum_x<=output_z_2x; k2_sum_y<=output_z_2y;
						k2_count <= k2_count + 32'b1;  
						add_state <= 3'b100; end end
				else if (k_2 == 32'b101) add_state <= 3'b100;
				end
			  3'b100:
				begin 
				  if (k_3 ==32'b00) begin 
					 k_sum_x <= k0_sum_x; 
					k_sum_y <= k0_sum_y;
					input_a_stb_3x<=1; input_b_stb_3x<=1; output_z_ack_3x<=1;
					input_a_stb_3y<=1; input_b_stb_3y<=1; output_z_ack_3y<=1;
					
					if(output_z_stb_3x_done) begin input_a_stb_3x <= 0; input_b_stb_3x <= 0; output_z_ack_3x <= 0; end
					if(output_z_stb_3y_done) begin input_a_stb_3y <= 0; input_b_stb_3y <= 0; output_z_ack_3y <= 0; end
					
					if(output_z_stb_3x_done && output_z_stb_3y_done) begin 
						k0_sum_x<=output_z_3x; k0_sum_y<=output_z_3y;
						k0_count <= k0_count + 32'b1;  
						num_sum_of_k_end <= 1; 
						add_state <= 3'b000; end end
				else if(k_3 == 32'b01) begin
					k_sum_x <= k1_sum_x; 
					k_sum_y <= k1_sum_y;
					input_a_stb_3x<=1; input_b_stb_3x<=1; output_z_ack_3x<=1;
					input_a_stb_3y<=1; input_b_stb_3y<=1; output_z_ack_3y<=1;
					
					if(output_z_stb_3x_done) begin input_a_stb_3x <= 0; input_b_stb_3x <= 0; output_z_ack_3x <= 0; end
					if(output_z_stb_3y_done) begin input_a_stb_3y <= 0; input_b_stb_3y <= 0; output_z_ack_3y <= 0; end
					
					if(output_z_stb_3x_done && output_z_stb_3y_done) begin 
						k1_sum_x<=output_z_3x; k1_sum_y<=output_z_3y;
						k1_count <= k1_count + 32'b1;  
						num_sum_of_k_end <= 1; 
						add_state <= 3'b000; end end
				else if(k_3 == 32'b10) begin 
					k_sum_x <= k2_sum_x; 
					k_sum_y <= k2_sum_y;
					input_a_stb_3x<=1; input_b_stb_3x<=1; output_z_ack_3x<=1;
					input_a_stb_3y<=1; input_b_stb_3y<=1; output_z_ack_3y<=1;
					
					if(output_z_stb_3x_done) begin input_a_stb_3x <= 0; input_b_stb_3x <= 0; output_z_ack_3x <= 0; end
					if(output_z_stb_3y_done) begin input_a_stb_3y <= 0; input_b_stb_3y <= 0; output_z_ack_3y <= 0; end
					
					if(output_z_stb_3x_done && output_z_stb_3y_done) begin 
						k2_sum_x<=output_z_3x; k2_sum_y<=output_z_3y;
						k2_count <= k2_count + 32'b1;  
						num_sum_of_k_end <= 1; 
						add_state <= 3'b000;  end end
				else if (k_3 == 32'b101) begin
					add_state <= 3'b000; num_sum_of_k_end <= 1; 
					end
				end
		endcase
		end
	end

adder_jn u0x(k_sum_x, x_save_0, input_a_stb_0x, input_b_stb_0x, output_z_ack_0x, clk, rstnn, 
			output_z_0x, output_z_stb_0x, input_a_ack_0x, input_b_ack_0x);
adder_jn u0y(k_sum_y, y_save_0, input_a_stb_0y, input_b_stb_0y, output_z_ack_0y, clk, rstnn, 
			output_z_0y, output_z_stb_0y, input_a_ack_0y, input_b_ack_0y);


adder_jn u1x(k_sum_x, x_save_1, input_a_stb_1x, input_b_stb_1x, output_z_ack_1x, clk, rstnn, 
			output_z_1x, output_z_stb_1x,input_a_ack_1x, input_b_ack_1x);
adder_jn u1y(k_sum_y, y_save_1, input_a_stb_1y, input_b_stb_1y, output_z_ack_1y, clk, rstnn,
			output_z_1y, output_z_stb_1y, input_a_ack_1y, input_b_ack_1y);

adder_jn u2x(k_sum_x, x_save_2, input_a_stb_2x, input_b_stb_2x, output_z_ack_2x, clk, rstnn,
        output_z_2x, output_z_stb_2x, input_a_ack_2x, input_b_ack_2x);
adder_jn u2y(k_sum_y, y_save_2, input_a_stb_2y, input_b_stb_2y, output_z_ack_2y, clk, rstnn,
        output_z_2y, output_z_stb_2y, input_a_ack_2y, input_b_ack_2y);

adder_jn u3x(k_sum_x, x_save_3, input_a_stb_3x, input_b_stb_3x, output_z_ack_3x, clk, rstnn,
        output_z_3x, output_z_stb_3x, input_a_ack_3x, input_b_ack_3x);
adder_jn u3y(k_sum_y, y_save_3, input_a_stb_3y, input_b_stb_3y, output_z_ack_3y, clk, rstnn,
        output_z_3y, output_z_stb_3y, input_a_ack_3y, input_b_ack_3y);

endmodule


