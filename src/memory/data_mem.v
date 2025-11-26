module data_mem(
    input clk,
    input mem_read,
    input mem_write,
    input [7:0] address,
    input [7:0] write_data,
    output reg [7:0] read_data
);

    reg [7:0] mem [0:255];

    always @(posedge clk) begin
        if (mem_write)
            mem[address] <= write_data;

        if (mem_read)
            read_data <= mem[address];
    end
endmodule