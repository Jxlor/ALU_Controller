class alu_ctrl_item extends uvm_sequence_item ;
    rand logic [2:0] funct3;
    rand logic [6:0] opcode ;
    rand logic funct7_5 ;
    rand logic [31:0] raw_imm ;
    logic [3:0] alu_op ;
    constraint c_opcode {
      opcode dist {
        `OPCODE_AUIPC       := 5,
        `OPCODE_JAL         := 5,
        `OPCODE_JALR        := 5,
        `OPCODE_BRANCH      := 10,
        `OPCODE_LOAD        := 8,
        `OPCODE_STORE       := 8,
        `OPCODE_ITYPE       := 15,
        `OPCODE_RTYPE       := 15,
        `OPCODE_ENVIRONMENT := 5
      };
    }
    `uvm_object_utils_begin(alu_ctrl_item)
        `uvm_field_int(funct3,   UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(opcode,   UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(funct7_5, UVM_ALL_ON)
        `uvm_field_int(raw_imm,  UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(alu_op,   UVM_ALL_ON | UVM_HEX)
      `uvm_object_utils_end
  
      function new(string name = "alu_ctrl_item");
        super.new(name);
      endfunction
    endclass
