module CU(
  input wire[7:0] CU_in,
  input wire CU_clk,
  output reg[2:0] Mode,
  output reg[1:0] Select,
  output[7:0] State,
  output reg MBR_rw,IR_rw,PC_inc,Reg_rw,Buff_rw,MAR_rw,RAM_rw,ALU_in_select,Reg_in_select, ALU_out_select, MAR_select, MBR_select, Data_imm,Buff_imm
);

  parameter s0=0, s1=1, s2=2, s3=3, s4=4, s5=5, s6=6, s7=7, s8=8, s9=9, s10=10, s11=11, s12=12, s13=13, s14=14, s15=15, s16=16;
  reg[7:0] Next_State;
  reg[7:0] State = s0;
 

  always @(posedge CU_clk)
  begin
    State <= Next_State;
  end

  always @(State)
  begin
    case(State)
		s0:
			begin
				MBR_rw=0;
				IR_rw=0;
				PC_inc=0;
				Reg_rw=0;
				Buff_rw=0;
				MAR_rw=1;
				RAM_rw=0;
				ALU_in_select=0;
				Reg_in_select=0;
				ALU_out_select=0;
				MAR_select=0;
				MBR_select=0;
				Data_imm = 0;
				Buff_imm=0;
				Mode=3'b111;
				Next_State=s1;
			end
		s1:
			begin
				MBR_rw=1;
				PC_inc=1;
				MAR_rw=0;
				Next_State = s2;
			end
		s2:
			begin
				MBR_rw = 0;
				IR_rw = 1;
				PC_inc = 0;
				Next_State = s3;
			end
		s3: //the decoding State
			begin
				IR_rw = 0;
				case(CU_in[7:4])
					4'b0000: // LD
						begin
							Next_State = s4;
						end
					4'b0001: // ST
						begin
							Next_State = s4;
						end
					4'b0011: // MR
						begin
							Next_State = (CU_in[1:0]==2'b00 && CU_in[3:2]==2'b00)?s9:s5;
						end
					4'b0010: // MI
						begin
							Next_State = s6;
						end
					4'b0100: // SUM
						begin
							Next_State = s7;
						end
					4'b1100: // SMI
						begin
							Next_State = s8;
						end
					4'b0101: // SB
						begin
							Next_State = s7;
						end
					4'b1101: // SBI
						begin
							Next_State = s8;
						end
					4'b0111: // CM
						begin
							Next_State = s7;
						end
					4'b1111: // CMI
						begin
							Next_State = s8;
						end
					4'b0110: // ANR
						begin
							Next_State = s7;
						end
					4'b1110: // ANI
						begin
							Next_State = s8;
						end
					4'b1000: // ORR
						begin
							Next_State = s7;
						end
					4'b1001: // ORI
						begin
							Next_State = s8;
						end
					4'b1010: // XRR
						begin
							Next_State = s7;
						end
					4'b1011: // XRI
						begin
							Next_State = s8;
						end
					default: // Fetch next instruction
						begin
							Next_State = s0;
						end
				endcase
			end
		s4:
			begin
				MAR_rw = 1;
				MAR_select = 1;
				Next_State = (CU_in[7:4]==4'b0000)?s13:s15;
			end
		
		s5: // MR
			begin
				Buff_rw = 1;
				ALU_out_select = 1;
				Select = CU_in[1:0];
				Next_State = s10;
			end
		s6: // MI
			begin
				Data_imm = 1;
				Reg_rw = 1;
				Select = CU_in[3:2];
				Next_State = s0;
			end
		s7: // SUM
			begin
				Buff_rw = 1;
				ALU_out_select = 1;
				Select = CU_in[1:0];
				Next_State = s11;
			end
		s8: // SMI
			begin
				Buff_imm = 1;
				Buff_rw = 1;
				Next_State = s11;
			end
		s9:// HALT
				Next_State=s9;
		s10: // From s5 (MR)
			begin
				Reg_rw = 1;
				Buff_rw = 0;
				Reg_in_select= 1;
				ALU_out_select = 0;
				Select = CU_in[3:2];
				Next_State = s0;
			end
		s11: // From s7 (SUM)
			begin
				Buff_imm=0;
				Buff_rw = 1;
				ALU_in_select = 1;
				ALU_out_select = 0;
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
				Next_State = s12;
			end
		s12: // From S21 (SUM)
			begin
				Buff_rw = 0;
				ALU_in_select = 0;
				Reg_rw = 1;
				Reg_in_select = 1;
				Select = CU_in[3:2];
				Mode = 3'b111;
				Next_State = s0;
			end
		s13: // From S4 (LD)
			begin
				MAR_select = 0;
				MAR_rw = 0;
				MBR_rw = 1;
				Next_State = s14;
			end
		s14: // From S23 (LD)
			begin
				Reg_rw = 1;
				MBR_rw = 0;
				Select = 2'b00;
				Next_State = s0;
			end
		s15: //From s4 (ST)
			begin
				MAR_select = 0;
				MAR_rw = 0;
				Select=2'b00;
				MBR_select=1;
				MBR_rw=1;
				Next_State=s16;
			end
		s16: //From s15 (ST)
		begin
			MBR_select=0;
			MBR_rw=0;
			RAM_rw=1;
			Next_State=s0;
		end
		
    endcase
  end
endmodule