`timescale 1ns/1ps

module tb_cpu;

    reg clk;
    reg reset;

    integer f_in;
    integer f_bin;
    integer f_hex;
    integer c;
    
    cpu cpu_inst(
        .clk(clk),
        .reset(reset)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset = 1;
        #20;
        reset = 0;

        f_in  = $fopen("input.txt", "r");
        if (f_in == 0) begin
            $finish;
        end

        f_hex = $fopen("output_hex.txt", "w");
        f_bin = $fopen("output_bin.txt", "w");

        while (!$feof(f_in)) begin
            c = $fgetc(f_in);
            if (c != -1 && c != 10) begin
                $fwrite(f_hex, "%02h\n", c[7:0]);
                $fwrite(f_bin, "%08b\n", c[7:0]);
            end
        end

        $fclose(f_in);
        $fclose(f_hex);
        $fclose(f_bin);

        $finish;
    end

endmodule