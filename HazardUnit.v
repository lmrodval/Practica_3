module HazardUnit

(

	input [2:0] MEM_IDEX,
	


	////Datos
	input [4:0]IFID_RT,
	input [4:0]IFID_RS,
	input [4:0]IDEX_Rt,
	
	//Salida
	
	//Datos
	
	//Control
	output reg MUX_HazardMegaMux,
	output reg IFID_Write,
	output reg PCWrite 
);

always @ (MEM_IDEX)
	begin 
		if (MEM_IDEX[2]== 1'b1 && IDEX_Rt == IFID_RS  || IDEX_Rt == IFID_RT )
			begin
				MUX_HazardMegaMux = 1'b0; 
				IFID_Write = 1'b0; 
				PCWrite = 1'b1; 
			end
			else
			begin
				MUX_HazardMegaMux = 1'b1;
				IFID_Write = 1'b1;
				PCWrite = 1'b0;
			end
	end

endmodule
