class alu_ctrl_env extends uvm_env;
    `uvm_component_utils(alu_ctrl_env)

    // Khai báo các thành phần trong môi trường
    alu_ctrl_driver     drv;
    alu_ctrl_monitor    mon;
    alu_ctrl_scoreboard scb;
    uvm_sequencer#(alu_ctrl_seq_item) sqr;

    function new(string name = "alu_ctrl_env", uvm_component parent);
        super.new(name, parent);
    endfunction

    // Khởi tạo các component bằng factory create trong build_phase
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        drv = alu_ctrl_driver::type_id::create("drv", this);
        mon = alu_ctrl_monitor::type_id::create("mon", this);
        scb = alu_ctrl_scoreboard::type_id::create("scb", this);
        sqr = uvm_sequencer#(alu_ctrl_seq_item)::type_id::create("sqr", this);
    endfunction

    // Kết nối các cổng (Port - Export) trong connect_phase
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // Nối Driver với Sequencer để nhận transaction
        drv.seq_item_port.connect(sqr.seq_item_export);
        // Nối Monitor với Scoreboard để gửi dữ liệu đối chiếu
        mon.mon_analysis_port.connect(scb.item_collected_export);
    endfunction
endclass
