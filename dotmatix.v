
    `define TimeExpire 25'b0000000010000000000000000
 // `define TimeExpire 25'b0000010000001000000000000


module dotmatix(clk, rst, DMAXCol0, DMAXCol1, DMAXCol2, DMAXCol3, DMAXCol4, DMAXCol5, DMAXRow);

	input clk, rst;

	output [4:0]DMAXCol0, DMAXCol1, DMAXCol2, DMAXCol3, DMAXCol4, DMAXCol5;
	output [6:0]DMAXRow;

	reg [4:0]DMAXCol0, DMAXCol1, DMAXCol2, DMAXCol3, DMAXCol4, DMAXCol5;
	reg [6:0]DMAXRow;
	reg [24:0]DMAXDelay;
	
	always@(posedge clk)
	begin
		if(!rst)
		begin
			DMAXRow = 7'b00000001;
			DMAXCol0 = 5'b11111;
					DMAXCol1 = 5'b11111;
					DMAXCol2 = 5'b11111;
					DMAXCol3 = 5'b11111;
					DMAXCol4 = 5'b11111;
					DMAXCol5 = 5'b11111;
		end
		else
		begin
			if(DMAXDelay == `TimeExpire)
			begin
				DMAXDelay = 25'd0;
				case(DMAXRow)
				7'b0000001:DMAXRow = 7'b0000010;
				7'b0000010:DMAXRow = 7'b0000100;
				7'b0000100:DMAXRow = 7'b0001000;
				7'b0001000:DMAXRow = 7'b0010000;
				7'b0010000:DMAXRow = 7'b0100000;
				7'b0100000:DMAXRow = 7'b1000000;
				7'b1000000:DMAXRow = 7'b0000001;
				endcase
				case(DMAXRow)
				7'b0000001:
				begin
					DMAXCol0 = 5'b11111;
					DMAXCol1 = 5'b11111;
					DMAXCol2 = 5'b11111;
					DMAXCol3 = 5'b11111;
					DMAXCol4 = 5'b11111;
					DMAXCol5 = 5'b11111;
				end
				
				7'b0000010:
				begin
					DMAXCol0 = 5'b10001;
					DMAXCol1 = 5'b11010;
					DMAXCol2 = 5'b00101;
					DMAXCol3 = 5'b01000;
					DMAXCol4 = 5'b10001;
					DMAXCol5 = 5'b01000;
				end
				7'b0000100:
				begin
					DMAXCol0 = 5'b10101;
					DMAXCol1 = 5'b11011;
					DMAXCol2 = 5'b10101;
					DMAXCol3 = 5'b01011;
					DMAXCol4 = 5'b10111;
					DMAXCol5 = 5'b01010;
				end
				7'b0001000:
				begin
					DMAXCol0 = 5'b10101;
					DMAXCol1 = 5'b00010;
					DMAXCol2 = 5'b00100;
					DMAXCol3 = 5'b01000;
					DMAXCol4 = 5'b10001;
					DMAXCol5 = 5'b01010;
				end
				7'b0010000:
				begin
					DMAXCol0 = 5'b10111;
					DMAXCol1 = 5'b01010;
					DMAXCol2 = 5'b11101;
					DMAXCol3 = 5'b11011;
					DMAXCol4 = 5'b11101;
					DMAXCol5 = 5'b01010;
				end
				7'b0100000:
				begin
					DMAXCol0 = 5'b10111;
					DMAXCol1 = 5'b00010;
					DMAXCol2 = 5'b00101;
					DMAXCol3 = 5'b11000;
					DMAXCol4 = 5'b10001;
					DMAXCol5 = 5'b01000;
				end
				7'b1000000:
				begin
					DMAXCol0 = 5'b11111;
					DMAXCol1 = 5'b11111;
					DMAXCol2 = 5'b11111;
					DMAXCol3 = 5'b11111;
					DMAXCol4 = 5'b11111;
					DMAXCol5 = 5'b11111;
				end
				default:
				begin
					DMAXCol0 = 5'b11111;
					DMAXCol1 = 5'b11111;
					DMAXCol2 = 5'b11111;
					DMAXCol3 = 5'b11111;
					DMAXCol4 = 5'b11111;
					DMAXCol5 = 5'b11111;
				end
				endcase
			end
			else
				DMAXDelay = DMAXDelay + 1'b1;
		end
	end
	
endmodule
	