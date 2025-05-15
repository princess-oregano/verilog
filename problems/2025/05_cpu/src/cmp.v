`include "cmp.vh"

module cmp (
    input wire [31:0]             i_a,
    input wire [31:0]             i_b,
    input wire [`CMPOP_WIDTH-1:0] i_op,

    output reg                    o_res
);

always @(*) begin
    case (i_op)
        `CMP_BEQ  :     o_res = (i_a == i_b);
        `CMP_BNE  :     o_res = (i_a != i_b);
        `CMP_BLT  :     o_res = ($signed(i_a) < $signed(i_b));
        `CMP_BGE  :     o_res = ($signed(i_a) >= $signed(i_b));
        `CMP_BLTU :     o_res = (i_a < i_b);
        `CMP_BGEU :     o_res = (i_a >= i_b);
        default   :     o_res = 'dX;
    endcase
end

endmodule

