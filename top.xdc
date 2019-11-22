#CLOCKS
#SYSCLK
#create_clock -period 10.000 -name clk_p -waveform {0.000 5.000} [get_ports {clk_p}]
#create_clock -period 10 [get_ports clk_p]
#create_clock -period 5.000 -name tc_clk_p -waveform {0.000 2.500} [get_ports {clk_p}]
#create_clock -period 5.000 -name tc_clk_n -waveform {2.500 5.000} [get_ports {clk_n}]
set_property IOSTANDARD LVDS [get_ports clk_n]
set_property PACKAGE_PIN AD12 [get_ports clk_p]
set_property PACKAGE_PIN AD11 [get_ports clk_n]
set_property IOSTANDARD LVDS [get_ports clk_p]

#USERCLK
#set_property PACKAGE_PIN K29 [get_ports clk_n]
#set_property IOSTANDARD LVDS_25 [get_ports clk_n]
#set_property PACKAGE_PIN K28 [get_ports clk_p]
#set_property IOSTANDARD LVDS_25 [get_ports clk_p]

#Global IIC BUS
set_property PACKAGE_PIN K21 [get_ports IIC_SCL_MAIN]
set_property IOSTANDARD LVCMOS25 [get_ports IIC_SCL_MAIN]
set_property PACKAGE_PIN L21 [get_ports IIC_SDA_MAIN]
set_property IOSTANDARD LVCMOS25 [get_ports IIC_SDA_MAIN]
set_property PACKAGE_PIN P23 [get_ports IIC_MUX_RESET_B]
set_property IOSTANDARD LVCMOS25 [get_ports IIC_MUX_RESET_B]

#SI5324 Low Jitter Clock
set_property PACKAGE_PIN W28 [get_ports REC_CLOCK_C_N]
set_property IOSTANDARD LVCMOS25 [get_ports REC_CLOCK_C_N]
set_property PACKAGE_PIN W27 [get_ports REC_CLOCK_C_P]
set_property IOSTANDARD LVCMOS25 [get_ports REC_CLOCK_C_P]
set_property PACKAGE_PIN AG24 [get_ports SI5326_INT_ALM_LS]
set_property IOSTANDARD LVCMOS25 [get_ports SI5326_INT_ALM_LS]
set_property PACKAGE_PIN L8 [get_ports SI5326_OUT_C_P]
set_property PACKAGE_PIN L7 [get_ports SI5326_OUT_C_N]
set_property PACKAGE_PIN AE20 [get_ports SI5326_RST_LS]
set_property IOSTANDARD LVCMOS25 [get_ports SI5326_RST_LS]


##GPIO PUSHBUTTON SW
set_property PACKAGE_PIN G12 [get_ports GPIO_SW_C]
set_property IOSTANDARD LVCMOS15 [get_ports GPIO_SW_C]
set_property PACKAGE_PIN AG5 [get_ports GPIO_SW_E]
set_property IOSTANDARD LVCMOS15 [get_ports GPIO_SW_E]
set_property PACKAGE_PIN AA12 [get_ports GPIO_SW_N]
set_property IOSTANDARD LVCMOS15 [get_ports GPIO_SW_N]
#set_property PACKAGE_PIN AB12 [get_ports GPIO_SW_S]
#set_property IOSTANDARD LVCMOS15 [get_ports GPIO_SW_S]
#set_property PACKAGE_PIN AC6 [get_ports GPIO_SW_W]
#set_property IOSTANDARD LVCMOS15 [get_ports GPIO_SW_W]
#set_property PACKAGE_PIN AB7 [get_ports CPU_RESET]
#set_property IOSTANDARD LVCMOS15 [get_ports CPU_RESET]

##GPIO LEDs
set_property PACKAGE_PIN AB8 [get_ports GPIO_LED_0_LS]
set_property IOSTANDARD LVCMOS15 [get_ports GPIO_LED_0_LS]
set_property PACKAGE_PIN AA8 [get_ports GPIO_LED_1_LS]
set_property IOSTANDARD LVCMOS15 [get_ports GPIO_LED_1_LS]
set_property PACKAGE_PIN AC9 [get_ports GPIO_LED_2_LS]
set_property IOSTANDARD LVCMOS15 [get_ports GPIO_LED_2_LS]
set_property PACKAGE_PIN AB9 [get_ports GPIO_LED_3_LS]
set_property IOSTANDARD LVCMOS15 [get_ports GPIO_LED_3_LS]
set_property PACKAGE_PIN AE26 [get_ports GPIO_LED_4_LS]
set_property IOSTANDARD LVCMOS25 [get_ports GPIO_LED_4_LS]
set_property PACKAGE_PIN G19 [get_ports GPIO_LED_5_LS]
set_property IOSTANDARD LVCMOS25 [get_ports GPIO_LED_5_LS]
#set_property PACKAGE_PIN E18 [get_ports GPIO_LED_6_LS]
#set_property IOSTANDARD LVCMOS25 [get_ports GPIO_LED_6_LS]
#set_property PACKAGE_PIN F16 [get_ports GPIO_LED_7_LS]
#set_property IOSTANDARD LVCMOS25 [get_ports GPIO_LED_7_LS]

set_property PULLUP true [get_ports IIC_SDA_MAIN]
set_property PULLUP true [get_ports IIC_SCL_MAIN]
