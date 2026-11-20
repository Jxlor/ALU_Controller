module ALU_Ctrl_tb;
  logic clk = 0;
  always #5 clk = ~clk;

  logic [31:0] instr;
  logic [3:0]  alu_op;

  alu_ctrl dut (
    .instr  (instr),
    .alu_op (alu_op)
  );

  bind alu_ctrl alu_ctrl_if vif_inst(.clk(ALU_Ctrl_tb.clk));

  initial begin
    uvm_config_db#(virtual alu_ctrl_if)::set(null, "*", "vif", dut.vif_inst);
    run_test("alu_ctrl_test");
  end
endmodule
