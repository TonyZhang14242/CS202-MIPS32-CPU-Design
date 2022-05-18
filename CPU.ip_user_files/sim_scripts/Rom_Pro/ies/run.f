-makelib ies_lib/xil_defaultlib -sv \
  "D:/Tools/Vivado/Vivado/2017.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "D:/Tools/Vivado/Vivado/2017.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "D:/Tools/Vivado/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/blk_mem_gen_v8_4_1 \
  "../../../ipstatic/simulation/blk_mem_gen_v8_4.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../../../../ComputerDesignProject/CS202-MIPS32-CPU-Design/CPU.srcs/sources_1/Rom_Pro/sim/Rom_Pro.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

