`include "opcode.svh"

`timescale 1ns/1ps

module alu_tb;

logic [31:0] i_a;
logic [31:0] i_b;
logic [3:0]  i_op;
logic [31:0] o_res;

alu alu1 (.i_a(i_a), .i_b(i_b), .i_op(i_op), .o_res(o_res));

task check (input logic [31:0] expects);
    $display("opcode=%d i_a=%b i_b=%b o_res=%b",
               i_op, i_a, i_b, o_res);
    if (o_res != expects) begin
        $display("ALU TEST FAILED");
    end
endtask

initial begin
    $dumpvars;
    i_a = 'd5; i_b = 'd3; i_op = ADD; #1 check(8);
    i_a = 'd5; i_b = 'd3; i_op = SUB; #1 check(2);
    i_a = 'b101; i_b = 'd3; i_op = SLL; #1 check('b101000);
    i_a = 'd3; i_b = 'd5; i_op = SLT; #1 check(1);
    i_a = 'd3; i_b = 'd5; i_op = SLTU; #1 check(1);
    i_a = -3; i_b = 3; i_op = SLTU; #1 check(0);
    i_a = 'b1010; i_b = 'b1100; i_op = XOR; #1 check('b0110);
    i_a = 23; i_b = 2; i_op = SRL; #1 check(5);
    i_a = 'b11111111111111111111111111110010; i_b = 2; i_op = SRL; #1 check('b00111111111111111111111111111100);
    i_a = 23; i_b = 2; i_op = SRA; #1 check(5);
    i_a = 'b11111111111111111111111111110010; i_b = 2; i_op = SRA; #1 check('b11111111111111111111111111111100);
    i_a = 'b1010; i_b = 'b1100; i_op = OR; #1 check('b1110);
    i_a = 'b1010; i_b = 'b1100; i_op = AND; #1 check('b1000);
    $finish();
end

endmodule
