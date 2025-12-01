`timescale 1ns/1ps

module tb_cpu;

reg clk;
reg reset;

integer f_in;
integer f_bin;
integer f_hex;
integer c;

integer total_cycles = 0;
integer instruction_count = 0;

real CPI;
real exec_time_ns;

reg finished = 0;

cpu cpu_inst(
    .clk(clk),
    .reset(reset)
);

wire [7:0] pc        = cpu_inst.pc;
wire [15:0] instr    = cpu_inst.instruction;
wire [2:0] state     = cpu_inst.state;
wire halted          = cpu_inst.halted;

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, tb_cpu);
end

initial begin
    reset = 1;
    #20 reset = 0;
end

always @(posedge clk) begin
    if (!reset)
        total_cycles = total_cycles + 1;
end

always @(posedge clk) begin
    if (!reset && state == 3'd0)
        instruction_count = instruction_count + 1;
end

always @(posedge clk) begin
    if (!reset)
        $display("T=%0t PC=%h INSTR=%h STATE=%0d", $time, pc, instr, state);
end

initial begin
    f_in  = $fopen("input.txt", "r");
    f_hex = $fopen("output_hex.txt", "w");
    f_bin = $fopen("output_bin.txt", "w");

    while (!$feof(f_in)) begin
        c = $fgetc(f_in);
        if (c != -1 && c != 10) begin
            $fwrite(f_hex, "%02h\n", c[7:0]);
            $fwrite(f_bin, "%08b\n", c[7:0]);
        end
    end

    $fclose(f_in);
    $fclose(f_hex);
    $fclose(f_bin);
end

always @(posedge clk) begin
    if (halted)
        finished = 1;
end

initial begin
    wait(finished);

    CPI = total_cycles * 1.0 / instruction_count;
    exec_time_ns = total_cycles * 10.0;

    $display("");
    $display("===== PERFORMANCE REPORT =====");
    $display("Instruction Count = %0d", instruction_count);
    $display("Total Cycles      = %0d", total_cycles);
    $display("CPI               = %0f", CPI);
    $display("Execution Time    = %0f ns", exec_time_ns);
    $display("=================================");

    $finish;
end

endmodule