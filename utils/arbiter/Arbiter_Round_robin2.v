
// despription  : round robin arbiter,
//                base on fixed arbiter and mask
// input        : each bit of the input req is a request
// output       : a one-hot-vector wire gnt
// rules        : at the begining, the lowest bit has the highest 
//                priority. After it fires, its priority turns lowest.
// author       : Chen Yan
// date         : 2024-03-02

module Arbiter_Round_robin2
#(
  parameter REQ_WIDTH = 8
)
(
  input                   clk     ,
  input                   rst_n   ,
  input   [REQ_WIDTH-1:0] req     ,
  output  [REQ_WIDTH-1:0] gnt
);

reg [REQ_WIDTH-1:0] mask;
wire [REQ_WIDTH-1:0] req_mask, req_unmask, mask_pre, gnt_mask, gnt_unmask;

assign mask_pre[0] = 1'b0;
assign mask_pre[REQ_WIDTH-1:1] = mask_pre[REQ_WIDTH-2:0] | gnt[REQ_WIDTH-2:0];
assign req_mask = req & mask;
assign req_unmask = req;
assign gnt = (|req_mask) ? gnt_mask : gnt_unmask;

always@(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    mask <= {REQ_WIDTH{1'b1}};
  end
  else if(|req) begin
    mask <= mask_pre;
  end
end

Arbiter_Fixed_priority 
#(
  .REQ_WIDTH(REQ_WIDTH)
)
Arbiter_Fixed_priority_inst0
(
  .req(req_mask),
  .gnt(gnt_mask)
);

Arbiter_Fixed_priority 
#(
  .REQ_WIDTH(REQ_WIDTH)
)
Arbiter_Fixed_priority_inst1
(
  .req(req_unmask),
  .gnt(gnt_unmask)
);

endmodule


// instantiation
/*  

Arbiter_Round_robin2
#(
  .REQ_WIDTH(8)
)
Arbiter_Round_robin2_inst
(
  .clk     (clk  ),
  .rst_n   (rst_n),
  .req     (req  ),
  .gnt     (gnt  )
);

*/   


