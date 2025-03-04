module fpga_top (
    input  wire CLK,   // CLOCK
    input  wire RSTN,  // BUTTON RST (NEGATIVE)
    output wire STCP,
    output wire SHCP,
    output wire DS,
    output wire OE
);

reg rst_n, RSTN_d;

always @(posedge CLK) begin
    rst_n <= RSTN_d;
    RSTN_d <= RSTN;
end

wire [3:0] anodes;
wire [7:0] segments;
wire [15:0] val;
wire timer_en;

timer timer(.clk(CLK), .rst_n(rst_n), .en(timer_en), .o_cnt(val));

clkdiv clkdiv(.clk(CLK), .rst_n(rst_n), .out(timer_en));

hex_display hex_display(CLK, rst_n, val, anodes, segments);

ctrl_74hc595 ctrl(
    .clk    (CLK                ),
    .rst_n  (rst_n              ),
    .i_data ({segments, anodes} ),
    .o_stcp (STCP               ),
    .o_shcp (SHCP               ),
    .o_ds   (DS                 ),
    .o_oe   (OE                 )
);

endmodule

