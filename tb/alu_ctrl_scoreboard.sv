class alu_ctrl_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(alu_ctrl_scoreboard)
  uvm_analysis_imp #(alu_ctrl_item, alu_ctrl_scoreboard) item_export;

  ALU_Ctrl_model model;
  int pass_cnt = 0, fail_cnt = 0;

  function new(string name = "alu_ctrl_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_export = new("item_export", this);
    model       = new();
  endfunction

  function void write(alu_ctrl_item item);
    logic [3:0] exp_op;
    model.set_inputs(item.opcode, item.funct3, item.funct7_5, item.imm_10);
    exp_op = model.get_alu_op_expected();

    if (item.alu_op === exp_op) begin
      pass_cnt++;
    end else begin
      fail_cnt++;
      `uvm_error("ALU_CTRL_ERR", $sformatf("Opc=%b f3=%b f7_5=%b imm10=%b | Exp=%b | Act=%b",
                 item.opcode, item.funct3, item.funct7_5, item.imm_10, exp_op, item.alu_op))
    end
  endfunction

  function void report_phase(uvm_phase phase);
    `uvm_info("SCB_REPORT", $sformatf("ALU_CTRL SUMMARY: PASS=%0d, FAIL=%0d",
              pass_cnt, fail_cnt), UVM_LOW)
  endfunction
endclass
