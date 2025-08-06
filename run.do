.main clear
vlog async_fifo_tb.v +acc
vsim -sv_seed random tb
add wave -r *
run -all
