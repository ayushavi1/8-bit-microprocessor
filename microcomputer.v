`include "memory.v"

module microcomputer;

	wire[7:0] RAM_out;
	wire[7:0] RAM_data;
	wire[7:0] RAM_addr;	 
	wire RAM_we;
	wire[7:0] state;	
	wire[7:0] A,B,C,D,Acc;
	wire[7:0] PC_out,IR_out;
	wire zero, carry;
	
	reg clock=1'b0;
	
	always
		begin
			#1 clock<=~clock;
		end
	
	memory mem(.din(RAM_data),.addr(RAM_addr),.clk(clock),.we(RAM_we),.dout(RAM_out));
	microprocessor mp(.ram_out(RAM_out),.clk(clock),.ram_data(RAM_data),.ram_addr(RAM_addr), .ram_we(RAM_we), .test_state(state), .test_A(A), .test_B(B), .test_C(C), .test_D(D), .test_Acc(Acc), .pc_out(PC_out), .ir_out(IR_out), .zero(zero), .carry(carry));
	
	initial
		$monitor($time,"	state=s:%d,A=%b,B=%b,C=%b,D=%b,Acc=%b,PC=%b,IR=%b,Zero=%b,Carry=%b",state,A,B,C,D,Acc,PC_out,IR_out,zero,carry);
		
	initial #8500 $finish;
	
endmodule