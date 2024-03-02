
// despription  : a fixed priority arbiter
// input        : each bit of the input req is a request
// output       : a one-hot-vector wire gnt
// rules        : the lowest bit has the highest priority
// author       : Chen Yan
// date         : 2024-03-02

module Arbiter_Fixed_priority 
#(
    parameter REQ_WIDTH = 8
)
(
    input   [REQ_WIDTH-1:0] req,
    output  [REQ_WIDTH-1:0] gnt
);

wire [REQ_WIDTH-1:0] pre_req;

// this makes a mask: the bits higher than the lowest bit are all 1, and others are 0
assign pre_req[REQ_WIDTH-1:1] = pre_req[REQ_WIDTH-2:0] | req[REQ_WIDTH-2:0];
assign pre_req[0] = 1'b0;
assign gnt = req & ~pre_req;

endmodule



// instantiation
/*  

Arbiter_Fixed_priority 
#(
    .REQ_WIDTH(8)
)
Arbiter_Fixed_priority_inst
(
    .req(req),
    .gnt(gnt)
);

*/



// another implementation
/*

assign gnt = req & ~(req-1);

// ~(req-1) is the complement of req
// a data AND with its complement get the lowest bit in a one-hot-vector

*/




