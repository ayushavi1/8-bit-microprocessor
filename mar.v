module MAR(
    input[7:0] MAR_in,
	output reg [7:0] MAR_out,
	input MAR_we,
	input MAR_clk
);
	 
	wire[7:0] MAR_next;
	always @(posedge MAR_clk)
	begin
		MAR_out <= MAR_next;
    end
	assign MAR_next = MAR_we ? MAR_in : MAR_out;
endmodule