module timer #(
    parameter COUNT = 600
)(
    input  wire             clk,
    input  wire             rst_n,
    input  wire             en,

    output reg [WIDTH-1:0]  o_cnt
);

localparam WIDTH = $clog2(COUNT);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        o_cnt <= COUNT;
    end
    else if (en) begin
        if (o_cnt)
            o_cnt <= o_cnt - 1;
        else
            o_cnt <= COUNT;
    end
end

endmodule

