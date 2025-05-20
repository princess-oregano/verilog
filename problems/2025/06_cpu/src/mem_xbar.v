module mem_xbar #(  // Memory cross-bar.
    // Names and sizes are taken from cpu_top.v
    parameter DATA_START = `XBAR_DATA_START,
    parameter DATA_LIMIT = `XBAR_DATA_LIMIT,
    parameter MMIO_START = `XBAR_MMIO_START,
    parameter MMIO_LIMIT = `XBAR_MMIO_LIMIT
)(
    input  wire        clk,

    input  wire [29:0] i_addr,
    input  wire [31:0] i_data,
    input  wire        i_wren,
    input  wire  [3:0] i_mask,
    output reg  [31:0] o_data,

    output reg  [29:0] o_dmem_addr,
    output reg  [31:0] o_dmem_data,
    output reg         o_dmem_wren,
    output reg   [3:0] o_dmem_mask,
    input  wire [31:0] i_dmem_data,

    output reg  [29:0] o_mmio_addr,
    output reg  [31:0] o_mmio_data,
    output reg         o_mmio_wren,
    output reg   [3:0] o_mmio_mask,
    input  wire [31:0] i_mmio_data
);

always @(*) begin
    if (MMIO_START <= i_addr && i_addr < MMIO_LIMIT) begin
        o_data      = i_mmio_data;

        // Disable DMEM.
        o_dmem_wren = 1'b0;
        o_dmem_data = 32'dX;
        o_dmem_addr = 30'dX;
        o_dmem_mask = 4'dX;

        // Enable MMIO.
        o_mmio_wren = 1'b1;
        o_mmio_data = i_data;
        o_mmio_addr = i_addr - MMIO_START;
        o_mmio_mask = i_mask;
    end
    else if (DATA_START <= i_addr && i_addr < DATA_LIMIT) begin
        o_data      = i_dmem_data;

        // Disable MMIO.
        o_mmio_wren = 1'b0;
        o_mmio_data = 32'dX;
        o_mmio_addr = 30'dX;
        o_mmio_mask = 4'dX;

        // Enable DMEM.
        o_dmem_wren = 1'b1;
        o_dmem_data = i_data;
        o_dmem_addr = i_addr - DATA_START;
        o_dmem_mask = i_mask;
    end
    else begin
        // Invalid addr -> disable all.
        o_data      = 32'dX;

        o_mmio_wren = 1'b0;
        o_mmio_data = 32'dX;
        o_mmio_addr = 30'dX;
        o_mmio_mask = 4'dX;

        o_dmem_wren = 1'b0;
        o_dmem_data = 32'dX;
        o_dmem_addr = 30'dX;
        o_dmem_mask = 4'dX;
    end
end

endmodule

