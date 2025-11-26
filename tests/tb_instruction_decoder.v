module tb_instruction_decoder;

reg  [15:0] instr;
wire [3:0] opcode;
wire [3:0] reg1;
wire [3:0] reg2;
wire [3:0] imm;

instruction_decoder uut(
    .instr(instr),
    .opcode(opcode),
    .reg1(reg1),
    .reg2(reg2),
    .imm(imm)
);

initial begin
    $display("Starting Decoder Test");

    instr = 16'b0001_0001_0010_0000;
    #10 $display("ADD R1,R2  opcode=%d reg1=%d reg2=%d imm=%d", opcode, reg1, reg2, imm);

    instr = 16'b0110_0011_0000_0101;
    #10 $display("XORENC R3 key=5  opcode=%d reg1=%d reg2=%d imm=%d", opcode, reg1, reg2, imm);

    instr = 16'b0111_0000_0000_1100;
    #10 $display("JMP addr=12 opcode=%d reg1=%d reg2=%d imm=%d", opcode, reg1, reg2, imm);

    $display("Decoder Test Completed");
    $finish;
end

endmodule