

module Adder_Full
(
	input  a    ,     	
	input  b    ,		
	input  cin  ,		
	output sum  ,		
	output cout		
);

	assign sum = (a^b) ^ cin;
	assign cout = (a&b) | ((a^b) & cin);
    
endmodule

// instantiation
/*  

Adder_Full Adder_Full_inst
(
	.a    (a   ),     	
	.b    (b   ),		
	.cin  (cin ),		
	.sum  (sum ),		
	.cout (cout)		
);


*/