class alu_ctrl_sequence extends uvm_sequence#(alu_ctrl_seq_item);
    `uvm_object_utils(alu_ctrl_sequence)

    function new(string name = "alu_ctrl_sequence");
        super.new(name);
    endfunction

    virtual task body();
        alu_ctrl_seq_item req;
        
        // Gửi các test case cụ thể hoặc random
        // Ví dụ test case 1: ITYPE ADDI
        req = alu_ctrl_seq_item::type_id::create("req");
        start_item(req);
        req.opcode   = 7'b0010011; // `OPCODE_ITYPE
        req.funct3   = 3'b000;     // `ITYPE_ADDI
        req.funct7_5 = 1'b0;
        req.raw_imm  = 32'h0;
        finish_item(req);

        // Bé có thể viết thêm các transaction khác ở đây...
    endtask
endclass
