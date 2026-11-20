class alu_ctrl_item extends uvm_sequence_item;
  rand logic [31:0] instr;
       alu_op_e     alu_op;

  `uvm_object_utils_begin(alu_ctrl_item)
    `uvm_field_int(instr, UVM_ALL_ON | UVM_HEX)
    `uvm_field_enum(alu_op_e, alu_op, UVM_ALL_ON)
  `uvm_object_utils_end

  constraint c_valid_opcode {
    instr[6:0] inside {
      7'b0110011, 7'b0010011, 7'b0000011,
      7'b0100011, 7'b1100011, 7'b0110111, 7'b0010111
    };
    if (instr[6:0] == 7'b0110011 && !(instr[14:12] inside {3'b000, 3'b101}))
      instr[31:25] == 7'b0;
    if (instr[6:0] == 7'b0010011 && instr[14:12] == 3'b001)
      instr[31:25] == 7'b0;
    if (instr[6:0] == 7'b0010011 && instr[14:12] == 3'b101)
      instr[31:26] == 6'b0;
  }

  function new(string name = "alu_ctrl_item");
    super.new(name);
  endfunction
endclass
