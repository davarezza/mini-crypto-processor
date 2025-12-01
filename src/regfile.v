module regfile(
    input clk,
    input reset,
    input reg_write,
    input [3:0] rs1,
    input [3:0] rs2,
    input [3:0] rd,
    input [7:0] write_data,
    output [7:0] out_rs1,
    output [7:0] out_rs2
);

    reg [7:0] regs [0:15];
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 16; i = i + 1) regs[i] <= 8'h00;
            regs[2] <= 8'h41;
            regs[3] <= 8'h20;
        end else if (reg_write) begin
            regs[rd] <= write_data;
        end
    end

    assign out_rs1 = regs[rs1];
    assign out_rs2 = regs[rs2];

endmodule