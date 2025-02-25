module shiftreg #(
    parameter int WIDTH = 8
) (
    input  logic             clk,

    input  logic             i_bit,
    input  logic [WIDTH-1:0] i_fill,
    input  logic             i_fill_en,

    output logic             o_out
);

logic [WIDTH-1:0] r;

assign o_out = r[WIDTH-1];

always @(posedge clk) begin
    if (i_fill_en) begin
        r <= i_fill;
    end else begin
        r <= {r[WIDTH-2:0], i_bit};
    end
end

endmodule

