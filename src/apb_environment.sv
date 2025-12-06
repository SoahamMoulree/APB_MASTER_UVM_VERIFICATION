class apb_environment extends uvm_env;

  `uvm_component_utils(apb_environment)
  apb_active_agent act_agt;
  apb_passive_agent pass_agt;
  apb_scoreboard scb;
  apb_coverage cov;
  function new(string name = "apb_envirnoment", uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    act_agt = apb_active_agent::type_id::create("act_agt",this);
    uvm_config_db#(uvm_active_passive_enum)::set(this,"act_agt*","is_active",UVM_ACTIVE);
    pass_agt = apb_passive_agent::type_id::create("pass_agt",this);
    uvm_config_db#(uvm_active_passive_enum)::set(this,"pass_agt*","is_active",UVM_PASSIVE);
    scb = apb_scoreboard::type_id::create("scb",this);
    cov = apb_coverage::type_id::create("cov",this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase( phase);
    act_agt.act_mon.act_mon_port.connect(scb.act_mon_imp);
    pass_agt.pass_mon.pass_mon_port.connect(scb.pass_mon_imp);
    act_agt.act_mon.act_cg_port.connect(cov.act_cg_imp);
    pass_agt.pass_mon.pass_cg_port.connect(cov.pass_cg_imp);
  endfunction

endclass
