`include "uvm_macros.svh"
`include "apb_interface.sv"
`include "design3.v"
module top;
  import uvm_pkg::*;
  import apb_pkg::*;

  bit PCLK;
  bit PRESETn;

  initial begin
    PCLK = 0;
  end

  always #5 PCLK = ~PCLK;

  intf vif(PCLK,PRESETn);

  apb_master #(
    .ADDR_WIDTH(8),
    .DATA_WIDTH(32)
) u_apb_master (
    .PCLK         (PCLK),
    .PRESETn      (PRESETn),
    .PADDR        (vif.PADDR),
    .PSEL         (vif.PSEL),
    .PENABLE      (vif.PENABLE),
    .PWRITE       (vif.PWRITE),
    .PWDATA       (vif.PWDATA),
    .PSTRB        (vif.PSTRB),
    .PRDATA       (vif.PRDATA),
    .PREADY       (vif.PREADY),
    .PSLVERR      (vif.PSLVERR),
    .transfer     (vif.transfer),
    .write_read   (vif.write_read),
    .addr_in      (vif.addr_in),
    .wdata_in     (vif.wdata_in),
    .strb_in      (vif.strb_in),
    .rdata_out    (vif.rdata_out),
    .transfer_done(vif.transfer_done),
    .error        (vif.error)
);

  initial begin
    PRESETn = 0;
    #20;
    PRESETn = 1;
  end

  initial begin
    uvm_config_db#(virtual intf)::set(null,"*","vif",vif);
  end

  initial begin
    run_test("random_pready_write_test");
  end

endmodule
