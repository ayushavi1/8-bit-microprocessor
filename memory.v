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

        // Move Register Values
        // mem_reg[8'h00]<=8'b0010_00_01;
        // mem_reg[8'h01]<=8'b0011_10_00;
        // mem_reg[8'h02]<=8'b0011_00_00;

        // Add 2 Numbers
		// mem_reg[8'h00]<=8'b0010_00_01;
		// mem_reg[8'h01]<=8'b0010_01_01;
		// mem_reg[8'h02]<=8'b0100_00_01;
		// mem_reg[8'h03]<=8'b0011_00_00;

        // Add with immediate
        // mem_reg[8'h00]<=8'b0010_00_01;
        // mem_reg[8'h01]<=8'b1100_00_01;
        // mem_reg[8'h02]<=8'b0011_00_00;

        // Subtract 2 Numbers
        // mem_reg[8'h00]<=8'b0010_00_01;
        // mem_reg[8'h01]<=8'b0010_01_11;
        // mem_reg[8'h02]<=8'b0101_00_01;
        // mem_reg[8'h03]<=8'b0011_00_00;
        
        // Subtract with immediate
        // mem_reg[8'h00]<=8'b0010_00_01;
        // mem_reg[8'h01]<=8'b1101_00_01;
        // mem_reg[8'h02]<=8'b0011_00_00;

        // Load a value in A
        // mem_reg[8'h00]<=8'b0000_1011;
        // mem_reg[8'h01]<=8'b0011_00_00;
        // mem_reg[8'hFB]<=8'b10101010;

        // Store a value from A to memory address
        // mem_reg[8'h00]<=8'b0010_00_01;
        // mem_reg[8'h01]<=8'b0001_1011;
        // mem_reg[8'h02]<=8'b0010_00_00;
        // mem_reg[8'h03]<=8'b0000_1011;
        // mem_reg[8'h04]<=8'b0011_00_00;

        // Compare 2 numbers
        // mem_reg[8'h00]<=8'b0010_00_00;
		// mem_reg[8'h01]<=8'b0010_01_01;
		// mem_reg[8'h02]<=8'b0111_00_01;
		// mem_reg[8'h03]<=8'b0011_00_00;
		
		// Compare 2 numbers with immediate
        // mem_reg[8'h00]<=8'b0010_00_00;
		// mem_reg[8'h01]<=8'b1111_00_01;
		// mem_reg[8'h02]<=8'b0011_00_00;
		
		// And 2 Numbers
		mem_reg[8'h00]<=8'b0010_00_10;
		mem_reg[8'h01]<=8'b0010_01_11;
		mem_reg[8'h02]<=8'b0110_00_01;
		mem_reg[8'h03]<=8'b0011_00_00;
		
		

    end

    always @(posedge clk)
	begin
		if (we)
			mem_reg[addr] <= din;
	end
	
	assign dout = mem_reg[addr];
endmodule