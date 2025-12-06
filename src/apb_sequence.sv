class apb_write_sequence extends uvm_sequence#(apb_sequence_item);

  `uvm_object_utils(apb_write_sequence)

  function new(string name = "apb_write_sequence");
    super.new(name);
  endfunction

  task body();
    bit [`DATA_WIDTH - 1:0] temp_data;
    bit [(`DATA_WIDTH/8)-1:0]temp_strb;
    repeat(3) begin
      $display("---------------------------- NEW-TRANSFER ---------------------------------------------------");
      req = apb_sequence_item::type_id::create("req");
      start_item(req);
      req.randomize() with {transfer == 1;write_read == 1;PREADY == 0;};
      temp_data = req.wdata_in;
      temp_strb = req.strb_in;
      finish_item(req);

      req = apb_sequence_item::type_id::create("req");
      start_item(req);
      req.randomize() with {transfer == 1;write_read == 1; PSLVERR == 0;wdata_in == temp_data; PREADY == 1;strb_in == temp_strb;};
      finish_item(req);

      /*req = apb_sequence_item::type_id::create("req");
      start_item(req);
      req.randomize() with {transfer == 1; write_read == 1; PSLVERR == 0; PREADY == 1; wdata_in == temp_data;};
      finish_item(req);*/

      req = apb_sequence_item::type_id::create("req");
      start_item(req);
      req.randomize() with {transfer == 0; PREADY == 1;};
      finish_item(req);

    end
  endtask

endclass

class random_pready_write_sequence extends uvm_sequence#(apb_sequence_item);

  `uvm_object_utils(random_pready_write_sequence)

  function new(string name = "random_pready_sequence");
    super.new(name);
  endfunction

  task body();
    bit [`DATA_WIDTH - 1:0] temp_data;
    bit [(`DATA_WIDTH/8)-1:0]temp_strb;
    repeat(3) begin

      $display("---------------------------- NEW-TRANSFER ---------------------------------------------------");

      req = apb_sequence_item::type_id::create("req");
      start_item(req);
      req.randomize() with {transfer == 0;};
      finish_item(req);

      req = apb_sequence_item::type_id::create("req");
      start_item(req);
      req.randomize() with {transfer == 1;write_read == 1;PREADY == 0;};
      temp_data = req.wdata_in;
      temp_strb = req.strb_in;
      finish_item(req);

      repeat(3) begin
        req = apb_sequence_item::type_id::create("req");
        start_item(req);
        req.randomize() with {transfer == 1;write_read == 1; PSLVERR == 0;wdata_in == temp_data; PREADY == 0;strb_in == temp_strb;};
        finish_item(req);
      end

      req = apb_sequence_item::type_id::create("req");
      start_item(req);
      req.randomize() with {transfer == 1;write_read == 1; PSLVERR == 0;wdata_in == temp_data; PREADY == 1;strb_in == temp_strb;};
      finish_item(req);

      /*req = apb_sequence_item::type_id::create("req");
      start_item(req);
      req.randomize() with {transfer == 0;};
      finish_item(req);*/

    end
  endtask

endclass

/*class imm_read_sequence extends uvm_sequence#(apb_sequence_item);

  `uvm_object_utils(imm_read_sequence)

  function new(string name = "imm_read_sequence");
    super.new(name);
  endfunction

  task body();
    bit [`DATA_WIDTH - 1:0] temp_data;
    repeat(3) begin
      req = apb_sequence_item::type_id::create("req");
      start_item(req);
      req.randomize() with {transfer == 1;write_read == 0;PREADY == 0;};
      finish_item(req);

      req = apb_sequence_item::type_id::create("req");
      start_item(req);
      req.randomize() with {transfer == 1;write_read == 0; PSLVERR == 0; };
      temp_data = req.wdata_in;
      finish_item(req);

      req = apb_sequence_item::type_id::create("req");
      start_item(req);
      req.randomize() with {transfer == 1; write_read == 0; PSLVERR == 0; PREADY == 1; wdata_in == temp_data;};
      finish_item(req);

      req = apb_sequence_item::type_id::create("req");
      start_item(req);
      req.randomize() with {transfer == 0;};
      finish_item(req);

    end
  endtask

endclass*/
