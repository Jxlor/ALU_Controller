interface alu_ctrl_if(input logic clk);
  logic [31:0] instr;
  logic [3:0]  alu_op;

  clocking drv_cb @(posedge clk);
    output instr;
  endclocking

  clocking mon_cb @(negedge clk);
    input instr;
    input alu_op;
  endclocking
endinterface
