module microprocessor(
    input wire[7:0] ram_out,
	input wire clk,
	output reg[7:0] ram_data,
	output reg[7:0] ram_addr,	 
	output reg ram_we,
	output reg[7:0] test_state,
	output reg[7:0] test_A,test_B,test_C,test_D,test_Acc;
);

    wire mbr_we,ir_we,pc_inc,rf_we,acc_we,mar_we,alu_mux,rf_mux,alu_out_mux,mar_mux,mbr_mux,ram_we, data_imm, acc_imm;
	wire[2:0] mode;
	wire[1:0] select;
	wire[1:0] ram_in;
	
	wire[7:0] ir_out; //IR
	wire[7:0] pc_out; //PC
	wire[7:0] data_in,acc_in,data_out,acc_out; //RF
	wire[7:0] y,z; //ALU
	wire[7:0] mar_in,mar_out; //MAR
	wire[7:0] mbr_in,mbr_out; //MBR
	wire zero, carry; //Condition Code Registers
	

	MBR mbr(.MBR_in(mbr_in), .MBR_out(mbr_out), .MBR_we(mbr_we), .MBR_clk(clk));

	IR ir(.IR_in(mbr_out), .IR_out(ir_out), .IR_we(ir_we), .IR_clk(clk));

	PC pc(.PC_out(pc_out), .PC_clk(clk), .PC_inc(pc_inc));

	Register register(.Select(select), .Reg_clk(clk), .RF_we(rf_we), .Acc_we(acc_we), .Data_in(data_in), , .Acc_in(acc_in), .Data_out(data_out), .Acc_out(acc_out), .A_out(test_A),.B_out(test_B),.C_out(test_C),.D_out(test_D));

	ALU alu(.in1(acc_out),.in2(y),.Mode(mode),.out(z),.flag_zero(zero), .flag_carry(carry));

	MAR mar(.MAR_in(mar_in),.MAR_out(mar_out),.MAR_we(mar_we),.MAR_clk(clk));
	
	CU cu(.cu_in(ir_out), .CU_clk(clk), .Mode(mode), .Select(select), .State(test_state), .MBR_we(mbr_we),.IR_we(ir_we),.PC_inc(pc_inc),.RF_we(rf_we),.Acc_we(acc_we), .MAR_we(mar_we),.RAM_we(ram_we), .ALU_mux(alu_mux),.RF_mux(rf_mux),.ALU_out_mux(alu_out_mux),.MAR_mux(mar_mux),.MBR_mux(mbr_mux), .Data_imm(data_imm), .Acc_imm(acc_imm));

    assign data_in = data_imm?(ir_out[1]?{6'b111111,ir_out[1:0]}:{6'b000000,ir_out[1:0]}):(rf_mux ? acc_out : mbr_out);
	assign acc_in = acc_imm?(ir_out[1]?{6'b111111,ir_out[1:0]}:{6'b000000,ir_out[1:0]}):(alu_out_mux ? data_out : z);
    assign mar_in = mar_mux?(ir_out[3]?{4'b1111,ir_out[3:0]}:{4'b000,ir_out[3:0]}):pc_out;
    assign y = alu_mux ? data_out : mbr_out;
	assign mbr_in = mbr_mux ? data_out : ram_out;
	assign ram_addr = mar_out;
	assign ram_data = mbr_out;
	assign test_Acc=Acc_out;

	

endmodule