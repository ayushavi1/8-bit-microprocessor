module ALU(
  input wire[7:0] In1, 
  input wire[7:0] In2, 
  input wire[2:0] Mode,
  
  output reg[7:0] Out,
  output reg Flag_Zero,
  output reg Flag_Carry
);
  
  /*
  MANAGE SIGN EXTENDED VALUES
  0 - 000000_00
  1 - 000000_01
  2 - 111111_10
  3 - 111111_11
  */

  // initializing both flags
  initial
    begin
      Flag_Zero = 1'b0;
      Flag_Carry= 1'b0;
    end
  
  // Modes for ALU
	always @(In1 or In2 or Mode)
		begin
			case(Mode)
				3'b000 : {Flag_Carry, Out} = In1 + In2;		//sum
				3'b001 : {Flag_Carry, Out} = In2 - In1;		//diff
				3'b010 : // comp
						begin
							Flag_Zero = (In1==In2)?1'b1:1'b0;
							Flag_Carry = (In1>In2)?1'b1:1'b0;
							Out = In2;
						end
				3'b011 : Out = In1 & In2;	// and
				3'b100 : Out = In1 | In2;	// or
				3'b101 : Out = In1 ^ In2;	// xor
			endcase
			
			if(Mode!=3'b010 && Mode!=3'b111)
				begin
					Flag_Zero = (Out == 8'b00000000)?1'b1:1'b0;	// to handle zero flag
				end
    end

endmodule