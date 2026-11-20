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

class alu_ctrl_test extends uvm_test;
  `uvm_component_utils(alu_ctrl_test)
  alu_ctrl_env env;

  function new(string name = "alu_ctrl_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(uvm_active_passive_enum)::set(this, "env.agent", "is_active", UVM_ACTIVE);
    env = alu_ctrl_env::type_id::create("env", this);
  endfunction

  task run_phase(uvm_phase phase);
    alu_ctrl_vplan_seq seq = alu_ctrl_vplan_seq::type_id::create("seq");
    phase.raise_objection(this);
    seq.start(env.agent.sqr);
    #20;
    phase.drop_objection(this);
  endtask
endclass
