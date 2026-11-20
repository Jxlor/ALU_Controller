class alu_ctrl_monitor extends uvm_monitor;
  `uvm_component_utils(alu_ctrl_monitor)
  virtual alu_ctrl_if vif;
  uvm_analysis_port #(alu_ctrl_item) ap;

  function new(string name = "alu_ctrl_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap = new("ap", this);
    if (!uvm_config_db#(virtual alu_ctrl_if)::get(this, "", "vif", vif))
      `uvm_fatal("NO_VIF", "Khong tim thay alu_ctrl_if cho Monitor")
  endfunction

  task run_phase(uvm_phase phase);
    alu_ctrl_item item;
    forever begin
      @(vif.mon_cb);
      item = alu_ctrl_item::type_id::create("item");
      item.instr  = vif.mon_cb.instr;
      item.alu_op = alu_op_e'(vif.mon_cb.alu_op);
      ap.write(item);
    end
  endtask
endclass
