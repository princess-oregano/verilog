module uart_rx #(
    parameter FREQ = 50_000_000,
    parameter RATE =  2_000_000
) (
    input  wire        clk,
    input  wire        rst_n,

    input  wire        i_rx,
    output wire  [7:0] o_data,
    output reg         o_vld
);

// Enabling Counter
wire en;
// Shifting Register
reg [7:0] data;
// FSM
reg [3:0] state, next_state;
// Negedge detector.
reg rx_d;
wire rx_fall = !i_rx & rx_d;
// Load counter.
wire cnt_load = rx_fall & (state == IDLE);

localparam [3:0] IDLE  = {1'b0, 3'd0},
                 START = {1'b0, 3'd1},
                 STOP  = {1'b0, 3'd2},
                 BIT0  = {1'b1, 3'd0},
                 BIT1  = {1'b1, 3'd1},
                 BIT2  = {1'b1, 3'd2},
                 BIT3  = {1'b1, 3'd3},
                 BIT4  = {1'b1, 3'd4},
                 BIT5  = {1'b1, 3'd5},
                 BIT6  = {1'b1, 3'd6},
                 BIT7  = {1'b1, 3'd7};

counter #(
    .CNT_WIDTH  ($clog2(FREQ/RATE)),
    .CNT_LOAD   (FREQ/RATE/2      ),
    .CNT_MAX    (FREQ/RATE-1    )
) cnt (
    .clk        (clk  ),
    .rst_n      (rst_n),
    .i_load     (cnt_load),
    .o_en       (en   )
);

wire data_en =  (state == IDLE ) ||
                (state == START) ||
                (state == STOP ) ? 1'b0 : en;

// Read data.
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data <= 8'b0;
    end else
    if (data_en) begin
        data <= {i_rx, data[7:1]};
    end
end

// FSM.
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        rx_d <= 1'b0;
    end
    else begin
        state <= next_state;
        rx_d <= i_rx;
    end
end

always @(*) begin
    case (state)
        IDLE:    next_state = rx_fall ? START                          : state;
        START:   next_state = en      ? (i_rx ? START : BIT0)          : state;
        BIT0:    next_state = en      ? BIT1                           : state;
        BIT1:    next_state = en      ? BIT2                           : state;
        BIT2:    next_state = en      ? BIT3                           : state;
        BIT3:    next_state = en      ? BIT4                           : state;
        BIT4:    next_state = en      ? BIT5                           : state;
        BIT5:    next_state = en      ? BIT6                           : state;
        BIT6:    next_state = en      ? BIT7                           : state;
        BIT7:    next_state = en      ? STOP                           : state;
        STOP:    next_state = en      ? IDLE                           : state;
        default: next_state = state;
    endcase
end

// Data output.
always @(*) begin
    if (en && i_rx && (state == STOP)) begin
        o_vld  <= 1'b1;
    end
    else begin
        o_vld  <= 1'b0;
    end
end

assign o_data = data;

endmodule

