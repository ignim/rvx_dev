

	module fp_change(clk, rstnn, int_value, signal_fp, var_fp, output_var_fp_ack);


	input clk, rstnn;
	input signal_fp;
	input [31:0] int_value;

	reg [7:0] var_e;
	reg [22:0] var_m;
	reg [31:0] var_binary;
	output reg [31:0] var_fp;
	output reg output_var_fp_ack;
	
	reg [3:0] state;
	parameter get_int_value = 4'd0,
			divide_parts = 4'd1,
			put_var_fp = 4'd2;



	always @(posedge clk, negedge rstnn) begin

		if (rstnn == 0||signal_fp == 0) begin
			state <= get_int_value;
			output_var_fp_ack <= 0;
		 end
		 
	else if (signal_fp == 1) begin

		case(state)
		
		get_int_value: begin
		var_binary <= int_value;
		state <= divide_parts;
		end
		
		divide_parts: begin

		if (var_binary[31] == 1) begin
			var_e <= 8'b11111 +127; // 31
			var_m <= var_binary[30:8];
			state <= put_var_fp;
			end
		else if (var_binary[31] == 0 && var_binary[30] == 1) begin
			var_e <= 8'b11110 +127; // 30
			var_m <= var_binary[29:7];
			state <= put_var_fp;
			end
		else if (var_binary[31:30] == 0 && var_binary[29] == 1) begin
			var_e <= 8'b11101 +127;
			var_m <= var_binary[28:6];
			state <= put_var_fp;
			end
		else if (var_binary[31:29] == 0 && var_binary[28] == 1) begin
			var_e <= 8'b11100 +127;
			var_m <= var_binary[27:5];
			state <= put_var_fp;
			end
		else if (var_binary[31:28] == 0 && var_binary[27] == 1) begin
			var_e <= 8'b11011 +127;
			var_m <= var_binary[26:4];
			state <= put_var_fp;
			end
		else if (var_binary[31:27] == 0 && var_binary[26] == 1) begin
			var_e <= 8'b11010 +127;
			var_m <= var_binary[25:3];
			state <= put_var_fp;
			end	
		else if (var_binary[31:26] == 0 && var_binary[25] == 1) begin
			var_e <= 8'b11001 +127;
			var_m <= var_binary[24:2];
			state <= put_var_fp;
			end				
		else if (var_binary[31:25] == 0 && var_binary[24] == 1) begin
			var_e <= 8'b11000 +127;
			var_m <= var_binary[23:1];
			state <= put_var_fp;
			end	
		else if (var_binary[31:24] == 0 && var_binary[23] == 1) begin
			var_e <= 8'b10111 +127;
			var_m <= var_binary[22:0];
			state <= put_var_fp;
			end
		else if (var_binary[31:23] == 0 && var_binary[22] == 1) begin
			var_e <= 8'b10110 +127;
			var_m <= {var_binary[21:0], 1'b0};
			state <= put_var_fp;
			end
		else if (var_binary[31:22] == 0 && var_binary[21] == 1) begin
			var_e <= 8'b10101 +127;
			var_m <= {var_binary[20:0], 2'b0};
			state <= put_var_fp;
			end
		else if (var_binary[31:21] == 0 && var_binary[20] == 1) begin
			var_e <= 8'b10100 +127;
			var_m <= {var_binary[19:0], 3'b0};
			state <= put_var_fp;
			end
		else if (var_binary[31:20] == 0 && var_binary[19] == 1) begin
			var_e <= 8'b10011 +127;
			var_m <= {var_binary[18:0], 4'b0};
			state <= put_var_fp;
			end
		else if (var_binary[31:19] == 0 && var_binary[18] == 1) begin
			var_e <= 8'b10010 +127;
			var_m <= {var_binary[17:0], 5'b0};
			state <= put_var_fp;
			end
		else if (var_binary[31:18] == 0 && var_binary[17] == 1) begin
			var_e <= 8'b10001 +127;
			var_m <= {var_binary[16:0], 6'b0};
			state <= put_var_fp;
			end
		else if (var_binary[31:17] == 0 && var_binary[16] == 1) begin
			var_e <= 8'b10000 +127;
			var_m <= {var_binary[15:0], 7'b0};
			state <= put_var_fp;
			end
		else if (var_binary[31:16] == 0 && var_binary[15] == 1) begin
			var_e <= 8'b1111 +127;
			var_m <= {var_binary[14:0], 8'b0};
			state <= put_var_fp;
			end
		else if (var_binary[31:15] == 0 && var_binary[14] == 1) begin
			var_e <= 8'b1110 +127;
			var_m <= {var_binary[13:0], 9'b0};
			state <= put_var_fp;
			end

		else if (var_binary[31:14] == 0 && var_binary[13] == 1) begin
			var_e <= 8'b1101 +127;
			var_m <= {var_binary[12:0], 10'b0};
			state <= put_var_fp;
			end
		else if (var_binary[31:13] == 0 && var_binary[12] == 1) begin
			var_e <= 8'b1100 +127;
			var_m <= {var_binary[11:0], 11'b0};
			state <= put_var_fp;
			end
		else if (var_binary[31:12] == 0 && var_binary[11] == 1) begin
			var_e <= 8'b1011 +127;
			var_m <= {var_binary[10:0], 12'b0};
			state <= put_var_fp;
			end
		else if (var_binary[31:11] == 0 && var_binary[10] == 1) begin
			var_e <= 8'b1010 +127;
			var_m <= {var_binary[9:0], 13'b0};
			state <= put_var_fp;
			end		
		else if (var_binary[31:10] == 0 && var_binary[9] == 1) begin
			var_e <= 8'b1001 +127;
			var_m <= {var_binary[8:0], 14'b0};
			state <= put_var_fp;
			end
		else if (var_binary[31:9] == 0 && var_binary[8] == 1) begin
			var_e <= 8'b1000 +127;
			var_m <= {var_binary[7:0], 15'b0};
			state <= put_var_fp;
			end
		else if (var_binary[31:8] == 0 && var_binary[7] == 1) begin
			var_e <= 8'b111 +127;
			var_m <= {var_binary[6:0], 16'b0};
			state <= put_var_fp;
			end
		else if (var_binary[31:7] == 0 && var_binary[6] == 1) begin
			var_e <= 8'b110 +127;
			var_m <= {var_binary[5:0], 17'b0};
			state <= put_var_fp;
			end		
		else if (var_binary[31:6] == 0 && var_binary[5] == 1) begin
			var_e <= 8'b101 +127;
			var_m <= {var_binary[4:0], 18'b0};
			state <= put_var_fp;
			end
		else if (var_binary[31:5] == 0 && var_binary[4] == 1) begin
			//var_e <= 8'b100 +127; // 4
			var_e <= 8'b10000011;
			var_m <= {var_binary[3:0], 19'b0};
			state <= put_var_fp;
			end
		else if (var_binary[31:4] == 0 && var_binary[3] == 1) begin
			//var_e <= 8'b11 +127; // 3
			var_e <= 8'b10000010;
			var_m <= {var_binary[2:0], 20'b0};
			state <= put_var_fp;
			end
		else if (var_binary[31:3] == 0 && var_binary[2] == 1) begin
			//var_e <= 8'b10 +127; // 2
			var_e <= 8'b10000001;
			var_m <= {var_binary[1:0], 21'b0};
			state <= put_var_fp;
			end
		else if (var_binary[31:2] == 0 && var_binary[1] == 1) begin
			var_e <= 8'b01 +127; // 1
			var_m <= {var_binary[0], 22'b0};
			state <= put_var_fp;
			end
		else if (var_binary[31:1] == 0 && var_binary[0] == 1) begin
			var_e <= 8'b0 +127; // 0
			var_m <= 23'b0;
			state <= put_var_fp;
			end
			
		else begin
			var_e <= 8'b0;
			var_m <= 23'b0;
			state <= put_var_fp;
			end
		end
		
		put_var_fp: begin
		
		output_var_fp_ack <= 1;
		
		if (output_var_fp_ack && signal_fp) begin
			var_fp <= {1'b0, var_e, var_m};
			output_var_fp_ack <= 0;
			state <= get_int_value;
			end
		end
		
		endcase
		end
		
	end

endmodule


