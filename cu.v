module cu(
  input wire[7:0] cu_in,
  // input wire zero, carry, 
  input wire cu_clk,
  output reg[2:0] mode,
  output reg[1:0] select,
  output reg[7:0] state

);
  reg[7:0] next_state;

  

endmodule