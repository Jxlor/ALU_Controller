class alu_ctrl_env extends uvm_env;
  `uvm_component_utils(alu_ctrl_env)
  alu_ctrl_agent      agent;
  alu_ctrl_scoreboard scb;

  function new(string name = "alu_ctrl_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = alu_ctrl_agent::type_id::create("agent", this);
    scb   = alu_ctrl_scoreboard::type_id::create("scb", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agent.mon.ap.connect(scb.item_export);
  endfunction
endclass
