class alu_ctrl_seq_item extends uvm_sequence_item;
    rand logic [6:0]  opcode;
    rand logic [2:0]  funct3;
    rand logic        funct7_5;
    rand logic [31:0] raw_imm;
    
    logic      [3:0]  alu_op;

    `uvm_object_utils_begin(alu_ctrl_seq_item)
        `uvm_field_int(opcode, UVM_ALL_ON)
        `uvm_field_int(funct3, UVM_ALL_ON)
        `uvm_field_int(funct7_5, UVM_ALL_ON)
        `uvm_field_int(raw_imm, UVM_ALL_ON)
        `uvm_field_int(alu_op, UVM_ALL_ON)
    `uvm_object_utils_end

    // Gom toàn bộ các Opcode có mặt trong DUT của bé vào đây
    constraint valid_opcode_c {
        opcode inside {
            `OPCODE_AUIPC,
            `OPCODE_JAL, 
            `OPCODE_JALR,
            `OPCODE_LOAD,
            `OPCODE_STORE,
            `OPCODE_BRANCH,
            `OPCODE_ITYPE,
            `OPCODE_RTYPE,
            `OPCODE_ENVIRONMENT
        };
    }

    // Ràng buộc riêng cho bit 10 của raw_imm khi test lệnh dịch phải I-type (SRXI)
    constraint srai_srli_c {
        if (opcode == `OPCODE_ITYPE && funct3 == `ITYPE_SRXI) {
            raw_imm[10] inside {0, 1};
        }
    }

    function new(string name = "alu_ctrl_seq_item");
        super.new(name);
    endfunction
endclass
