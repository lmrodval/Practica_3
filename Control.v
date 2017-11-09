/******************************************************************
* Description
*	This is control unit for the MIPS processor. The control unit is 
*	in charge of generation of the control signals. Its only input 
*	corresponds to opcode from the instruction.
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	01/03/2014
******************************************************************/
module Control
(
	input [5:0]OP,
	
	
	output [1:0]RegDst,
	output BranchEQ,
	output BranchNE,
	output MemRead,
	output [1:0]MemtoReg,
	output MemWrite,
	output ALUSrc,
	output RegWrite,
	output Jump,
	output [3:0]ALUOp
);

localparam R_Type = 0;

localparam I_Type_ANDI = 6'hc;

localparam I_Type_ADDI = 6'h8;
localparam I_Type_ORI = 6'h0d;
localparam I_Type_LUI = 6'h0F;
localparam I_Type_BEQ = 6'h04;
localparam I_Type_BNE = 6'h05;

localparam I_Type_LW  = 6'h23;
localparam I_Type_SW  = 6'h2b;

localparam J_Type_JUMP= 6'h02;
localparam J_Type_JAL = 6'h03;




reg [14:0] ControlValues;


always@(OP) begin
	casex(OP)
		R_Type:       ControlValues=  15'b0_01_0_00_1_00_00_0111;
		
		I_Type_LW:	  ControlValues=  15'b0_00_1_01_1_10_00_0011;
		I_Type_SW:	  ControlValues=  15'b0_00_1_00_0_01_00_0011;		
		
		I_Type_ANDI:  ControlValues=  15'b0_00_1_00_1_00_00_1000;
		I_Type_ADDI:  ControlValues=  15'b0_00_1_00_1_00_00_0100;
		I_Type_ORI:   ControlValues=  15'b0_00_1_00_1_00_00_0101;
		I_Type_LUI:		ControlValues= 15'b0_00_1_00_1_00_00_0110;
		
		I_Type_BEQ:		ControlValues= 15'b0_00_0_00_0_00_01_0001;
		I_Type_BNE:		ControlValues= 15'b0_00_0_00_0_00_10_0010;
		
		J_Type_JUMP:   ControlValues= 15'b1_00_0_00_0_00_00_0000;
		J_Type_JAL:		ControlValues= 15'b1_10_0_10_1_00_00_0000;
		
		
		
		default:
			ControlValues= 15'b000000000000000;
		endcase
end	
	

assign Jump = ControlValues[14];
	
assign RegDst = ControlValues[13:12];	

assign ALUSrc = ControlValues[11];	
assign MemtoReg = ControlValues[10:9]; 
assign RegWrite = ControlValues[8];	

assign MemRead = ControlValues[7];
assign MemWrite = ControlValues[6];

assign BranchNE = ControlValues[5];
assign BranchEQ = ControlValues[4];

assign ALUOp = ControlValues[3:0];	







endmodule


