// F0/F1 stage border is at sign-magnitude adder
//
// Registers on border have f_ prefix.

module fp16add_pipe (
    input wire        clk,

    input wire [15:0] i_a,
    input wire [15:0] i_b,

    output reg [15:0] o_res
);

// Parse according to fp16 format.
// Apply DAZ -- denormal-as-zero.
wire       a_sign = i_a[15];
wire [4:0] a_exp  = i_a[14:10];
wire [9:0] a_mant = (a_exp == 5'b0) ? 10'b0 : i_a[9:0];

wire       b_sign = i_b[15];
wire [4:0] b_exp  = i_b[14:10];
wire [9:0] b_mant = (b_exp == 5'b0) ? 10'b0 : i_b[9:0];

// Result.
reg       res_sign;
reg [4:0] res_exp;
reg [9:0] res_mant;

// Result of calculation without handling NaN/Inf/Zero/FTZ.
wire       sign;
wire [4:0] exp;
wire [9:0] mant;

// Exponent difference
wire [5:0] exp_diff, exp_absdiff;
assign exp_diff = a_exp - b_exp;

// Swap.
wire swap = exp_diff[5] || ((exp_diff == 6'b0) && (a_mant < b_mant));
assign exp_absdiff = swap ? -exp_diff : exp_diff;

wire        x_sign = swap ? b_sign : a_sign;
wire [4:0]  x_exp  = swap ? i_b[14:10] : i_a[14:10];
wire [42:0] x_mant = swap ? {2'b01, b_mant, 31'h0} : {2'b01, a_mant, 31'h0};

wire        y_sign = swap ? a_sign : b_sign;
wire [4:0]  y_exp  = swap ? i_a[14:10] : i_b[14:10];
wire [42:0] y_mant = swap ? {2'b01, a_mant, 31'h0} >> exp_absdiff[4:0] : {2'b01, b_mant, 31'h0} >> exp_absdiff[4:0];

// Sign-magnitude adder -- F0/1 border.

reg [42:0] f_sum_mant;
reg [5:0]  f_sum_exp ;
reg        f_sum_sign;

always @(*) begin
    f_sum_mant = (x_sign ^ y_sign) ? x_mant - y_mant : x_mant + y_mant;
    f_sum_exp  = {1'b0, x_exp};
    f_sum_sign = x_sign;
end

reg [42:0] sum_mant;
reg [5:0]  sum_exp ;
reg        sum_sign;

always @(posedge clk) begin
    sum_mant <= f_sum_mant;
    sum_exp  <= f_sum_exp ;
    sum_sign <= f_sum_sign;
end

// Leading one detector.
reg [3:0] pos;
always @(*) begin
     casez (sum_mant[42:30])
        13'b1????????????: pos = 'd01;
        13'b01???????????: pos = 'd02;
        13'b001??????????: pos = 'd03;
        13'b0001?????????: pos = 'd04;
        13'b00001????????: pos = 'd05;
        13'b000001???????: pos = 'd06;
        13'b0000001??????: pos = 'd07;
        13'b00000001?????: pos = 'd08;
        13'b000000001????: pos = 'd09;
        13'b0000000001???: pos = 'd10;
        13'b00000000001??: pos = 'd11;
        13'b000000000001?: pos = 'd12;
        13'b0000000000001: pos = 'd13;
        13'b0000000000000: pos = 'd14;
    endcase
end

wire [42:0] mant_nnorm;

assign sign       = sum_sign;
assign exp        = (pos == 'd14) ? 6'd0 : sum_exp - pos + 2;
assign mant_nnorm = sum_mant << pos;
assign mant       = mant_nnorm[42:33];

// Calculate final result.
// Possible cases:
// a      | b      | Res
// Zero   | Zero   | Zero
//        | Inf    | Inf
//        | NaN    | NaN
//        | Normal | Normal (b)
// Inf    | Zero   | NaN
//        | Inf    | Inf
//        | NaN    | NaN
//        | Normal | Inf
// NaN    | Zero   | NaN
//        | Inf    | NaN
//        | NaN    | NaN
//        | Normal | NaN
// Normal | Zero   | Zero (a)
//        | Inf    | Inf
//        | NaN    | NaN
//        | Normal | Normal
always@(*) begin
    if ((a_exp == 5'b11111 && a_mant != 10'h0)
     || (b_exp == 5'b11111 && b_mant != 10'h0)) begin
        res_sign = 1'b0;
        res_exp = 5'b11111;
        res_mant = 10'h77;
    end
    else if ((a_exp == 5'b11111 && a_mant == 10'h0)
          && (b_exp == 5'b11111 && b_mant == 10'h0)) begin
        res_sign = 1'b0;
        res_exp = (a_sign ^ b_sign) ? 5'b00000 : 5'b11111;
        res_mant = 10'h0;
    end
    else if (a_exp == 5'b00000) begin
        {res_sign, res_exp, res_mant} = i_b;
    end
    else if (b_exp == 5'b00000) begin
        {res_sign, res_exp, res_mant} = i_a;
    end
    else begin
        {res_sign, res_exp, res_mant} = {sign, exp, mant};
    end

    o_res = {res_sign, res_exp, res_mant};
end

endmodule

