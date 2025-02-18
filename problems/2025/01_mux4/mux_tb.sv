`timescale 1ns/1ps

module mux_tb;

localparam int WIDTH = 8;

wire  [WIDTH-1:0] i_a = 1;
wire  [WIDTH-1:0] i_b = 2;
wire  [WIDTH-1:0] i_c = 3;
wire  [WIDTH-1:0] i_d = 4;
logic  [1:0]       i_sel;

logic  [WIDTH-1:0] o_out;

mux #(WIDTH) mux8 (.i_a(i_a), .i_b(i_b), .i_c(i_c), .i_d(i_d), .i_sel(i_sel), .o_out(o_out));

initial begin
    $dumpvars;
    i_sel = 0; #1 check(1);
    i_sel = 1; #1 check(2);
    i_sel = 2; #1 check(3);
    i_sel = 3; #1 check(4);
    $display("END OF TEST");
end

task check (input [WIDTH-1:0] expects) ;
    if (o_out !== expects) begin
        $display("MUX TEST FAILED: o_out = %b, expected value %b", o_out, expects);
    end
endtask

endmodule
