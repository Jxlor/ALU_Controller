import uvm_pkg::*;
`include "uvm_macros.svh"

class alu_ctrl_seq_item extends uvm_sequence_item;
    // Khai báo các tín hiệu vào (rand để sau này dùngconstrained random)
    rand logic [6:0] opcode;
    rand logic [2:0] funct3;
    rand logic       funct7_5;
    rand logic [31:0] raw_imm;
    
    // Tín hiệu ngõ ra từ DUT
    logic [3:0] alu_op; // 

    `uvm_object_utils_begin(alu_ctrl_seq_item)
        `uvm_field_int(opcode, UVM_ALL_ON)
        `uvm_field_int(funct3, UVM_ALL_ON)
        `uvm_field_int(funct7_5, UVM_ALL_ON)
        `uvm_field_int(raw_imm, UVM_ALL_ON)
        `uvm_field_int(alu_op, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "alu_ctrl_seq_item");
        super.new(name);
    endfunction
endclass
