module control_unit(
    input clk,
    input reset,
    input [3:0] opcode,

    output reg reg_write,
    output reg mem_read,
    output reg mem_write,
    output reg alu_enable,
    output reg pc_enable,
    output reg halt,
    output reg [2:0] state
);

localparam S_FETCH     = 3'd0;
localparam S_DECODE    = 3'd1;
localparam S_EXECUTE   = 3'd2;
localparam S_MEM       = 3'd3;
localparam S_WRITEBACK = 3'd4;
localparam S_HALT      = 3'd5;

reg [2:0] next_state;
reg next_mem_read;
reg next_mem_write;
reg next_alu_enable;
reg next_pc_enable;
reg next_halt;
reg next_reg_write;

always @(posedge clk or posedge reset) begin
    if (reset) state <= S_FETCH;
    else state <= next_state;
end

always @(*) begin
    next_state = state;
    next_mem_read = 0;
    next_mem_write = 0;
    next_alu_enable = 0;
    next_pc_enable = 0;
    next_halt = 0;
    next_reg_write = 0;

    case (state)
        S_FETCH: begin
            next_state = S_DECODE;
        end

        S_DECODE: begin
            next_state = S_EXECUTE;
        end

        S_EXECUTE: begin
            next_alu_enable = 1;
            case (opcode)
                4'b0011: next_state = S_MEM;
                4'b0100: next_state = S_MEM;
                4'b1111: next_state = S_HALT;
                default: next_state = S_WRITEBACK;
            endcase
            if (next_state == S_WRITEBACK) next_reg_write = 1;
        end

        S_MEM: begin
            if (opcode == 4'b0011) begin
                next_mem_read = 1;
                next_reg_write = 1;
            end
            else if (opcode == 4'b0100) begin
                next_mem_write = 1;
            end
            next_state = S_WRITEBACK;
        end

        S_WRITEBACK: begin
            next_pc_enable = 1;
            next_state = S_FETCH;
        end

        S_HALT: begin
            next_halt = 1;
            next_state = S_HALT;
        end

        default: next_state = S_FETCH;
    endcase

    mem_read    = next_mem_read;
    mem_write   = next_mem_write;
    alu_enable  = next_alu_enable;
    pc_enable   = next_pc_enable;
    halt        = next_halt;
    reg_write   = next_reg_write;
end

endmodule