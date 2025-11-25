module regfile #(
    parameter REG_WIDTH = 32,
    parameter REG_COUNT = 16
)(
    input clk,
    input we,                       // Write enable
    input [$clog2(REG_COUNT)-1:0] w_addr, // Write address
    input [REG_WIDTH-1:0] w_data,         // Write data
    
    input [$clog2(REG_COUNT)-1:0] r_addr1, // Read port 1 address
    input [$clog2(REG_COUNT)-1:0] r_addr2, // Read port 2 address
    
    output [REG_WIDTH-1:0] r_data1,        // Read port 1 data
    output [REG_WIDTH-1:0] r_data2         // Read port 2 data
);

    reg [REG_WIDTH-1:0] regs [0:REG_COUNT-1];

    // Read asynchronous
    assign r_data1 = regs[r_addr1];
    assign r_data2 = regs[r_addr2];

    // Write synchronous
    always @(posedge clk) begin
        if (we) begin
            regs[w_addr] <= w_data;
        end
    end

endmodule
