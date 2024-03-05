
// Big-Endian : low address store high bit of data, when bigger data is split


module Fifo_Async
#(
    parameter WIDTH_WR=8,
    parameter DEPTH_WR=128,
    parameter WIDTH_RD=16,
    parameter DEPTH_RD=64
)
(   
    input                               rst_n           ,

    input                               wr_clk          ,
    input                               wr_en           ,            
    input       [WIDTH_WR-1:0]          wr_data         ,

    input                               rd_clk          ,
    input                               rd_en           ,  
    output reg  [WIDTH_RD-1:0]          rd_data         ,

    output                              full            ,
    output                              almost_full     ,
    output                              rd_data_cnt     ,
    output                              empty           ,
    output                              almost_empty    ,
    output                              wr_data_cnt
);

localparam DEPTH_BIT_WR = $clog2(DEPTH_WR);
localparam DEPTH_BIT_RD = $clog2(DEPTH_RD);

localparam IS_EXPAND = WIDTH_WR < WIDTH_RD ? 1 : 0;
localparam EXPAND = WIDTH_RD / WIDTH_WR;
localparam SHRINK = WIDTH_WR / WIDTH_RD;

// ********************* read, write ptr and their overflow flag  *********************
reg [DEPTH_BIT_WR-1:0] wr_ptr;
reg [DEPTH_BIT_RD-1:0] rd_ptr;
reg wr_over, rd_over;

// write ptr
always@(posedge wr_clk or negedge rst_n) begin
    if(!rst_n) begin
        wr_ptr <= 0;
        wr_over <= 0;
    end
    else begin
        if(wr_en && !full) begin
            wr_ptr <= wr_ptr + 1;
            if(wr_ptr == DEPTH_WR-1) begin
                wr_ptr <= 0;
                wr_over <= ~wr_over;
            end
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
            rd_ptr <= rd_ptr + 1;
            if(rd_ptr == DEPTH_RD-1) begin
                rd_ptr <= 0;
                rd_over <= ~rd_over;
            end
        end
    end
end





genvar i;
generate
    if(IS_EXPAND) begin
        





    end

    else begin

    end
endgenerate


endmodule

//  instantiation
/*  

Fifo_Async
#( 
    .WIDTH_WR(8),
    .DEPTH_WR(128),
    .WIDTH_RD(16),
    .DEPTH_RD(64)
)
Fifo_Async_inst
(
    .wr_clk    (wr_clk   ),     
    .wr_en     (wr_en    ),
    .wr_addr   (wr_addr  ),
    .wr_data   (wr_data  ),
    .rd_clk    (rd_clk   ),
    .rd_addr   (rd_addr  ),
    .rd_data   (rd_data  )
);

*/

