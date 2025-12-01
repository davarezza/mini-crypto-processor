module pc(
    input clk,
    input reset,
    input pc_enable,
    output reg [7:0] pc
);

    always @(posedge clk or posedge reset) begin
        if (reset) pc <= 8'h00;
        else if (pc_enable) pc <= pc + 1;
    end

endmodule