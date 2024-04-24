
// Despcription: a singular port ram
// Author: Chris Chen
// Data: 2024-04-16
// Version: 1.0


module Ram_Sig
#(
  parameter WIDTH = 8,
  parameter DEPTH = 128
)
(
  input  wire                       clk      ,
  input  wire                       rst_n    ,
  input  wire                       wren     ,
  input  wire [WIDTH-1:0]           data_in  ,
  input  wire [$clog2(DEPTH)-1:0]   addr     ,
  output wire [WIDTH-1:0]           data_out
);

reg [WIDTH-1:0] mem [DEPTH-1:0];
reg [WIDTH-1:0] data_rd;
reg wren_r;

always@(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    data_rd <= 0;
  end
  else if(!wren) begin
    data_rd <= mem[addr];
  end
end

always@(posedge clk) begin
  if(wren) begin
    mem[addr] <= data_in;
  end
end

assign data_out = data_rd;

endmodule

//  instantiation
/*

Ram_Sig
#(
  .WIDTH(8),
  .DEPTH(128)
)
Ram_Sig_inst
(
  .clk      (clk      ),
  .rst_n    (rst_n    ),
  .wren     (wren     ),
  .data_in  (data_in  ),
  .addr     (addr     ),
  .data_out (data_out )
);

*/
