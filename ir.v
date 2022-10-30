module IR(
    input[7:0] IR_in,
	output[7:0] IR_out,
	input IR_we,IR_clk);

	reg[7:0] IR_out = 8'h00;
	 
	always @(posedge IR_clk)
	begin
    	IR_out <= IR_we ? IR_in : IR_out;
	end
endmodule