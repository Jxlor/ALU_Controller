typedef class ALU_model;

class ALU_Ctrl_model;
  protected logic [31:0] instr;
  protected logic [6:0]  opcode;
  protected logic [2:0]  funct3;
  protected logic        funct7_5;
  protected alu_op_e     alu_op_expected;

  ALU_model next_alu_model;

  function new();
    instr           = 32'h0;
    alu_op_expected = ALU_ADD;
  endfunction

  function void set_instr(logic [31:0] a);
    this.instr    = a;
    this.opcode   = a[6:0];
    this.funct3   = a[14:12];
    this.funct7_5 = a[30];
    predict_alu_op();
  endfunction

  function void set_decoded_fields(logic [6:0] opc, logic [2:0] f3, logic f7_5);
    this.opcode   = opc;
    this.funct3   = f3;
    this.funct7_5 = f7_5;
    predict_alu_op();
  endfunction

  protected function void predict_alu_op();
    case (opcode)
      7'b0110011: begin // R-Type
        case (funct3)
          3'b000: alu_op_expected = funct7_5 ? ALU_SUB : ALU_ADD;
          3'b001: alu_op_expected = ALU_SLL;
          3'b010: alu_op_expected = ALU_SLT;
          3'b011: alu_op_expected = ALU_SLTU;
          3'b100: alu_op_expected = ALU_XOR;
          3'b101: alu_op_expected = funct7_5 ? ALU_SRA : ALU_SRL;
          3'b110: alu_op_expected = ALU_OR;
          3'b111: alu_op_expected = ALU_AND;
        endcase
      end
      7'b0010011: begin // I-Type
        case (funct3)
          3'b000: alu_op_expected = ALU_ADD;
          3'b001: alu_op_expected = ALU_SLL;
          3'b010: alu_op_expected = ALU_SLT;
          3'b011: alu_op_expected = ALU_SLTU;
          3'b100: alu_op_expected = ALU_XOR;
          3'b101: alu_op_expected = funct7_5 ? ALU_SRA : ALU_SRL;
          3'b110: alu_op_expected = ALU_OR;
          3'b111: alu_op_expected = ALU_AND;
        endcase
      end
      7'b0000011, 7'b0100011, 7'b0010111: alu_op_expected = ALU_ADD;
      7'b0110111: alu_op_expected = ALU_PASS_B;
      7'b1100011: alu_op_expected = ALU_SUB;
      default:    alu_op_expected = ALU_ADD;
    endcase
  endfunction

  function alu_op_e get_alu_op_expected();
    return alu_op_expected;
  endfunction
endclass
