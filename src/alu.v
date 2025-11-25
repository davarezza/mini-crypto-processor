module ALU (
    input  wire [7:0] A,
    input  wire [7:0] B,
    input  wire [3:0] opcode,
    output reg  [7:0] result
);

    // Opcode mapping
    localparam ADD = 4'b0001;
    localparam SUB = 4'b0010;
    localparam XOR_OP = 4'b0011;
    localparam MOV = 4'b0100;

    always @(*) begin
        case(opcode)
            ADD: result = A + B;
            SUB: result = A - B;
            XOR_OP: result = A ^ B;
            MOV: result = B;
            default: result = 8'b00000000;
        endcase
    end

endmodule
