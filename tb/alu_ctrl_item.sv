class alu_ctrl_item extends uvm_sequence_item;
  rand logic [6:0] opcode;
  rand logic [2:0] funct3;
  rand logic       funct7_5;
  rand logic       imm_10;
       logic [3:0] alu_op;

  `uvm_object_utils_begin(alu_ctrl_item)
    `uvm_field_int(opcode,   UVM_ALL_ON | UVM_BIN)
    `uvm_field_int(funct3,   UVM_ALL_ON | UVM_BIN)
    `uvm_field_int(funct7_5, UVM_ALL_ON | UVM_BIN)
    `uvm_field_int(imm_10,   UVM_ALL_ON | UVM_BIN)
    `uvm_field_int(alu_op,   UVM_ALL_ON | UVM_BIN)
  `uvm_object_utils_end

  constraint c_valid_ctrl {
    opcode dist {
      `OPCODE_AUIPC       := 8,
      `OPCODE_JAL         := 8,
      `OPCODE_JALR        := 8,
      `OPCODE_BRANCH      := 15,
      `OPCODE_LOAD        := 10,
      `OPCODE_STORE       := 10,
      `OPCODE_ITYPE       := 15,
      `OPCODE_RTYPE       := 15,
      `OPCODE_ENVIRONMENT := 12,
      7'b0101010          := 3,
      7'b0001000          := 3 // Invalid opcode test
    };
    if (opcode == `OPCODE_BRANCH)
      funct3 inside {`BRANCH_BEQ, `BRANCH_BNE, `BRANCH_BLT, `BRANCH_BGE, `BRANCH_BLTU, `BRANCH_BGEU, 3'b010};
    if (opcode == `OPCODE_ENVIRONMENT)
      funct3 inside {`CSR_CSRRW, `CSR_CSRRS, `CSR_CSRRC, `CSR_CSRRWI, `CSR_CSRRSI, `CSR_CSRRCI, 3'b000};
  }

  function new(string name = "alu_ctrl_item");
    super.new(name);
  endfunction
endclass
