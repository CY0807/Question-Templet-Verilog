
module Adder_RAC
(
	input   [3:0]   A     ,
	input   [3:0]   B     ,
  input           C_in  ,
	output  [4:0]   C_out 
);

wire [4:0] Ci;
wire [3:0] S;

assign Ci[0] = C_in;
assign C_out = {Ci[4], S};

genvar i;

generate 
  for(i=0; i<4; i=i+1) begin: adder_full_loop
    Adder_Full Adder_Full_inst
    (
    	.a    (A[i]     ),     	
    	.b    (B[i]     ),		
    	.cin  (Ci[i]    ),		
    	.sum  (S[i]     ),		
    	.cout (Ci[i+1]  )		
    );
  end
endgenerate

endmodule

// instantiation
/*

Adder_RAC Adder_RAC_inst
(
  .A      (A      ),
  .B      (B      ),
  .C_in   (C_in   ),
  .C_out  (C_out  )
);

*/
