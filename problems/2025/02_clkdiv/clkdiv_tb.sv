`timescale 1ns/1ps

module clkdiv_tb;

logic clk   = 1'b0;
logic rst_n = 1'b1;
logic out1;
logic out2;
logic out3;

always begin
    #1 clk = ~clk;
end

clkdiv #(.F_0(50_000_000), .F_1(9_600))   clkdiv1 (.clk(clk), .rst_n(rst_n), .out(out1));
clkdiv #(.F_0(50_000_000), .F_1(38_400))  clkdiv2 (.clk(clk), .rst_n(rst_n), .out(out2));
clkdiv #(.F_0(50_000_000), .F_1(115_200)) clkdiv3 (.clk(clk), .rst_n(rst_n), .out(out3));

initial begin
    $dumpvars;
    #1; rst_n = 1'b0; #1; rst_n = 1'b1;
    // Check waveforms.
    #50000;
    $finish;
end

endmodule

