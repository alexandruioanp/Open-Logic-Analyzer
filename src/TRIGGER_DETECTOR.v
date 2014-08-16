`timescale 1ns / 1ps

module TRIGGER_DETECTOR(input CLK, input [15:0] DATA_IN, input [31:0] TRIG_DATA, input TRIG_UPDATE, input TRIG_FORCE, output reg RST=0, output reg TRIGGERED=0);

wire [15:0] MASK;
wire [15:0] TRIG_COND;
reg [31:0] CURRENT_TRIG_DATA=0;
reg TRIGGERED_D;

assign MASK=CURRENT_TRIG_DATA[15:0];
assign TRIG_COND=CURRENT_TRIG_DATA[31:16];

always@(posedge CLK) begin
	TRIGGERED_D<=TRIGGERED;
	if(TRIGGERED_D==0 && TRIGGERED) RST<=1;	//rising edge trigger
		else RST<=0;
	if((DATA_IN&MASK)==TRIG_COND || TRIG_FORCE) begin
		TRIGGERED<=1;
	end
	if(TRIG_UPDATE) begin	//only copies the new data when it is completely received
						 CURRENT_TRIG_DATA<=TRIG_DATA;
						 RST<=0;
						 TRIGGERED<=0;
						 end
end

endmodule
