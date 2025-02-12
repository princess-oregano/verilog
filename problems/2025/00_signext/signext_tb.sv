`timescale 1ns/1ps

module signext_tb;

localparam int N = 4;
localparam int M = 6;

logic [N-1:0] init_val = 0;
logic [M-1:0]  ext_val;

signext #(
    .N(N),
    .M(M)
) signext_inst (
    .i_x(init_val),
    .o_y(ext_val)
);

always begin
    init_val = init_val + 1;
    #1;
    if ({{M-N{init_val[N-1]}}, init_val} == ext_val) begin
        //$display("OKAY val = %b, ext = %b", {{M-N{init_val[N-1]}}, init_val}, ext_val);
    end else begin
        $display("NOT OKAY val = %b, ext = %b", {{M-N{init_val[N-1]}}, init_val}, ext_val);
    end

    if (init_val == (2**N - 1))
        $finish();
end

initial begin
    $dumpvars;
end

endmodule
