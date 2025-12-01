module instr_mem(
    input  [7:0] address,
    output reg [15:0] instruction
);

    always @(*) begin
        case(address)
            8'd0: instruction = {4'b1000, 4'd1, 4'd2, 4'd3};
            8'd1: instruction = {4'b0100, 4'd0, 4'd1, 4'd0};
            8'd2: instruction = 16'b1111_0000_0000_0000;
            default: instruction = 16'b1111_0000_0000_0000;
        endcase
    end

endmodule