
// Despription: This is a glitch free clock switch circuit
// clk_out = select == 1 ? clk_a : clk_b

// rule no.1: disable all clocks before enable a new clock
// rule no.2: switch at the negetive clock edge to avoid glitch


module Clk_Switch
(
  input  wire clk_a   ,
  input  wire clk_b   ,
  input  wire rst_n   ,
  input  wire select  ,
  output wire clk_out
);

// var definition

reg enable_a, enable_a_r, enable_b, enable_b_r;

// clock a 

always@(posedge clk_a or negedge rst_n) begin
  if(!rst_n) begin
    enable_a <= 0;
  end
  else begin
    enable_a <= select & !enable_b_r;
  end
end

always@(negedge clk_a or negedge rst_n) begin
  if(!rst_n) begin
    enable_a_r <= 0;
  end
  else begin
    enable_a_r <= enable_a;
  end
end

// clock b

always@(posedge clk_b or negedge rst_n) begin
  if(!rst_n) begin
    enable_b <= 0;
  end
  else begin
    enable_b <= !select & !enable_a_r;
  end
end

always@(negedge clk_b or negedge rst_n) begin
  if(!rst_n) begin
    enable_b_r <= 0;
  end
  else begin
    enable_b_r <= enable_b;
  end
end

// clock out

assign clk_out = (enable_a_r & clk_a) | (enable_b_r & clk_b);

endmodule



// instantiation
/*


Clk_Switch Clk_Switch_inst
(
  .clk_a   (clk_a    ),
  .clk_b   (clk_b    ),
  .rst_n   (rst_n    ),
  .select  (select   ),
  .clk_out (clk_out  )
);


*/
