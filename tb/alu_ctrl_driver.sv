
class alu_ctrl_driver extends uvm_driver#(alu_ctrl_seq_item);
    `uvm_component_utils(alu_ctrl_driver)

    virtual alu_ctrl_if vif;

    function new(string name = "alu_ctrl_driver", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual alu_ctrl_if)::get(this, "", "vif", vif))
            `uvm_fatal("DRV", "Không tìm thấy virtual interface cho Driver!")
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
            
            // Đẩy dữ liệu vào chân của DUT thông qua Interface
            vif.opcode   = req.opcode;
            vif.funct3   = req.funct3;
            vif.funct7_5 = req.funct7_5;
            vif.raw_imm  = req.raw_imm;
            
            #10; // Đợi mạch tổ hợp đáp ứng
            
            seq_item_port.item_done();
        end
    endtask
endclass
