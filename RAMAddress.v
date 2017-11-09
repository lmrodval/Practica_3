module RAMAddress
(
	
	input [31:0] RAM,
	output reg [31:0] RAMAddress
	
);

localparam M1 = 32'h10010000;

always@(RAM) begin
		RAMAddress= (RAM-M1)>>2;
end

endmodule