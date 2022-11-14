module MBR(
    input[7:0] MBR_in,
	output[7:0] MBR_out,
	input MBR_rw, MBR_clk);
	 
	reg[7:0] MBR_out = 8'h02;
	wire[7:0] MBR_next;
	 
	always @(posedge MBR_clk)
	begin
		MBR_out <= MBR_next;
	end
		
	assign MBR_next = MBR_rw ? MBR_in : MBR_out;

endmodule