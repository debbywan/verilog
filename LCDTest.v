
`define LCDTimeExpire 50000

module LCDTest(clk, rst, button, EN, RS, RW, DB);

	input clk, rst;
	input button;
	
	output EN, RS, RW;
	output [7:0]DB;
	
	reg EN, RS, RW;
	reg [6:0]LCDStep;
	reg [7:0]DB;
	reg [10:0]nextLCD;
	reg [15:0]LCDCounter;
	reg [7:0]LCDData[31:0];
	
	integer i;
	
	always@(posedge clk)
	begin
	
		if(!rst)
		begin
			LCDStep = 7'd34;
			nextLCD = 11'd0;
			LCDCounter = 16'd0;
			{EN, RS, RW, DB} = 11'd0;
			for(i = 0; i < 32; i = i + 1)
				LCDData[i] = 8'b00110001;
		end
		else
		begin
			//Data
			LCDData[00] = (button) ? 8'b00000000 : 8'b00000001;
			LCDData[01] = (button) ? 8'b00110010 : 8'b00110001;
			LCDData[02] = (button) ? 8'b00110001 : 8'b00110001;
			LCDData[03] = (button) ? 8'b00110010 : 8'b00110001;
			LCDData[04] = (button) ? 8'b00110001 : 8'b00110001;
			LCDData[05] = (button) ? 8'b00110010 : 8'b00110001;
			LCDData[06] = (button) ? 8'b00110001 : 8'b00110001;
			LCDData[07] = (button) ? 8'b00110010 : 8'b00110001;
			LCDData[08] = (button) ? 8'b00110001 : 8'b00110001;
			LCDData[09] = (button) ? 8'b00110010 : 8'b00110001;
			LCDData[10] = (button) ? 8'b00110001 : 8'b00110001;
			LCDData[11] = (button) ? 8'b00110010 : 8'b00110001;
			LCDData[12] = (button) ? 8'b00110001 : 8'b00110001;
			LCDData[13] = (button) ? 8'b00110010 : 8'b00110001;
			LCDData[14] = (button) ? 8'b00110001 : 8'b00110001;
			LCDData[15] = (button) ? 8'b00110010 : 8'b00110001;
			LCDData[16] = (button) ? 8'b00110001 : 8'b00110001;
			LCDData[17] = (button) ? 8'b00110010 : 8'b00110001;
			LCDData[18] = (button) ? 8'b00110001 : 8'b00110001;
			LCDData[19] = (button) ? 8'b00110010 : 8'b00110001;
			LCDData[20] = (button) ? 8'b00110001 : 8'b00110001;
			LCDData[21] = (button) ? 8'b00110010 : 8'b00110001;
			LCDData[22] = (button) ? 8'b00110001 : 8'b00110001;
			LCDData[23] = (button) ? 8'b00110010 : 8'b00110001;
			LCDData[24] = (button) ? 8'b00110001 : 8'b00110001;
			LCDData[25] = (button) ? 8'b00110010 : 8'b00110001;
			LCDData[26] = (button) ? 8'b00110001 : 8'b00110001;
			LCDData[27] = (button) ? 8'b00110010 : 8'b00110001;
			LCDData[28] = (button) ? 8'b00110001 : 8'b00110001;
			LCDData[29] = (button) ? 8'b00110010 : 8'b00110001;
			LCDData[30] = (button) ? 8'b00110001 : 8'b00110001;
			LCDData[31] = (button) ? 8'b00110010 : 8'b00110001;
			
			//LCD Control
			if(LCDCounter == `LCDTimeExpire)
			begin
				LCDCounter = 16'd0;
				LCDStep = (LCDStep == 7'd99) ? 7'd0 :
				          (LCDStep == 7'd33) ? 7'd0 :
							                      LCDStep + 1'd1;
				{EN, RS, RW, DB} = 11'd0;
			end
			else
			begin
				LCDCounter = LCDCounter + 1'd1;
				{EN, RS, RW, DB} = nextLCD;
			end

			case(LCDStep)
			7'd00 : nextLCD = {3'b1_1_0, LCDData[00]};
			7'd01 : nextLCD = {3'b1_1_0, LCDData[01]};
			7'd02 : nextLCD = {3'b1_1_0, LCDData[02]};
			7'd03 : nextLCD = {3'b1_1_0, LCDData[03]};
			7'd04 : nextLCD = {3'b1_1_0, LCDData[04]};
			7'd05 : nextLCD = {3'b1_1_0, LCDData[05]};
			7'd06 : nextLCD = {3'b1_1_0, LCDData[06]};
			7'd07 : nextLCD = {3'b1_1_0, LCDData[07]};
			7'd08 : nextLCD = {3'b1_1_0, LCDData[08]};
			7'd09 : nextLCD = {3'b1_1_0, LCDData[09]};
			7'd10 : nextLCD = {3'b1_1_0, LCDData[10]};
			7'd11 : nextLCD = {3'b1_1_0, LCDData[11]};
			7'd12 : nextLCD = {3'b1_1_0, LCDData[12]};
			7'd13 : nextLCD = {3'b1_1_0, LCDData[13]};
			7'd14 : nextLCD = {3'b1_1_0, LCDData[14]};
			7'd15 : nextLCD = {3'b1_1_0, LCDData[15]};
			7'd16 : nextLCD = 11'b1_0_0_11000000;
			7'd17 : nextLCD = {3'b1_1_0, LCDData[16]};
			7'd18 : nextLCD = {3'b1_1_0, LCDData[17]};
			7'd19 : nextLCD = {3'b1_1_0, LCDData[18]};
			7'd20 : nextLCD = {3'b1_1_0, LCDData[19]};
			7'd21 : nextLCD = {3'b1_1_0, LCDData[20]};
			7'd22 : nextLCD = {3'b1_1_0, LCDData[21]};
			7'd23 : nextLCD = {3'b1_1_0, LCDData[22]};
			7'd24 : nextLCD = {3'b1_1_0, LCDData[23]};
			7'd25 : nextLCD = {3'b1_1_0, LCDData[24]};
			7'd26 : nextLCD = {3'b1_1_0, LCDData[25]};
			7'd27 : nextLCD = {3'b1_1_0, LCDData[26]};
			7'd28 : nextLCD = {3'b1_1_0, LCDData[27]};
			7'd29 : nextLCD = {3'b1_1_0, LCDData[28]};
			7'd30 : nextLCD = {3'b1_1_0, LCDData[29]};
			7'd31 : nextLCD = {3'b1_1_0, LCDData[30]};
			7'd32 : nextLCD = {3'b1_1_0, LCDData[31]};
			7'd33 : nextLCD = 11'b1_0_0_10000000;
			
			7'd34 : nextLCD = 11'b0_0_0_00000000;
			7'd35 : nextLCD = 11'b1_0_0_00000000;//power on
			7'd75 : nextLCD = 11'b1_0_0_00111000;//function set
			7'd76 : nextLCD = 11'b1_0_0_00111000;//function set
			7'd77 : nextLCD = 11'b1_0_0_00001110;//display on
			7'd78 : nextLCD = 11'b1_0_0_00000001;//display clear
			7'd80 : nextLCD = 11'b1_0_0_00000110;//entry mode set
			
			7'd81 : nextLCD = 11'b1_0_0_01000000;
			7'd82 : nextLCD = 11'b1_1_0_00010000;
			7'd83 : nextLCD = 11'b1_1_0_00001000;
			7'd84 : nextLCD = 11'b1_1_0_00000100;
			7'd85 : nextLCD = 11'b1_1_0_00000010;
			7'd86 : nextLCD = 11'b1_1_0_00000001;
			7'd87 : nextLCD = 11'b1_1_0_00000010;
			7'd88 : nextLCD = 11'b1_1_0_00000100;
			7'd89 : nextLCD = 11'b1_1_0_00001000;
			
			7'd90 : nextLCD = 11'b1_0_0_01001000;
			7'd91 : nextLCD = 11'b1_1_0_00001111;
			7'd92 : nextLCD = 11'b1_1_0_00010111;
			7'd93 : nextLCD = 11'b1_1_0_00011011;
			7'd94 : nextLCD = 11'b1_1_0_00011101;
			7'd95 : nextLCD = 11'b1_1_0_00011110;
			7'd96 : nextLCD = 11'b1_1_0_00011101;
			7'd97 : nextLCD = 11'b1_1_0_00011011;
			7'd98 : nextLCD = 11'b1_1_0_00010111;
			
			7'd99 : nextLCD = 11'b1_0_0_10000000;
			default : nextLCD = 11'b0;
			endcase
		end
	end

endmodule 