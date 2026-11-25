class alu_ctrl_cov extends uvm_subscriber #(alu_ctrl_item);
  `uvm_component_utils(alu_ctrl_cov)
  alu_ctrl_item tr;

  covergroup cg_alu_ctrl;
    cp_opcode: coverpoint tr.opcode {
      bins auipc   = {`OPCODE_AUIPC};
      bins jal     = {`OPCODE_JAL};
      bins jalr    = {`OPCODE_JALR};
      bins branch  = {`OPCODE_BRANCH};
      bins load    = {`OPCODE_LOAD};
      bins store   = {`OPCODE_STORE};
      bins itype   = {`OPCODE_ITYPE};
      bins rtype   = {`OPCODE_RTYPE};
      bins csr_env = {`OPCODE_ENVIRONMENT};
      bins invalid = default;
    }
    cp_funct3: coverpoint tr.funct3;
    cp_f7_5:   coverpoint tr.funct7_5;
    cp_imm10:  coverpoint tr.imm_10;
    cp_alu_op: coverpoint tr.alu_op {
      bins op_add  = {`ALU_OP_ADD};
      bins op_sub  = {`ALU_OP_SUB};
      bins op_sll  = {`ALU_OP_SLL};
      bins op_slt  = {`ALU_OP_SLT};
      bins op_sltu = {`ALU_OP_SLTU};
      bins op_xor  = {`ALU_OP_XOR};
      bins op_srl  = {`ALU_OP_SRL};
      bins op_sra  = {`ALU_OP_SRA};
      bins op_or   = {`ALU_OP_OR};
      bins op_and  = {`ALU_OP_AND};
      bins op_bpa  = {`ALU_OP_BPA};
      bins op_abj  = {`ALU_OP_ABJ};
      bins op_nop  = {`ALU_OP_NOP};
    }
    cross_op_f3: cross cp_opcode, cp_funct3{
      // Loáº¡i bá» cÃ¡c lá»nh khÃ´ng cÃ³ trÆ°á»ng funct3 trong kiáº¿n trÃºc RISC-V (U-type, J-type)
      ignore_bins no_funct3_type = binsof(cp_opcode) intersect {
        `OPCODE_AUIPC, `OPCODE_JAL
      };
      // Loáº¡i bá» 2 giÃ¡ trá» funct3 bá» cáº¥m trong constraint cá»§a BRANCH vÃ  ENVIRONMENT
      ignore_bins branch_unused  = binsof(cp_opcode) intersect {`OPCODE_BRANCH} && binsof(cp_funct3) intersect {3'b011};
      ignore_bins csr_unused     = binsof(cp_opcode) intersect {`OPCODE_ENVIRONMENT} && binsof(cp_funct3) intersect {3'b100};
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
