
`define TimeExpire 25'b0100000000000000000000000
module keypad(clk, rst, segmentData, segmentSelect, keypadRow, keypadCol);

	input clk, rst;
	input [3:0]keypadCol;
	
	output [2:0]keypadRow;
	output [5:0]segmentSelect;
	output [7:0]segmentData;
	
	reg [2:0]keypadRow;
	reg [3:0]keypadBuf;
	
	//reg [4:0]min = 5'd0;
	
	reg [5:0]segmentSelect;
	reg [7:0]segmentData;
	reg [24:0]keypadDelay;
	reg [24:0]segmentDelay;
	
	always@(posedge clk)
	begin
		if(!rst)
		begin
			keypadRow = 3'b110;
			keypadBuf = 4'b0000;
			keypadDelay = 25'd0;
			segmentSelect = 6'b111110;
		end
		
		
		else
		 begin
			if (keypadDelay == `TimeExpire)			
			begin
				keypadDelay = 25'd0;
				case({keypadRow, keypadCol})
				7'b110_1110 : keypadBuf = 4'd1;
				7'b110_1101 : keypadBuf = 4'd2;
				7'b110_1011 : keypadBuf = 4'd3;
				7'b110_0111 : keypadBuf = 4'd10;
				7'b101_1110 : keypadBuf = 4'd4;
				7'b101_1101 : keypadBuf = 4'd5;
				7'b101_1011 : keypadBuf = 4'd6;
				7'b101_0111 : keypadBuf = 4'd11;
				7'b011_1110 : keypadBuf = 4'd7;
				7'b011_1101 : keypadBuf = 4'd8;
				7'b011_1011 : keypadBuf = 4'd9;
				7'b011_0111 : keypadBuf = 4'd0;
				default     : keypadBuf = keypadBuf;
				endcase
				case(keypadRow)
				3'b110 : keypadRow = 3'b101;
				3'b101 : keypadRow = 3'b011;
				3'b011 : keypadRow = 3'b110;
				default: keypadRow = 3'b110;
				endcase
			end
			
			else if(segmentDelay == `TimeExpire)
			begin
				segmentSelect =25'd0;
		
				case(segmentSelect)
				6'b111110 : segmentSelect = 6'b111101 ;
				6'b111101 : segmentSelect = 6'b111011 ;
				6'b111011 : segmentSelect= 6'b110111 ;
				6'b110111 : segmentSelect = 6'b101111 ;
				6'b101111 : segmentSelect = 6'b011111 ;
				6'b011111 : segmentSelect= 6'b111110 ;
				default: segmentSelect = 6'b111110 ;
				endcase
				case(segmentSelect)
				6'b111110 : 
								case(keypadBuf)
								4'd0 : segmentData = 8'b11000000;
								4'd1 : segmentData = 8'b11111001;
								4'd2 : segmentData = 8'b10100100;
								4'd3 : segmentData = 8'b10110000;
								4'd4 : segmentData = 8'b10011001;
								4'd5 : segmentData = 8'b10010010;
								4'd6 : segmentData = 8'b10000010;
								4'd7 : segmentData = 8'b11111000;
								4'd8 : segmentData = 8'b10000000;
								4'd9 : segmentData = 8'b10010000;
								default : segmentData = 8'b11111111;
								endcase
				6'b111101 : 
								case(keypadBuf)
								4'd0 : segmentData = 8'b11000000;
								4'd1 : segmentData = 8'b11111001;
								4'd2 : segmentData = 8'b10100100;
								4'd3 : segmentData = 8'b10110000;
								4'd4 : segmentData = 8'b10011001;
								4'd5 : segmentData = 8'b10010010;
								4'd6 : segmentData = 8'b10000010;
								4'd7 : segmentData = 8'b11111000;
								4'd8 : segmentData = 8'b10000000;
								4'd9 : segmentData = 8'b10010000;
								default : segmentData = 8'b11111111;
								endcase
				6'b111011 : segmentData = 8'b11111111;
				6'b110111 : segmentData = 8'b11111111;
				6'b101111 : segmentData = 8'b11111111;
				6'b011111 : segmentData = 8'b11111111;
				default: segmentData = 8'b11111111;
				endcase
				end
				else
				begin
				keypadDelay = keypadDelay + 1'b1;
				segmentDelay= segmentDelay+ 25'b1;
				end
		end
end
	/*always@(*)
	begin
		case(keypadBuf)
		4'd0 : segmentData = 8'b11000000;
		4'd1 : segmentData = 8'b11111001;
		4'd2 : segmentData = 8'b10100100;
		4'd3 : segmentData = 8'b10110000;
		4'd4 : segmentData = 8'b10011001;
		4'd5 : segmentData = 8'b10010010;
		4'd6 : segmentData = 8'b10000010;
		4'd7 : segmentData = 8'b11111000;
		4'd8 : segmentData = 8'b10000000;
		4'd9 : segmentData = 8'b10010000;
		default : segmentData = 8'b11111111;
		endcase
	end*/
	
endmodule 
