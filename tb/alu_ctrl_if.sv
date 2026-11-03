interface alu_ctrl_if ;
  logic [2:0] funct3 ;
  logic [6:0] opcode ;
  logic funct7_5 ;
  logic [31:0] raw_imm ;
  logic [3:0] alu_op ;
endinterface 
