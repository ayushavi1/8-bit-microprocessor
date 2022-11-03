module memory(
    input [7:0] din,
    input [7:0] addr,
    input clk, we, 
    output [7:0] dout
);
    reg [7:0] mem_reg[255:0];

    initial
    begin
        // Assembly Code
    end

    always @(posedge clk)
	begin
		if (we)
			memory[addr] <= din;
	end
	
	assign dout = memory[addr];
endmodule