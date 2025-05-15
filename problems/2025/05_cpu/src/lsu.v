`include "lsu.vh"

module lsu (
    input  wire                    i_store,
    input  wire             [31:0] i_addr,
    // Use lsu_op instead of size to handle LBU and LHU cases.
    // Maybe use sign extension bit?
    input  wire [`LSUOP_WIDTH-1:0] i_op,
    input  wire             [31:0] i_st_data,
    output reg              [31:0] o_ld_data,

    output wire                    o_mem_we,
    output wire             [29:0] o_mem_addr,
    output wire             [31:0] o_mem_data,
    output reg               [3:0] o_mem_mask,
    input  wire             [31:0] i_mem_data
);

assign o_mem_we   = i_store;
assign o_mem_addr = i_addr[31:2];
assign o_mem_data = i_st_data;

// Load.
always @(*) begin
    casez (i_op)
        `LSU_BYTE   : o_ld_data = {{24{i_mem_data[ 7]}}, i_mem_data[ 7:0]};
        `LSU_HALF   : o_ld_data = {{24{i_mem_data[15]}}, i_mem_data[15:0]};
        `LSU_WORD   : o_ld_data = i_mem_data;
        `LSU_U_BYTE : o_ld_data = {24'b0, i_mem_data[ 7:0]};
        `LSU_U_HALF : o_ld_data = {24'b0, i_mem_data[15:0]};
        default     : o_ld_data = 32'dX;
    endcase
end

// Store.
always @(*) begin
    casez (i_op)
        `LSU_BYTE : o_mem_mask = 4'b0001;
        `LSU_HALF : o_mem_mask = 4'b0011;
        `LSU_WORD : o_mem_mask = 4'b1111;
        default   : o_mem_mask = 4'bXXXX;
    endcase
end

endmodule

