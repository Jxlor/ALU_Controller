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
    alu_op_e exp_op;
    model.set_instr(item.instr);
    exp_op = model.get_alu_op_expected();

    if (item.alu_op === exp_op) begin
      pass_cnt++;
    end else begin
      fail_cnt++;
      `uvm_error("ALU_CTRL_ERR", $sformatf("Instr=%h | Expected=%s | Actual=%s",
                 item.instr, exp_op.name(), item.alu_op.name()))
    end
  endfunction

  function void report_phase(uvm_phase phase);
    `uvm_info("SCB_REPORT", $sformatf("ALU_CTRL SUMMARY: PASS=%0d, FAIL=%0d",
              pass_cnt, fail_cnt), UVM_LOW)
  endfunction
endclass
