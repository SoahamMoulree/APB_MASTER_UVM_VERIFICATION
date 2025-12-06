class apb_active_monitor extends uvm_monitor;

  `uvm_component_utils(apb_active_monitor)

  apb_sequence_item mon_seq;
  virtual intf vif;
  uvm_analysis_port#(apb_sequence_item)act_mon_port;
  uvm_analysis_port#(apb_sequence_item)act_cg_port;

  function new(string name = "apb_active_monitor", uvm_component parent);
    super.new(name,parent);
    mon_seq = new();
    act_mon_port = new("act_mon_port",this);
    act_cg_port = new("act_cg_port",this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual intf)::get(this,"","vif",vif))
      `uvm_error(get_type_name(),"Failed to get interface in the monitor")
  endfunction

  task monitor_inp();
   mon_seq.PRDATA = vif.PRDATA;
   mon_seq.PREADY = vif.PREADY;
   mon_seq.PSLVERR = vif.PSLVERR;
   mon_seq.transfer = vif.transfer;
   mon_seq.write_read = vif.write_read;
   mon_seq.addr_in = vif.addr_in;
   mon_seq.wdata_in = vif.wdata_in;
   mon_seq.strb_in = vif.strb_in;
   act_mon_port.write(mon_seq);
   act_cg_port.write(mon_seq);
  endtask

  task run_phase(uvm_phase phase);
    repeat(2)@(vif.mon_cb);
    forever begin
      monitor_inp();
      $display("\n=========================================================================================================================");
      `uvm_info("APB_MONITOR", $sformatf("| ACTIVE MONITOR CAPTURED | PREADY = %0d | PSLVERR = %0d | transfer = %0d | write_read = %0d |", mon_seq.PREADY, mon_seq.PSLVERR, mon_seq.transfer, mon_seq.write_read), UVM_LOW)
      `uvm_info("APB_MONITOR", $sformatf("| ACTIVE MONITOR CAPTURED | PRDATA = %0d | addr_in = %0d | wdata_in = %0d | strb_in = %0d|", mon_seq.PRDATA, mon_seq.addr_in, mon_seq.wdata_in, mon_seq.strb_in), UVM_LOW)
      $display("\n=========================================================================================================================");
      repeat(1)@(vif.mon_cb);
    end
  endtask

endclass

class apb_passive_monitor extends uvm_monitor;

  `uvm_component_utils(apb_passive_monitor)
  apb_sequence_item mon_seq;
  uvm_analysis_port#(apb_sequence_item)pass_mon_port;
  uvm_analysis_port#(apb_sequence_item)pass_cg_port;
  virtual intf vif;

  function new(string name = "apb_passive_monitor", uvm_component parent);
    super.new(name,parent);
    mon_seq = new();
    pass_mon_port = new("pass_mon_port",this);
    pass_cg_port = new("pass_cg_port",this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual intf)::get(this,"","vif",vif))
      `uvm_error(get_type_name(),"Failed to get interface in the monitor")
  endfunction

  task monitor_out();
    mon_seq.PSEL = vif.PSEL;
    mon_seq.PENABLE = vif.PENABLE;
    mon_seq.PWRITE = vif.PWRITE;
    mon_seq.PWDATA = vif.PWDATA;
    mon_seq.PSTRB = vif.PSTRB;
    mon_seq.PADDR = vif.PADDR;
    mon_seq.rdata_out = vif.rdata_out;
    mon_seq.error = vif.error;
    mon_seq.transfer_done = vif.transfer_done;
    pass_mon_port.write(mon_seq);
    pass_cg_port.write(mon_seq);
  endtask

  task run_phase(uvm_phase phase);
    repeat(2)@(vif.mon_cb);
    forever begin
      monitor_out();
      $display("\n=========================================================================================================================");
      `uvm_info("APB_MONITOR", $sformatf("| PASSIVE MONITOR CAPTURED | PSEL = %0d | PENABLE = %0d | PWRITE = %0d | ERROR = %0d | TRANSFER_DONE = %0d |", mon_seq.PSEL, mon_seq.PENABLE, mon_seq.PWRITE, mon_seq.error, mon_seq.transfer_done), UVM_LOW)
      `uvm_info("APB_MONITOR", $sformatf("| PASSIVE MONITOR CAPTURED | PWDATA = %0d | PSTRB = %0d | PADDR = %0d | RDATA_OUT = %0d ", mon_seq.PWDATA, mon_seq.PSTRB, mon_seq.PADDR, mon_seq.rdata_out), UVM_LOW)
      $display("\n=========================================================================================================================");
      repeat(1)@(vif.mon_cb);
    end
  endtask

endclass
