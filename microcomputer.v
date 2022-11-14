`include "memory.v"

module microcomputer;
	wire[7:0] RAM_out;
	wire[7:0] RAM_data;
	wire[7:0] RAM_addr;	 
	wire RAM_rw;
	wire[7:0] State;	
	wire[7:0] A,B,C,D,Buff;
	wire[7:0] PC_out,IR_out;
	wire Zero, Carry;
	
	reg clock=1'b0;
	
	always
		begin
			#1 clock<=~clock;
		end
	
	memory mem(.mem_in(RAM_data),.addr(RAM_addr),.clk(clock),.rw(RAM_rw),.mem_out(RAM_out));
	microprocessor mp(.ram_out(RAM_out),.clk(clock),.ram_data(RAM_data),.ram_addr(RAM_addr), .ram_rw(RAM_rw), .test_state(State), .test_A(A), .test_B(B), .test_C(C), .test_D(D), .test_Buff(Buff), .pc_out(PC_out), .ir_out(IR_out), .zero(Zero), .carry(Carry));
	
	initial
		$monitor($time,"	State=s:%d,A=%b,B=%b,C=%b,D=%b,Buff=%b,PC=%b,IR=%b,Zero=%b,Carry=%b",State,A,B,C,D,Buff,PC_out,IR_out,Zero,Carry);
		
	initial #8500 $finish;
	
endmodule