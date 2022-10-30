module MAR(
    input[15:0] MAR_in,
	output reg [15:0] MAR_out,
	input MAR_we,
	input MAR_clk,
);
	 
	reg[15:0] MAR_out;
	wire[15:0] MAR_next;
	always @(posedge MAR_clk)
	begin
		MAR_out <= MAR_next;
    end
	assign MAR_next = MAR_we ? MAR_in : MAR_out;
endmodule