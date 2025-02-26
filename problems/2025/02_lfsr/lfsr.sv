module lfsr #(
    parameter int WIDTH = 8,
    parameter logic [WIDTH-1:0] INITIAL_FILL = 8'b00000001,
    parameter logic [WIDTH-1:0] TAPS = 8'b10111000
) (
    input  logic             clk,
    input  logic             rst_n,

    output logic [WIDTH-1:0] o_out
);

logic [WIDTH-1:0] r;

assign o_out = r;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        r <= INITIAL_FILL;
    end
    else begin
        // Fibonacci + polynomial x^8 + x^6 + x^5 + x^4 + 1
        r <= {r[6:0], (r[7] ^ r[5] ^ r[4] ^ r[3]) & 1'b1};
    end
end

endmodule

