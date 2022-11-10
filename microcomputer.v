module microcomputer;

	wire[7:0] RAM_out;
	wire[7:0] RAM_data;
	wire[7:0] RAM_addr;	 
	wire RAM_we;
	wire[7:0] state;	
	wire [7:0] A,B,C,D,Acc;
	
	reg clock=1'b0;
	
	always
		begin
			#1 clock<=~clock;
		end
		
	initial 
		begin
			#8500 $stop;
		end
	
	memory mem(.din(RAM_data),.addr(RAM_addr),.clk(clock),.we(RAM_we),.dout(RAM_out));
	microprocessor mp(.ram_out(RAM_out),.clk(clock),.ram_data(RAM_data),.ram_addr(RAM_addr), .ram_we(RAM_we), .test_state(state), .test_A(A), .test_B(B), .test_C(C), .test_D(D), .test_Acc(Acc));
	
	initial
		$monitor(,$time,"state=%b,A=%b,B=%b,A=%b,B=%b,Acc=%b",state,A,B,C,D,Acc);
	
endmodule