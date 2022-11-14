`include "mbr.v"
`include "ir.v"
`include "alu.v"
`include "mar.v"
`include "pc.v"
`include "cu.v"
`include "register.v"

module microprocessor(
    input wire[7:0] ram_out,
	input wire clk,
	output[7:0] ram_data,
	output[7:0] ram_addr,	 
	output ram_rw,
	output[7:0] test_state,
	output[7:0] test_A,test_B,test_C,test_D,test_Buff,
	output[7:0] pc_out,ir_out,
	output zero, carry
);

    wire mbr_rw,ir_rw,pc_inc,reg_rw,buff_rw,mar_rw,alu_in_select,reg_in_select,alu_out_select,mar_select,mbr_select, data_imm, buff_imm; 
	// ram_rw is output
	wire[2:0] mode;
	wire[1:0] select;
	wire[1:0] ram_in;
	
	wire[7:0] ir_out; //IR
	wire[7:0] pc_out; //PC
	wire[7:0] data_in,buff_in,data_out,buff_out; //RF
	wire[7:0] y,z; //ALU
	wire[7:0] mar_in,mar_out; //MAR
	wire[7:0] mbr_in,mbr_out; //MBR
	wire zero, carry; //Condition Code Registers
	

	MBR mbr(.MBR_in(mbr_in), .MBR_out(mbr_out), .MBR_rw(mbr_rw), .MBR_clk(clk));

	IR ir(.IR_in(mbr_out), .IR_out(ir_out), .IR_rw(ir_rw), .IR_clk(clk));

	PC pc(.PC_out(pc_out), .PC_clk(clk), .PC_inc(pc_inc));
	
	Register register(.Select(select), .Reg_clk(clk), .Reg_rw(reg_rw), .Buff_rw(buff_rw), .Data_in(data_in), .Buff_in(buff_in), .Data_out(data_out), .Buff_out(buff_out), .A_out(test_A),.B_out(test_B),.C_out(test_C),.D_out(test_D));

	ALU alu(.In1(buff_out),.In2(y),.Mode(mode),.Out(z),.Flag_Zero(zero), .Flag_Carry(carry));

	MAR mar(.MAR_in(mar_in),.MAR_out(mar_out),.MAR_rw(mar_rw),.MAR_clk(clk));
	
	CU cu(.CU_in(ir_out), .CU_clk(clk), .Mode(mode), .Select(select), .State(test_state), .MBR_rw(mbr_rw),.IR_rw(ir_rw),.PC_inc(pc_inc),.Reg_rw(reg_rw),.Buff_rw(buff_rw), .MAR_rw(mar_rw),.RAM_rw(ram_rw), .ALU_in_select(alu_in_select),.Reg_in_select(reg_in_select),.ALU_out_select(alu_out_select),.MAR_select(mar_select),.MBR_select
	(mbr_select), .Data_imm(data_imm), .Buff_imm(buff_imm));

    assign data_in = data_imm?(ir_out[1]?{6'b111111,ir_out[1:0]}:{6'b000000,ir_out[1:0]}):(reg_in_select ? buff_out : mbr_out);
	assign buff_in = buff_imm?(ir_out[1]?{6'b111111,ir_out[1:0]}:{6'b000000,ir_out[1:0]}):(alu_out_select ? data_out : z);
    assign mar_in = mar_select?(ir_out[3]?{4'b1111,ir_out[3:0]}:{4'b0000,ir_out[3:0]}):pc_out;
    assign y = alu_in_select ? data_out : mbr_out;
	assign mbr_in = mbr_select ? data_out : ram_out;
	assign ram_addr = mar_out;
	assign ram_data = mbr_out;
	assign test_Buff=buff_out;

	

endmodule