module tb_control;

reg clk;
reg reset;
reg [3:0] opcode;

wire reg_write;
wire mem_read;
wire mem_write;
wire alu_enable;
wire pc_enable;
wire halt;
wire [2:0] state;

control_unit uut(
    .clk(clk),
    .reset(reset),
    .opcode(opcode),
    .reg_write(reg_write),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .alu_enable(alu_enable),
    .pc_enable(pc_enable),
    .halt(halt),
    .state(state)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    reset = 1;
    #10 reset = 0;

    opcode = 4'b0001;
    #50;

    opcode = 4'b0011;
    #50;

    opcode = 4'b1111;
    #50;

    $finish;
end

endmodule