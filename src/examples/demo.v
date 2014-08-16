`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// By modifying the value of SW we change the incrementing speed
// of a counter that is used to drive the on-board LEDs. The two switches
// and the value of each bit of the counter are fed by way of DATA_IN to the logic analyzer.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module demo(input CLK, input [1:0] SW, input serial_in, output serial_out, output reg [5:0] LED=0);

wire [15:0] DATA_IN;
wire [15:0] TXD;
wire [7:0] RXD;
wire TXD_DONE_2;
reg FF;
reg [31:0] divcount=0;
reg led_increment_enable;

assign DATA_IN[1:0]=SW;
assign DATA_IN[7:2]=LED;
assign DATA_IN[15:8]=0;

always@(posedge CLK)
  if(led_increment_enable)
    divcount <= 0;
  else
    divcount <= divcount+1;

always @*
  case(SW)
    0: led_increment_enable=(divcount == 2**0);
    1: led_increment_enable=(divcount == 2**22);
    2: led_increment_enable=(divcount == 2**25);
    3: led_increment_enable=(divcount == 2**28);
  endcase

always@(posedge CLK) if(led_increment_enable) LED<=LED+1;

AssembledLogicAnalyzer LA(
	.CLK(CLK),
	.RXD_START(RXD_START),
	.RXD(RXD),
	.TXD_DONE(TXD_DONE),
	.DATA_IN(DATA_IN),
	.TXD_ENABLE(TXD_ENABLE),
	.TXD(TXD)
);

always@(posedge CLK) FF<=TXD_DONE_2;
assign TXD_DONE=(~FF)&TXD_DONE_2; //whether this is needed or not depends on your chosen communication module

uart SERIAL(
	.clk(CLK),
	.rx(serial_in),
	.tx(serial_out),
	.par_en(1'b0),
	.tx_req(TXD_ENABLE),
	.tx_end(TXD_DONE_2),
	.tx_data(TXD[7:0]),
	.rx_ready(RXD_START),
	.rx_data(RXD)
);

endmodule
