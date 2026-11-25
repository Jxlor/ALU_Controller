`timescale 1ns/1ps
`include "uvm_macros.svh"
import uvm_pkg::*;
`include "modules/headers/alu_op.vh"
`include "modules/headers/branch.vh"
`include "modules/headers/csr.vh"
`include "modules/headers/itype.vh"
`include "modules/headers/load.vh"
`include "modules/headers/opcode.vh"
`include "modules/headers/rtype.vh"
`include "modules/headers/store.vh"
module ALU_Controller_tb;
  logic clk = 0;
  always #5 clk = ~clk;

  alu_ctrl_if vif(clk) ;

  // Khá»i táº¡o DUT ALU_Controller nguyÃªn báº£n (khÃ´ng sá»­a RTL)
  ALU_Controller alu_controller (
    .opcode   (vif.opcode),
    .funct3   (vif.funct3),
    .funct7_5 (vif.funct7_5),
    .imm_10   (vif.imm_10),
    .alu_op   (vif.alu_op)
  );

  // Tá»± Äá»ng ná»i cÃ¡c biáº¿n trÃ¹ng tÃªn vÃ o interface báº±ng bind
  
  initial begin
    $dumpfile("testbenches/results/waveforms/ALU_Controller_tb_result.vcd");
    $dumpvars(0, alu_controller);

    uvm_config_db#(virtual alu_ctrl_if)::set(null, "*", "vif", vif) ;
    run_test("alu_ctrl_test");
  end
endmodule
