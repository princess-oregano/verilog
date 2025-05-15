module lsu ( //FIXME: sizes, names
    input wire i_st_ld_sel,
    input wire [31:0] i_addr,
    input wire [31:0] i_st_data,
    input wire  [3:0] i_mask,
    output wire [31:0] o_ld_data,

    output wire o_st_ld_sel,
    output wire [29:0] o_addr,
    output wire [31:0] o_st_data,
    output wire [3:0] o_mask,
    input wire  [31:0] i_ld_data
);

assign o_st_ld_sel = i_st_ld_sel;
assign o_addr = i_addr[31:2];
assign o_ld_data = i_ld_data;
assign o_mask = i_mask;
assign o_st_data = i_st_data;

endmodule

