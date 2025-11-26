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

// State encoding
localparam S_FETCH     = 3'd0;
localparam S_DECODE    = 3'd1;
localparam S_EXECUTE   = 3'd2;
localparam S_MEM       = 3'd3;
localparam S_WRITEBACK = 3'd4;
localparam S_HALT      = 3'd5;

reg [2:0] next_state;

always @(posedge clk or posedge reset) begin
    if (reset) state <= S_FETCH;
    else state <= next_state;
end

always @(*) begin
    reg_write = 0;
    mem_read = 0;
    mem_write = 0;
    alu_enable = 0;
    pc_enable = 0;
    halt = 0;

    case (state)
        S_FETCH: begin
            pc_enable = 1;
            next_state = S_DECODE;
        end

        S_DECODE: begin
            next_state = S_EXECUTE;
        end

        S_EXECUTE: begin
            alu_enable = 1;
            if (opcode == 4'b0000 || opcode == 4'b0001 || opcode == 4'b0010) begin
                next_state = S_WRITEBACK;
            end else if (opcode == 4'b0011 || opcode == 4'b0100) begin
                next_state = S_MEM;
            end else if (opcode == 4'b1111) begin
                next_state = S_HALT;
            end else begin
                next_state = S_WRITEBACK;
            end
        end

        S_MEM: begin
            if (opcode == 4'b0011) mem_read = 1;
            if (opcode == 4'b0100) mem_write = 1;
            next_state = S_WRITEBACK;
        end

        S_WRITEBACK: begin
            reg_write = 1;
            next_state = S_FETCH;
        end

        S_HALT: begin
            halt = 1;
            next_state = S_HALT;
        end

        default: next_state = S_FETCH;
    endcase
end

endmodule