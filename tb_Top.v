
// Despcription: This is a templet for doing verilog questions
// Author: Chris Chen
// Date: 2024-02-27
// Version: 1.0

`timescale 1ns / 1ps

module tb_Top();

parameter PERIOD = 20;
parameter WIDTH = 8;
parameter DEPTH = 123;
parameter DPETH_BITS = $clog2(DEPTH);


/************************* 1. signals *************************/

// clock and reset
reg clk, rst_n;

// input and output signals
reg a, b;
wire c;

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
    is_finish = 0;
    a = 0;
    b = 0;
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
        a = ($random) % 2;
        b = ($random) % 2;
        # (PERIOD/10);
        if(c != a & b) begin
            $display("error: %d & %d = %d", a, b, c);
        end
    end
       
    is_finish = 1;
end


/************************ 3. others ***************************/

initial begin  
    $dumpfile("wave.vcd"); 
    $dumpvars(0, tb_Top);
end

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

endmodule


