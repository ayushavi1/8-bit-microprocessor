module microprocessor(
    input wire ,
    output reg
);

    assign data_in = data_imm?(ir_out[1]?{6'b111111,ir_out[1:0]}:{6'b000000,ir_out[1:0]}):(rf_mux ? acc_out : mbr_out);
    
endmodule