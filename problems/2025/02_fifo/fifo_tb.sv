`timescale 1ns/1ps

module fifo_tb;

localparam  int DATAW = 8;
localparam  int DEPTH = 4;

logic clk   = 1'b0;
logic rst_n = 1'b1;

always begin
    #1 clk = ~clk;
end

logic [DATAW-1:0] wr_data;
logic             wr_en;
logic             rd_en;

logic             wr_full;
logic             rd_empty;
logic [DATAW-1:0] rd_data;

fifo fifo (.clk(clk), .rst_n(rst_n),
           .i_wr_data(wr_data), .i_wr_en(wr_en), .i_rd_en(rd_en),
           .o_wr_full(wr_full),  .o_rd_empty(rd_empty),
           .o_rd_data(rd_data));

initial begin
    $dumpvars;
    wr_en = 0;
    rd_en = 0;
    #2;
    rst_n = 1'b0; #1; rst_n = 1'b1;

    $display("Filling FIFO...");
    wr_en = 1'b1;
    wr_data = 1;
    #2;
    wr_data = 2;
    #2;
    wr_data = 3;
    #2;
    wr_data = 4;
    #2;
    $display("Check if FIFO is full: wr_full = %b", wr_full);
    wr_en = 1'b0;
    #2;

    $display("Reading FIFO...");
    rd_en = 1'b1;
    #2;
    check(1);
    #2;
    check(2);
    #2;
    check(3);
    #2;
    check(4);
    $display("Check if FIFO is empty: rd_empty = %b", rd_empty);

    $finish;
end

task check (input logic [7:0] expects);
    if (rd_data !== expects) begin
        $display("FIFO TEST FAILED:");
    end
    $display("rd_data = %b, expected value %b", rd_data, expects);
endtask

endmodule
