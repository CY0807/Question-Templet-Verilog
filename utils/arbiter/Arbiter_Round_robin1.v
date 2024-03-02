
// despription  : round robin arbiter,
//                base on arbiter with base priority
// input        : each bit of the input req is a request
// output       : a one-hot-vector wire gnt
// rules        : at the begining, the lowest bit has the highest 
//                priority. After it fires, its priority turns lowest.
// author       : Chen Yan
// date         : 2024-03-02

module Arbiter_Round_robin1
#(
    parameter REQ_WIDTH = 8
)
(
    input                   clk     ,
    input                   rst_n   ,
    input   [REQ_WIDTH-1:0] req     ,
    output  [REQ_WIDTH-1:0] gnt
);

reg [REQ_WIDTH-1:0] base;

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        base <= 'd1;
    end
    else if(|req) begin
        base <= {gnt[REQ_WIDTH-2:0], gnt[REQ_WIDTH-1]};
    end
end

Arbiter_base
#(
    .REQ_WIDTH(REQ_WIDTH)
)
Arbiter_base_inst
(
    .req        (req    ),
    .base       (base   ),
    .gnt        (gnt    )
);

endmodule


// instantiation
/*  

Arbiter_Round_robin1
#(
    .parameter REQ_WIDTH(8)
)
Arbiter_Round_Robin1_inst
(
    .clk     (clk  ),
    .rst_n   (rst_n),
    .req     (req  ),
    .gnt     (gnt  )
);

*/   


