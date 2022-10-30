module cu(
  input wire[7:0] cu_in,
  // input wire zero, carry, 
  input wire cu_clk,
  output reg[2:0] mode,
  output reg[1:0] select,
  output reg[7:0] state,
  output reg MBR_we,IR_we,PC_inc,RF_we,Acc_we,MAR_we,RAM_we,ALU_mux,RF_mux,ALU_out_mux,MAR_mux,MBR_mux
);
  reg [7:0]next_state;
  
  parameter s0=0,s1=1;

  always @(posedge cu_clk)
  begin
    state<=next_state;
  end

  always @(state)
  begin
    case(state)
      s0:
        begin
          
        end
      s1:
        begin
        end
    endcase
  end
endmodule