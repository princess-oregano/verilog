module clkdiv #(
    parameter F_0 = 50_000_000,
    parameter F_1 = 10
)(
    input  wire clk,
    input  wire rst_n,

    output wire out
);

localparam CNT_WIDTH = $clog2(F_0/F_1);

reg [CNT_WIDTH-1:0] cnt;

assign out = (cnt == 0);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
       cnt <= {CNT_WIDTH{1'b0}};
    end
    else begin
        if (cnt == F_0/F_1) begin
            cnt <= {CNT_WIDTH{1'b0}};
        end
        else begin
            cnt <= cnt + 1'b1;
        end
    end
end

endmodule

