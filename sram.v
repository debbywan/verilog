module sram(clk, rst, segmentData, segmentSelect, CE, OE, WE, LB, UB, D, A);

	input clk, rst;
	
	output CE, OE, WE, LB, UB;
	output [5:0]segmentSelect;
	output [7:0]segmentData;
	inout [15:0]D;
	output [17:0]A;
	
	reg CE, OE, WE, LB, UB;
	reg [1:0]cs,ns;
	reg [3:0]resultData1;
	reg [3:0]resultData2;
	reg [3:0]resultData3;
	reg [3:0]resultData4;
	reg [3:0]resultData5;
	reg [3:0]resultData6;
	reg [5:0]segmentSelect;
	reg [7:0]segmentData;
	reg [9:0]cycle;
	reg [15:0]Di;
	reg [17:0]A;
	reg [24:0]segmentDelay;
	
	reg SRAMUB, SRAMLB;
	reg SRAMRCommand, SRAMWCommand;
	reg [15:0]SRAMDin;
	reg [17:0]SRAMAin;
	
	parameter WRITE = 2'b00, READ = 2'b01, IDLE = 2'b11;
	
	/***** Specify Test Data *****/
	
	always@(*)
	begin
		case(cycle)
		10'd0 :
		begin
			SRAMWCommand = 1'd0;
			SRAMRCommand = 1'd0;
			SRAMUB = 1'd0;
			SRAMLB = 1'd0;
			SRAMDin = 16'd0;
			SRAMAin = 18'd0;
		end
		10'd1 :
		begin
			SRAMWCommand = 1'd0;
			SRAMRCommand = 1'd0;
			SRAMUB = 1'd0;
			SRAMLB = 1'd0;
			SRAMDin = 16'd0;
			SRAMAin = 18'd0;
		end
		10'd2 :
		begin
			SRAMWCommand = 1'd1;
			SRAMRCommand = 1'd0;
			SRAMUB = 1'd0;
			SRAMLB = 1'd0;
			SRAMDin = 16'd0;
			SRAMAin = 18'd0;
		end
		10'd3 :
		begin
			SRAMWCommand = 1'd0;
			SRAMRCommand = 1'd0;
			SRAMUB = 1'd0;
			SRAMLB = 1'd0;
			SRAMDin = 16'd6;
			SRAMAin = 18'd100;
		end
		10'd4 :
		begin
			SRAMWCommand = 1'd0;
			SRAMRCommand = 1'd1;
			SRAMUB = 1'd0;
			SRAMLB = 1'd0;
			SRAMDin = 16'd0;
			SRAMAin = 18'd0;
		end
		10'd5 :
		begin
			SRAMWCommand = 1'd0;
			SRAMRCommand = 1'd0;
			SRAMUB = 1'd0;
			SRAMLB = 1'd0;
			SRAMDin = 16'd0;
			SRAMAin = 18'd100;
		end
		10'd6 :
		begin
			SRAMWCommand = 1'd1;
			SRAMRCommand = 1'd0;
			SRAMUB = 1'd0;
			SRAMLB = 1'd0;
			SRAMDin = 16'd0;
			SRAMAin = 18'd0;
		end
		10'd7 :
		begin
			SRAMWCommand = 1'd0;
			SRAMRCommand = 1'd0;
			SRAMUB = 1'd0;
			SRAMLB = 1'd0;
			SRAMDin = 16'd5;
			SRAMAin = 18'd1000;
		end
		10'd8 :
		begin
			SRAMWCommand = 1'd0;
			SRAMRCommand = 1'd1;
			SRAMUB = 1'd0;
			SRAMLB = 1'd0;
			SRAMDin = 16'd0;
			SRAMAin = 18'd0;
		end
		10'd9 :
		begin
			SRAMWCommand = 1'd0;
			SRAMRCommand = 1'd0;
			SRAMUB = 1'd0;
			SRAMLB = 1'd0;
			SRAMDin = 16'd0;
			SRAMAin = 18'd1000;
		end
		/**/
		10'd10 :
		begin
			SRAMWCommand = 1'd1;
			SRAMRCommand = 1'd0;
			SRAMUB = 1'd0;
			SRAMLB = 1'd0;
			SRAMDin = 16'd0;
			SRAMAin = 18'd0;
		end
		10'd11 :
		begin
			SRAMWCommand = 1'd0;
			SRAMRCommand = 1'd0;
			SRAMUB = 1'd0;
			SRAMLB = 1'd0;
			SRAMDin = 16'd4;
			SRAMAin = 18'd10000;
		end
		10'd12 :
		begin
			SRAMWCommand = 1'd0;
			SRAMRCommand = 1'd1;
			SRAMUB = 1'd0;
			SRAMLB = 1'd0;
			SRAMDin = 16'd0;
			SRAMAin = 18'd0;
		end
		10'd13 :
		begin
			SRAMWCommand = 1'd0;
			SRAMRCommand = 1'd0;
			SRAMUB = 1'd0;
			SRAMLB = 1'd0;
			SRAMDin = 16'd0;
			SRAMAin = 18'd10000;
		end
		/**/
		10'd14:
		begin
			SRAMWCommand = 1'd1;
			SRAMRCommand = 1'd0;
			SRAMUB = 1'd0;
			SRAMLB = 1'd0;
			SRAMDin = 16'd0;
			SRAMAin = 18'd0;
		end
		10'd15 :
		begin
			SRAMWCommand = 1'd0;
			SRAMRCommand = 1'd0;
			SRAMUB = 1'd0;
			SRAMLB = 1'd0;
			SRAMDin = 16'd3;
			SRAMAin = 18'd10000;
		end
		10'd16 :
		begin
			SRAMWCommand = 1'd0;
			SRAMRCommand = 1'd1;
			SRAMUB = 1'd0;
			SRAMLB = 1'd0;
			SRAMDin = 16'd0;
			SRAMAin = 18'd0;
		end
		10'd17 :
		begin
			SRAMWCommand = 1'd0;
			SRAMRCommand = 1'd0;
			SRAMUB = 1'd0;
			SRAMLB = 1'd0;
			SRAMDin = 16'd0;
			SRAMAin = 18'd10000;
		end
		/**/
		10'd18 :
		begin
			SRAMWCommand = 1'd1;
			SRAMRCommand = 1'd0;
			SRAMUB = 1'd0;
			SRAMLB = 1'd0;
			SRAMDin = 16'd0;
			SRAMAin = 18'd0;
		end
		10'd19 :
		begin
			SRAMWCommand = 1'd0;
			SRAMRCommand = 1'd0;
			SRAMUB = 1'd0;
			SRAMLB = 1'd0;
			SRAMDin = 16'd2;
			SRAMAin = 18'd100000;
		end
		10'd20 :
		begin
			SRAMWCommand = 1'd0;
			SRAMRCommand = 1'd1;
			SRAMUB = 1'd0;
			SRAMLB = 1'd0;
			SRAMDin = 16'd0;
			SRAMAin = 18'd0;
		end
		10'd21 :
		begin
			SRAMWCommand = 1'd0;
			SRAMRCommand = 1'd0;
			SRAMUB = 1'd0;
			SRAMLB = 1'd0;
			SRAMDin = 16'd0;
			SRAMAin = 18'd100000;
		end
		/**/
		10'd22 :
		begin
			SRAMWCommand = 1'd1;
			SRAMRCommand = 1'd0;
			SRAMUB = 1'd0;
			SRAMLB = 1'd0;
			SRAMDin = 16'd0;
			SRAMAin = 18'd0;
		end
		10'd23 :
		begin
			SRAMWCommand = 1'd0;
			SRAMRCommand = 1'd0;
			SRAMUB = 1'd0;
			SRAMLB = 1'd0;
			SRAMDin = 16'd1;
			SRAMAin = 18'd1000000;
		end
		10'd24 :
		begin
			SRAMWCommand = 1'd0;
			SRAMRCommand = 1'd1;
			SRAMUB = 1'd0;
			SRAMLB = 1'd0;
			SRAMDin = 16'd0;
			SRAMAin = 18'd0;
		end
		10'd25 :
		begin
			SRAMWCommand = 1'd0;
			SRAMRCommand = 1'd0;
			SRAMUB = 1'd0;
			SRAMLB = 1'd0;
			SRAMDin = 16'd0;
			SRAMAin = 18'd1000000;
		end
		default:
		begin
			SRAMWCommand = 1'd0;
			SRAMRCommand = 1'd0;
			SRAMUB = 1'd0;
			SRAMLB = 1'd0;
			SRAMDin = 16'd0;
			SRAMAin = 18'd0;
		end
		endcase
	end

	/***** SRAM *****/
	
	always@(posedge clk)
	begin
		if(!rst)
		begin
			cs <= IDLE;
			cycle <= 10'd0;
		end
		else
		begin
			cs <= ns;
			cycle <= (cycle == 10'd1023) ? cycle : cycle + 1'b1;
		end
	end
	
	always@(*)
	begin
	
		case({SRAMRCommand, SRAMWCommand})
		2'b00 : ns = IDLE;
		2'b01 : ns = WRITE;
		2'b10 : ns = READ;
		default : ns = IDLE;
		endcase
	
		case(cs)
		IDLE :
		begin
			CE = 1'b1;
			OE = 1'b0;
			WE = 1'b0;
			LB = 1'b0;
			UB = 1'b0;
			Di = 16'd0;
			A = 18'd0;
		end
		WRITE :
		begin
			CE = 1'b0;
			OE = 1'b0;
			WE = 1'b0;
			LB = SRAMLB;
			UB = SRAMUB;
			Di = SRAMDin;
			A = SRAMAin;
		end
		READ :
		begin
			CE = 1'b0;
			OE = 1'b0;
			WE = 1'b1;
			LB = SRAMLB;
			UB = SRAMUB;
			Di = 16'd0;
			A = SRAMAin;
		end
		default:
		begin
			CE = 1'b1;
			OE = 1'b0;
			WE = 1'b0;
			LB = 1'b0;
			UB = 1'b0;
			Di = 16'd0;
			A = 18'd0;
		end
		endcase
	end

	assign D = (cs == WRITE) ? Di : 16'dz;
	
		/***** Receive Data from SRAM *****/

	always@(posedge clk)
	begin
		if(!rst)
		begin
			resultData1 <= 4'd0;
			resultData2 <= 4'd0;
			resultData3 <= 4'd0;
			resultData4 <= 4'd0;
			resultData5 <= 4'd0;
			resultData6 <= 4'd0;
		end
		else
		begin
			if(cs == READ)
			begin
				resultData1 <= resultData2;
				resultData2 <= resultData3;
				resultData3 <= resultData4;
				resultData4 <= resultData5;
				resultData5 <= resultData6;
				resultData6 <= D[3:0];
			end
		end
	end

	always@(posedge clk)
	begin
		if(!rst)
		begin
			segmentSelect <= 6'b011111;
			segmentDelay <= 25'd0;
		end
		else
		begin
			if(segmentDelay == 25'b0000000100000000000000000)
			begin
				segmentSelect[4:0] <= segmentSelect[5:1];
				segmentSelect[5] <= segmentSelect[0];
				segmentDelay <=25'd0;
			end
			else
			begin
				segmentDelay <= segmentDelay + 25'd1;
			end
		end
	end
	
	//seven segment for data selection
	always@(*)
	begin
		case(segmentSelect)
		6'b011111 : 
			case(resultData1[3:0])
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
		6'b101111 :
			case(resultData2[3:0])
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
		6'b110111 : 
			case(resultData3[3:0])
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
		6'b111011 : 
			case(resultData4[3:0])
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
			case(resultData5[3:0])
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
		6'b111110 : 
			case(resultData6[3:0])
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
		default   : segmentData = 8'b01111111;
		endcase
	end
	
endmodule 