class apb_sequence_item extends uvm_sequence_item;
  `uvm_object_utils(apb_sequence_item)
  rand logic [`DATA_WIDTH-1:0] PRDATA;
  rand logic PREADY;
  rand logic PSLVERR;
  rand logic transfer;
  rand logic write_read;
  rand logic [`ADDR_WIDTH-1:0] addr_in;
  rand logic [`DATA_WIDTH-1:0] wdata_in;
  rand logic [`DATA_WIDTH/8-1:0] strb_in;
  logic [`ADDR_WIDTH-1:0] PADDR;
  logic PSEL;
  logic PENABLE;
  logic PWRITE;
  logic [`DATA_WIDTH-1:0] PWDATA;
  logic [(`DATA_WIDTH/8)-1:0] PSTRB;
  logic [`DATA_WIDTH-1:0] rdata_out;
  logic transfer_done;
  logic error;

  function new(string name="apb_sequence_item");
    super.new(name);
  endfunction

endclass
