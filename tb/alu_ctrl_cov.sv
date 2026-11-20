class alu_ctrl_cov extends uvm_subscriber #(alu_ctrl_item);
  `uvm_component_utils(alu_ctrl_cov)
  alu_ctrl_item tr;

  covergroup cg_alu_ctrl;
    cp_opcode: coverpoint tr.instr[6:0] {
      bins r_type  = {7'b0110011};
      bins i_arith = {7'b0010011};
      bins load    = {7'b0000011};
      bins store   = {7'b0100011};
      bins branch  = {7'b1100011};
      bins lui     = {7'b0110111};
      bins auipc   = {7'b0010111};
    }
    cp_alu_op: coverpoint tr.alu_op {
      bins all_ops[] = {[ALU_ADD:ALU_PASS_B]};
    }
    cp_instr_bits: coverpoint tr.instr {
      wildcard bins bit_ones  = {32'hFFFF_FFFF};
      wildcard bins bit_zeros = {32'h0000_0000};
    }
  endgroup

  function new(string name = "alu_ctrl_cov", uvm_component parent = null);
    super.new(name, parent);
    cg_alu_ctrl = new();
  endfunction

  function void write(alu_ctrl_item t);
    tr = t;
    cg_alu_ctrl.sample();
  endfunction
endclass
