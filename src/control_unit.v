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

    always @(posedge clk or posedge reset) begin
        if (reset) state <= S_FETCH;
        else state <= next_state;
    end

    always @(*) begin
        next_state = state;
        case (state)
            S_FETCH:    next_state = S_DECODE;
            S_DECODE:   next_state = S_EXECUTE;
            S_EXECUTE: begin
                case (opcode)
                    4'b0011: next_state = S_MEM;
                    4'b0100: next_state = S_MEM;
                    4'b1000: next_state = S_WRITEBACK;
                    4'b1111: next_state = S_HALT;
                    default: next_state = S_WRITEBACK;
                endcase
            end
            S_MEM:       next_state = S_WRITEBACK;
            S_WRITEBACK: next_state = S_FETCH;
            S_HALT:      next_state = S_HALT;
            default:     next_state = S_FETCH;
        endcase
    end

    always @(*) begin
        reg_write  = 0;
        mem_read   = 0;
        mem_write  = 0;
        alu_enable = 0;
        pc_enable  = 0;
        halt       = 0;

        pc_enable = (state == S_FETCH);

        if (state == S_EXECUTE) begin
            if (opcode == 4'b1000) alu_enable = 1'b1;
            else if (opcode != 4'b0011 && opcode != 4'b0100 && opcode != 4'b1111)
                alu_enable = 1'b1;
        end

        if (next_state == S_MEM) begin
            if (opcode == 4'b0011) mem_read  = 1'b1;
            else if (opcode == 4'b0100) mem_write = 1'b1;
        end

        if (next_state == S_WRITEBACK) begin
            if (opcode != 4'b0100 && opcode != 4'b1111)
                reg_write = 1'b1;
        end

        halt = (next_state == S_HALT);

    end

endmodule