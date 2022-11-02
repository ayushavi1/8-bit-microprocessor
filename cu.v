module cu(
  input wire[7:0] cu_in,
  // input wire zero, carry, 
  input wire cu_clk,
  output reg[2:0] mode,
  output reg[1:0] select,
  output reg[7:0] state,
  output reg[1:0] RAM_in,
  output reg MBR_we,IR_we,PC_inc,RF_we,Acc_we,MAR_we,RAM_we,ALU_mux,RF_mux, ALU_out_mux, MAR_mux, MBR_mux, data_imm,Acc_imm, 
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
				MAR_mux=0;
				MBR_mux=0;
				data_imm = 0;
				Acc_imm=0;
				RAM_in=2'b00;
				mode=3'b111;
				next_state=s1;
			end
		s1:
			begin
				MBR_we=1;
				PC_inc=1;
				MAR_we=0;
				next_state = s2;
			end
		s2:
			begin
				MBR_we = 0;
				IR_we = 1;
				PC_inc = 0;
				next_state = s3;
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
							next_state = s8;
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
		s4:
			begin
				MAR_we = 1;
				MAR_mux = 1;
				next_state = s23;
			end
		s5:
			begin
				MAR_we = 1;
				MAR_mux = 1;
				next_state = s24;
			end
		s6: // MR
			begin
				Acc_we = 1;
				ALU_out_mux = 1;
				Select = CU_in[1:0];
				next_state = s20;
			end
		s7: // MI
			begin
				data_imm = 1;
				RF_we = 1;
				Select = CU_in[3:2];
				next_state = s0;
			end
		s8: // SUM
			begin
				Acc_we = 1;
				ALU_out_mux = 1;
				Select = CU_in[1:0];
				next_state = s21;
			end
		s9: // SMI
			begin
				Acc_imm = 1;
				Acc_we = 1;
				next_state = s21;
			end
		s20: // From S6 (MR)
			begin
				RF_we = 1;
				Acc_we = 0;
				RF_mux= 1;
				ALU_out_mux = 0;
				Select = CU_in[3:2];
				next_state = s0;
			end
		s21: // From S8 (SUM)
			begin
				Acc_imm=0;
				Acc_we = 1;
				ALU_mux = 1;
				ALU_out_mux = 0;
				Select = CU_in[3:2];
				case(CU_in[7:4])
					4'b0100: // SUM
						mode = 3'b000;
					4'b1100: // SMI
						mode = 3'b000;
					4'b0101: // SB
						mode = 3'b001;	
					4'b1101: // SBI
						mode = 3'b001;
					4'b0111: // CM
						mode = 3'b010;
					4'b1111: // CMI
						mode = 3'b010;
					4'b0110: // ANR
						mode = 3'b011;
					4'b1110: // ANI
						mode = 3'b011;
					4'b1000: // ORR
						mode = 3'b100;
					4'b1001: // ORI
						mode = 3'b100;
					4'b1010: // XRR
						mode = 3'b101;
					4'b1011: // XRI
						mode = 3'b101;
				endcase
				next_state = s22;
			end
		s22: // From S21 (SUM)
			begin
				Acc_we = 0;
				ALU_mux = 0;
				RF_we = 1;
				RF_mux = 1;
				Select = CU_in[3:2];
				mode = 3'b111;
				next_state = s0;
			end
		s23: // From S4 (LD)
			begin
				MAR_mux = 0;
				MAR_we = 0;
				MBR_we = 1;
				next_state = s24;
			end
		s24: // From S23 (LD)
			begin
				RF_we = 1;
				MBR_we = 0;
				select = 2'b00;
				next_state = s0;
			end
    endcase
  end
endmodule