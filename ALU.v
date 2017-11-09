/******************************************************************
* Description
*	This is an 32-bit arithetic logic unit that can execute the next set of operations:
*		add
*		sub
*		or
*		and
*		nor
* This ALU is written by using behavioral description.
* Version:
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	01/03/2014
******************************************************************/
/*
 add, Luis R
 addi,Luis I
 sub, Luis 		R
 or, 	Luis	R
 ori, Luis
 and, Luis
 andi,Luis
 lui, Luis
 sll, Luis
 srl, Luis
 nor, Luis
 lw, 
 sw,
 beq, hacer
 bne, hacer
 j,
 jal, 
 jr
 
 
*/

module ALU 
(
	input [3:0] ALUOperation,
	input [31:0] A,
	input [31:0] B,
	output reg Zero,
	
	input [4:0] Shamt,
	
	output reg [31:0]ALUResult
);
localparam AND = 4'b0000;
localparam OR  = 4'b0001;
localparam NOR = 4'b0010;
localparam ADD = 4'b0011;
localparam SUB = 4'b0100;
localparam SLL = 4'b0101;
localparam SRL = 4'b0110;
localparam LUI = 4'b0111;
localparam BNE = 4'b0100;
localparam BEQ = 4'b0100;

localparam LW	= 4'b0011;
localparam SW	= 4'b0011;


   
   always @ (A or B or ALUOperation)
     begin
		case (ALUOperation)
		  ADD: // add
			ALUResult=A + B;
		  SUB: // sub
			ALUResult=A - B;
		  AND: // and
			ALUResult= A & B; 
		  OR: // or
			ALUResult= A | B;
		  NOR: // or
			ALUResult= ~(A|B);
		  SLL:	//shift left logical
			ALUResult= B<<Shamt;
		  SRL:	//shift right logical
			ALUResult= B>>Shamt;
			LUI:
			ALUResult={B[15:0], 16'b0};
		default:
			ALUResult= 0;
		endcase // case(control)
		Zero = (ALUResult==0) ? 1'b1 : 1'b0;
     end // always @ (A or B or control)
endmodule // ALU