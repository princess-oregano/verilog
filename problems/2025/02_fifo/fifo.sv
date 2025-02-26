module fifo #(
    parameter int DATAW = 8,
    parameter int DEPTH = 4
)(
    input  logic                clk,
    input  logic                rst_n,

    input  logic [DATAW-1:0]    i_wr_data,
    input  logic                i_wr_en,
    input  logic                i_rd_en,

    output logic                o_wr_full,
    output logic                o_rd_empty,
    output logic [DATAW-1:0]    o_rd_data
);

localparam int ADDRW = $clog2(DEPTH);

logic [DATAW-1:0] mem [DEPTH-1:0];

logic [ADDRW:0] rd_ptr;
logic [ADDRW:0] wr_ptr;

assign o_wr_full  = (rd_ptr[ADDRW-1:0] == wr_ptr[ADDRW-1:0]) && (wr_ptr[ADDRW] != rd_ptr[ADDRW]);
assign o_rd_empty = (rd_ptr[ADDRW-1:0] == wr_ptr[ADDRW-1:0]) && (wr_ptr[ADDRW] == rd_ptr[ADDRW]);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        rd_ptr <= {ADDRW{1'b0}};
        wr_ptr <= {ADDRW{1'b0}};
        // Mem should also be zero? Or x?
    end
    else begin
        if (i_wr_en) begin
            mem [wr_ptr[ADDRW-1:0]] <= i_wr_data;
            wr_ptr <= wr_ptr + 1;
        end

        if (i_rd_en) begin
            o_rd_data <=  mem [rd_ptr[ADDRW-1:0]];
            rd_ptr <= rd_ptr + 1;
        end
    end
end

endmodule

