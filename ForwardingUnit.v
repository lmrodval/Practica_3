module ForwardingUnit

(
	//input clk,
	//input reset,

	
	//Control
	
	input [2:0] WB_EXMEM,
	input [2:0] WB_MEMWB,


	////Datos
	input [4:0]EXMEM_RegisterRd,
	input [4:0]MEMWB_RegisterRd,
	input [4:0]IDEX_Rs,
	input [4:0]IDEX_Rt,
	
	//Salida
	
	//Datos
	
	//Control
	output reg [1:0]ForwardA,
	output reg [1:0]ForwardB
);

//Control for mux FA	
always @ (WB_EXMEM, WB_MEMWB)
	begin 
		if (WB_EXMEM[2] == 1'b1 && EXMEM_RegisterRd != 0 && EXMEM_RegisterRd == IDEX_Rs)
			begin
			ForwardA = 2'b00;
			end
		else if (WB_MEMWB[2] == 1'b1 && MEMWB_RegisterRd != 0 && EXMEM_RegisterRd != IDEX_Rs && MEMWB_RegisterRd == IDEX_Rs)
			begin
			ForwardA = 2'b01;	
			end
			else
			begin
			ForwardA = 2'b10;
			end
	end

//Control for mux FB	
always @ (WB_EXMEM, WB_MEMWB)
	begin 
		if (WB_EXMEM[2] == 1'b1 && (EXMEM_RegisterRd != 0) && EXMEM_RegisterRd == IDEX_Rt)
			begin
			ForwardB = 2'b00;
			end
		else if (WB_MEMWB[2] == 1'b1 && MEMWB_RegisterRd != 0 && EXMEM_RegisterRd != IDEX_Rt && MEMWB_RegisterRd == IDEX_Rt)
			begin
			ForwardB = 2'b01;	
			end
			else
			begin
			ForwardB = 2'b10;
			end
	end
endmodule