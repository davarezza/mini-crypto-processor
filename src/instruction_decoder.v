module instruction_decoder(
    input  [15:0] instr,
    output [3:0] opcode,
    output [3:0] reg1,
    output [3:0] reg2,
    output [3:0] imm
);

assign opcode = instr[15:12];
assign reg1   = instr[11:8];
assign reg2   = instr[7:4];
assign imm    = instr[3:0];

endmodule