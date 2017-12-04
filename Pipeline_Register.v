module Pipeline_Register
#(
	parameter N=1
)
(
	input clk,
	input reset,
	input enable,
	input  [N-1:0] DataInput,
	
	
	output reg [N-1:0] DataOutput
);

always@(negedge reset or negedge clk) begin
	if(reset==0)
		DataOutput <= 0;
	else	
		if(enable==1)
			DataOutput<=DataInput;
		else//(enable==0)
			DataOutput <= 31'b0;
			
end

endmodule