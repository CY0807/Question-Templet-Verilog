
// Big-Endian : low address store high bit of data, when bigger data is split


module Fifo_Async
#(
  parameter DWI = 8   ,   // data width in
  parameter AWI = 7   ,   // address width in
  parameter DWO = 16  ,   // data width out
  parameter AWO = 6       // address width out
)
(   
  input                     rst_n           ,

  input                     wr_clk          ,
  input                     wr_en           ,            
  input       [DWI-1:0]     wr_data         ,

  input                     rd_clk          ,
  input                     rd_en           ,  
  output      [DWO-1:0]     rd_data         ,

  output                    full            ,
  output                    almost_full     ,
  output      [AWO:0]       rd_data_cnt     ,
  output                    empty           ,
  output                    almost_empty    ,
  output      [AWI:0]       wr_data_cnt
);

localparam DEPTH_WR = {1'b1, {AWI{1'b0}}};
localparam DEPTH_RD = {1'b1, {AWO{1'b0}}};

localparam IS_EXPAND = DWI < DWO ? 1 : 0;
localparam EXPAND = DWO / DWI;
localparam SHRINK = DWI / DWO;
localparam EXPAND_BIT = AWI - AWO;
localparam SHRINK_BIT = AWO - AWI;

localparam ALMOST_THRESH = 3; // programmable almost full / empty


reg     [AWI-1:0]       wr_ptr                      ;
wire    [AWI-1:0]       wr_ptr_2rd                  ; // write ptr in read clock
wire    [AWI-1:0]       wr_ptr_pre_1                ;
wire    [AWI-1:0]       wr_ptr_pre_almost           ;
reg     [AWO-1:0]       rd_ptr                      ;
wire    [AWO-1:0]       rd_ptr_2wr                  ; // read ptr in write clock
wire    [AWO-1:0]       rd_ptr_pre_1                ;
wire    [AWO-1:0]       rd_ptr_pre_almost           ;
reg                     wr_over, rd_over            ; // overflow flags
wire                    wr_over_2rd, rd_over_2wr    ;
wire                    over_flag                   ;

// write ptr
always@(posedge wr_clk or negedge rst_n) begin
  if(!rst_n) begin
    wr_ptr <= 0;
    wr_over <= 0;
  end
  else begin
    if(wr_en && !full) begin
      {wr_over, wr_ptr} <= {wr_over, wr_ptr} + 1;
    end
  end
end

// read ptr
always@(posedge rd_clk or negedge rst_n) begin
  if(!rst_n) begin
    rd_ptr <= 0;
    rd_over <= 0;
  end
  else begin
    if(rd_en && !empty) begin
      {rd_over, rd_ptr} <= {rd_over, rd_ptr} + 1;
    end
  end
end

// convert write ptr to read clock

Cnt_Cross_clock #(
  .WIDTH(AWI+1)
) 
Cnt_Cross_clock_wrptr_2rd ( 
  .clk_in   ( wr_clk            ),
  .cnt_in   ( {wr_over, wr_ptr} ),
  .clk_out  ( rd_clk            ),
  .cnt_out  ( {wr_over_2rd, wr_ptr_2rd} )
);

// convert read ptr to write clock

Cnt_Cross_clock #(
  .WIDTH(AWO+1)
) 
Cnt_Cross_clock_rdptr_2wr ( 
  .clk_in   ( rd_clk            ),
  .cnt_in   ( {rd_over, rd_ptr} ),
  .clk_out  ( wr_clk            ),
  .cnt_out  ( {rd_over_2wr, rd_ptr_2wr} )
);

// full, empty signals .etc

assign over_flag = wr_over == rd_over;
assign wr_ptr_pre_almost = wr_ptr + ALMOST_THRESH;
assign rd_ptr_pre_almost = rd_ptr + ALMOST_THRESH;

genvar i;
generate
  if(IS_EXPAND) begin
    assign empty        = (rd_ptr >= wr_ptr_2rd>>EXPAND_BIT)                && over_flag    ;
    assign almost_empty = (rd_ptr_pre_almost >= wr_ptr_2rd>>EXPAND_BIT)     && over_flag    ;
    assign full         = (rd_ptr_2wr<<EXPAND_BIT <= wr_ptr)                && !over_flag   ;
    assign almost_full  = (rd_ptr_2wr<<EXPAND_BIT <= wr_ptr_pre_almost)     && !over_flag   ;

    assign rd_data_cnt = ({~over_flag, wr_ptr_2rd} >> EXPAND_BIT) - rd_ptr;
    assign wr_data_cnt = {~over_flag, wr_ptr} - (rd_ptr_2wr<<EXPAND_BIT);
  end

  else begin
    assign empty        = (rd_ptr >= wr_ptr_2rd<<SHRINK_BIT)                && over_flag    ;
    assign almost_empty = (rd_ptr_pre_almost >= wr_ptr_2rd<<SHRINK_BIT)     && over_flag    ;
    assign full         = (rd_ptr_2wr>>SHRINK_BIT <= wr_ptr)                && !over_flag   ;
    assign almost_full  = (rd_ptr_2wr>>SHRINK_BIT <= wr_ptr_pre_almost)     && !over_flag   ;

    assign rd_data_cnt = ({~over_flag, wr_ptr_2rd}<<SHRINK_BIT) - rd_ptr;
    assign wr_data_cnt = {~over_flag, wr_ptr} - (rd_ptr_2wr>>SHRINK_BIT);
  end
endgenerate



// mem

Ram_Async
#( 
  .DWI (DWI)  ,   // data width in
  .AWI (AWI)  ,   // address width in
  .DWO (DWO)  ,   // data width out
  .AWO (AWO)      // address width out
)
Ram_Async_inst
(
  .wr_clk    (wr_clk   ),     
  .wr_en     (wr_en & !full),
  .wr_addr   (wr_ptr   ),
  .wr_data   (wr_data  ),
  .rd_clk    (rd_clk   ),
  .rd_addr   (rd_ptr   ),
  .rd_data   (rd_data  )
);


endmodule

//  instantiation
/*  

Fifo_Async
#(
  .DWI (8  ),   // data width in
  .AWI (7  ),   // address width in
  .DWO (16 ),   // data width out
  .AWO (6  )    // address width out
)
Fifo_Async_inst
(   
  .rst_n          (rst_n        ),
  .wr_clk         (wr_clk       ),
  .wr_en          (wr_en        ),            
  .wr_data        (wr_data      ), // [DWI-1:0]
  .rd_clk         (rd_clk       ),
  .rd_en          (rd_en        ),  
  .rd_data        (rd_data      ), // [DWO-1:0]
  .full           (full         ),
  .almost_full    (almost_full  ),
  .wr_data_cnt    (wr_data_cnt  ), // [AWI-1:0]
  .empty          (empty        ),
  .almost_empty   (almost_empty ),
  .rd_data_cnt    (rd_data_cnt  )  // [AWO-1:0]
);

*/

