module mux #(
    parameter int WIDTH = 8
) (
    input wire  [WIDTH-1:0] i_a,
    input wire  [WIDTH-1:0] i_b,
    input wire  [WIDTH-1:0] i_c,
    input wire  [WIDTH-1:0] i_d,
    input logic  [1:0]       i_sel,

    output logic [WIDTH-1:0] o_out
);

always @(*) begin
    case (i_sel)
        2'b00: o_out = i_a;
        2'b01: o_out = i_b;
        2'b10: o_out = i_c;
        2'b11: o_out = i_d;
    endcase
end

endmodule

