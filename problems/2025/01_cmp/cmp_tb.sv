`include "cmpop.svh"

`timescale 1ns/1ps

module cmp_tb;

logic [31:0] i_a;
logic [31:0] i_b;
logic [2:0]  i_cmpop;
logic o_taken;

cmp cmp1 (.i_a(i_a), .i_b(i_b), .i_cmpop(i_cmpop), .o_taken(o_taken));

task check (input logic expects);
    $display("opcode=%d i_a=%b i_b=%b o_taken=%b",
               i_cmpop, i_a, i_b, o_taken);
    if (o_taken != expects) begin
        $display("ALU TEST FAILED");
    end
endtask

initial begin
    $dumpvars;
    // BEQ
    i_a =  3; i_b =  3; i_cmpop = BEQ; #1 check(1);
    i_a =  5; i_b =  3; i_cmpop = BEQ; #1 check(0);

    // BNE
    i_a =  3; i_b =  3; i_cmpop = BNE; #1 check(0);
    i_a =  5; i_b =  3; i_cmpop = BNE; #1 check(1);

    // BLT
    i_a =  3; i_b =  5; i_cmpop = BLT; #1 check(1);
    i_a =  5; i_b =  5; i_cmpop = BLT; #1 check(0);
    i_a = -3; i_b = -5; i_cmpop = BLT; #1 check(0);
    i_a = -5; i_b = -3; i_cmpop = BLT; #1 check(1);
    i_a = -5; i_b =  3; i_cmpop = BLT; #1 check(1);
    i_a = -3; i_b =  3; i_cmpop = BLT; #1 check(1);

    // BGE
    i_a =  3; i_b =  5; i_cmpop = BGE; #1 check(0);
    i_a =  5; i_b =  5; i_cmpop = BGE; #1 check(1);
    i_a = -3; i_b = -5; i_cmpop = BGE; #1 check(1);
    i_a = -5; i_b = -3; i_cmpop = BGE; #1 check(0);
    i_a = -5; i_b =  3; i_cmpop = BGE; #1 check(0);
    i_a = -3; i_b =  3; i_cmpop = BGE; #1 check(0);

    // BLTU
    i_a =  3; i_b =  5; i_cmpop = BLTU; #1 check(1);
    i_a =  5; i_b =  5; i_cmpop = BLTU; #1 check(0);
    i_a = -3; i_b = -5; i_cmpop = BLTU; #1 check(0);
    i_a = -5; i_b = -3; i_cmpop = BLTU; #1 check(1);
    i_a = -5; i_b =  3; i_cmpop = BLTU; #1 check(0);
    i_a = -3; i_b =  3; i_cmpop = BLTU; #1 check(0);

    // BGEU
    i_a =  3; i_b =  5; i_cmpop = BGEU; #1 check(0);
    i_a =  5; i_b =  5; i_cmpop = BGEU; #1 check(1);
    i_a = -3; i_b = -5; i_cmpop = BGEU; #1 check(1);
    i_a = -5; i_b = -3; i_cmpop = BGEU; #1 check(0);
    i_a = -5; i_b =  3; i_cmpop = BGEU; #1 check(1);
    i_a = -3; i_b =  3; i_cmpop = BGEU; #1 check(1);

    $finish();
end

endmodule

