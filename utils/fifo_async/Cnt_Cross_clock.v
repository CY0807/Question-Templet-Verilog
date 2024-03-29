
// convert a counter from one clock domain to another

module Cnt_Cross_clock
#(
  parameter WIDTH = 8
)
( 
  input                  clk_in     ,
  input     [WIDTH-1:0]  cnt_in     ,
  input                  clk_out    ,
  output    [WIDTH-1:0]  cnt_out
);

wire [WIDTH-1:0] cnt_gray;
reg [WIDTH-1:0] cnt_gray_r1, cnt_gray_r2;

// 1. encode to gray code

assign cnt_gray[WIDTH-1] = cnt_in[WIDTH-1];
assign cnt_gray[WIDTH-2:0] = cnt_in[WIDTH-2:0] ^ cnt_in[WIDTH-1:1];

// 2. cross clock domain clocking

always@(posedge clk_out) begin
  cnt_gray_r1 <= cnt_gray;
  cnt_gray_r2 <= cnt_gray_r1;
end

// 3. decode the gray code to binary

assign cnt_out[WIDTH-1] = cnt_gray_r2[WIDTH-1];
assign cnt_out[WIDTH-2:0] = cnt_gray_r2[WIDTH-2:0] ^ cnt_out[WIDTH-1:1];

endmodule


//  instantiation
/*  

Cnt_Cross_clock
#(
  .WIDTH(WIDTH)
)
Cnt_Cross_clock_inst
( 
  .clk_in   (clk_in )  ,
  .cnt_in   (cnt_in )  ,
  .clk_out  (clk_out)  ,
  .cnt_out  (cnt_out)
);

*/
