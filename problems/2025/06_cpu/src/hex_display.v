module hex_display #(
    parameter CNT_WIDTH = 14
)(
    input  wire         clk,
    input  wire         rst_n,

    input  wire [15:0]  i_data,
    input  wire         i_we,

    output wire  [3:0]  o_anodes,
    output reg   [7:0]  o_segments
);

reg  [CNT_WIDTH-1:0] cnt;
wire           [1:0] pos = cnt[CNT_WIDTH-1:CNT_WIDTH-2];

reg            [3:0] digit;

reg [15:0] tmp_buf;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        tmp_buf <= 16'd0;
    end
    else if (i_we) begin
        tmp_buf <= i_data;
    end
end

always @(*) begin
    case (pos)
        2'b00: digit = tmp_buf[3:0];
        2'b01: digit = tmp_buf[7:4];
        2'b10: digit = tmp_buf[11:8];
        2'b11: digit = tmp_buf[15:12];
    endcase
end

always @(posedge clk or negedge rst_n) begin
    cnt <= !rst_n ? {CNT_WIDTH{1'b0}} : (cnt + 1'b1);
end

assign o_anodes = ~(4'b0001 << pos);

always @(*) begin
    case (digit)
        4'h0: o_segments = 8'b11111100;
        4'h1: o_segments = 8'b01100000;
        4'h2: o_segments = 8'b11011010;
        4'h3: o_segments = 8'b11110010;
        4'h4: o_segments = 8'b01100110;
        4'h5: o_segments = 8'b10110110;
        4'h6: o_segments = 8'b10111110;
        4'h7: o_segments = 8'b11100000;
        4'h8: o_segments = 8'b11111110;
        4'h9: o_segments = 8'b11110110;
        4'hA: o_segments = 8'b11101110;
        4'hB: o_segments = 8'b00111110;
        4'hC: o_segments = 8'b10011100;
        4'hD: o_segments = 8'b01111010;
        4'hE: o_segments = 8'b10011110;
        4'hF: o_segments = 8'b10001110;
    endcase
end

endmodule

