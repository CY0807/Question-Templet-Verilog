
module Ram 
#(
    parameter WIDTH=8,
    parameter DEPTH=128
)
(
    input                        clk       ,
    input                        wr_en     ,            
    input   [$clog2(DEPTH)-1:0]  wr_addr   ,
    input   [WIDTH-1:0]          wr_data   ,
    input   [$clog2(DEPTH)-1:0]  rd_addr   ,
    output  [WIDTH-1:0]          rd_data
);

reg [WIDTH-1:0] mem [0:DEPTH-1];
reg [WIDTH-1:0] rd_data_reg;

// memeroy write
always@(posedge clk) begin
    if(wr_en) begin
        mem[wr_addr] <= wr_data;
    end
end

//memory read
always @(posedge clk) begin
    rd_data_reg <= mem[rd_addr];
end

assign rd_data = rd_data_reg;

endmodule

//  instantiation
/*  

Ram
#( 
    .WIDTH(8),
    .DEPTH(128)
)
Ram_inst
(
    .clk       (clk      ),     
    .wr_en     (wr_en    ),
    .wr_addr   (wr_addr  ),
    .wr_data   (wr_data  ),
    .rd_addr   (rd_addr  ),
    .rd_data   (rd_data  )
);

*/

