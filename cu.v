module CU(
  input wire[7:0] CU_in,
  // input wire zero, carry, 
  input wire CU_clk,
  output reg[2:0] Mode,
  output reg[1:0] Select,
  output[7:0] State,
  output reg MBR_we,IR_we,PC_inc,RF_we,Acc_we,MAR_we,RAM_we,ALU_mux,RF_mux, ALU_out_mux, MAR_mux, MBR_mux, Data_imm,Acc_imm
);

  parameter s0=0,s1=1,s2=2,s3=3,s4=4,s5=5,s6=6,s7=7,s8=8,s9=9,s10=10,s11=11,s12=12,s13=13,s14=14,s15=15,s16=16,s17=17;
  reg[7:0] next_State;
  reg[7:0] State=s0;
 

  always @(posedge CU_clk)
  begin
    State <= next_State;
  end

  always @(State)
  begin
    case(State)
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
				Data_imm = 0;
				Acc_imm=0;
				Mode=3'b111;
				next_State=s1;
			end
		s1:
			begin
				MBR_we=1;
				PC_inc=1;
				MAR_we=0;
				next_State = s2;
			end
		s2:
			begin
				MBR_we = 0;
				IR_we = 1;
				PC_inc = 0;
				next_State = s3;
			end
		s3: //the decoding State
			begin
				IR_we = 0;
				case(CU_in[7:4])
					4'b0000: // LD
						begin
							next_State = s4;
						end
					4'b0001: // ST
						begin
							next_State = s4;
						end
					4'b0011: // MR
						begin
							next_State = (CU_in[1:0]==2'b00 && CU_in[3:2]==2'b00)?s10:s6;
						end
					4'b0010: // MI
						begin
							next_State = s7;
						end
					4'b0100: // SUM
						begin
							next_State = s8;
						end
					4'b1100: // SMI
						begin
							next_State = s9;
						end
					4'b0101: // SB
						begin
							next_State = s8;
						end
					4'b1101: // SBI
						begin
							next_State = s9;
						end
					4'b0111: // CM
						begin
							next_State = s8;
						end
					4'b1111: // CMI
						begin
							next_State = s9;
						end
					4'b0110: // ANR
						begin
							next_State = s8;
						end
					4'b1110: // ANI
						begin
							next_State = s9;
						end
					4'b1000: // ORR
						begin
							next_State = s8;
						end
					4'b1001: // ORI
						begin
							next_State = s9;
						end
					4'b1010: // XRR
						begin
							next_State = s8;
						end
					4'b1011: // XRI
						begin
							next_State = s9;
						end
					default: // Fetch next instruction
						begin
							next_State = s0;
						end
				endcase
			end
		s4:
			begin
				MAR_we = 1;
				MAR_mux = 1;
				next_State = (CU_in[7:4]==4'b0000)?s14:s16;
			end
		
		s6: // MR
			begin
				Acc_we = 1;
				ALU_out_mux = 1;
				Select = CU_in[1:0];
				next_State = s11;
			end
		s7: // MI
			begin
				Data_imm = 1;
				RF_we = 1;
				Select = CU_in[3:2];
				next_State = s0;
			end
		s8: // SUM
			begin
				Acc_we = 1;
				ALU_out_mux = 1;
				Select = CU_in[1:0];
				next_State = s12;
			end
		s9: // SMI
			begin
				Acc_imm = 1;
				Acc_we = 1;
				next_State = s12;
			end
		s10:// HALT
				next_State=s10;
		s11: // From S6 (MR)
			begin
				RF_we = 1;
				Acc_we = 0;
				RF_mux= 1;
				ALU_out_mux = 0;
				Select = CU_in[3:2];
				next_State = s0;
			end
		s12: // From S8 (SUM)
			begin
				Acc_imm=0;
				Acc_we = 1;
				ALU_mux = 1;
				ALU_out_mux = 0;
				Select = CU_in[3:2];
				case(CU_in[7:4])
					4'b0100: // SUM
						Mode = 3'b000;
					4'b1100: // SMI
						Mode = 3'b000;
					4'b0101: // SB
						Mode = 3'b001;	
					4'b1101: // SBI
						Mode = 3'b001;
					4'b0111: // CM
						Mode = 3'b010;
					4'b1111: // CMI
						Mode = 3'b010;
					4'b0110: // ANR
						Mode = 3'b011;
					4'b1110: // ANI
						Mode = 3'b011;
					4'b1000: // ORR
						Mode = 3'b100;
					4'b1001: // ORI
						Mode = 3'b100;
					4'b1010: // XRR
						Mode = 3'b101;
					4'b1011: // XRI
						Mode = 3'b101;
				endcase
				next_State = s13;
			end
		s13: // From S21 (SUM)
			begin
				Acc_we = 0;
				ALU_mux = 0;
				RF_we = 1;
				RF_mux = 1;
				Select = CU_in[3:2];
				Mode = 3'b111;
				next_State = s0;
			end
		s14: // From S4 (LD)
			begin
				MAR_mux = 0;
				MAR_we = 0;
				MBR_we = 1;
				next_State = s15;
			end
		s15: // From S23 (LD)
			begin
				RF_we = 1;
				MBR_we = 0;
				Select = 2'b00;
				next_State = s0;
			end
		s16: //From s4 (ST)
			begin
				MAR_mux = 0;
				MAR_we = 0;
				Select=2'b00;
				MBR_mux=1;
				MBR_we=1;
				next_State=s17;
			end
		s17: //From s16 (ST)
		begin
			MBR_mux=0;
			MBR_we=0;
			RAM_we=1;
			next_State=s0;
		end
		
    endcase
  end
endmodule