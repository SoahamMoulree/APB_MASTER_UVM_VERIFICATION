class apb_active_agent extends uvm_agent;

  `uvm_component_utils(apb_active_agent)

  apb_driver drv;
  apb_active_monitor act_mon;
  apb_sequencer seqr;


  function new(string name = "apb_active_agent",uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    uvm_config_db#(uvm_active_passive_enum)::get(this,"","is_active",is_active);
    if(is_active == UVM_ACTIVE) begin
      drv = apb_driver::type_id::create("drv",this);
      seqr = apb_sequencer::type_id::create("seqr",this);
    end
    act_mon = apb_active_monitor::type_id::create("act_mon",this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(is_active == UVM_ACTIVE) begin
      drv.seq_item_port.connect(seqr.seq_item_export);
    end
  endfunction

endclass

class apb_passive_agent extends uvm_agent;

  `uvm_component_utils(apb_passive_agent)
  apb_passive_monitor pass_mon;

  function new(string name = "apb_passive_agent",uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    pass_mon = apb_passive_monitor::type_id::create("pass_mon",this);
  endfunction

endclass
