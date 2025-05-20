module fpga_top(
    input  wire CLK,
    input  wire RSTN,

    input  wire RXD,
    output wire TXD,
    output wire [11:0] LED,

    output wire STCP,
    output wire SHCP,
    output wire DS,
    output wire OE
);

localparam RATE = 2_000_000;

assign LED[0] = RXD;
assign LED[4] = TXD;
assign {LED[11:5], LED[3:1]}  = ~10'b0;

wire [3:0] anodes;
wire [7:0] segments;

// RSTN synchronizer
reg rst_n, RSTN_d;

always @(posedge CLK) begin
    rst_n <= RSTN_d;
    RSTN_d <= RSTN;
end

reg i_rx, RXD_d;
always @(posedge CLK) begin
    i_rx  <= RXD_d;
    RXD_d <= RXD;
end

wire       d_vld;
wire [7:0] d;

// uart_tx #(
//     .FREQ       (50_000_000),
//     .RATE       (      RATE)
// ) u_uart_tx (
//     .clk        (CLK       ),
//     .rst_n      (rst_n     ),
//     .i_data     (d         ),
//     .i_vld      (d_vld     ),
//     .o_tx       (TXD       )
// );

uart_rx #(
    .FREQ       (50_000_000),
    .RATE       (      RATE)
)
uart_rx (
    .clk        (CLK    ),
    .rst_n      (rst_n  ),
    .i_rx       (i_rx   ),
    .o_data     (d      ),
    .o_vld      (d_vld  )
);

hex_display hex_display(
    .clk(CLK),
    .rst_n(rst_n),
    .i_data(d),
    .o_anodes(anodes),
    .o_segments(segments)
);

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

