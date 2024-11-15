module rptr_empty #(
    parameter ASIZE = 4
) (
    input  logic             rclk,
    input  logic             rrst_n,
    input  logic             rinc,
    output logic             rempty,
    output logic [ASIZE-1:0] raddr,
    output logic [ASIZE : 0] rptr,
    input  logic [ASIZE : 0] rq2_wptr
);

  logic [ASIZE:0] rbin;
  logic [ASIZE:0] rgraynext, rbinnext;

  //-------------------
  // GRAYSTYLE2 pointer
  //-------------------
  always @(posedge rclk or negedge rrst_n)
    if (!rrst_n) {rbin, rptr} <= 0;
    else {rbin, rptr} <= {rbinnext, rgraynext};

  // Memory read-address pointer (okay to use binary to address memory)
  assign raddr = rbin[ASIZE-1:0];
  assign rbinnext = rbin + (rinc & ~rempty);
  assign rgraynext = (rbinnext >> 1) ^ rbinnext;

  //---------------------------------------------------------------
  // FIFO empty when the next rptr == synchronized wptr or on reset
  //---------------------------------------------------------------
  logic rempty_val;
  assign rempty_val = (rgraynext == rq2_wptr);

  always @(posedge rclk or negedge rrst_n)
    if (!rrst_n) rempty <= 1'b1;
    else rempty <= rempty_val;

endmodule
