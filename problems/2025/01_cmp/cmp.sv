`include "cmpop.svh"

module cmp (
    input wire [31:0] i_a,
    input wire [31:0] i_b,
    input wire [2:0]  i_cmpop,

    output logic o_taken
);

always @(*) begin
    case (i_cmpop)
        BEQ    :     o_taken = (i_a == i_b);
        BNE    :     o_taken = (i_a != i_b);
        BLT    :     o_taken = ($signed(i_a) < $signed(i_b));
        BGE    :     o_taken = ($signed(i_a) >= $signed(i_b));
        BLTU   :     o_taken = (i_a < i_b);
        BGEU   :     o_taken = (i_a >= i_b);
        default:     o_taken = 'dx;
    endcase
end

endmodule

