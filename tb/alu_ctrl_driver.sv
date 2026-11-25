class alu_ctrl_driver extends uvm_driver #(alu_ctrl_item);
  `uvm_component_utils(alu_ctrl_driver)
  virtual alu_ctrl_if vif;

  function new(string name = "alu_ctrl_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual alu_ctrl_if)::get(this, "", "vif", vif))
      `uvm_fatal("NO_VIF", "Khong tim thay alu_ctrl_if cho Driver")
  endfunction

  task run_phase(uvm_phase phase);
    vif.drv_cb.opcode   <= 7'b0;
    vif.drv_cb.funct3   <= 3'b0;
    vif.drv_cb.funct7_5 <= 1'b0;
    vif.drv_cb.imm_10   <= 1'b0;

    forever begin
      seq_item_port.get_next_item(req);
      @(vif.drv_cb);
      vif.drv_cb.opcode   <= req.opcode;
      vif.drv_cb.funct3   <= req.funct3;
      vif.drv_cb.funct7_5 <= req.funct7_5;
      vif.drv_cb.imm_10   <= req.imm_10;
      seq_item_port.item_done();
    end
  endtask
endclass
