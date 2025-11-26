`timescale 1ns/1ps
module tb_pc;

reg clk;
reg reset;
reg pc_enable;
reg jump;
reg [3:0] jump_addr;

wire [3:0] pc;

program_counter uut(
    .clk(clk),
    .reset(reset),
    .pc_enable(pc_enable),
    .jump(jump),
    .jump_addr(jump_addr),
    .pc(pc)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    reset = 1;
    pc_enable = 0;
    jump = 0;
    jump_addr = 0;

    #10 reset = 0;

    pc_enable = 1;
    #40;

    jump = 1;
    jump_addr = 4'b1010;
    #10 jump = 0;

    #40;

    $finish;
end

initial begin
    $monitor("t=%0t PC=%d jump=%b", $time, pc, jump);
end

endmodule