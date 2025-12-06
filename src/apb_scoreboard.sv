`uvm_analysis_imp_decl(_act_mon)
`uvm_analysis_imp_decl(_pass_mon)

class apb_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(apb_scoreboard)

  uvm_analysis_imp_act_mon#(apb_sequence_item, apb_scoreboard)act_mon_imp;
  uvm_analysis_imp_pass_mon#(apb_sequence_item, apb_scoreboard)pass_mon_imp;

  apb_sequence_item act_queue[$];
  apb_sequence_item pass_queue[$];
  apb_sequence_item act_req,pass_req;

  bit prev_transfer;
  int count_state;
  int idle_match, idle_mismatch;
  int setup_match, setup_mismatch;
  int access_match, access_mismatch;
  int t_done_match, t_done_mismatch;
  int error_match, error_mismatch;
  int strb_match, strb_mismatch;
  bit [`DATA_WIDTH - 1:0] ref_wdata;
  bit [(`DATA_WIDTH/8)-1 : 0] ref_strb;

  function new(string name = "apb_scoreboard", uvm_component parent);
    super.new(name,parent);
    act_mon_imp = new("act_mon_imp",this);
    pass_mon_imp = new("pass_mon_imp",this);
    act_req = new();
    pass_req = new();
  endfunction

  function void write_act_mon(apb_sequence_item req);
    act_queue.push_back(req);
  endfunction

  function void write_pass_mon(apb_sequence_item req);
    pass_queue.push_back(req);
  endfunction


  task run_phase(uvm_phase phase);
    forever begin : fb
      fork
        begin : p1
          wait(act_queue.size > 0);
          act_req = act_queue.pop_front();
        end : p1

        begin : p2
          wait(pass_queue.size > 0);
          pass_req = pass_queue.pop_front();
        end : p2
      join

      if(act_req.transfer == 0) begin : if_main //transfer becomes 1 but previously it was 0. Then we will check for idle state.
        if(pass_req.PSEL == 0 && pass_req.PENABLE == 0) begin
          `uvm_info(get_type_name(), $sformatf(" | SCOREBOARD-IDLE_STATE-MATCH | PSEL = %0d | PENABLE = %0d |",pass_req.PSEL,pass_req.PENABLE),UVM_LOW)
          idle_match++;
        end
        else begin
          `uvm_info(get_type_name(),$sformatf(" | SCOREBOARD-IDLE_STATE-MISMATCH | PSEL = %0d | PENABLE = %0d |", pass_req.PSEL,pass_req.PENABLE),UVM_LOW)
          idle_mismatch++;
        end
        //count_state++;
        prev_transfer = act_req.transfer;
      end : if_main

      /*else if(act_req.transfer == 0) begin : elseif_main
        `uvm_info(get_type_name(),$sformatf("|NO COMPARISON HERE SINCE TRANSFER IS 0|"),UVM_LOW)
    end : elseif_main*/

        else if(act_req.transfer == 1) begin : else_main
          if(count_state == 0) begin :cs1
            if(pass_req.PSEL == 1 && pass_req.PENABLE == 0) begin
              `uvm_info(get_type_name(),$sformatf("|SCOREBOARD-SETUP_PHASE-MATCH| PSEL = %0d | PENABLE = %0d |",pass_req.PSEL,pass_req.PENABLE),UVM_LOW)
              setup_match++;
            end
            else begin
              `uvm_info(get_type_name(),$sformatf("|SCOREBOARD-SETUP_PHASE-MISMATCH| PSEL = %0d | PENABLE = %0d |",pass_req.PSEL,pass_req.PENABLE),UVM_LOW)
              setup_mismatch++;
            end
            count_state++;
            ref_wdata = act_req.wdata_in;
            ref_strb = act_req.strb_in;
          end : cs1
          else if(count_state == 1) begin : cs2
            if(pass_req.PSEL == 1 && pass_req.PENABLE == 1) begin
              `uvm_info(get_type_name(), $sformatf("| SCOREBOARD-ACCESS_PHASE-MATCH | PSEL = %0d | PENABLE = %0d |",pass_req.PSEL, pass_req.PENABLE),UVM_LOW)
              access_match++;
            end
            else begin
              `uvm_info(get_type_name(),$sformatf("| SCOREBOARD-ACCESS_PHASE-MISMATCH | PSEL = %0d | PENABLE = %0d |",pass_req.PSEL,pass_req.PENABLE),UVM_LOW)
              access_mismatch++;
            end
            if(pass_req.PSTRB == act_req.strb_in) begin
              `uvm_info(get_type_name(),$sformatf("| SCOREBOARD_PSTRB_MATCH | PSTRB = %0d | strb_in = %0d |",pass_req.PSTRB, act_req.strb_in),UVM_LOW)
              strb_match++;
            end
            else begin
              `uvm_info(get_type_name(),$sformatf("| SCOREBOARD_PSTRB_MISMATCH | PSTRB = %0d | strb_in = %0d |",pass_req.PSTRB, act_req.strb_in),UVM_LOW)
              strb_mismatch++;
            end
            if(act_req.PREADY) begin : if_ready
              if(act_req.write_read == 1) begin : wr_rd
                if((ref_wdata == pass_req.PWDATA) && (pass_req.transfer_done)) begin
                  `uvm_info(get_type_name(),$sformatf("|SCOREBOARD-TRANSFER_COMPELETE-MATCH | PWDATA = %0d | wdata_in = %0d | transfer_done = %0d |",pass_req.PWDATA,ref_wdata,pass_req.transfer_done),UVM_LOW)
                  t_done_match++;
                end
                else begin
                  `uvm_info(get_type_name(),$sformatf("|SCOREBOARD-TRANSFER_COMPELETE-MISMATCH | PWDATA = %0d | wdata_in = %0d | transfer_done = %0d |",pass_req.PWDATA,ref_wdata,pass_req.transfer_done),UVM_LOW)
                  t_done_mismatch++;
                end
              end : wr_rd
              else begin : e_wr_rd
                if(act_req.PRDATA == pass_req.rdata_out) begin
                  `uvm_info(get_type_name(),$sformatf("|SCOREBOARD-TRANSFER_COMPELETE-MATCH | PRDATA = %0d | rdata_out = %0d | transfer_done = %0d |",pass_req.rdata_out,act_req.PRDATA,pass_req.transfer_done),UVM_LOW)
                  t_done_match++;
                end
                else begin
                   `uvm_info(get_type_name(),$sformatf("|SCOREBOARD-TRANSFER_COMPELETE-MISMATCH | PRDATA = %0d | rdata_out = %0d | transfer_done = %0d |",pass_req.rdata_out,act_req.PRDATA,pass_req.transfer_done),UVM_LOW)
                  t_done_mismatch++;
                end
              end : e_wr_rd
              count_state = 0;
            end : if_ready
            if(act_req.PSLVERR == pass_req.error) begin
              `uvm_info(get_type_name(),$sformatf("| SCOREBOARD-ERROR-MATCH | error = %0d | PSLVERR = %0d |",pass_req.error, act_req.PSLVERR),UVM_LOW)
              error_match++;
            end
            else begin
              `uvm_info(get_type_name(),$sformatf("| SCOREBOARD-ERROR-MATCH | error = %0d | PSLVERR = %0d |",pass_req.error, act_req.PSLVERR),UVM_LOW)
              error_mismatch++;
            end
          end : cs2
        end : else_main
        $display("\n================================================== SCOREBOARD ===================================================================");
    end : fb
  endtask


  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    $display("************************************************************************************************************************************************");
    `uvm_info(get_type_name(),$sformatf("| PHASE MATCH | IDLE_PHASE = %0d | SETUP_PHASE = %0d | ACCESS_PHASE = %0d |", idle_match, setup_match, access_match),UVM_LOW)
    `uvm_info(get_type_name(),$sformatf("| TRANSACTION_COMPLETE MATCH = %0d |",t_done_match),UVM_LOW)
    `uvm_info(get_type_name(),$sformatf("| ERROR MATCH = %0d |",error_match),UVM_LOW)
    `uvm_info(get_type_name(),$sformatf("| STRB MATCH = %0d |",strb_match),UVM_LOW);
    $display("************************************************************************************************************************************************");
    $display("");
    $display("************************************************************************************************************************************************");
    `uvm_info(get_type_name(),$sformatf("| PHASE MISMATCH | IDLE_PHASE = %0d | SETUP_PHASE = %0d | ACCESS_PHASE = %0d |", idle_mismatch, setup_mismatch, access_mismatch),UVM_LOW)
    `uvm_info(get_type_name(),$sformatf("| TRANSACTION_COMPLETE MISMATCH = %0d |",t_done_mismatch),UVM_LOW)
    `uvm_info(get_type_name(),$sformatf("| ERROR MISMATCH = %0d |",error_mismatch),UVM_LOW)
    `uvm_info(get_type_name(),$sformatf("| STRB MISMATCH = %0d |",strb_mismatch),UVM_LOW);
    $display("************************************************************************************************************************************************");

  endfunction
endclass
