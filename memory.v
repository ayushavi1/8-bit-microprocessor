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
		mem_reg[8'h00]<=8'b0010_00_01;
		mem_reg[8'h01]<=8'b0010_01_01;
		mem_reg[8'h02]<=8'b0100_00_01;
		mem_reg[8'h04]<=8'b0011_00_00;
    end

    always @(posedge clk)
	begin
		if (we)
			mem_reg[addr] <= din;
	end
	
	assign dout = mem_reg[addr];
endmodule