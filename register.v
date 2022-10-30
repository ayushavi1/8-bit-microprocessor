// Code your design here
module register(
  input wire[1:0] select,
  input reg_clk;
  input wire rd, wr,
  input wire[7:0] data_in,
  output reg[7:0] data_out
);
  reg[7:0] A, B, C, D;
  
  always@(posedge reg_clk)
    begin
      if(rd)
        begin
          case(select)
            begin
       	 	  2'b00: data_out <= A;
              2'b01: data_out <= B;
       	 	  2'b10: data_out <= C;
              2'b11: data_out <= D;
            end
        end

      if(wr)
        begin
          case(select)
            begin
       	 	  2'b00: A <= data_in;
              2'b01: B <= data_in;
       	 	  2'b10: C <= data_in;
              2'b11: D <= data_in;
            end
        end
    end
endmodule