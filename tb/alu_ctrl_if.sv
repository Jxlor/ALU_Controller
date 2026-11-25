interface alu_ctrl_if(input logic clk);
  logic [6:0] opcode;
  logic [2:0] funct3;
  logic       funct7_5;
  logic       imm_10;
  logic [3:0] alu_op;

  clocking drv_cb @(posedge clk);
    output opcode, funct3, funct7_5, imm_10;
  endclocking

  clocking mon_cb @(negedge clk);
    input opcode, funct3, funct7_5, imm_10, alu_op;
  endclocking
endinterface
