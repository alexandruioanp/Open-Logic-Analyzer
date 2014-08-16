`timescale 1ns / 1ps

module ADDR_SEQUENCER(input CLK, input RST, output reg WE=0, output reg [9:0] ADDR=0);

always@(posedge CLK) begin
	if(RST) begin
			  WE<=1;
			  ADDR<=0;
			  end
	else if(ADDR<=1022) ADDR<=ADDR+1;
		  else if(ADDR==1023) WE<=0;
end

endmodule
