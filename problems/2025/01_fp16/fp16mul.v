module fp16mul (
    input wire [15:0] i_a,
    input wire [15:0] i_b,

    output reg [15:0] o_res
);

parameter EXP_BIAS = 'd15;

// Parse according to fp16 format.
// Apply DAZ -- denormal-as-zero.
wire       a_sign = i_a[15];
wire [4:0] a_exp  = i_a[14:10];
wire [9:0] a_mant = (a_exp == 5'b0) ? 10'b0 : i_a[9:0];

wire       b_sign = i_b[15];
wire [4:0] b_exp  = i_b[14:10];
wire [9:0] b_mant = (b_exp == 5'b0) ? 10'b0 : i_b[9:0];

// Result of calculation without handling NaN/Inf/Zero/FTZ.
wire       sign;
wire [4:0] exp;
wire [9:0] mant;

// Final results.
reg       res_sign;
reg [4:0] res_exp;
reg [9:0] res_mant;

// Not normalized mantissa.
wire [21:0] mant_nnorm = {1'b1, a_mant} * {1'b1, b_mant};
wire norm = mant_nnorm[21];

// Calculate sign.
assign sign = a_sign ^ b_sign;

// RTZ -- round to zero.
assign mant = norm ? {mant_nnorm[20:11]} : {mant_nnorm[19:10]};
assign exp = a_exp + b_exp + norm - EXP_BIAS;

// Calculate final result.
// Possible cases:
// a      | b      | Res
// Zero   | Zero   | Zero
//        | Inf    | NaN
//        | NaN    | NaN
//        | Normal | Zero
// Inf    | Zero   | NaN
//        | Inf    | Inf
//        | NaN    | NaN
//        | Normal | Inf
// NaN    | Zero   | NaN
//        | Inf    | NaN
//        | NaN    | NaN
//        | Normal | NaN
// Normal | Zero   | Zero
//        | Inf    | Inf
//        | NaN    | NaN
//        | Normal | Normal
always@(*) begin
    // Calculate sign.
    res_sign = sign;

    if (a_exp == 5'b11111 || b_exp == 5'b11111) begin
        res_exp = 5'b11111;

        if ((a_mant != 10'd0 || b_mant != 10'd0) || (a_exp == 5'd0 || b_exp == 5'd0)) begin
            res_mant = 10'b1111111111;
        end
        else begin
            res_mant = 10'b0000000000;
        end
    end
    else if (a_exp == 5'd0 || b_exp == 5'd0) begin
        {res_exp, res_mant} = 15'd0;
    end
    else begin
        res_exp  = exp;
        res_mant = (exp != 5'd0) ? mant : 10'b0;
    end

    o_res = {res_sign, res_exp, res_mant};
end

endmodule

