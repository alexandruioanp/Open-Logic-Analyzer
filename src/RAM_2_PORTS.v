`timescale 1ns / 1ps

module RAM_2_PORTS(input CLK, input WE, input [9:0] WRITE_ADDR, input [9:0] READ_ADDR, input [15:0] DATA_IN, output reg [15:0] DATA_OUT);

//1kB
reg [15:0] MEM[0:1023];

always@(posedge CLK)
	if(WE) MEM[WRITE_ADDR]<=DATA_IN;

always@(posedge CLK)
	DATA_OUT<=MEM[READ_ADDR];

endmodule
