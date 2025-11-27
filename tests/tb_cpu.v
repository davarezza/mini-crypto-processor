`timescale 1ns/1ps

module tb_cpu;
    reg clk;
    reg reset;

    cpu cpu_inst(
        .clk(clk),
        .reset(reset)
    );

    initial begin
        $monitor("t=%0dns | clk=%b | PC=%0d | state=%0d | opcode=%0h | rd=%0d | rs1=%0h | rs2=%0h | reg_write=%b | alu_out=%0h | crypto=%0h | write_data=%0h",
                 $time,
                 clk,
                 cpu_inst.pc_inst.pc,
                 cpu_inst.cu_inst.state,
                 cpu_inst.instr_mem_inst.instruction[15:12],
                 cpu_inst.instr_mem_inst.instruction[11:8],
                 cpu_inst.reg_rs1,
                 cpu_inst.reg_rs2,
                 cpu_inst.cu_inst.reg_write,
                 cpu_inst.alu_result,
                 cpu_inst.crypto_out,
                 cpu_inst.reg_write_data
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

        #200;

        $display("Reg[2] (plaintext) = 0x%02h", cpu_inst.regfile_inst.regs[2]);
        $display("Reg[3] (key)       = 0x%02h", cpu_inst.regfile_inst.regs[3]);
        $display("Reg[1] (cipher)    = 0x%02h", cpu_inst.regfile_inst.regs[1]);

        $display("plaintext char = %c, key = 0x%02h, cipher char = %c",
                 cpu_inst.regfile_inst.regs[2],
                 cpu_inst.regfile_inst.regs[3],
                 cpu_inst.regfile_inst.regs[1]);

        $finish;
    end
endmodule