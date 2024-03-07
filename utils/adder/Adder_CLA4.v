
module Adder_CLA4
(
	input   [3:0]   A    ,
	input   [3:0]   B    ,
    input           C_in ,
	output  [4:0]   OUT  ,
    output          G    ,
    output          P
);

wire [3:0] S;
wire [4:0] Ci;

assign Ci[0] = C_in;

genvar i;
generate
	for(i=0; i<4; i=i+1) begin
		Add1 Add1_inst(
			.A      (A[i]   ),
			.B      (B[i]   ),
			.C_in   (Ci[i]  ),
			.S      (S[i]   ),
			.G      (G[i]   ),
			.P      (P[i]   )
		);
	end
endgenerate

CLA_4 CLA_4_inst
(
	.P      (P        ),
	.G      (G        ),
	.C_in   (C_in     ),
	.Ci     (Ci[4:1]  ),
	.Gm     (G        ),
	.Pm     (P        )
);

assign OUT = {Ci[4], S};


endmodule

// instantiation
/* 

Adder_CLA4 Adder_CLA4_inst
(
	.A    (A    ) ,
	.B    (B    ) ,
    .C_in (C_in ) ,
	.OUT  (OUT  ) ,
    .G    (G    ) ,
    .P    (P    ) 
);


*/