`timescale 1ns/1ps

module ALU_tb;

reg [7:0] A, B;
reg [3:0] opcode;
wire [7:0] result;

ALU uut (
    .A(A),
    .B(B),
    .opcode(opcode),
    .result(result)
);

initial begin
    $display("Starting ALU Test");

    // Test ADD
    A = 8'd10;
    B = 8'd5;
    opcode = 4'b0001;
    #10;
    $display("ADD 10 + 5 = %d", result);

    // Test SUB
    opcode = 4'b0010;
    #10;
    $display("SUB 10 - 5 = %d", result);

    // Test XOR
    opcode = 4'b0011;
    #10;
    $display("XOR 10 ^ 5 = %d", result);

    // Test MOV
    opcode = 4'b0100;
    #10;
    $display("MOV B -> result, B=%d result=%d", B, result);

    $display("ALU Test Completed");
    $finish;
end

endmodule