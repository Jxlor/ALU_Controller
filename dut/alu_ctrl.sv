module alu_ctrl (
  input  wire [31:0] instr,
  output reg  [3:0]  alu_op
);

  // Mã điều khiển ALU_Op (khớp với enum alu_op_e trong Testbench)
  localparam [3:0]
    ALU_ADD    = 4'd0,
    ALU_SUB    = 4'd1,
    ALU_SLL    = 4'd2,
    ALU_SLT    = 4'd3,
    ALU_SLTU   = 4'd4,
    ALU_XOR    = 4'd5,
    ALU_SRL    = 4'd6,
    ALU_SRA    = 4'd7,
    ALU_OR     = 4'd8,
    ALU_AND    = 4'd9,
    ALU_PASS_B = 4'd10;

  wire [6:0] opcode   = instr[6:0];
  wire [2:0] funct3   = instr[14:12];
  wire       funct7_5 = instr[30];

  always @(*) begin
    case (opcode)
      // R-Type (0110011)
      7'b0110011: begin
        case (funct3)
          3'b000: alu_op = funct7_5 ? ALU_SUB : ALU_ADD;
          3'b001: alu_op = ALU_SLL;
          3'b010: alu_op = ALU_SLT;
          3'b011: alu_op = ALU_SLTU;
          3'b100: alu_op = ALU_XOR;
          3'b101: alu_op = funct7_5 ? ALU_SRA : ALU_SRL;
          3'b110: alu_op = ALU_OR;
          3'b111: alu_op = ALU_AND;
          default: alu_op = ALU_ADD;
        endcase
      end

      // I-Type Arith & Shift (0010011)
      7'b0010011: begin
        case (funct3)
          3'b000: alu_op = ALU_ADD;
          3'b001: alu_op = ALU_SLL;
          3'b010: alu_op = ALU_SLT;
          3'b011: alu_op = ALU_SLTU;
          3'b100: alu_op = ALU_XOR;
          3'b101: alu_op = funct7_5 ? ALU_SRA : ALU_SRL;
          3'b110: alu_op = ALU_OR;
          3'b111: alu_op = ALU_AND;
          default: alu_op = ALU_ADD;
        endcase
      end

      // Load (0000011), Store (0100011), AUIPC (0010111)
      7'b0000011,
      7'b0100011,
      7'b0010111: alu_op = ALU_ADD;

      // LUI (0110111)
      7'b0110111: alu_op = ALU_PASS_B;

      // Branch: BEQ, BNE, BLT, BGE, BLTU, BGEU (1100011)
      7'b1100011: alu_op = ALU_SUB;

      default:    alu_op = ALU_ADD;
    endcase
  end

endmodule
