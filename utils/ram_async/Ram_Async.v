
// Big-Endian : low address store high bit of data, when bigger data is split


module Ram_Async
#(
    parameter WIDTH_WR=8,
    parameter DEPTH_WR=128,
    parameter WIDTH_RD=16,
    parameter DEPTH_RD=64
)
(
    input                               wr_clk    ,
    input                               wr_en     ,            
    input       [$clog2(DEPTH_WR)-1:0]  wr_addr   ,
    input       [WIDTH_WR-1:0]          wr_data   ,

    input                               rd_clk    ,
    input       [$clog2(DEPTH_RD)-1:0]  rd_addr   ,
    output reg  [WIDTH_RD-1:0]          rd_data
);

localparam IS_EXPAND = WIDTH_WR < WIDTH_RD ? 1 : 0;
localparam EXPAND = WIDTH_RD / WIDTH_WR;
localparam SHRINK = WIDTH_WR / WIDTH_RD;

genvar i;
generate
    if(IS_EXPAND) begin
        // mem
        reg [WIDTH_WR-1:0] mem [0:DEPTH_WR-1];

        // write
        always@(posedge wr_clk) begin
            if(wr_en) begin
                mem[wr_addr] <= wr_data;
            end
        end

        // read
        for(i=0; i<EXPAND; i=i+1) begin
            always@(posedge rd_clk) begin           
                rd_data[WIDTH_RD-1-i*WIDTH_WR : WIDTH_RD-(i+1)*WIDTH_WR] <= mem[rd_addr*EXPAND + i]; 
                // Big-Endian
            end
        end
    end

    else begin
        // mem
        reg [WIDTH_RD-1:0] mem [0:DEPTH_RD-1];

        // write
        for(i=0; i<SHRINK; i=i+1) begin
            always@(posedge wr_clk) begin
                if(wr_en) begin         
                    mem[wr_addr*SHRINK + i] <= wr_data[WIDTH_WR-1-i*WIDTH_RD : WIDTH_WR-(i+1)*WIDTH_RD];
                    // Big-Endian
                end
            end
        end

        // read
        always@(posedge rd_clk) begin
            rd_data <= mem[rd_addr];
        end
    end
endgenerate


endmodule

//  instantiation
/*  

Ram_Async
#( 
    .WIDTH_WR(8),
    .DEPTH_WR(128),
    .WIDTH_RD(16),
    .DEPTH_RD(64)
)
Ram_Async_inst
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

