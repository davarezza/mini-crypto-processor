module xor_enc(
    input  wire [7:0] data_in,
    input  wire [7:0] key,
    output wire [7:0] data_out
);
    assign data_out = data_in ^ key;
endmodule