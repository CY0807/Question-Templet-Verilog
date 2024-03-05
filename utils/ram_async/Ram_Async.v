
// Big-Endian : low address store high bit of data, when bigger data is split


module Ram_Async
#(
    parameter DWI = 8   ,   // data width in
    parameter AWI = 7   ,   // address width in
    parameter DWO = 16  ,   // data width out
    parameter AWO = 6       // address width out
)
(
    input                       wr_clk    ,
    input                       wr_en     ,            
    input       [AWI-1:0]       wr_addr   ,
    input       [DWI-1:0]       wr_data   ,

    input                       rd_clk    ,
    input       [AWO-1:0]       rd_addr   ,
    output reg  [DWO-1:0]       rd_data
);

localparam DEPTH_WR = {1'b1, {AWI{1'b0}}};
localparam DEPTH_RD = {1'b1, {AWO{1'b0}}};

localparam IS_EXPAND = DWI < DWO ? 1 : 0;
localparam EXPAND = DWO / DWI;
localparam SHRINK = DWI / DWO;
localparam EXPAND_BIT = AWI - AWO;
localparam SHRINK_BIT = AWO - AWI;

genvar i;
generate
    if(IS_EXPAND) begin
        // mem
        reg [DWI-1:0] mem [0:DEPTH_WR-1];

        // write
        always@(posedge wr_clk) begin
            if(wr_en) begin
                mem[wr_addr] <= wr_data;
            end
        end

        // read
        for(i=0; i<EXPAND; i=i+1) begin
            always@(posedge rd_clk) begin           
                rd_data[DWO-1-i*DWI : DWO-(i+1)*DWI] <= mem[(rd_addr << EXPAND_BIT) + i]; 
                // Big-Endian
            end
        end
    end

    else begin
        // mem
        reg [DWO-1:0] mem [0:DEPTH_RD-1];

        // write
        for(i=0; i<SHRINK; i=i+1) begin
            always@(posedge wr_clk) begin
                if(wr_en) begin         
                    mem[(wr_addr << SHRINK_BIT) + i] <= wr_data[DWI-1-i*DWO : DWI-(i+1)*DWO];
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
    .DWI (8  )  ,   // data width in
    .AWI (7  )  ,   // address width in
    .DWO (16 )  ,   // data width out
    .AWO (6  )      // address width out
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

