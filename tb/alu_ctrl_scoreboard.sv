class alu_ctrl_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(alu_ctrl_scoreboard)

    uvm_analysis_imp#(alu_ctrl_seq_item, alu_ctrl_scoreboard) item_collected_export;

    function new(string name = "alu_ctrl_scoreboard", uvm_component parent);
        super.new(name, parent);
        item_collected_export = new("item_collected_export", this);
    endfunction

    virtual function void write(alu_ctrl_seq_item tr);
        logic [3:0] expected_alu_op;
        
        // 👉 GOLDEN MODEL MÔ PHỎNG CHÍNH XÁC 100% LOGIC CỦA DUT
        case (tr.opcode)
            `OPCODE_AUIPC,
            `OPCODE_JAL, 
            `OPCODE_JALR,
            `OPCODE_LOAD,
            `OPCODE_STORE: begin 
                expected_alu_op = `ALU_OP_ADD;
            end 
            
            `OPCODE_BRANCH: begin 
                case(tr.funct3) 
                    `BRANCH_BEQ,
                    `BRANCH_BNE:  expected_alu_op = `ALU_OP_SUB;
                    `BRANCH_BLT,
                    `BRANCH_BGE:  expected_alu_op = `ALU_OP_SLT;
                    `BRANCH_BLTU, 
                    `BRANCH_BGEU: expected_alu_op = `ALU_OP_SLTU;
                    default:      expected_alu_op = `ALU_OP_NOP;
                endcase
            end

            `OPCODE_ITYPE: begin
                case (tr.funct3)
                    `ITYPE_ADDI:  expected_alu_op = `ALU_OP_ADD;
                    `ITYPE_SLLI:  expected_alu_op = `ALU_OP_SLL;
                    `ITYPE_SLTI:  expected_alu_op = `ALU_OP_SLT;
                    `ITYPE_SLTIU: expected_alu_op = `ALU_OP_SLTU;
                    `ITYPE_XORI:  expected_alu_op = `ALU_OP_XOR;
                    `ITYPE_SRXI:  expected_alu_op = tr.raw_imm[10] ? `ALU_OP_SRA : `ALU_OP_SRL;
                    `ITYPE_ORI:   expected_alu_op = `ALU_OP_OR;
                    `ITYPE_ANDI:  expected_alu_op = `ALU_OP_AND;
                    default:      expected_alu_op = `ALU_OP_NOP;
                endcase
            end

            `OPCODE_RTYPE: begin
                case (tr.funct3)
                    `RTYPE_ADDSUB: expected_alu_op = tr.funct7_5 ? `ALU_OP_SUB : `ALU_OP_ADD;
                    `RTYPE_SLL:    expected_alu_op = `ALU_OP_SLL;
                    `RTYPE_SLT:    expected_alu_op = `ALU_OP_SLT;
                    `RTYPE_SLTU:   expected_alu_op = `ALU_OP_SLTU;
                    `RTYPE_XOR:    expected_alu_op = `ALU_OP_XOR;
                    `RTYPE_SR:     expected_alu_op = tr.funct7_5 ? `ALU_OP_SRA : `ALU_OP_SRL;
                    `RTYPE_OR:     expected_alu_op = `ALU_OP_OR;
                    `RTYPE_AND:    expected_alu_op = `ALU_OP_AND;
                    default:       expected_alu_op = `ALU_OP_NOP;
                endcase
            end

            `OPCODE_ENVIRONMENT: begin
                case (tr.funct3)
                    `CSR_CSRRW, `CSR_CSRRWI: expected_alu_op = `ALU_OP_BPA;
                    `CSR_CSRRS, `CSR_CSRRSI: expected_alu_op = `ALU_OP_OR;
                    `CSR_CSRRC, `CSR_CSRRCI: expected_alu_op = `ALU_OP_ABJ;
                    default:                 expected_alu_op = `ALU_OP_NOP;
                endcase
            end

            default: begin
                expected_alu_op = `ALU_OP_NOP;
            end
        endcase

        // 👉 ĐỐI CHIẾU KẾT QUẢ THỰC TẾ VÀ IN KẾT QUẢ
        if (tr.alu_op === expected_alu_op) begin
            `uvm_info("SCB", $sformatf("[PASS] Opcode=0x%0h | funct3=0x%0h | funct7_5=%0b | alu_op=0x%0h", 
                tr.opcode, tr.funct3, tr.funct7_5, tr.alu_op), UVM_LOW)
        end else begin
            `uvm_error("SCB", $sformatf("[FAIL] Opcode=0x%0h | funct3=0x%0h | funct7_5=%0b | Expected alu_op=0x%0h, Got alu_op=0x%0h", 
                tr.opcode, tr.funct3, tr.funct7_5, expected_alu_op, tr.alu_op))
        end
    endfunction
endclass
