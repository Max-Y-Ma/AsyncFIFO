module async_fifo #(
    parameter DSIZE = 8,
    parameter ASIZE = 4
) (
    // Write Clock Domain Interface
    input  logic             wclk,
    input  logic             wrst_n,
    input  logic             winc,
    output logic             wfull,
    input  logic [DSIZE-1:0] wdata,

    // Read Clock Domain Interface
    input  logic             rclk,
    input  logic             rrst_n,
    input  logic             rinc,
    output logic             rempty,
    output logic [DSIZE-1:0] rdata
);

  // FIFO binary read and write address
  logic [ASIZE-1:0] waddr, raddr;

  // FIFO write pointer and synchronized read pointer
  logic [ASIZE:0] wptr, wq2_rptr;

  // FIFO read pointer and synchronized write pointer
  logic [ASIZE:0] rptr, rq2_wptr;

  sync_r2w sync_r2w0 (
      .wclk(wclk),
      .wrst_n(wrst_n),
      .rptr(rptr),
      .wq2_rptr(wq2_rptr)
  );

  sync_w2r sync_w2r0 (
      .rclk(rclk),
      .rrst_n(rrst_n),
      .wptr(wptr),
      .rq2_wptr(rq2_wptr)
  );

  fifomem #(
      .DSIZE(DSIZE),
      .ASIZE(ASIZE)
  ) fifomem0 (
      .wclk  (wclk),
      .wclken(winc),
      .wfull (wfull),
      .waddr (waddr),
      .wdata (wdata),
      .raddr (raddr),
      .rdata (rdata)
  );

  rptr_empty #(ASIZE) rptr_empty0 (
      .rclk(rclk),
      .rrst_n(rrst_n),
      .rinc(rinc),
      .rempty(rempty),
      .raddr(raddr),
      .rptr(rptr),
      .rq2_wptr(rq2_wptr)
  );

  wptr_full #(ASIZE) wptr_full0 (
      .wclk(wclk),
      .wrst_n(wrst_n),
      .winc(winc),
      .wfull(wfull),
      .waddr(waddr),
      .wptr(wptr),
      .wq2_rptr(wq2_rptr)
  );

endmodule : async_fifo

