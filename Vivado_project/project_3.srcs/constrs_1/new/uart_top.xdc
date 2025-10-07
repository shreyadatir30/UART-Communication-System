
# 200 MHz differential system clock
set_property PACKAGE_PIN D18 [get_ports {clk_p}]
set_property PACKAGE_PIN C19 [get_ports {clk_n}]
set_property IOSTANDARD   LVDS_25 [get_ports {clk_p clk_n}]
create_clock -name sysclk -period 10.0 [get_ports clk_p]
##create_clock -name sysclk_buf -period 5.0 [get_pins {*clk_ibuf*/O}]


## Reset (active-low)
set_property PACKAGE_PIN H17          [get_ports rst_n]
set_property IOSTANDARD   LVCMOS25    [get_ports rst_n]   
set_property PULLUP        TRUE       [get_ports rst_n]
 

# I/O Pin Constraints (PL PMOD1/J63 header)

# UART RX PMOD1_0 (E15)
set_property PACKAGE_PIN E15           [get_ports i_Rx_Serial]
set_property IOSTANDARD  LVCMOS25      [get_ports i_Rx_Serial]

# UART TX PMOD1_1 (D15)
set_property PACKAGE_PIN D15           [get_ports o_Tx_Serial]
set_property IOSTANDARD  LVCMOS25      [get_ports o_Tx_Serial]
