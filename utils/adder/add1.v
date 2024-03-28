
module Add1
(
  input   A     ,
  input   B     ,
  input   C_in  ,
  output  S     ,
  output  G     ,
  output  P
);

assign S = A ^ B ^ C_in;
assign G = A & B;
assign P = A | B;

endmodule 

// instantiation
/*

Add1 Add1_inst(
  .A    (A    ),
  .B    (B    ),
  .C_in (C_in ),
  .S    (S    ),
  .G    (G    ),
  .P    (P    )
)

*/
