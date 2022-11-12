// Code your design here
module Register(
  input wire[1:0] Select,
  input Reg_clk,
  input RF_we,
  input Acc_we,
  input wire[7:0] Data_in,
  input wire[7:0] Acc_in,
  output reg[7:0] Data_out,
  output reg[7:0] Acc_out,
  output[7:0] A_out,B_out,C_out,D_out
);
  reg[7:0] A, B, C, D, Acc;
  
  initial 
		begin
			A <= 8'h00;
			B <= 8'h00;
			C <= 8'h00;
			D <= 8'h00;
			Acc <= 8'h00;
		end
  
  always@(posedge Reg_clk)
    begin
      case(Select)
        2'b00: A <= (RF_we ? Data_in: A); 
        2'b01: B <= (RF_we ? Data_in: B);
     	  2'b10: C <= (RF_we ? Data_in: C);
        2'b11: D <= (RF_we ? Data_in: D);
      endcase
      Acc <= Acc_we ? Acc_in : Acc;
    end
    always @(Select or Acc or A or B or C or D)
		begin
			case(Select)  
				2'b00: Data_out <= A;
				2'b01: Data_out <= B;
				2'b10: Data_out <= C;
				2'b11: Data_out <= D;
			endcase
			Acc_out <= Acc;
		end
		
		assign A_out=A;
		assign B_out=B;
		assign C_out=C;
		assign D_out=D;
	  
		
endmodule