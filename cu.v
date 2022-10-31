module cu(
  input wire[7:0] cu_in,
  // input wire zero, carry, 
  input wire cu_clk,
  output reg[2:0] mode,
  output reg[1:0] select,
  output reg[7:0] state,
  output reg[1:0] RAM_in,
  output reg MBR_we,IR_we,PC_inc,RF_we,Acc_we,MAR_we,RAM_we,ALU_mux,RF_mux, ALU_out_mux, MBR_mux
);
  reg [7:0]next_state;
  
  parameter s0=0,s1=1,s2=2;

  always @(posedge cu_clk)
  begin
    state <= next_state;
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
				MBR_we = 0;
				IR_we = 1;
				PC_inc = 0;
				nextstate = s3;
			end
		s3: //the decoding state
			begin
				IR_we = 0;
				case(cu_in[7:4])
					4'b0000: // LD
						begin
							next_state = s4;
						end
					4'b0001: // ST
						begin
							next_state = s5;
						end
					4'b0011: // MR
						begin
							next_state = s6;
						end
					4'b0010: // MI
						begin
							next_state = s7;
						end
					4'b0100: // SUM
						begin
							next_state = s8;
						end
					4'b1100: // SMI
						begin
							next_state = s9;
						end
					4'b0101: // SB
						begin
							next_state = s10;
						end
					4'b1101: // SBI
						begin
							next_state = s11;
						end
					4'b0111: // CM
						begin
							next_state = s12;
						end
					4'b1111: // CMI
						begin
							next_state = s13;
						end
					4'b0110: // ANR
						begin
							next_state = s14;
						end
					4'b1110: // ANI
						begin
							next_state = s15;
						end
					4'b1000: // ORR
						begin
							next_state = s16;
						end
					4'b1001: // ORI
						begin
							next_state = s17;
						end
					4'b1010: // XRR
						begin
							next_state = s18;
						end
					4'b1011: // XRI
						begin
							next_state = s19;
						end
					default: // Fetch next instruction
						begin
							next_state = s0;
						end
				endcase
			end
		s6: // MR
			begin
				Acc_we = 1;
				ALU_out_mux=1;
				Select = CU_in[1:0];
				nextstate = s20;
			end
		s20: 
			begin
				RF_we=1;
				Acc_we=0;
				RF_mux= 1;
				ALU_out_mux=0;
				Select = CU_in[3:2];
				nextstate = s0;
			end
				
    endcase
  end
endmodule