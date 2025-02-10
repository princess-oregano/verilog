// `define BEHAVIORAL

`ifdef BEHAVIORAL

module signext #(
    parameter int N = 20,
    parameter int M = 32
)(
    input  wire [N-1:0] i_x,
    output wire [M-1:0] o_y
);

assign o_y = {{(M-N){i_x[N-1]}}, i_x};

endmodule

`else

module signext #(
    parameter int N = 20,
    parameter int M = 32
)(
    input  wire [N-1:0] i_x,
    output wire [M-1:0] o_y
);

generate
genvar i;
for (i = 0; i < N; ++i) begin : gen_xbits
    sn_bit #(.SIGN(1'b0)) sn_bit_inst (.i_signbit(i_x[N-1]), .i_ibit(i_x[i]), .o_out(o_y[i]));
end
for (i = N; i < M; ++i) begin : gen_signbits
    sn_bit #(.SIGN(1'b1)) sn_bit_inst (.i_signbit(i_x[N-1]), .i_ibit(i_x[N-1]), .o_out(o_y[i]));
end
endgenerate

endmodule

`endif

