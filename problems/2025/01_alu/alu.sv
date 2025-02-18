`include "opcode.svh"

module alu (
    input wire [31:0] i_a,
    input wire [31:0] i_b,
    input wire [3:0]  i_op,

    output logic [31:0] o_res
);

always @(*) begin
    case (i_op)
        ADD     : o_res = i_a + i_b;
        SUB     : o_res = i_a - i_b;
        SLL     : o_res = i_a << i_b[4:0];
        SLT     : o_res = $signed(i_a) < $signed(i_b);
        SLTU    : o_res = i_a < i_b;
        XOR     : o_res = i_a ^ i_b;
        SRL     : o_res = i_a >> i_b[4:0];
        SRA     : o_res = i_a >>> i_b[4:0];
        OR      : o_res = i_a | i_b;
        AND     : o_res = i_a & i_b;
        default : o_res = 1'dx;
    endcase
end

endmodule
