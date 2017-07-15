`define TimeExpire 25'b0000000100000000000000000

module top1(clk, rst, seg , sevenSegmentSel);

	input clk, rst;
	
	output [5:0]sevenSegmentSel;
	output [7:0]seg;
	
	
	reg [5:0]sevenSegmentSel;
	reg [7:0]seg;
	reg [24:0]SevenSegmentDelay;
	
	reg [3:0]counter;
	reg [26:0] count;
	
	
always@(posedge clk)

begin

	if(!rst)
		begin
			sevenSegmentSel = 6'b111110;
			seg = 8'b11000000;
			count<=27'd15;
			counter<=4'b1111;
			SevenSegmentDelay = 25'd0;
		end
	
	else	
		begin
			SevenSegmentDelay = SevenSegmentDelay + 25'b1;
			count<=count+1;
			
			if (count==27'd50000000) // for one second duration 
		//else if (count==27'd1000000) // 1 MHz clock
		//else if (count==27'd50000) // 50 KHz clock
				begin
						count <=27'd0;
						if (counter > 0) 
							begin 
								counter <= counter -1;
							end
						else  counter <= 15;
						
				end
			else if (SevenSegmentDelay == `TimeExpire)	
			   begin
				SevenSegmentDelay = 25'd0;
				case(sevenSegmentSel)
					6'b111110 : sevenSegmentSel = 6'b111101;
					6'b111101 : sevenSegmentSel = 6'b111011;
					6'b111011 : sevenSegmentSel = 6'b110111;
					6'b110111 : sevenSegmentSel = 6'b101111;
					6'b101111 : sevenSegmentSel = 6'b011111;
					6'b011111 : sevenSegmentSel = 6'b111110;
					default   : sevenSegmentSel = 6'b111110;
				endcase
				case(sevenSegmentSel)
					6'b111110:
						case(counter)
						4'b0000: 
							begin
								seg = 8'b11000000; //0
							end
						4'b0001: 
							begin
								seg = 8'b11111001; // 1
							end
						4'b0010:
							begin				
								seg = 8'b10100100; // 2
							end
						4'b0011:
							begin
								seg = 8'b10110000; // 3 				
							end
						4'b0100: 
							begin
								seg = 8'b10011001; // 4 
							end
						4'b0101:
							begin
								seg = 8'b10010010; // 5 
							end
						4'b0110:
							begin
								seg = 8'b10000010; // 6 
							end
						4'b0111: 
							begin
								seg = 8'b11111000; // 7 
							end
						4'b1000: 
							begin
								seg = 8'b10000000; // 8
							end
						4'b1001:
							begin
								seg = 8'b10010000; // 9
							end
						4'b1010:
							begin
								seg= 8'b11000000; //10
							end
						4'b1011:
							begin
								seg = 8'b11111001; //11
							end
						4'b1100: 
							begin
								seg = 8'b10100100; // 12
							end
						4'b1101:
							begin
								seg = 8'b10110000; 
							end
						4'b1110:
							begin
								seg = 8'b10011001; // 14
							end
						4'b1111: 
							begin
								seg = 8'b10010010; //15
							end
					endcase
					
				6'b111101:
		
						case(counter)
						4'b0000: 
							begin
								seg = 8'b11000000; //0 0
							end
						4'b0001: 
							begin
								seg = 8'b11000000; //0 1
							end
						4'b0010:
							begin				
								seg = 8'b11000000; //0 2
							end
						4'b0011:
							begin
								seg = 8'b11000000; //0 3 				
							end
						4'b0100: 
							begin
								seg = 8'b11000000; // 04 
							end
						4'b0101:
							begin
								seg = 8'b11000000; // 05 
							end
						4'b0110:
							begin
								seg = 8'b11000000; // 06 
							end
						4'b0111: 
							begin
								seg = 8'b11000000; // 07 
							end
						4'b1000: 
							begin
								seg = 8'b11000000; //0 8
							end
						4'b1001:
							begin
								seg = 8'b11000000; // 09
							end
						4'b1010:
							begin
								seg = 8'b11111001;  //10
							end
						4'b1011:
							begin
								seg = 8'b11111001;//11
							end
						4'b1100: 
							begin
								seg = 8'b11111001; // 12
							end
						4'b1101:
							begin
								seg = 8'b11111001;//13
							end
						4'b1110:
							begin
								seg = 8'b11111001; // 14
							end
						4'b1111: 
							begin
								seg = 8'b11111001;  //15
							end
					endcase
			6'b111011 :seg = 8'b11111111;
			6'b110111 :seg =8'b11111111;
			6'b101111 :seg =8'b11111111;
			6'b011111 :seg =8'b11111111;
			endcase //sevenSegmentSel
						
			end//else if
		
		end//else begin
 	
end  // end always begin
		
endmodule
	//always@(counter)
/*	always@(*)*/
