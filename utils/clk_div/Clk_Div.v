
// Despcription: This is a templet for doing verilog questions
// Function: Divide an input clock with an integer parameter
// Author: Chris Chen
// Date: 2024-03-27
// Version: 1.0

module Clk_Div
#( 
  parameter DIV = 3
)
(
  input  wire clk_in  ,
  input  wire rst_n   ,
  output wire clk_out
);

// parameter define

localparam IS_ODD = DIV % 2;
localparam HALF = DIV >> 1;
    
// signals define

// logic

reg [$clog2(DIV)-1:0] cnt;

always@(posedge clk_in or negedge rst_n) begin
  if(!rst_n) begin
    cnt <= 0; 
  end
  else begin
    cnt <= cnt + 1;
    if(cnt == DIV-1) begin
      cnt <= 0;
    end
  end
end


generate
  // no clk div
  if(DIV == 0 || DIV == 1) begin: clk_div_none
    assign clk_out = rst_n ? clk_in : 0;
  end
  
  // clk div by even
  else if(!IS_ODD) begin: clk_div_even
    reg clk;

    always@(posedge clk_in or negedge rst_n) begin
      if(!rst_n) begin
        clk <= 0;
      end
      else begin
        clk <= cnt >= HALF;
      end
    end

    assign clk_out = clk;
  end
  
  // clk div by odd
  else begin: clk_div_odd
    reg clk_pos, clk_neg;
    
    always@(posedge clk_in or negedge rst_n) begin
      if(!rst_n) begin
        clk_pos <= 0;
      end
      else begin
        clk_pos <= cnt >= HALF;
      end
    end
      
    always@(negedge clk_in or negedge rst_n) begin
      if(!rst_n) begin
        clk_neg <= 0;
      end
      else begin
        clk_neg <= cnt >= HALF;
      end
    end

    assign clk_out = clk_pos & clk_neg;
  end

endgenerate





endmodule



//  instantiation
/*  

Clk_Div
#( 
  .DIV(3)
)
Clk_Div_inst
(
  .clk_in   (clk_in   ),
  .rst_n    (rst_n    ),
  .clk_out  (clk_out  )
);

*/
