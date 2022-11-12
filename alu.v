// Code for ALU
module ALU(
  input wire[7:0] in1, 
  input wire[7:0] in2, 
  input wire[2:0] Mode,
  
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
      flag_zero <= 0;
      flag_carry <= 0;
    end
  
  // Modes for ALU
  always @(in1 or in2 or Mode)
	 begin
      case(Mode)
        3'b000 : {flag_carry, out} <= in1 + in2;		//sum
        3'b001 : {flag_carry, out} <= in2 - in1;		//diff
        3'b010 : // comp
         begin
           flag_zero <= (in1==in2);
           flag_carry <= (in1<in2);
         end
        3'b011 : out <= in1 & in2;	// and
        3'b100 : out <= in1 | in2;	// or
        3'b101 : out <= in1 ^ in2;	// xor
		  endcase
  		
      flag_zero <= (out == 0);	// to handle zero flag
    end

endmodule