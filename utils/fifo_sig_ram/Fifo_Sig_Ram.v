
// Description: A Fifo using a Ram with only one port (write & read use the
// same one port)
// Author: Chris Chen
// Date: 2024-04-23
// Version: 1.0


module Fifo_Sig_Ram
#(
  parameter WIDTH = 8,
  parameter DEPTH = 128
)
(
  input  wire                       clk       ,
  input  wire                       rst_n     ,
  input  wire                       wren      ,
  input  wire [WIDTH-1:0]           data_in   ,
  input  wire                       rden      ,
  output wire [WIDTH-1:0]           data_out  ,
  output wire [$clog2(DEPTH):0]     data_cnt  ,
  output wire                       full      ,
  output wire                       empty
);

localparam WIDTH_RAM = WIDTH << 1;
localparam DEPTH_RAM = (DEPTH+1) >> 1;

// Data Cache
reg [WIDTH-1:0] wr_cache [0:1];
reg [WIDTH-1:0] rd_cache_r [0:1];
wire [WIDTH-1:0] rd_cache [0:1];
reg [1:0] wr_cache_en, rd_cache_en;

// RAM
wire empty_ram, full_ram;
wire wren_ram, rden_ram;
reg rden_ram_r;
wire [WIDTH_RAM-1:0] data_in_ram, data_out_ram;
wire [$clog2(DEPTH_RAM)-1:0] addr_ram;
reg  [$clog2(DEPTH_RAM):0] cnt_ram;

Ram_Sig
#(
  .WIDTH( WIDTH_RAM   ),
  .DEPTH( DEPTH_RAM   )
)
Ram_Sig_inst
(
  .clk      (clk            ),
  .rst_n    (rst_n          ),
  .wren     (wren_ram       ),
  .data_in  (data_in_ram    ),
  .addr     (addr_ram       ),
  .data_out (data_out_ram   )
);

// Fifo Vars
reg [$clog2(DEPTH_RAM)-1:0] wr_ptr, rd_ptr;
wire rden_fifo, wren_fifo;

// Logic
assign {rd_cache[1], rd_cache[0]} = rden_ram_r ? data_out_ram : {rd_cache_r[1], rd_cache_r[0]};
assign rden_fifo = rden & !empty;
assign wren_fifo = wren & !full;

assign empty_ram = wr_ptr == rd_ptr && cnt_ram == 0;
assign full_ram = wr_ptr == rd_ptr && cnt_ram == DEPTH_RAM;
assign wren_ram = !full_ram && wr_cache_en[0] && wr_cache_en[1];
assign rden_ram = !empty_ram && ((!rd_cache_en[0] && !rd_cache_en[1]) || (!rd_cache_en[0] && rden_fifo && !wren_ram));
assign data_in_ram = {wr_cache[1], wr_cache[0]};
assign addr_ram = wren_ram ? wr_ptr : rd_ptr;

assign data_out = rd_cache_en[0] ? rd_cache[0] : rd_cache[1];
assign empty = empty_ram && !rd_cache_en[0] && !rd_cache_en[1];
assign full = full_ram && wr_cache_en[0] && wr_cache_en[1];
assign data_cnt = (cnt_ram << 1) + wr_cache_en[0] + wr_cache_en[1];

// cnt_ram
always@(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    cnt_ram <= 0;
  end
  else if(wren_ram) begin
    cnt_ram <= cnt_ram + 1;
    if(rden_ram) begin
      $display("Ram read write happens in the same clock, Fail!");
      $finish;
    end
  end
  else if(rden_ram) begin
    cnt_ram <= cnt_ram - 1;
  end
end

// wr/rd_cache
always@(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    wr_cache_en <= 0;
  end
  else begin
    case(wr_cache_en)
      2'b00: begin
        if(wren) begin
          wr_cache_en <= 2'b01;
          wr_cache[0] <= data_in;
        end
      end
      2'b01: begin
        if(wren_fifo) begin
          wr_cache_en <= 2'b11;
          wr_cache[1] <= data_in;
        end
      end
      2'b10: begin
        $display("wr_cache_en=10, Fail!");
        $finish;
      end
      2'b11: begin
        if(wren_fifo) begin
          if(wren_ram) begin
            wr_cache_en <= 2'b01;
            wr_cache[0] <= data_in;
          end
          else begin
            $display("wr_cache overflow, Fail!");
            $finish;
          end
        end
        else if(wren_ram) begin
          wr_cache_en <= 2'b00;
        end
      end
      default: begin
      end
    endcase
  end
end

always@(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    rd_cache_en <= 0;
  end
  else begin
    case(rd_cache_en)
      2'b00: begin
        if(rden_fifo) begin
          if(rden_ram) begin
            rd_cache_en <= 2'b10;
          end
          else begin
            $display("read a empty cache, Fail!");
            $finish;
          end
        end
        else if(rden_ram) begin
          rd_cache_en <= 2'b11;
        end
      end
      2'b01: begin
        $display("rd_cache_en = 01, Fail!");
        $finish;
      end
      2'b10: begin
        if(rden_fifo) begin
          rd_cache_en <= 2'b00;
          if(rden_ram) begin
            rd_cache_en <= 2'b11;
          end
        end
      end
      2'b11: begin
        if(rden_fifo) begin
          rd_cache_en <= 2'b10;
        end
      end
      default: begin
      end
    endcase
  end
end

always@(posedge clk) begin
  rden_ram_r <= rden_ram;
  if(rden_ram_r) begin
    {rd_cache_r[1], rd_cache_r[0]} <= data_out_ram;
  end
end

// wr/rd_ptr
always@(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    wr_ptr <= 0;
    rd_ptr <= 0;
  end
  else if(wren_ram) begin
    wr_ptr <= wr_ptr + 'd1;
    if(wr_ptr == DEPTH_RAM-1) begin
      wr_ptr <= 0;
    end
  end
  else if(rden_ram) begin
    rd_ptr <= rd_ptr + 1;
    if(rd_ptr == DEPTH_RAM-1) begin
      rd_ptr <= 0;
    end
  end
end

// for debug
wire [WIDTH-1:0] wr_cache0, wr_cache1, rd_cache0, rd_cache1;
assign wr_cache0 = wr_cache[0];
assign wr_cache1 = wr_cache[1];
assign rd_cache0 = rd_cache[0];
assign rd_cache1 = rd_cache[1];


endmodule

// instantiation
/*

Fifo_Sig_Ram
#(
  .WIDTH(8),
  .DEPTH(128)
)
Fifo_Sig_Ram_inst
(
  .clk       (clk       ),
  .rst_n     (rst_n     ),
  .wren      (wren      ),
  .data_in   (data_in   ),
  .rden      (rden      ),
  .data_out  (data_out  ),
  .data_cnt  (data_cnt  ),
  .full      (full      ),
  .empty     (empty     )
);


*/
