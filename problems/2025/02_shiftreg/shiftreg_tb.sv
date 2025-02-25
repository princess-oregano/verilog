`timescale 1ns/1ps

module shiftreg_tb;

localparam int WIDTH = 8;

logic clk = 1'b0;

always begin
    #1 clk = ~clk;
end

logic             i_bit = 1'b0;
logic [WIDTH-1:0] i_fill = 'b10011010;
logic             i_fill_en = 1'b1;
logic             o_out;

shiftreg #(.WIDTH(WIDTH)) shiftreg (.clk(clk), .i_bit(i_bit), .i_fill(i_fill),
                                    .i_fill_en(i_fill_en), .o_out(o_out));

initial begin
    $dumpvars();
    #2; check(i_fill[7]);
    i_fill_en = 1'b0;
    #2; check(i_fill[6]);
    #2; check(i_fill[5]);
    #2; check(i_fill[4]);
    #2; check(i_fill[3]);
    #2; check(i_fill[2]);
    #2; check(i_fill[1]);
    #2; check(i_fill[0]);
    #2; check(0);
    #10;
    $finish();
end

task check (input expects);
    if (o_out !== expects) begin
        $display("SHIFTREG TEST FAILED:");
    end
    $display("o_out = %b, expected value %b", o_out, expects);
endtask

endmodule

