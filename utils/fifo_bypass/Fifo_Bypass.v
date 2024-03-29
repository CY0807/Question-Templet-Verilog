

module Fifo_Bypass
#(
  WIDTH=8,
  DEPTH=128
)
(
  input                       clk           ,
  input                       rst_n         ,
  input                       wr_en         ,
  input   [WIDTH-1:0]         wr_data       ,
  input                       rd_en         ,
  output  [WIDTH-1:0]         rd_data       ,
  output                      empty         ,
  output                      almostempty   ,
  output                      full          ,
  output                      almostfull    ,
  output  [$clog2(DEPTH):0]   data_cnt
);


wire wr_en_fifo, rd_en_fifo, rd_bypass;
wire [WIDTH-1:0] rd_data_fifo;

assign rd_bypass = rd_en && wr_en && empty;
assign wr_en_fifo = wr_en && !rd_bypass;
assign rd_en_fifo = rd_en && !rd_bypass;
assign rd_data = rd_bypass ? wr_data : rd_data_fifo;


Fifo_Sync 
#(
  .WIDTH(WIDTH),
  .DEPTH(DEPTH)
)
Fifo_Sync_inst
(
  .clk         (clk          ),
  .rst_n       (rst_n        ),
  .wr_en       (wr_en_fifo   ),
  .wr_data     (wr_data      ),
  .rd_en       (rd_en_fifo   ),
  .rd_data     (rd_data_fifo ),
  .empty       (empty        ),
  .almostempty (almostempty  ),
  .full        (full         ),
  .almostfull  (almostfull   ),
  .data_cnt    (data_cnt     )  
);


endmodule

//  instantiation
/*  

Fifo_Bypass 
#(
  .WIDTH(8),
  .DEPTH(128)
)
Fifo_Bypass_inst
(
  .clk         (clk          ),
  .rst_n       (rst_n        ),
  .wr_en       (wr_en        ),
  .wr_data     (wr_data      ),
  .rd_en       (rd_en        ),
  .rd_data     (rd_data      ),
  .empty       (empty        ),
  .almostempty (almostempty  ),
  .full        (full         ),
  .almostfull  (almostfull   ),
  .data_cnt    (data_cnt     )  
);

*/
