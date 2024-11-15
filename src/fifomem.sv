module fifomem #(
    parameter DSIZE = 8,  // Memory data word width
    parameter ASIZE = 4   // Number of mem address bits
) (
    input  logic             wclk,
    input  logic             wclken,
    input  logic             wfull,
    input  logic [ASIZE-1:0] waddr,
    input  logic [DSIZE-1:0] wdata,
    input  logic [ASIZE-1:0] raddr,
    output logic [DSIZE-1:0] rdata
);

`ifdef VENDORRAM
  // Instantiation of a vendor's dual-port RAM
  vendor_ram mem (
      .dout(rdata),
      .din(wdata),
      .waddr(waddr),
      .raddr(raddr),
      .wclken(wclken),
      .wclken_n(wfull),
      .clk(wclk)
  );
`else
  // RTL memory model
  localparam DEPTH = 1 << ASIZE;

  logic [DSIZE-1:0] mem[DEPTH];

  always @(posedge wclk) begin
    if (wclken && !wfull) mem[waddr] <= wdata;
  end

  assign rdata = mem[raddr];
`endif
endmodule : fifomem
