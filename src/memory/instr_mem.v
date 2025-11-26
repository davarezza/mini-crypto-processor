module instr_mem(
    input  [7:0] address,
    output reg [15:0] instruction
);

    always @(*) begin
        case(address)
            8'd0: instruction = 16'b0001_0001_0010_0011; 
            default: instruction = 16'b1111_0000_0000_0000; 
        endcase
    end
endmodule