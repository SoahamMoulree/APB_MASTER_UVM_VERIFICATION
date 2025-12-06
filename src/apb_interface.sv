`include "defines.svh"
interface intf(input bit PCLK, PRESETn);

  logic PSEL;
  logic PENABLE;
  logic PWRITE;
  logic [`ADDR_WIDTH - 1:0] PADDR;
  logic [`DATA_WIDTH - 1:0] PWDATA;
  logic [(`DATA_WIDTH/8)-1:0]PSTRB;
  logic [`DATA_WIDTH - 1:0] PRDATA;
  logic PREADY;
  logic PSLVERR;
  logic transfer;
  logic write_read;
  logic [`ADDR_WIDTH - 1:0] addr_in;
  logic [`DATA_WIDTH - 1:0] wdata_in;
  logic [`DATA_WIDTH - 1:0] rdata_out;
  logic [(`DATA_WIDTH/8) - 1:0] strb_in;
  logic transfer_done;
  logic error;

  clocking drv_cb@(posedge PCLK);
    output addr_in,wdata_in,PREADY,PSLVERR,transfer,write_read,PRDATA,strb_in;
  endclocking

  clocking mon_cb@(posedge PCLK);
    input PSEL,PENABLE,PWRITE,PADDR,PWDATA,PSTRB,PRDATA,PREADY,PSLVERR,transfer,write_read,addr_in,wdata_in,strb_in,transfer_done,error;
  endclocking


endinterface
