class alu_ctrl_vplan_seq extends uvm_sequence #(alu_ctrl_item);
  `uvm_object_utils(alu_ctrl_vplan_seq)
  function new(string name = "alu_ctrl_vplan_seq");
    super.new(name);
  endfunction

  task body();
    repeat (1000) begin
      req = alu_ctrl_item::type_id::create("req");
      start_item(req);
      assert(req.randomize());
      finish_item(req);
    end
  endtask
endclass
