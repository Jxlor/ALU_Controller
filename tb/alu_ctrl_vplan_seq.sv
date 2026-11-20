class alu_ctrl_vplan_seq extends uvm_sequence #(alu_ctrl_item);
  `uvm_object_utils(alu_ctrl_vplan_seq)

  logic [31:0] vplan_hex[29] = '{
    32'h0063_82B3, 32'h4063_82B3, 32'h0063_92B3, 32'h0063_A2B3, 32'h0063_B2B3,
    32'h0063_C2B3, 32'h0063_D2B3, 32'h4063_D2B3, 32'h0063_E2B3, 32'h0063_F2B3,
    32'h0052_8293, 32'h0052_A293, 32'h0052_B293, 32'h0052_C293, 32'h0052_E293,
    32'h0052_F293, 32'h0012_9293, 32'h0052_D293, 32'h4052_D293,
    32'h0100_2003, 32'h0102_2223, 32'h1234_5037, 32'hABCDE017,
    32'h0020_8463, 32'h0020_9463, 32'h0020_C463, 32'h0020_D463, 32'h0020_E463, 32'h0020_F463
  };

  function new(string name = "alu_ctrl_vplan_seq");
    super.new(name);
  endfunction

  task body();
    foreach (vplan_hex[i]) begin
      req = alu_ctrl_item::type_id::create("req");
      start_item(req);
      req.instr = vplan_hex[i];
      finish_item(req);
    end

    repeat (500) begin
      req = alu_ctrl_item::type_id::create("req");
      start_item(req);
      assert(req.randomize());
      finish_item(req);
    end
  endtask
endclass
