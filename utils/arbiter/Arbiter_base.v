
// despription  : a arbiter with a input priority
// input        : req - each bit of the input req is a request
// input        : base - a one-hot-vector, the bit has the highest priority,
//                       and priority decrease from the bit to the MSB,
//                       and then to the LSB, go back the this bit
// output       : a one-hot-vector wire gnt
// author       : Chen Yan
// date         : 2024-03-02

module Arbiter_base
#(
    parameter REQ_WIDTH = 8
)
(
    input   [REQ_WIDTH-1:0] req     ,
    input   [REQ_WIDTH-1:0] base    ,
    output  [REQ_WIDTH-1:0] gnt
);

wire [2*REQ_WIDTH-1:0] req_double, gnt_double;

assign req_double = {req, req};
assign gnt_double = req_double & ~(req_double - base); // in case base > req
assign gnt = gnt_double[2*REQ_WIDTH-1:REQ_WIDTH] | gnt_double[REQ_WIDTH-1:0];

endmodule


// instantiation
/*  

Arbiter_base
#(
    .REQ_WIDTH(8)
)
Arbiter_base_inst
(
    .req        (req    ),
    .base       (base   ),
    .gnt        (gnt    )
);

*/   


