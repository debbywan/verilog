module sdram(clk, rst, CLK, CKE, nCE, nRAS, nCAS, nWE, DM, BA, A, D, 
             segmentSelect, segmentData);

	input clk, rst;
	
	inout [15:0]D;
	
	output CLK, CKE;
	output nCE, nRAS, nCAS, nWE;
	output [1:0]DM;
	output [1:0]BA;
	output [12:0]A;
	output [7:0]segmentData;
	output [5:0]segmentSelect;
	
	reg CKE;
	reg nCE, nRAS, nCAS, nWE;
	reg [1:0]DM;
	reg [1:0]BA;
	reg [12:0]A;
	reg [7:0]SDRAMControl;
	reg [15:0]SDRAMCounter;
	
	reg SDRAMWCommand;//write command from HOST to SDRAM
	reg SDRAMRCommand;//read command from HOST to SDRAM
	reg SDRAMWDone;//SDRAM-to-HOST signal for SDRAM write command done
	reg SDRAMRDone;//SDRAM-to-HOST signal for SDRAM read command done
	reg [2:0]SDRAMBank;
	reg [15:0]SDRAMDin;//data for HOST to SDRAM write command
	reg [15:0]SDRAMDout;
	reg [21:0]SDRAMAddr;
	
	reg [24:0]segmentCounter;
	reg [5:0]segmentSelect;
	reg [7:0]segmentData;
	reg [7:0]D1, D2, D3, D4, D5, D6;
	
	parameter Disable     = 4'b0000;
	parameter NoOperation = 4'b0001;
	parameter Precharge   = 4'b0010;
	parameter Refresh     = 4'b0011;
	parameter LodeModeReg = 4'b0100;
	parameter Active      = 4'b0101;
	parameter Write       = 4'b0110;
	parameter Read        = 4'b0111;
	parameter Mode        = 13'b000_0_00_011_0_011;

	/*****Host*****/
	
	reg [9:0]cycleCount;
	
	always@(posedge clk)
	begin
		if(!rst)
		begin
			cycleCount = 10'd0;
			SDRAMWCommand = 1'b0;
			SDRAMRCommand = 1'b0;
			SDRAMBank = 4'b0;
			SDRAMAddr = 22'b0;
			SDRAMDin = 16'b0;
			
			segmentSelect = 6'b011111;
			segmentCounter = 25'd0;
			D1 = 8'b0;
			D2 = 8'b0;
			D3 = 8'b0;
			D4 = 8'b0;
		end
		else
		begin

			/*****Command Counter*****/
			//each count will give SDRAM a command
			//SDRAM will give SDRAMRDONE/SDRAMWDONE signal when SDRAM finish previous command
			//after that, next command will be issued
			if((SDRAMRDone)||(SDRAMWDone)) cycleCount = (cycleCount == 20'd8) ? cycleCount : cycleCount + 1'b1;
		   
			/*****Give Read/Write Command, Data, Address To SDRAM*****/
			case(cycleCount)
			10'd0 :
			begin
			   //Write Command
				//Bank : 0
				//Addr : 1
				//Data : 16'b00000000_11111000;
				SDRAMWCommand = 1'd1;
				SDRAMRCommand = 1'd0;
				SDRAMBank = 4'd0;
				SDRAMAddr = 22'd1;
				SDRAMDin = 16'b00000000_11111000;//7
			end
			10'd1 :
			begin
				//Read Command
				//Bank : 0
				//Addr : 1
				//Data : x
				SDRAMWCommand = 1'd0;
				SDRAMRCommand = 1'd1;
				SDRAMBank = 4'd0;
				SDRAMAddr = 22'd1;
				SDRAMDin = 16'd0;
			end
			10'd2 :
			begin
				//Write Command
				//Bank : 1
				//Addr : 100
				//Data : 16'b00000_10010010;
				SDRAMWCommand = 1'd1;
				SDRAMRCommand = 1'd0;
				SDRAMBank = 4'd1;
				SDRAMAddr = 22'd100;
				SDRAMDin = 16'b00000_10010010; //5
			end
			10'd3 :
			begin
				//Read Command
				//Bank : 2
				//Addr : 1000
				//Data : x;
				SDRAMWCommand = 1'd0;
				SDRAMRCommand = 1'd1;
				SDRAMBank = 4'd1;
				SDRAMAddr = 22'd100;
				SDRAMDin = 16'd0;
			end
			10'd4 :
			begin
				//Write Command
				//Bank : 2
				//Addr : 1000
				//Data : 16'b00000_10010010;
				SDRAMWCommand = 1'd1;
				SDRAMRCommand = 1'd0;
				SDRAMBank = 4'd2;
				SDRAMAddr = 22'd1000;
				SDRAMDin = 16'b00000_10100100;//2
			end
			10'd5 :
			begin
				//Read Command
				//Bank : 2
				//Addr : 1000
				//Data : x;
				SDRAMWCommand = 1'd0;
				SDRAMRCommand = 1'd1;
				SDRAMBank = 4'd2;
				SDRAMAddr = 22'd1000;
				SDRAMDin = 16'd0;
			end
			10'd6 :
			begin
				//Write Command
				//Bank : 3
				//Addr : 1000
				//Data : 16'b00000_10010010;
				SDRAMWCommand = 1'd1;
				SDRAMRCommand = 1'd0;
				SDRAMBank = 4'd3;
				SDRAMAddr = 22'd10000;
				SDRAMDin = 16'b00000_10010000;//9
			end
			10'd7 :
			begin
				//Read Command
				//Bank : 3
				//Addr : 1000
				//Data : x;
				SDRAMWCommand = 1'd0;
				SDRAMRCommand = 1'd1;
				SDRAMBank = 4'd3;
				SDRAMAddr = 22'd10000;
				SDRAMDin = 16'd0;
			end
			default :
			begin
				SDRAMWCommand = 1'd0;
				SDRAMRCommand = 1'd0;
				SDRAMBank = 4'd0;
				SDRAMAddr = 22'd0;
				SDRAMDin = 16'd0;
			end
			endcase
			
			/*****Recieve Data From SDRAM******/
			case(cycleCount)
			10'd1 : D1 = SDRAMDout[7:0];
			10'd3 : D2 = SDRAMDout[7:0];
			10'd5 : D3 = SDRAMDout[7:0];
			10'd7 : D4 = SDRAMDout[7:0];
			endcase
			
			/*****Display Data From SDRAM*****/
			if(segmentCounter == 25'b0000000100000000000000000)
			begin
			
				segmentCounter = 25'd0;
			
				case(segmentSelect)
				6'b011111 : segmentSelect = 6'b101111;
				6'b101111 : segmentSelect = 6'b110111;
				6'b110111 : segmentSelect = 6'b111011;
				6'b111011 : segmentSelect = 6'b111101;
				6'b111101 : segmentSelect = 6'b111110;
				6'b111110 : segmentSelect = 6'b011111;
				default   : segmentSelect = 6'b011111;
				endcase
				
				case(segmentSelect)
				6'b011111 : segmentData = D1;
				6'b101111 : segmentData = D2;
				6'b110111 : segmentData = D3;
				6'b111011 : segmentData = D4;
				default   : segmentData = 8'd0;
				endcase
			end
			else
			begin
				segmentCounter = segmentCounter + 25'd1;
			end
		end
	end
	
	/***************************
	*                          *
	*    SDRAM Controller      *
	*                          *
	***************************/
	
	always@(posedge clk)
	begin
		if(!rst)
		begin
			SDRAMCounter = 16'd0;
			SDRAMControl = 4'd0;
			SDRAMWDone = 1'd0;
			SDRAMRDone = 1'd0;
			SDRAMDout = 16'd0;
			A = 13'd0;
			BA = 2'd0;
			{DM,nCE,nRAS,nCAS,nWE,CKE} = 7'b00_1_0_0_0_1;
		end
		else
		begin
	      /*****SDRAM State Control*****/
			case(SDRAMCounter)
			16'd10026 : SDRAMCounter = 
			           (SDRAMWCommand) ? 16'd20001 :
			           (SDRAMRCommand) ? 16'd30001 :
									           16'd10026;
			16'd20033 : SDRAMCounter = 
			           (SDRAMWCommand) ? 16'd20001 :
			           (SDRAMRCommand) ? 16'd30001 :
			                             16'd20033;
			16'd30032 : SDRAMCounter = 
			           (SDRAMWCommand) ? 16'd20001 :
			           (SDRAMRCommand) ? 16'd30001 :
			                             16'd30032;
			default   : SDRAMCounter = 
			            SDRAMCounter + 1'b1;
			endcase
			
			/*****SDRAM Data Output*****/
			if(SDRAMCounter == 16'd30007) SDRAMDout = D;
		
			/*****SDRAM Command Selection*****/
			SDRAMControl = 
			(SDRAMCounter == 16'd00000) ? Disable : 
			(SDRAMCounter == 16'd10001) ? Precharge :
			(SDRAMCounter == 16'd10017) ? Refresh :
			(SDRAMCounter == 16'd10025) ? LodeModeReg :
			(SDRAMCounter == 16'd20001) ? Active :
			(SDRAMCounter == 16'd20002) ? NoOperation :
			(SDRAMCounter == 16'd20003) ? NoOperation :
			(SDRAMCounter == 16'd20004) ? Write       :
			(SDRAMCounter == 16'd30001) ? Active :
			(SDRAMCounter == 16'd30002) ? NoOperation :
			(SDRAMCounter == 16'd30003) ? NoOperation :
			(SDRAMCounter == 16'd30004) ? Read :
													NoOperation ;

			/*****User Interface*****/
			SDRAMWDone = (SDRAMCounter == 16'd20032) ? 1'b1 : 1'b0;
			SDRAMRDone = (SDRAMCounter == 16'd30031) ? 1'b1 : 1'b0;

			/*****SDRAM Control Signal Output*****/
			case(SDRAMControl)
			Disable:
			begin
				A = 13'd0;
				BA = 2'd0;
				{DM,nCE,nRAS,nCAS,nWE,CKE} = 7'b00_1_0_0_0_1;
			end
			NoOperation:
			begin
				A = 13'd0;
				BA = 2'd0;
				{DM,nCE,nRAS,nCAS,nWE,CKE} = 7'b00_0_1_1_1_1;
			end
			Precharge:
			begin
				A = 13'b0010000000000;
				BA = 2'd0;
				{DM,nCE,nRAS,nCAS,nWE,CKE} = 7'b00_0_0_1_0_1;
			end
			Refresh:
			begin
				A = 13'd0;
				BA = 2'd0;
				{DM,nCE,nRAS,nCAS,nWE,CKE} = 7'b00_0_0_0_1_1;
			end
			LodeModeReg:
			begin
				A = Mode;
				BA = 2'd0;
				{DM,nCE,nRAS,nCAS,nWE,CKE} = 7'b00_0_0_0_0_1;
			end
			Active:
			begin
				A = SDRAMAddr[21:9];
				BA = SDRAMBank;
				{DM,nCE,nRAS,nCAS,nWE,CKE} = 7'b00_0_0_1_1_1;
			end
			Write:
			begin
				A = {4'b0010, SDRAMAddr[8:0]};
				BA = SDRAMBank;
				{DM,nCE,nRAS,nCAS,nWE,CKE} = 7'b00_0_1_0_0_1;
			end
			Read:
			begin
				A = {4'b0010, SDRAMAddr[8:0]};
				BA = SDRAMBank;
				{DM,nCE,nRAS,nCAS,nWE,CKE} = 7'b00_0_1_0_1_1;
			end
			default:
			begin
				A = 13'd0;
				BA = 2'd0;
				{DM,nCE,nRAS,nCAS,nWE,CKE} = 7'b00_1_1_1_1_1;
			end
			endcase
		end
	end
	
	assign CLK = clk;
	assign D = (SDRAMCounter == 16'd20004) ? SDRAMDin : 16'dz;

endmodule 