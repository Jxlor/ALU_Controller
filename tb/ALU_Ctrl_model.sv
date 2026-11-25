class ALU_Ctrl_model;
  protected logic [6:0] opcode;
  protected logic [2:0] funct3;
  protected logic       funct7_5;
  protected logic       imm_10;
  protected logic [3:0] alu_op_expected;

  //ALU_model next_alu_model;

  function new();
    opcode          = 7'h0;
    funct3          = 3'h0;
    funct7_5        = 1'b0;
    imm_10          = 1'b0;
    alu_op_expected = `ALU_OP_NOP;
  endfunction

  function void set_inputs(logic [6:0] opc, logic [2:0] f3, logic f7_5, logic i10);
    this.opcode   = opc;
    this.funct3   = f3;
    this.funct7_5 = f7_5;
    this.imm_10   = i10;
    predict_alu_op();
  endfunction

  protected function void predict_alu_op();
    case (opcode)
      `OPCODE_AUIPC, `OPCODE_JAL, `OPCODE_JALR, `OPCODE_LOAD, `OPCODE_STORE:
        alu_op_expected = `ALU_OP_ADD;
      `OPCODE_BRANCH: begin
        case (funct3)
          `BRANCH_BEQ, `BRANCH_BNE:   alu_op_expected = `ALU_OP_SUB;
          `BRANCH_BLT, `BRANCH_BGE:   alu_op_expected = `ALU_OP_SLT;
          `BRANCH_BLTU, `BRANCH_BGEU: alu_op_expected = `ALU_OP_SLTU;
          default:                    alu_op_expected = `ALU_OP_NOP;
        endcase
      end
      `OPCODE_ITYPE: begin
        case (funct3)
          `ITYPE_ADDI:  alu_op_expected = `ALU_OP_ADD;
          `ITYPE_SLLI:  alu_op_expected = `ALU_OP_SLL;
          `ITYPE_SLTI:  alu_op_expected = `ALU_OP_SLT;
          `ITYPE_SLTIU: alu_op_expected = `ALU_OP_SLTU;
          `ITYPE_XORI:  alu_op_expected = `ALU_OP_XOR;
          `ITYPE_SRXI:  alu_op_expected = imm_10 ? `ALU_OP_SRA : `ALU_OP_SRL;
          `ITYPE_ORI:   alu_op_expected = `ALU_OP_OR;
          `ITYPE_ANDI:  alu_op_expected = `ALU_OP_AND;
          default:      alu_op_expected = `ALU_OP_NOP;
        endcase
      end
      `OPCODE_RTYPE: begin
        case (funct3)
          `RTYPE_ADDSUB: alu_op_expected = funct7_5 ? `ALU_OP_SUB : `ALU_OP_ADD;
          `RTYPE_SLL:    alu_op_expected = `ALU_OP_SLL;
          `RTYPE_SLT:    alu_op_expected = `ALU_OP_SLT;
          `RTYPE_SLTU:   alu_op_expected = `ALU_OP_SLTU;
          `RTYPE_XOR:    alu_op_expected = `ALU_OP_XOR;
          `RTYPE_SR:     alu_op_expected = funct7_5 ? `ALU_OP_SRA : `ALU_OP_SRL;
          `RTYPE_OR:     alu_op_expected = `ALU_OP_OR;
          `RTYPE_AND:    alu_op_expected = `ALU_OP_AND;
          default:       alu_op_expected = `ALU_OP_NOP;
        endcase
      end
      `OPCODE_ENVIRONMENT: begin
        case (funct3)
          `CSR_CSRRW, `CSR_CSRRWI: alu_op_expected = `ALU_OP_BPA;
          `CSR_CSRRS, `CSR_CSRRSI: alu_op_expected = `ALU_OP_OR;
          `CSR_CSRRC, `CSR_CSRRCI: alu_op_expected = `ALU_OP_ABJ;
          default:                 alu_op_expected = `ALU_OP_NOP;
        endcase
      end
      default: alu_op_expected = `ALU_OP_NOP;
    endcase
  endfunction

  function logic [3:0] get_alu_op_expected();
    return alu_op_expected;
  endfunction
endclass
