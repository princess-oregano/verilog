module lfsr #(
    parameter WIDTH = 16
) (
    input  wire             clk,
    input  wire             rst_n,
    input  wire             en,

    output wire [WIDTH-1:0] o_out
);

reg [WIDTH-1:0] r;

assign o_out = r;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        r <= {WIDTH{1'b0}};
    end
    else begin
        if (!r) begin
            r[0] <= ~r[0];
        end
        else if (en) begin
            // Fibonacci + TAPS 1101000000001000
            r <= {r[14:0], (r[15] ^ r[14] ^ r[13] ^ r[3]) & 1'b1};
        end
    end
end

endmodule

