`timescale 1ns/1ps

module lfsr_tb;

localparam int WIDTH = 8;

logic clk   = 1'b0;
logic rst_n = 1'b0;

always begin
    #1 clk = ~clk;
end

logic [WIDTH-1:0] o_out;

lfsr lfsr (.clk(clk), .rst_n(rst_n), .o_out(o_out));

initial begin
    $dumpvars();
    #2;
    rst_n = 1'b1;
    #50;
    rst_n = 1'b0; #1; rst_n = 1'b1;
    #50
    $finish();
end

endmodule

