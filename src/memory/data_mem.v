module data_mem(
    input clk,
    input mem_read,
    input mem_write,
    input [7:0] address,
    input [7:0] write_data,
    output reg [7:0] read_data
);

    reg [7:0] mem [0:255];
    integer i;

    initial begin
        for (i = 0; i < 256; i = i + 1) mem[i] = 8'h00;
    end

    always @(posedge clk) begin
        if (mem_write) begin
            mem[address] <= write_data;
        end
    end

    always @(*) begin
        if (mem_read) read_data = mem[address];
        else read_data = 8'h00;
    end

endmodule