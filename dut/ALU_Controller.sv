`include "modules/headers/alu_op.vh"
`include "modules/headers/branch.vh"
`include "modules/headers/csr.vh"
`include "modules/headers/itype.vh"
`include "modules/headers/opcode.vh"
`include "modules/headers/rtype.vh"

module ALU_Controller (
	input logic [2:0] funct3 ,
	input logic [6:0] opcode ,
	input logic funct7_5 ,
	input logic [31:0] raw_imm ,
	output logic [3:0] alu_op
) ;
	always_comb begin 
		alu_op = `ALU_OP_NOP ;

		case (opcode) 
			`OPCODE_AUIPC,
			`OPCODE_JAL, 
			`OPCODE_JALR,
			`OPCODE_LOAD,
			`OPCODE_STORE: begin 
				alu_op = `ALU_OP_ADD ;
			end 
			
			`OPCODE_BRANCH: begin 
				case(funct3) 
					`BRANCH_BEQ,
					`BRANCH_BNE: alu_op = `ALU_OP_SUB ;
					`BRANCH_BLT,
					`BRANCH_BGE: alu_op = `ALU_OP_SLT ;
					`BRANCH_BLTU, 
                    `BRANCH_BGEU: alu_op = `ALU_OP_SLTU;
                    default:      alu_op = `ALU_OP_NOP;
                endcase
            end
			`OPCODE_ITYPE: begin
                case (funct3)
                    `ITYPE_ADDI:  alu_op = `ALU_OP_ADD;
                    `ITYPE_SLLI:  alu_op = `ALU_OP_SLL;
                    `ITYPE_SLTI:  alu_op = `ALU_OP_SLT;
                    `ITYPE_SLTIU: alu_op = `ALU_OP_SLTU;
                    `ITYPE_XORI:  alu_op = `ALU_OP_XOR;
                    `ITYPE_SRXI:  alu_op = raw_imm[10] ? `ALU_OP_SRA : `ALU_OP_SRL; // Phân biệt SRAI / SRLI dựa vào raw_imm[10]
                    `ITYPE_ORI:   alu_op = `ALU_OP_OR;
                    `ITYPE_ANDI:  alu_op = `ALU_OP_AND;
                    default:      alu_op = `ALU_OP_NOP;
                endcase
            end

            `OPCODE_RTYPE: begin
                case (funct3)
                    `RTYPE_ADDSUB: alu_op = funct7_5 ? `ALU_OP_SUB : `ALU_OP_ADD; // Phân biệt SUB / ADD
                    `RTYPE_SLL:    alu_op = `ALU_OP_SLL;
                    `RTYPE_SLT:    alu_op = `ALU_OP_SLT;
                    `RTYPE_SLTU:   alu_op = `ALU_OP_SLTU;
                    `RTYPE_XOR:    alu_op = `ALU_OP_XOR;
                    `RTYPE_SR:     alu_op = funct7_5 ? `ALU_OP_SRA : `ALU_OP_SRL; // Phân biệt SRA / SRL
                    `RTYPE_OR:     alu_op = `ALU_OP_OR;
                    `RTYPE_AND:    alu_op = `ALU_OP_AND;
                    default:       alu_op = `ALU_OP_NOP;
                endcase
            end

            `OPCODE_ENVIRONMENT: begin
                case (funct3)
                    `CSR_CSRRW,  `CSR_CSRRWI: alu_op = `ALU_OP_BPA;
                    `CSR_CSRRS,  `CSR_CSRRSI: alu_op = `ALU_OP_OR;
                    `CSR_CSRRC,  `CSR_CSRRCI: alu_op = `ALU_OP_ABJ;
                    default:                  alu_op = `ALU_OP_NOP;
                endcase
            end

            default: begin
                alu_op = `ALU_OP_NOP;
            end
        endcase
    end

endmodule
