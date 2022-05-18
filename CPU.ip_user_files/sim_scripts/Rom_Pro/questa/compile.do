vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib
vlib questa_lib/msim/xpm
vlib questa_lib/msim/blk_mem_gen_v8_4_1

vmap xil_defaultlib questa_lib/msim/xil_defaultlib
vmap xpm questa_lib/msim/xpm
vmap blk_mem_gen_v8_4_1 questa_lib/msim/blk_mem_gen_v8_4_1

vlog -work xil_defaultlib -64 -sv \
"D:/Tools/Vivado/Vivado/2017.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"D:/Tools/Vivado/Vivado/2017.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93 \
"D:/Tools/Vivado/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work blk_mem_gen_v8_4_1 -64 \
"../../../ipstatic/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib -64 \
"../../../../../../../ComputerDesignProject/CS202-MIPS32-CPU-Design/CPU.srcs/sources_1/Rom_Pro/sim/Rom_Pro.v" \

vlog -work xil_defaultlib \
"glbl.v"

