module cpu(
    input clk,
    input reset,
    output wire halted
);

    wire [7:0] pc;
    wire pc_enable;

    pc pc_inst(
        .clk(clk),
        .reset(reset),
        .pc_enable(pc_enable),
        .pc(pc)
    );

    wire [15:0] instruction;
    instr_mem instr_mem_inst(
        .address(pc),
        .instruction(instruction)
    );

    wire [3:0] opcode = instruction[15:12];
    wire [3:0] rd     = instruction[11:8];
    wire [3:0] rs1    = instruction[7:4];
    wire [3:0] rs2    = instruction[3:0];

    wire reg_write;
    wire mem_read;
    wire mem_write;
    wire alu_enable;
    wire halt_signal;
    wire [2:0] state;

    control_unit cu_inst(
        .clk(clk),
        .reset(reset),
        .opcode(opcode),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .alu_enable(alu_enable),
        .pc_enable(pc_enable),
        .halt(halt_signal),
        .state(state)
    );

    assign halted = halt_signal;

    wire [7:0] reg_rs1;
    wire [7:0] reg_rs2;
    wire [7:0] reg_write_data;

    regfile regfile_inst(
        .clk(clk),
        .reset(reset),
        .reg_write(reg_write),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(reg_write_data),
        .out_rs1(reg_rs1),
        .out_rs2(reg_rs2)
    );

    wire [7:0] alu_result;
    alu alu_inst(
        .enable(alu_enable),
        .opcode(opcode),
        .a(reg_rs1),
        .b(reg_rs2),
        .result(alu_result)
    );

    wire [7:0] crypto_out;
    xor_enc xor_inst(
        .data_in(reg_rs1),
        .key(reg_rs2),
        .data_out(crypto_out)
    );

    wire [7:0] alu_selected = (opcode == 4'b1000) ? crypto_out : alu_result;

    wire [7:0] data_out;
    data_mem data_mem_inst(
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .address({4'b0000, rd}),
        .write_data(reg_rs1),
        .read_data(data_out)
    );

    assign reg_write_data = mem_read ? data_out : alu_selected;

endmodule