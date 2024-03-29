
// Despcription: This is a templet for doing verilog questions
// Author: Chris Chen
// Date: 2024-02-27
// Version: 1.0

`timescale 1ns / 1ps

module tb_Fifo_Async();

parameter PERIOD = 20;
parameter DWI = 8;
parameter AWI = 7;
parameter DWO = 16;
parameter AWO = 6;


/************************* 1. signals *************************/

// clock and reset
reg clk, rst_n;

// input and output signals
reg                wr_en            ; 
reg                rd_en            ;         
reg     [DWI-1:0]  wr_data          ;
wire    [DWO-1:0]  rd_data          ;
wire               full             ;
wire               empty            ;
wire               almost_full      ;
wire               almost_empty     ;
wire    [AWI:0]    wr_data_cnt      ;
wire    [AWO:0]    rd_data_cnt      ;


// simulation signals
reg is_finish;
integer i;
reg wr_enable, rd_enable;



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
    wr_en = 0;
    rd_en = 0;
    wr_data = 0;
    wr_enable = 0;
    rd_enable = 0;
end

// time out
initial begin
    # (PERIOD * 50000 * 0.02) // 0.02ms @ 50MHz
    $display("\n***** Timeout Finish *****\n");
    $finish;
end

// simulation logic
initial begin
    wait(rst_n);
    # PERIOD; 
    
    wait(clk);
    wr_enable = 1;
    wait(full);

    # (PERIOD*10); wait(clk);
    rd_enable = 1;
    # (PERIOD*10); wait(clk);
    wr_enable = 0;
    wait(empty);

    # (PERIOD*10); wait(clk);
    wr_enable = 1;
    # (PERIOD*10); wait(clk);
    rd_enable = 0;
    wr_enable = 0;

    is_finish = 1;
end

always@(posedge clk) begin
    if(!full & wr_en) wr_data <= wr_data + 1;
end

always@(posedge clk) begin
    wr_en <= wr_enable;
    rd_en <= rd_enable;
end


/************************ 3. others ***************************/

initial begin  
    $dumpfile("tb_Fifo_Async.vcd"); 
    $dumpvars(0, tb_Fifo_Async);
end

Fifo_Async
#( 
    .DWI (DWI)  ,   // data width in
    .AWI (AWI)  ,   // address width in
    .DWO (DWO)  ,   // data width out
    .AWO (AWO)      // address width out
)
Fifo_Async_inst
(   
    .rst_n          (rst_n        ),
    .wr_clk         (clk          ),
    .wr_en          (wr_en        ),            
    .wr_data        (wr_data      ),
    .rd_clk         (clk          ),
    .rd_en          (rd_en        ),  
    .rd_data        (rd_data      ),
    .full           (full         ),
    .almost_full    (almost_full  ),
    .wr_data_cnt    (wr_data_cnt  ),
    .empty          (empty        ),
    .almost_empty   (almost_empty ),
    .rd_data_cnt    (rd_data_cnt  )
);

endmodule


