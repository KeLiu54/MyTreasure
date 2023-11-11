
create_clock -name FPGA_CLK1_50 -period 20 [get_ports {FPGA_CLK1_50}]
derive_pll_clocks -create_base_clocks -use_net_name
derive_clock_uncertainty
