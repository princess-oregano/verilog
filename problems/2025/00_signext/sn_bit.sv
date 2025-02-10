module sn_bit #(
    parameter bit SIGN = 1'b0
)(
    input  wire i_signbit,
    input  wire i_ibit,
    output wire o_out
);

// Саша хочет спросить, почему это не работает.
// always_comb begin
//     if (SIGN)
//         o_out = i_signbit;
//     else
//         o_out = i_ibit;
// end

assign o_out = (SIGN == 1'b1) ? i_signbit : i_ibit;

endmodule
