class base_test extends uvm_test;

  `uvm_component_utils(base_test)
  apb_environment env;
  apb_write_sequence seq;


  function new(string name = "base_test", uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = apb_environment::type_id::create("env",this);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = apb_write_sequence::type_id::create("seq");
    seq.start(env.act_agt.seqr);
    phase.drop_objection(this);
  endtask

endclass

class random_pready_write_test extends base_test;

  `uvm_component_utils(random_pready_write_test)
  random_pready_write_sequence seq2;

  function new(string name = "random_pready_write_test",uvm_component parent);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq2 = random_pready_write_sequence::type_id::create("seq2");
    seq2.start(env.act_agt.seqr);
    phase.drop_objection(this);

  endtask

endclass
~
