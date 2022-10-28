// Code for ALU
module alu(
  input wire[7:0] in1, 
  input wire[7:0] in2, 
  input wire[3:0] mode,
  input wire clk,
  
  output reg[7:0] out,
  output reg flag_zero,
  output reg flag_carry
);
  
  /*
  MANAGE SIGN EXTENDED VALUES
  0 - 000000_00
  1 - 000000_01
  2 - 111111_10
  3 - 111111_11
  */
  
  
  // initializing both carries
  initial
    begin
      flag_zero = 0;
      flag_carry = 0;
    end
  
  // modes for ALU
  always @(in1 or in2 or mode)
	 begin
       case(mode)
        3'bxxx : {flag_carry, out} = in1 + in2;		//sum
        3'bxxx : {flag_carry, out} = in1 - in2;		//diff
        3'bxxx : // comp
         begin
           flag_zero = (in1==in2);
           flag_carry = (in1<in2);
         end
		3'bxxx : out = in1 & in2;	// and
		3'bxxx : out = in1 | in2;	// or
		3'bxxx : out = in1 ^ in2;	// xor
		endcase
  		
       flag_zero = (out == 0);	// to handle zero flag
    end

endmodule