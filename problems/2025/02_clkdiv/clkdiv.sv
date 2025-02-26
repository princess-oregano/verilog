module clkdiv #(
    parameter int F_0 = 50_000_000,
    parameter int F_1 = 9_600
)(
    input  logic clk,
    input  logic rst_n,

    output logic out
);

localparam int CNT_WIDTH = $clog2(F_0/F_1);

logic [CNT_WIDTH-1:0] cnt;

assign out = &cnt;

always @(posedge clk or negedge rst_n) begin
   if (!rst_n)
       cnt <= {CNT_WIDTH{1'b0}};
   else
       cnt <= cnt + 1'b1;
end

endmodule

