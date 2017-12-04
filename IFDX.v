module RegisterFilePipelineIFID
(
	input clk,
	input reset,
	input [31:0] PCValue_IFID,
	input [31:0] Instruction_IFID,
	input hazard_unit,
	////Datos
	
	output  [31:0] DataOutputPCValue_IFID,
	output  [31:0] DataOutputInstruction_IFID
);



Pipeline_Register
#(
	.N(32)
)
RegisterPCAdder
(
	.clk(clk),																						
	.reset(reset),
	.enable(hazard_unit),
	.DataInput(PCValue_IFID),
	.DataOutput(DataOutputPCValue_IFID)
);


Pipeline_Register
#(
	.N(32)
)
RegisterROMtoReg
(
	.clk(clk),																						
	.reset(reset),
	.enable(hazard_unit),
	.DataInput(Instruction_IFID),
	.DataOutput(DataOutputInstruction_IFID)
);

endmodule