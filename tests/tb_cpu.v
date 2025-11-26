module tb_cpu;

    reg clk;
    reg reset;

    cpu uut(
        .clk(clk),
        .reset(reset)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset = 1;
        #20 reset = 0;
    end

    initial begin
        $dumpfile("cpu.vcd");
        $dumpvars(0, tb_cpu);
    end

    initial begin
        $monitor("t=%0t PC=%d OPCODE=%b",
                  $time,
                  uut.pc_inst.pc,
                  uut.opcode);
    end

    initial begin
        #300;
        $finish;
    end

endmodule