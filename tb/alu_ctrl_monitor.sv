class alu_ctrl_monitor extends uvm_monitor;
    `uvm_component_utils(alu_ctrl_monitor)

    virtual alu_ctrl_if vif;
    uvm_analysis_port#(alu_ctrl_seq_item) mon_analysis_port;

    function new(string name = "alu_ctrl_monitor", uvm_component parent);
        super.new(name, parent);
        mon_analysis_port = new("mon_analysis_port", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual alu_ctrl_if)::get(this, "", "vif", vif))
            `uvm_fatal("MON", "Không tìm thấy virtual interface cho Monitor!")
    endfunction

    virtual task run_phase(uvm_phase phase);
        alu_ctrl_seq_item tr;
        forever begin
            #10; // Lấy mẫu theo thời gian ổn định của tín hiệu
            tr = alu_ctrl_seq_item::type_id::create("tr");
            tr.opcode   = vif.opcode;
            tr.funct3   = vif.funct3;
            tr.funct7_5 = vif.funct7_5;
            tr.raw_imm  = vif.raw_imm;
            tr.alu_op   = vif.alu_op;
            
            mon_analysis_port.write(tr);
        end
    endtask
endclass
