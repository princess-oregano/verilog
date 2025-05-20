`include "alu.vh"

module alu (
    input wire [31:0]             i_a,
    input wire [31:0]             i_b,
    input wire [`ALUOP_WIDTH-1:0] i_op,

    output reg [31:0]             o_res
);

always @(*) begin
    case (i_op)
        `ALU_ADD     : o_res = i_a + i_b;
        `ALU_SUB     : o_res = i_a - i_b;
        `ALU_SLL     : o_res = i_a << i_b[4:0];
        `ALU_SLT     : o_res = $signed(i_a) < $signed(i_b);
        `ALU_SLTU    : o_res = i_a < i_b;
        `ALU_XOR     : o_res = i_a ^ i_b;
        `ALU_SRL     : o_res = i_a >> i_b[4:0];
        `ALU_SRA     : o_res = $signed(i_a) >>> i_b[4:0];
        `ALU_OR      : o_res = i_a | i_b;
        `ALU_AND     : o_res = i_a & i_b;
        default      : o_res = 32'dX;
    endcase
end

endmodule

