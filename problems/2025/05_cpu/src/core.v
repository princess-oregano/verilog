`include "alu.vh"
`include "cmp.vh"
`include "core.vh"

module core (
    input wire clk,
    input wire rst_n,

    // Names and sizes were taken from cpu_top.v
    input  wire [31:0] i_instr_data,
    output wire [29:0] o_instr_addr,

    output wire [29:0] o_mem_addr,
    output wire [31:0] o_mem_data,
    output wire        o_mem_we,
    output wire  [3:0] o_mem_mask,
    input  wire [31:0] i_mem_data
);

/////////////////////////// Parse instruction. ///////////////////////////////

// Short alias.
wire [31:0] instr  = i_instr_data;
// Operands.
wire  [4:0] rd     = instr[11:7];
wire  [4:0] rs1    = instr[19:15];
wire  [4:0] rs2    = instr[24:20];
// Immediates.
wire [31:0] uimm   = {instr[31:12], {12{1'b0}}};
wire [31:0] bimm   = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
wire [31:0] jimm   = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
wire [31:0] iimm   = {{20{instr[31]}}, instr[31:20]};
wire [31:0] simm   = {{20{instr[31]}}, instr[31:25], instr[11:7]};


////////////////////////////// Auxilary. /////////////////////////////////////

// ALU
wire  [`ALUOP_WIDTH-1:0] alu_op;
wire               [1:0] alu_sel1;
wire               [1:0] alu_sel2;
reg               [31:0] alu_src1;
reg               [31:0] alu_src2;
wire              [31:0] alu_res;

// Branch Unit
wire [`CMPOP_WIDTH-1:0] cmp_op;
wire                    cmp_res;
wire                    branch;
wire                    jump;

// Writeback.
wire [31:0] load_data;
reg  [31:0] wb_data;
wire [1:0]  wb_sel;
wire        wb_en;
wire        store;
wire [2:0]  lsu_op;

wire [31:0] src1;
wire [31:0] src2;


////////////////////////////// PC logic. /////////////////////////////////////

reg  [29:0] pc;     // 30 bits because pc % 4 = 0
wire [29:0] pc_inc = pc + 30'd1;
wire [29:0] pc_next;

assign o_instr_addr = pc;

wire taken = jump || (branch && cmp_res);
assign pc_next = taken ? alu_res[31:2] : pc_inc;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pc <= 30'b0;
    end
    else begin
        pc <= pc_next;
    end
end

////////////////////////////// Multiplexers. /////////////////////////////////

always @(*) begin
    case (alu_sel1)
        `ALUSEL1_UIMM: alu_src1 = uimm;
        `ALUSEL1_BIMM: alu_src1 = bimm;
        `ALUSEL1_JIMM: alu_src1 = jimm;
        `ALUSEL1_SRC1: alu_src1 = src1;
    endcase
end

always @(*) begin
    case (alu_sel2)
        `ALUSEL2_SRC2: alu_src2 = src2;
        `ALUSEL2_IIMM: alu_src2 = iimm;
        `ALUSEL2_SIMM: alu_src2 = simm;
        `ALUSEL2_PC  : alu_src2 = {pc, 2'b0};
    endcase
end

always @(*) begin
    case (wb_sel)
        `WBSEL_UIMM  : wb_data = uimm;
        `WBSEL_ALURES: wb_data = alu_res;
        `WBSEL_LSU   : wb_data = load_data;
        `WBSEL_PCNEXT: wb_data = {pc_inc, 2'b0};
    endcase
end

///////////////////////// Connect modules. ///////////////////////////////////

alu alu(
    .i_a   (alu_src1),
    .i_b   (alu_src2),
    .i_op  (alu_op  ),
    .o_res (alu_res )
);

cmp cmp(
    .i_a     (src1   ),
    .i_b     (src2   ),
    .i_op    (cmp_op ),
    .o_res   (cmp_res)
);

regfile regfile(
    .clk        (clk    ),
    .i_rd_addr1 (rs1    ),
    .o_rd_data1 (src1   ),
    .i_rd_addr2 (rs2    ),
    .o_rd_data2 (src2   ),
    .i_wr_addr  (rd     ),
    .i_wr_data  (wb_data),
    .i_wr_en    (wb_en  )
);

lsu lsu(
    .i_store    (store     ),
    .i_addr     (alu_res   ),
    .i_st_data  (src2      ),
    .i_op       (lsu_op    ),
    .o_ld_data  (load_data ),

    .o_mem_we   (o_mem_we  ),
    .o_mem_addr (o_mem_addr),
    .o_mem_data (o_mem_data),
    .o_mem_mask (o_mem_mask),
    .i_mem_data (i_mem_data)
);

control control(
    .i_instr      (i_instr_data),
    .o_aluop      (alu_op      ),
    .o_alusel1    (alu_sel1    ),
    .o_alusel2    (alu_sel2    ),
    .o_cmpop      (cmp_op      ),
    .o_branch     (branch      ),
    .o_jump       (jump        ),
    .o_wb_sel     (wb_sel      ),
    .o_wb_en      (wb_en       ),
    .o_store      (store       ),
    .o_lsu_op     (lsu_op      )
);

endmodule

