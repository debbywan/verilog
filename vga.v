module vga(clk, rst, VGA_HS, VGA_VS ,VGA_R, VGA_G, VGA_B);

input clk, rst;		//clk 50MHz
output VGA_HS, VGA_VS, VGA_R, VGA_G, VGA_B;

reg VGA_HS, VGA_VS, VGA_R, VGA_G, VGA_B;

reg[10:0] counterHS;
reg[9:0] counterVS;
reg valid;

always@(posedge clk)
begin
	if(!rst) 
		counterHS <= 0;
	else if(counterHS == 11'd1600) 
		counterHS <= 0;
	else 
		counterHS <= counterHS + 1'b1;
end

always@(posedge clk)
begin
	if(!rst) 
		counterVS <= 0;
	else if(counterVS == 10'd528) 
		counterVS <= 0;
	else if(counterHS == 11'd1600) 
		counterVS <= counterVS + 1'b1;
end

always@(posedge clk)
begin
	if (!rst) 
	begin
		VGA_HS <= 0;
      VGA_VS <= 0;
		valid <= 0;
   end
	else 
	begin
		VGA_HS <= (counterHS > 11'd190) ? 1'b1 : 1'b0;
		VGA_VS <= (counterVS > 10'd2) ? 1'b1 : 1'b0;
		valid <= ((counterHS > 11'd280) && (counterHS < 11'd1560) && (counterVS > 10'd34) && (counterVS < 10'd514)) ? 1'b1 : 1'b0;
		
		if(valid)
		begin
			if(counterVS < 10'd94 && counterHS < 11'd600)   //white
			begin
				VGA_R <= 1;
				VGA_G <= 1;
				VGA_B <= 1;
			end
			
			else if(counterVS < 10'd94 && counterHS < 11'd920)   //pink
			begin
				VGA_R <= 1;
				VGA_G <= 0;
				VGA_B <= 1;
			end
			
			else if(counterVS < 10'd94 && counterHS < 11'd1240)   //yellow
			begin
				VGA_R <= 1;
				VGA_G <= 1;
				VGA_B <= 0;
			end
			
			else if(counterVS < 10'd94 && counterHS < 11'd1560)   //red
			begin
				VGA_R <= 1;
				VGA_G <= 0;
				VGA_B <= 0;
			end
			
			else if(counterVS < 10'd94 && counterHS < 11'd1120)   //green
			begin
				VGA_R <= 1;
				VGA_G <= 0;
				VGA_B <= 1;
			end
			
			else if(counterVS < 10'd154)  //blue
			begin
				VGA_R <= 0;
				VGA_G <= 0;
				VGA_B <= 1;
			end
			else if(counterVS < 10'd214)  //green
			begin
				VGA_R <= 0;
				VGA_G <= 1;
				VGA_B <= 0;
			end
			else if(counterVS < 10'd274) //blue
			begin
				VGA_R <= 0;
				VGA_G <= 0;/**/
				VGA_B <= 1;
			end
			else if(counterVS < 10'd334) //green
			begin
				VGA_R <= 0;
				VGA_G <= 1;
				VGA_B <= 0;
			end
			else if(counterVS < 10'd394) //blue
			begin
				VGA_R <= 0;
				VGA_G <= 0;
				VGA_B <= 1;
			end
			else if(counterVS < 11'd454)  //green
			begin
				VGA_R <= 0;
				VGA_G <= 1;
				VGA_B <= 0;
			end
			else
			begin
				VGA_R <= 0;   //blue
				VGA_G <= 0;
				VGA_B <= 1;
			end
		end
		else
		begin
			VGA_R <= 0;
			VGA_G <= 0;
			VGA_B <= 0;
		end
   end
end

endmodule
