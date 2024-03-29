
module Fifo_Sync 
# 
(
  parameter WIDTH=8,
  parameter DEPTH=128
)
(
  input                       clk         ,
  input                       rst_n       ,
  input                       wr_en       ,
  input   [WIDTH-1:0]         wr_data     ,
  input                       rd_en       ,
  output  [WIDTH-1:0]         rd_data     ,
  output                      empty       ,
  output                      almostempty ,
  output                      full        ,
  output                      almostfull  ,
  output  [$clog2(DEPTH):0]   data_cnt
);

localparam ALMOST_EMPTY=1;      // number of items greater than zero
localparam ALMOST_FULL=DEPTH-1; // number of items less than DEPTH

reg [WIDTH-1:0] wr_data_reg;
reg [$clog2(DEPTH)-1:0] wPtr;
reg [$clog2(DEPTH)-1:0] rPtr;
reg [$clog2(DEPTH):0] cnt;
wire fifoWrValid;
wire fifoRdValid;

assign empty = cnt == 0 ? 1:0;
assign almostempty = cnt <= ALMOST_EMPTY ? 1:0;
assign full = cnt == DEPTH ? 1:0;
assign almostfull = cnt >= ALMOST_FULL ? 1:0;
assign fifoWrValid = !full & wr_en;
assign fifoRdValid = !empty & rd_en;
assign data_cnt = cnt;

Ram
#( 
  .WIDTH(WIDTH),
  .DEPTH(DEPTH)
)
Ram_inst
(
  .clk       (clk         ),     
  .wr_en     (fifoWrValid ),
  .wr_addr   (wPtr        ),
  .wr_data   (wr_data     ),
  .rd_addr   (rPtr        ),
  .rd_data   (rd_data     )
);
    
// write pointer logic
always @ (posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    wPtr <= 0;
  end
  else if (fifoWrValid) begin
    wPtr <= wPtr + 1'b1;
    if (wPtr == DEPTH-1) begin
      wPtr <= 0;
    end
  end
end
    
// read pointer logic
always @ (posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    rPtr <= 0;
  end
  else if (fifoRdValid) begin
    rPtr <= rPtr + 1'b1;  
    if (rPtr == DEPTH-1) begin
      rPtr <= 0;
    end
  end
end  

// count logic
always @ (posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    cnt <= 0;
  end
  else if (fifoWrValid & !fifoRdValid) begin
    cnt <= cnt+1;
  end
  else if (fifoRdValid & !fifoWrValid) begin
    cnt <= cnt-1;
  end
end
    
    
endmodule 

//  instantiation
/*  

Fifo_Sync 
#(
  .WIDTH(8),
  .DEPTH(128)
)
Fifo_Sync_inst
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



