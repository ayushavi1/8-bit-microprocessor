module cu(
  input wire[7:0] cu_in,
  // input wire zero, carry, 
  input wire cu_clk,
  output reg[2:0] mode,
  output reg[1:0] select,
  output reg[7:0] state,
  output reg[1:0] RAM_in,
  output reg MBR_we,IR_we,PC_inc,RF_we,Acc_we,MAR_we,RAM_we,ALU_mux,RF_mux,ALU_out_mux,MAR_mux,MBR_mux
);
  reg [7:0]next_state;
  
  parameter s0=0,s1=1,s2=2;

  always @(posedge cu_clk)
  begin
    state<=next_state;
  end

  always @(state)
  begin
    case(state)
		s0:
			begin
				MBR_we=0;
				IR_we=0;
				PC_inc=0;
				RF_we=0;
				Acc_we=0;
				MAR_we=1;
				RAM_we=0;
				ALU_mux=0;
				RF_mux=0;
				ALU_out_mux=0;
				MAR_mux=0;
				MBR_mux=0;
				RAM_in=2'b00;
				next_state=s1;
			end
		s1:
			begin
				MBR_we=1;
				PC_inc=1;
				MAR_we=0;
				nextstate = s2;
			end
		s2:
			begin
				MBR_we=0;
				IR_we=1;
				PC_inc=0;
				nextstate=s3;
			end
		s3: //the decoding state
			begin
			end
    endcase
  end
endmodule