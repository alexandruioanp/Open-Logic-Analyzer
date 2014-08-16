`timescale 1ns / 1ps

module AssembledLogicAnalyzer(input CLK, input RXD_START, input [7:0] RXD, input TXD_DONE, input [15:0] DATA_IN, output TXD_ENABLE, 
										output [15:0] TXD);

wire RST, WE;
wire [9:0] ADDR;
wire [15:0] RAM_DATA;
wire [15:0] DATA;
wire [9:0] READ_ADDR;
wire SEL;
wire [31:0] TRIG_DATA;
wire TRIG_FORCE, TRIG_UPDATE;

ADDR_SEQUENCER seq(
	.CLK(CLK),
	.RST(RST),
	.WE(WE),
	.ADDR(ADDR)
);

OUTPUT_MUX multiplexor(
	.SEL(SEL),
	.TRIGGERED(TRIGGERED),
	.RAM_DATA(RAM_DATA),
	.DATA(TXD)
);

RAM_2_PORTS RAM(
	.CLK(CLK),
	.WE(WE),
	.WRITE_ADDR(ADDR),
	.READ_ADDR(READ_ADDR),
	.DATA_IN(DATA_IN),
	.DATA_OUT(RAM_DATA)
);

TRIGGER_DETECTOR trig_det(
	.CLK(CLK),
	.DATA_IN(DATA_IN),
	.TRIG_DATA(TRIG_DATA),
	.TRIG_UPDATE(TRIG_UPDATE),
	.TRIG_FORCE(TRIG_FORCE),
	.RST(RST),
	.TRIGGERED(TRIGGERED)
);

INSTRUCTION_DECODER dec(
	.CLK(CLK),
	.RXD(RXD),
	.RXD_START(RXD_START),
	.TXD_DONE(TXD_DONE),
	.TXD_ENABLE(TXD_ENABLE),
	.MUX_SEL(SEL),
	.RAM_ADDR(READ_ADDR),
	.TRIG_DATA(TRIG_DATA),
	.TRIG_UPDATE(TRIG_UPDATE),
	.TRIG_FORCE(TRIG_FORCE)
);

endmodule
