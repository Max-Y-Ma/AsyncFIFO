module wptr_full #(
    parameter ASIZE = 4
) (
    input  logic             wclk,
    input  logic             wrst_n,
    input  logic             winc,
    output logic             wfull,
    output logic [ASIZE-1:0] waddr,
    output logic [ASIZE : 0] wptr,
    input  logic [ASIZE : 0] wq2_rptr
);

  logic [ASIZE:0] wbin;
  logic [ASIZE:0] wgraynext, wbinnext;

  // GRAYSTYLE2 pointer
  always @(posedge wclk or negedge wrst_n)
    if (!wrst_n) {wbin, wptr} <= 0;
    else {wbin, wptr} <= {wbinnext, wgraynext};

  // Memory write-address pointer (okay to use binary to address memory)
  assign waddr = wbin[ASIZE-1:0];
  assign wbinnext = wbin + (winc & ~wfull);
  assign wgraynext = (wbinnext >> 1) ^ wbinnext;

  //------------------------------------------------------------------
  // Simplified version of the three necessary full-tests:
  // assign wfull_val=((wgnext[ASIZE] !=wq2_rptr[ASIZE] ) &&
  // (wgnext[ASIZE-1] !=wq2_rptr[ASIZE-1]) &&
  // (wgnext[ASIZE-2:0]==wq2_rptr[ASIZE-2:0]));
  //------------------------------------------------------------------
  assign wfull_val = (wgraynext == {~wq2_rptr[ASIZE:ASIZE-1], wq2_rptr[ASIZE-2:0]});
  always @(posedge wclk or negedge wrst_n)
    if (!wrst_n) wfull <= 1'b0;
    else wfull <= wfull_val;

endmodule
