module PC(
	input PC_clk,
	input PC_inc,
    output[7:0] PC_out
);
	
	
	wire[7:0] PC_next;
	reg[7:0] PC_out = 8'b00000000;
	
	always @(posedge PC_clk)
	begin
		PC_out <= PC_next;
	end
	
	assign PC_next = PC_inc ? PC_out + 1 : PC_out;
	
endmodule