iverilog -o wave -y ./ Fifo_Async.v tb_Fifo_Async.v Cnt_Cross_clock.v ../ram_async/Ram_Async.v
vvp -n wave
gtkwave tb_Fifo_Async.vcd
rm wave tb_Fifo_Async.vcd
