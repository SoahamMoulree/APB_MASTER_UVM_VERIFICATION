class apb_driver extends uvm_driver#(apb_sequence_item);

  `uvm_component_utils(apb_driver)

  virtual intf vif;

  function new(string name = "apb_driver",uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual intf)::get(this,"","vif",vif)) begin
      `uvm_error(get_type_name(),"Failed to get interface !")
    end
  endfunction

  task drive();
    vif.PSLVERR <= req.PSLVERR;
    vif.PREADY <= req.PREADY;
    vif.PRDATA <= req.PRDATA;
    vif.addr_in <= req.addr_in;
    vif.wdata_in <= req.wdata_in;
    vif.transfer <= req.transfer;
    vif.write_read <= req.write_read;
    vif.strb_in <= req.strb_in;
  endtask

  task run_phase(uvm_phase phase);
    repeat(2)@(vif.drv_cb);
    forever begin
      seq_item_port.get_next_item(req);
      drive();
      $display("\n=========================================================================================================================");
     `uvm_info(get_type_name(), $sformatf("| SIGNALS DRIVEN | PREADY = %0d | PSLVERR = %0d | transfer = %0d | read_write = %0d ",req.PREADY, req.PSLVERR, req.transfer,req.write_read),UVM_LOW)
      `uvm_info(get_type_name(), $sformatf("| SIGNALS DRIVEN | PRDATA = %0d | addr_in = %0d | wdata_in = %0d | strb_in = %0d",req.PRDATA, req.addr_in, req.wdata_in,req.strb_in),UVM_LOW)
      $display("\n=========================================================================================================================");
      repeat(1)@(vif.drv_cb);
      seq_item_port.item_done;
    end
  endtask

endclass
