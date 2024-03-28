
// Despcription: This is a templet for doing verilog questions
// Author: Chris Chen
// Date: 2024-02-27
// Version: 1.0

`timescale 1ns / 1ps

module tb_Adders();

parameter PERIOD = 20;


/************************* 1. signals *************************/

// clock and reset
reg clk, rst_n;

// input and output signals
reg [3:0] A, B;
reg [4:0] OUT_REAL;
reg C_in;
wire [4:0] OUT_RAC, OUT_CLA;

// simulation signals
reg is_finish;
integer i;


/************************ 2. simulation ***********************/

always #(PERIOD/2) clk = ~clk;

// work flow
initial begin
  $display("\n***** Simulation Begin *****\n");
  clk = 1;
  rst_n = 0;
  #100;
  rst_n = 1;
    
  wait(is_finish);
  #100;
  $display("\n***** Simulation Finish *****\n");
  $finish;
end

// init vars
initial begin
  i = 0;
  A = 0;
  B = 0;
  C_in = 0;
  OUT_REAL = 0;
  is_finish = 0;
end

// time out
initial begin
  # (PERIOD * 50000 * 2) // 2ms @ 50MHz
  $display("\n***** Timeout Finish *****\n");
  $finish;
end

// simulation logic
initial begin
  wait(rst_n);
  # PERIOD;
    
  for(i=0; i<100; i=i+1) begin
    wait(clk)
    A = $random;
    B = $random;
    C_in = $random;
    OUT_REAL = A + B + C_in;

    # (PERIOD/10);

    if(OUT_REAL != OUT_RAC) begin
      $display("RAC error, A:%d, B:%d, C_in_%d, RAC:%D, REAL:%d", A, B, C_in, OUT_RAC, OUT_REAL);
      $finish;
    end
    if(OUT_REAL != OUT_CLA) begin
      $display("CLA error, A:%d, B:%d, C_in_%d, CLA:%D, REAL:%d", A, B, C_in, OUT_CLA, OUT_REAL);
      $finish;
    end
  end

  $display("test pass");
       
  is_finish = 1;
end


/************************ 3. others ***************************/

initial begin  
  $dumpfile("wave.vcd"); 
  $dumpvars(0, tb_Adders);
end

Adder_CLA4 Adder_CLA4_inst
(
	.A      (A      ),
	.B      (B      ),
  .C_in   (C_in   ),
	.C_out  (OUT_CLA),
  .G      (       ),
  .P      (       ) 
);

Adder_RAC Adder_RAC_inst
(
  .A      (A      ),
  .B      (B      ),
  .C_in   (C_in   ),
  .C_out  (OUT_RAC)
);

endmodule



