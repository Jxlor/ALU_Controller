`include "uvm_macros.svh"
import uvm_pkg::*;

// Include các file thành phần UVM của bé vào đây theo thứ tự
`include "alu_ctrl_seq_item.sv"
`include "alu_ctrl_sequence.sv"
`include "alu_ctrl_driver.sv"
`include "alu_ctrl_monitor.sv"
`include "alu_ctrl_scoreboard.sv"
`include "alu_ctrl_env.sv"

module tb_top;
    // Khởi tạo Interface
    alu_ctrl_if vif();

    // Instantiate DUT (Design Under Test)
    ALU_Controller dut (
        .funct3(vif.funct3),
        .opcode(vif.opcode),
        .funct7_5(vif.funct7_5),
        .raw_imm(vif.raw_imm),
        .alu_op(vif.alu_op)
    );

    initial begin
        // Đưa virtual interface vào uvm_config_db để Driver/Monitor xài chung
        uvm_config_db#(virtual alu_ctrl_if)::set(null, "*", "vif", vif);
        
        // Chạy môi trường UVM Environment vừa tạo
        run_test("alu_ctrl_env");
    end
endmodule
