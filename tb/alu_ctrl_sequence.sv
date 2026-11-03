class alu_ctrl_sequence extends uvm_sequence#(alu_ctrl_seq_item);
    `uvm_object_utils(alu_ctrl_sequence)

    function new(string name = "alu_ctrl_sequence");
        super.new(name);
    endfunction

    virtual task body();
        alu_ctrl_seq_item req;
        
        // 👉 Bơm tự động 1000 test case ngẫu nhiên có ràng buộc!
        repeat (1000) begin
            req = alu_ctrl_seq_item::type_id::create("req");
            start_item(req);
            
            // Lệnh randomize() sẽ tự động sinh dữ liệu tuân theo các constraint ở Transaction
            assert(req.randomize()); 
            
            finish_item(req);
        end
    endtask
endclass
