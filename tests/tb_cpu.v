`timescale 1ns/1ps

module tb_cpu;

    reg clk;
    reg reset;
    integer f_bin;
    integer f_hex;
    integer i;

    cpu cpu_inst(
        .clk(clk),
        .reset(reset)
    );

    initial begin
        $display("Time   PC  OPC  RS1 RS2 RD  R1  R2  WR_DATA  MEM_R MEM_W PC_EN");

        $monitor("%4t   %h    %h    %h   %h   %h   %h   %h    %h       %b      %b      %b   %b   %b",
            $time,
            cpu_inst.pc,
            cpu_inst.opcode,
            cpu_inst.rs1,
            cpu_inst.rs2,
            cpu_inst.rd,
            cpu_inst.regfile_inst.regs[1],
            cpu_inst.regfile_inst.regs[2],
            cpu_inst.reg_write_data,
            cpu_inst.mem_read,
            cpu_inst.mem_write,
            cpu_inst.pc_enable,
            cpu_inst.state,
            cpu_inst.reg_write
        );
    end

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset = 1;
        #20;
        reset = 0;

        while (cpu_inst.halted == 0) begin
            #10;
        end

        f_bin = $fopen("output_bin.txt", "w");
        f_hex = $fopen("output_hex.txt", "w");

        for (i = 0; i < 16; i = i + 1) begin
            $fwrite(f_bin, "%b\n", cpu_inst.regfile_inst.regs[i]);
            $fwrite(f_hex, "%02h\n", cpu_inst.regfile_inst.regs[i]);
        end

        $fclose(f_bin);
        $fclose(f_hex);

        $display("Enkripsi selesai");

        $finish;
    end

endmodule