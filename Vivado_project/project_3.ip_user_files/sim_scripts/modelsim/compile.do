vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xilinx_vip
vlib modelsim_lib/msim/xil_defaultlib

vmap xilinx_vip modelsim_lib/msim/xilinx_vip
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xilinx_vip  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L processing_system7_vip_v1_0_21 -L xilinx_vip "+incdir+C:/xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"C:/xilinx/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"C:/xilinx/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"C:/xilinx/Vivado/2024.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"C:/xilinx/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"C:/xilinx/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"C:/xilinx/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"C:/xilinx/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
"C:/xilinx/Vivado/2024.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
"C:/xilinx/Vivado/2024.2/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../project_3.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../project_3.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+C:/xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../project_3.srcs/sources_1/new/uart_top.v" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L processing_system7_vip_v1_0_21 -L xilinx_vip "+incdir+../../../project_3.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../project_3.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+C:/xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../project_3.srcs/sources_1/new/receiver.v" \
"../../../project_3.srcs/sources_1/new/transmitter.v" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../project_3.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../project_3.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+C:/xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../project_3.srcs/sim_1/new/uart_tb.v" \

vlog -work xil_defaultlib \
"glbl.v"

