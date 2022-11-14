// Code your design here
module Register(
  input wire[1:0] Select,
  input Reg_clk,
  input Reg_rw,
  input Buff_rw,
  input wire[7:0] Data_in,
  input wire[7:0] Buff_in,
  output reg[7:0] Data_out,
  output reg[7:0] Buff_out,
  output[7:0] A_out,B_out,C_out,D_out
);
  reg[7:0] A, B, C, D, Buff;
  
  initial 
		begin
			A <= 8'h00;
			B <= 8'h00;
			C <= 8'h00;
			D <= 8'h00;
			Buff <= 8'h00;
		end
  
  always@(posedge Reg_clk)
    begin
      case(Select)
        2'b00: A <= (Reg_rw ? Data_in: A); 
        2'b01: B <= (Reg_rw ? Data_in: B);
     	  2'b10: C <= (Reg_rw ? Data_in: C);
        2'b11: D <= (Reg_rw ? Data_in: D);
      endcase
      Buff <= Buff_rw ? Buff_in : Buff;
    end
    always @(Select or Buff or A or B or C or D)
		begin
			case(Select)  
				2'b00: Data_out <= A;
				2'b01: Data_out <= B;
				2'b10: Data_out <= C;
				2'b11: Data_out <= D;
			endcase
			Buff_out <= Buff;
		end
		
		assign A_out=A;
		assign B_out=B;
		assign C_out=C;
		assign D_out=D;
	  
		
endmodule