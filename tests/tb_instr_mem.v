`timescale 1ns/1ps

module tb_instr_mem;

reg [3:0] addr;
wire [15:0] instr;

instr_mem uut(.addr(addr), .instr(instr));

initial begin
    addr = 0;
    #10 addr = 1;
    #10 addr = 2;
    #10 addr = 3;
    #10 addr = 4;
    #10 $finish;
end

initial begin
    $monitor("t=%0t addr=%d instr=%b", $time, addr, instr);
end

endmodule