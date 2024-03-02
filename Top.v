
// Despcription: This is a templet for doing verilog questions
// Author: Chris Chen
// Date: 2024-02-27
// Version: 1.0

module Top
#( 
    parameter P1 = 1,
    parameter P2 = 2
)
(
    input  wire clk,
    input  wire rst_n,

    input  wire a,
    input  wire b,
    output wire c
    
);
    
// signals define

// logic

assign c = a & b;

endmodule



//  instantiation
/*  

Top 
#( 
    .P1(1),
    .P2(2)
)
Top_inst
(
    .clk(clk),
    .rst_n(rst_n),
    .a(a),
    .b(b),
    .c(c)
);

*/