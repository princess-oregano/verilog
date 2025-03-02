module lfsr #(
    parameter int WIDTH = 8
) (
    input  logic             clk,
    input  logic             rst_n,

    output logic [WIDTH-1:0] o_out
);

logic [WIDTH-1:0] r;

assign o_out = r;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        r <= {WIDTH{1'b0}};
    end
    else begin
        if (!r) begin
            r[0] <= ~r[0];
        end
        else begin
            // Fibonacci + polynomial x^8 + x^6 + x^5 + x^4 + 1
            r <= {r[6:0], (r[7] ^ r[5] ^ r[4] ^ r[3]) & 1'b1};
        end
    end
end

endmodule

