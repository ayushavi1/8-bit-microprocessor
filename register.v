// Code your design here
module Register(
  input wire[1:0] select,
  input Reg_clk,
  input RF_we,
	input Acc_we,
  input wire[7:0] data_in,
  input wire[7:0] Acc_in,
  output reg[7:0] data_out,
  output reg[7:0] Acc_out
);
  reg[7:0] A, B, C, D;
  
  always@(posedge Reg_clk)
    begin
      case(select)
        2'b00: A <= (RF_we ? data_in: A); 
        2'b01: B <= (RF_we ? data_in: B);
     	  2'b10: C <= (RF_we ? data_in: C);
        2'b11: D <= (RF_we ? data_in: D);
      endcase
      Acc <= Acc_we ? Acc_in : Acc;
    end
    always @(select or Acc or A or B or C or D)
      begin
        case(select)  
       	 	2'b00: data_out <= A;
          2'b01: data_out <= B;
       	  2'b10: data_out <= C;
          2'b11: data_out <= D;
        endcase
        Acc_out <= Acc;
      end
endmodule