module alu(
    input enable,
    input [3:0] opcode,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] result
);

    always @(*) begin
        if (!enable) result = 0;
        else begin
            case(opcode)
                4'b0001: result = a + b;
                4'b0010: result = a - b;
                4'b0011: result = a ^ b;
                4'b0100: result = b;
                default: result = 0;
            endcase
        end
    end

endmodule