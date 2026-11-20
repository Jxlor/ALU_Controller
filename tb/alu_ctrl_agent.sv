class alu_ctrl_agent extends uvm_agent;
  `uvm_component_utils(alu_ctrl_agent)
  uvm_sequencer #(alu_ctrl_item) sqr;
  alu_ctrl_driver                drv;
  alu_ctrl_monitor               mon;
  alu_ctrl_cov                   cov;

  function new(string name = "alu_ctrl_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon = alu_ctrl_monitor::type_id::create("mon", this);
    cov = alu_ctrl_cov::type_id::create("cov", this);
    if (get_is_active() == UVM_ACTIVE) begin
      sqr = uvm_sequencer#(alu_ctrl_item)::type_id::create("sqr", this);
      drv = alu_ctrl_driver::type_id::create("drv", this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    mon.ap.connect(cov.analysis_export);
    if (get_is_active() == UVM_ACTIVE)
      drv.seq_item_port.connect(sqr.seq_item_export);
  endfunction
endclass
