transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib riviera/xilinx_vip
vlib riviera/xil_defaultlib

vmap xilinx_vip riviera/xilinx_vip
vmap xil_defaultlib riviera/xil_defaultlib

vlog -work xilinx_vip  -incr -l axi_vip_v1_1_19 -l processing_system7_vip_v1_0_21 "+incdir+C:/xilinx/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xil_defaultlib \
"C:/xilinx/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"C:/xilinx/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"C:/xilinx/Vivado/2024.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"C:/xilinx/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"C:/xilinx/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"C:/xilinx/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"C:/xilinx/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
"C:/xilinx/Vivado/2024.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
"C:/xilinx/Vivado/2024.2/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../project_3.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../project_3.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+C:/xilinx/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xil_defaultlib \
"../../../project_3.srcs/sources_1/new/uart_top.v" \

vlog -work xil_defaultlib  -incr -l axi_vip_v1_1_19 -l processing_system7_vip_v1_0_21 "+incdir+../../../project_3.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../project_3.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+C:/xilinx/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xil_defaultlib \
"../../../project_3.srcs/sources_1/new/receiver.v" \
"../../../project_3.srcs/sources_1/new/transmitter.v" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../project_3.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../project_3.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+C:/xilinx/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xil_defaultlib \
"../../../project_3.srcs/sim_1/new/uart_tb.v" \

vlog -work xil_defaultlib \
"glbl.v"

