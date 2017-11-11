module RegisterFilePipelineMEMWB
(
	input clk,
	input reset,
	input [2:0] DataInputWB_MEMWB,
	
	output  [2:0] DataOutputWB_MEMWB

	


);



/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/


PipelineWB
WB
(

	.clk(clk),
	.reset(reset),
	.enable(1),
	.MemtoReg(DataInputWB_MEMWB[1:0]),
	.RegWrite(DataInputWB_MEMWB[2]),
	.DataOutputWB(DataOutputWB_MEMWB)
);




endmodule