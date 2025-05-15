`include "alu.vh"
`include "cmp.vh"
`include "core.vh"

module control (
    input wire [31:0] i_instr,

    output reg  [`ALUOP_WIDTH-1:0] o_aluop,
    output reg               [1:0] o_alusel1,
    output reg               [1:0] o_alusel2,

    output reg  [`CMPOP_WIDTH-1:0] o_cmpop,
    output reg                     o_branch,
    output reg                     o_jump,

    output reg               [1:0] o_wb_sel,
    output reg                     o_wb_en,

    output reg                     o_store,
    output reg               [3:0] o_store_mask
);

// Parse the instruction.
wire [6:0] opcode = i_instr[6:0];
wire [2:0] funct3 = i_instr[14:12];
wire [4:0] funct7 = i_instr[31:25];

// Set output according to intruction.
always @(*) begin
    casez ({funct7, funct3, opcode})
        `define CASE_OP(NAME_, ENCODE_, ALUOP_, ALUSEL1_, ALUSEL2_, WBSEL_, WB_, CMPOP_, BRANCH_, JUMP_, ST_, ST_MASK_)     \
            ENCODE_: begin                                                                                                  \
                o_aluop = ALUOP_;                                                                                           \
                o_alusel1 = ALUSEL1_;                                                                                       \
                o_alusel2 = ALUSEL2_;                                                                                       \
                                                                                                                            \
                o_cmpop = CMPOP_;                                                                                           \
                o_branch = BRANCH_;                                                                                         \
                o_jump = JUMP_;                                                                                             \
                                                                                                                            \
                o_wb_sel = WBSEL_;                                                                                          \
                o_wb_en = WB_;                                                                                              \
                                                                                                                            \
                o_store = ST_;                                                                                              \
                o_store_mask = ST_MASK_;                                                                                    \
            end

        `include "instr.vh"
        `undef CASE_OP
    default: begin
        $display("Invalid instuction: i_instr: %b %b_%b_%b", i_instr, funct7, funct3, opcode);
    end
    endcase
end

endmodule

