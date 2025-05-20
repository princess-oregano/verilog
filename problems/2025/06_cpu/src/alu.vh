`ifndef ALU
`define ALU

`define ALUOP_WIDTH 4
`define ALU_X       `ALUOP_WIDTH'dX
`define ALU_ADD     `ALUOP_WIDTH'd0
`define ALU_SUB     `ALUOP_WIDTH'd1
`define ALU_SLL     `ALUOP_WIDTH'd2
`define ALU_SLT     `ALUOP_WIDTH'd3
`define ALU_SLTU    `ALUOP_WIDTH'd4
`define ALU_XOR     `ALUOP_WIDTH'd5
`define ALU_SRL     `ALUOP_WIDTH'd6
`define ALU_SRA     `ALUOP_WIDTH'd7
`define ALU_OR      `ALUOP_WIDTH'd8
`define ALU_AND     `ALUOP_WIDTH'd9

`endif // ALU

