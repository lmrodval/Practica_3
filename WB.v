module RegisterFilePipelineWB
(
	input clk,
	input reset,
	input [2:0] DataInputWB_WB,
	
	output  [2:0] DataOutputWB_WB

	


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
	.MemtoReg(DataInputWB_WB[1:0]),
	.RegWrite(DataInputWB_WB[2]),
	.DataOutputWB(DataOutputWB_WB)
);




endmodule