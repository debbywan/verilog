`define TimeExpire 100000
`define zero	8'b11000000
`define one		8'b11111001
`define two		8'b10100100
`define three	8'b10110000
`define four	8'b10011001
`define five	8'b10010010
`define six		8'b10000010
`define seven	8'b11011000
`define eight	8'b10000000
`define nine	8'b10010000
`define h		8'b11111111
module clock(clk, rst, sevenSegmentSel, sevenSegmentData);

input clk, rst;
output [5:0]sevenSegmentSel;
output [7:0]sevenSegmentData;
reg [5:0]sevenSegmentSel;
reg [7:0]sevenSegmentData;
reg [31:0]delay;
reg [2:0]min_10 = 3'd0;
reg [4:0]min = 5'd0;
reg [2:0]sec_10 = 3'd0;
reg [4:0]sec = 5'd0;
reg [9:0]flag;

always@(posedge clk)
begin
	if(!rst)
	begin
		sevenSegmentSel = 6'b111110;
		sevenSegmentData = `zero;
		delay = 25'd0;
		min_10 = 3'd0;
		min = 5'd0;
		sec_10 = 3'd0;
		sec = 5'd0;
	end
	else
	begin
		delay = delay + 1'd1;
		if(flag == 500)
		begin
			flag = 10'd0;
			delay = 32'd0;
			sec = sec + 1'd1;
			if(sec == 10)
			begin
				sec = 5'd0;
				sec_10 = sec_10 + 1'd1;
			end
			if(sec_10 == 6)
			begin
				sec_10 = 3'd0;
				min = min + 1'd1;
			end
			if(min == 10)
			begin
				min = 5'd0;
				min_10 = min_10 + 1'd1;
			end
			if(min_10 == 6)
				min_10 = 3'd0;
		end
		else if(delay == `TimeExpire)
		begin
			flag = flag + 1'd1;
			delay = 32'd0;
			case(sevenSegmentSel)
				6'b111110 : sevenSegmentSel = 6'b111101 ;
				6'b111101 : sevenSegmentSel = 6'b111011 ;
				6'b111011 : sevenSegmentSel = 6'b110111 ;
				6'b110111 : sevenSegmentSel = 6'b101111 ;
				6'b101111 : sevenSegmentSel = 6'b011111 ;
				6'b011111 : sevenSegmentSel = 6'b111110 ;
				default: sevenSegmentSel = 6'b111110 ;
			endcase
			case(sevenSegmentSel)
				6'b011111 : sevenSegmentData = 8'b11111111;
				6'b101111 : begin
									case(min_10)
									6'd0 : sevenSegmentData = `zero;
									6'd1 : sevenSegmentData = `one;
									6'd2 : sevenSegmentData = `two;
									6'd3 : sevenSegmentData = `three;
									6'd4 : sevenSegmentData = `four;
									6'd5 : sevenSegmentData = `five;
									default : sevenSegmentData = `zero;
									endcase
								end
				6'b110111 : begin
									case(min)
									6'd0 : sevenSegmentData = `zero;
									6'd1 : sevenSegmentData = `one;
									6'd2 : sevenSegmentData = `two;
									6'd3 : sevenSegmentData = `three;
									6'd4 : sevenSegmentData = `four;
									6'd5 : sevenSegmentData = `five;
									6'd6 : sevenSegmentData = `six;
									6'd7 : sevenSegmentData = `seven;
									6'd8 : sevenSegmentData = `eight;
									6'd9 : sevenSegmentData = `nine;
									default : sevenSegmentData = `zero;
									endcase
								end
				6'b111011 : sevenSegmentData = `h;
				6'b111101 : begin
									case(sec_10)
									6'd0 : sevenSegmentData = `zero;
									6'd1 : sevenSegmentData = `one;
									6'd2 : sevenSegmentData = `two;
									6'd3 : sevenSegmentData = `three;
									6'd4 : sevenSegmentData = `four;
									6'd5 : sevenSegmentData = `five;
									default : sevenSegmentData = `zero;
									endcase
								end
				6'b111110 : begin
									case(sec)
									6'd0 : sevenSegmentData = `zero;
									6'd1 : sevenSegmentData = `one;
									6'd2 : sevenSegmentData = `two;
									6'd3 : sevenSegmentData = `three;
									6'd4 : sevenSegmentData = `four;
									6'd5 : sevenSegmentData = `five;
									6'd6 : sevenSegmentData = `six;
									6'd7 : sevenSegmentData = `seven;
									6'd8 : sevenSegmentData = `eight;
									6'd9 : sevenSegmentData = `nine;
									default : sevenSegmentData = `zero;
									endcase
								end
				default : sevenSegmentData = `zero;
			endcase
		end
	end
end
endmodule
