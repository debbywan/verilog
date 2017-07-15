`define TimeExpire 25'b0001000000000000000000000
`define LCDTimeExpire 25000

module lcd(clk, rst, LCMData, LCMEN, LCMRS, LCMRW, keypadRow, keypadCol);

	input clk, rst;
	input [3:0]keypadCol;
	
	output [2:0]keypadRow;
	
	output LCMEN, LCMRS, LCMRW;
	output [7:0]LCMData;

	reg [2:0]keypadRow;
	reg [7:0]keypadBuf1;
	reg [7:0]keypadBuf2;
	reg [7:0]keypadBuf3;
	reg [7:0]keypadBuf4;
	reg [7:0]keypadBuf5;
	reg [7:0]keypadBuf6;
	reg [7:0]keypadBuf7;
	reg [7:0]keypadBuf8;
	reg [7:0]keypadBuf9;
	reg [24:0]keypadDelay;
	
	reg LCMEN, LCMRS, LCMRW;
	reg [5:0]LCDStep;
	reg [7:0]LCMData, displayData;
	reg [10:0]LCD_DATA_state, n_LCD_DATA;
	reg [15:0]LCDDelay;
	
	always@(posedge clk)
	begin
		if(!rst)
		begin
			keypadRow = 3'b110;
			keypadBuf1 = 8'b00000000;
			keypadBuf2 = 8'b00000000;
			keypadBuf3 = 8'b00000000;
			keypadBuf4 = 8'b00000000;
			keypadBuf5 = 8'b00000000;
			keypadBuf6 = 8'b00000000;
			keypadBuf7 = 8'b00000000;
			keypadBuf8 = 8'b00000000;
			keypadBuf9 = 8'b00000000;
			keypadDelay = 25'd0;
			
			displayData = 8'b00110000;
			LCDStep = 6'd0;
			LCDDelay = 16'd0;
			n_LCD_DATA = 11'd0;
			LCD_DATA_state = 11'd0;
			{LCMEN, LCMRS, LCMRW, LCMData} = 11'd0;
		end
		else
		begin
			if(keypadDelay == `TimeExpire)
			begin
				keypadDelay = 25'd0;
				keypadBuf9=keypadBuf8;
				keypadBuf8=keypadBuf7;
				keypadBuf7=keypadBuf6;
				keypadBuf6=keypadBuf5;
				keypadBuf5=keypadBuf4;
				keypadBuf4=keypadBuf3;
				keypadBuf3=keypadBuf2;
				keypadBuf2=keypadBuf1;
				/*依照目前偵測的row，檢查是否該row是否有按鍵被按*/
				case({keypadRow, keypadCol})
				
				7'b110_1110 : keypadBuf1 = 8'd1+8'b00110000;
				7'b110_1101 : keypadBuf1 = 8'd2+8'b00110000;
				7'b110_1011 : keypadBuf1 = 8'd3+8'b00110000;
				7'b110_0111 : keypadBuf1 = 8'd10+8'b00110000;
				7'b101_1110 : keypadBuf1 = 8'd4+8'b00110000;
				7'b101_1101 : keypadBuf1 = 8'd5+8'b00110000;
				7'b101_1011 : keypadBuf1 = 8'd6+8'b00110000;
				7'b101_0111 : keypadBuf1 = 8'd11+8'b00110000;
				7'b011_1110 : keypadBuf1 = 8'd7+8'b00110000;
				7'b011_1101 : keypadBuf1 = 8'd8+8'b00110000;
				7'b011_1011 : keypadBuf1 = 8'd9+8'b00110000;
				7'b011_0111 : keypadBuf1 = 8'd0+8'b00110000;
				default     : 	begin
										keypadBuf1=keypadBuf2;
										keypadBuf2=keypadBuf3;
										keypadBuf3=keypadBuf4;
										keypadBuf4=keypadBuf5;
										keypadBuf5=keypadBuf6;
										keypadBuf6=keypadBuf7;
										keypadBuf7=keypadBuf8;
										keypadBuf8=keypadBuf9;
									end
				endcase
				/*切換到下一列*/
				case(keypadRow)
				3'b110 : keypadRow = 3'b101;
				3'b101 : keypadRow = 3'b011;
				3'b011 : keypadRow = 3'b110;
				default: keypadRow = 3'b110;
				endcase
			end
			else
				keypadDelay = keypadDelay + 1'b1;
				
			if(LCDStep == 6'd40)
			begin
				LCDStep = 6'd0;
			end
			else if(LCDDelay == `LCDTimeExpire)
			begin
				LCDDelay = 16'd0;
				LCDStep = (LCDStep == 6'd40) ? LCDStep : LCDStep + 1'd1;
				LCD_DATA_state = 11'd0;
			end
			else
			begin
				LCDDelay = LCDDelay + 1'd1;
				LCD_DATA_state = n_LCD_DATA;
			end
			
		end
		case(LCDStep)
		6'd0:n_LCD_DATA=11'b00000000000;
		6'd1:n_LCD_DATA=11'b10000111000;//Function Set
		6'd2:n_LCD_DATA=11'b10000001110;//Display On
		6'd3:n_LCD_DATA=11'b10000000001;//Display Clear 
		// Worst case need 1.64ms, so need at least two cycle(if 1 clk == 1ms)
		6'd5:n_LCD_DATA=11'b10000000110;//Entry mode set
		6'd6:n_LCD_DATA=11'b10010000000;
		6'd7:n_LCD_DATA={3'b110, keypadBuf1};
		6'd8:n_LCD_DATA={3'b110, keypadBuf2};
		6'd9:n_LCD_DATA={3'b110, keypadBuf3};
		6'd10:n_LCD_DATA={3'b110, keypadBuf4};
		6'd11:n_LCD_DATA={3'b110, keypadBuf5};
		6'd12:n_LCD_DATA={3'b110, keypadBuf6};
		6'd13:n_LCD_DATA={3'b110, keypadBuf7};
		6'd14:n_LCD_DATA={3'b110, keypadBuf8};
		6'd15:n_LCD_DATA={3'b110, displayData};
		6'd16:n_LCD_DATA={3'b110, displayData};
		6'd17:n_LCD_DATA={3'b110, displayData};
		6'd18:n_LCD_DATA={3'b110, displayData};
		6'd19:n_LCD_DATA={3'b110, displayData};
		6'd20:n_LCD_DATA={3'b110, displayData};
		6'd21:n_LCD_DATA={3'b110, displayData};
		6'd22:n_LCD_DATA={3'b110, displayData};
		6'd23:n_LCD_DATA=11'b10011000000;//cursor is propositioned at the head of the second line 
		6'd24:n_LCD_DATA={3'b110, displayData};
		6'd25:n_LCD_DATA={3'b110, displayData};
		6'd26:n_LCD_DATA={3'b110, displayData};
		6'd27:n_LCD_DATA={3'b110, displayData};
		6'd28:n_LCD_DATA={3'b110, displayData};
		6'd29:n_LCD_DATA={3'b110, displayData};
		6'd30:n_LCD_DATA={3'b110, displayData};
		6'd31:n_LCD_DATA={3'b110, displayData};
		6'd32:n_LCD_DATA={3'b110, displayData};
		6'd33:n_LCD_DATA={3'b110, displayData};
		6'd34:n_LCD_DATA={3'b110, displayData};
		6'd35:n_LCD_DATA={3'b110, displayData};
		6'd36:n_LCD_DATA={3'b110, displayData};
		6'd37:n_LCD_DATA={3'b110, displayData};
		6'd38:n_LCD_DATA={3'b110, displayData};
		6'd39:n_LCD_DATA={3'b110, displayData};
		6'd40:n_LCD_DATA=11'b10000000010;
		default:n_LCD_DATA=11'd0;
		endcase
		
		{LCMEN, LCMRS, LCMRW, LCMData} = LCD_DATA_state;
	end

	
endmodule 