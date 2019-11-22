//////////////////////////////////////////////////////////////////////////////////
// Next Lab
// Elliott Koehn
// 
// SI5324 Test for KC705 FPGA
// 
//////////////////////////////////////////////////////////////////////////////////

module top(
    input clk_p,
    input clk_n,
    input GPIO_SW_E,
    input GPIO_SW_C,
    input GPIO_SW_N,
    input SI5326_OUT_C_P,
    input SI5326_OUT_C_N,
    output REC_CLOCK_C_P,
    output REC_CLOCK_C_N,
    output SI5326_RST_LS,
    output SI5326_INT_ALM_LS,
    output GPIO_LED_0_LS,
    output GPIO_LED_1_LS,
    output GPIO_LED_2_LS,
    output GPIO_LED_3_LS,
    output GPIO_LED_4_LS,
    output GPIO_LED_5_LS,
    output IIC_SCL_MAIN,
    inout IIC_SDA_MAIN,
    output IIC_MUX_RESET_B
    );

// Start SI5324
//assign REC_CLOCK_C_P = clk_p;
//assign REC_CLOCK_C_N = clk_n;
assign REC_CLOCK_C_N = ~REC_CLOCK_C_P;
assign SI5326_INT_ALM_LS = 0;

wire clk;
// IBUFGDS: Differential Global Clock Input Buffer
// 7 Series
// Xilinx HDL Libraries Guide, version 14.7
IBUFGDS #(
.DIFF_TERM("FALSE"), // Differential Termination
.IBUF_LOW_PWR("TRUE"), // Low power="TRUE", Highest performance="FALSE"
.IOSTANDARD("DEFAULT") // Specify the input I/O standard
) IBUFGDS_inst (
.O(REC_CLOCK_C_P), // Clock buffer output
.I(clk_p), // Diff_p clock buffer input (connect directly to top-level port)
.IB(clk_n) // Diff_n clock buffer input (connect directly to top-level port)
);
// End of IBUFGDS_inst instantiation

// FSM
localparam RESET=0, IDLE=1, ADD=2, CHECK=3;
reg [1:0] state;

// Variables
reg [31:0] count;
reg hard_rst, reconfig, done;
wire rst;
wire txusrclk_out, txusrclk2_out, rxusrclk_out, rxusrclk2_out;
   
   // BUFG: Global Clock Simple Buffer
   //       Kintex-7
   // Xilinx HDL Language Template, version 2019.1

//   BUFG BUFG_inst (
//      .O(clk), // 1-bit output: Clock output
//      .I(txusrclk_out)  // 1-bit input: Clock input
//   );

ila_0 clk_debug (
	.clk(REC_CLOCK_C_P), // input wire clk
	
	.probe0(txusrclk_out), // input wire [0:0]  probe0  
	.probe1(hard_rst),  // input wire [0:0]  probe1
	.probe2(reconfig),  // input wire [0:0]  probe2
	.probe3(GPIO_SW_E),  // input wire [0:0]  probe3
	.probe4(REC_CLOCK_C_P)  // input wire [0:0]  probe4
);

// Conditional Logic
assign rst = GPIO_SW_E;
assign GPIO_LED_5_LS = rst;
assign SI5326_RST_LS = hard_rst;
assign IIC_MUX_RESET_B = hard_rst;

always @(posedge REC_CLOCK_C_P) begin
    if (rst) begin
        state <= RESET; // Initial state
        done <= 0;
    end else begin
        case (state)
            RESET : begin
                count <= 32'b0;
                hard_rst = 0;
                reconfig = 0;
                state <= ADD;
            end
            IDLE : begin
                state <= IDLE;
            end
            ADD : begin
                count <= count + 32'b1;
                state <= CHECK;
            end
            CHECK : begin
                if (done == 0) begin
                    state <= ADD;
                    if (count == 32'd4_000) begin
                       hard_rst = 1;
                    end else if (count == 32'd8_000) begin
                       reconfig = 1;
                    end else if (count == 32'd12_000) begin
                       reconfig = 0;
                       done = 1;
                    end
                end else begin
                    state <= IDLE;
                end
            end
            default : begin
                state <= RESET;
            end
        endcase
    end
end

parameter [31:0] period = 32'd200_000_000;

Divider #(
    .PERIOD (32'd200_000_000)
  )inst_Divider_0 (
    .clk        (REC_CLOCK_C_P),
	.rst_n      (~rst),
	.square_out (GPIO_LED_0_LS)
);

Divider #(
    .PERIOD (period)
  )inst_Divider_1 (
    .clk        (txusrclk_out),
	.rst_n      (~rst),
	.square_out (GPIO_LED_1_LS)
);

Divider #(
    .PERIOD (period)
  )inst_Divider_2 (
    .clk        (txusrclk2_out),
	.rst_n      (~rst),
	.square_out (GPIO_LED_2_LS)
);

Divider #(
    .PERIOD (period)
  )inst_Divider_3 (
    .clk        (rxusrclk_out),
	.rst_n      (~rst),
	.square_out (GPIO_LED_3_LS)
);

Divider #(
    .PERIOD (period)
  )inst_Divider_4 (
    .clk        (rxusrclk2_out),
	.rst_n      (~rst),
	.square_out (GPIO_LED_4_LS)
);

//parameter [31:0] flip = 32'd100_000_000;

//led_indicator #(
//    .flip (flip)
//  )inst_led_indicator_0 (
//    .clk        (REC_CLOCK_C_P),
//	.rst        (rst),
//	.led        (GPIO_LED_0_LS)
//);

//led_indicator #(
//    .flip (flip)
//  )inst_led_indicator_1 (
//    .clk        (txusrclk_out),
//	.rst        (rst),
//	.led        (GPIO_LED_1_LS)
//);

//led_indicator #(
//    .flip (flip)
//  )inst_led_indicator_2 (
//    .clk        (txusrclk2_out),
//	.rst        (rst),
//	.led        (GPIO_LED_2_LS)
//);

//led_indicator #(
//    .flip (flip)
//  )inst_led_indicator_3 (
//    .clk        (rxusrclk_out),
//	.rst        (rst),
//	.led        (GPIO_LED_3_LS)
//);

//led_indicator #(
//    .flip (flip)
//  )inst_led_indicator_4 (
//    .clk        (rxusrclk2_out),
//	.rst        (rst),
//	.led        (GPIO_LED_4_LS)
//);

SI5324_Config_1_1_at_200MHz #(
    .clkFreq (200_000_000),
    .I2CFreq (100_000)
  )inst_SI5324_AutoConfig (
    .clk        (REC_CLOCK_C_P),
	.rst_n      (~rst),
	.RECONFIG   (reconfig),
	.scl        (IIC_SCL_MAIN),
	.sda        (IIC_SDA_MAIN)
);

gtx_0  gtx_0_i
(
 .soft_reset_tx_in(~rst), // input wire soft_reset_tx_in
 .soft_reset_rx_in(~rst), // input wire soft_reset_rx_in
 .dont_reset_on_data_error_in(1'b1), // input wire dont_reset_on_data_error_in
.q1_clk0_gtrefclk_pad_n_in(SI5326_OUT_C_N), // input wire q1_clk0_gtrefclk_pad_n_in
.q1_clk0_gtrefclk_pad_p_in(SI5326_OUT_C_P), // input wire q1_clk0_gtrefclk_pad_p_in
 .gt0_tx_fsm_reset_done_out(), // output wire gt0_tx_fsm_reset_done_out
 .gt0_rx_fsm_reset_done_out(), // output wire gt0_rx_fsm_reset_done_out
 .gt0_data_valid_in(1'b1), // input wire gt0_data_valid_in

.gt0_txusrclk_out(txusrclk_out), // output wire gt0_txusrclk_out
.gt0_txusrclk2_out(txusrclk2_out), // output wire gt0_txusrclk2_out
.gt0_rxusrclk_out(rxusrclk_out), // output wire gt0_rxusrclk_out
.gt0_rxusrclk2_out(rxusrclk2_out), // output wire gt0_rxusrclk2_out
//_________________________________________________________________________
//GT0  (X0Y8)
//____________________________CHANNEL PORTS________________________________
//-------------------------- Channel - DRP Ports  --------------------------
    .gt0_drpaddr_in                 (9'b0), // input wire [8:0] gt0_drpaddr_in
    .gt0_drpdi_in                   (16'b0), // input wire [15:0] gt0_drpdi_in
    .gt0_drpdo_out                  (), // output wire [15:0] gt0_drpdo_out
    .gt0_drpen_in                   (1'b0), // input wire gt0_drpen_in
    .gt0_drprdy_out                 (), // output wire gt0_drprdy_out
    .gt0_drpwe_in                   (1'b0), // input wire gt0_drpwe_in
//------------------------- Digital Monitor Ports --------------------------
    .gt0_dmonitorout_out            (), // output wire [7:0] gt0_dmonitorout_out
//------------------- RX Initialization and Reset Ports --------------------
    .gt0_eyescanreset_in            (1'b0), // input wire gt0_eyescanreset_in
    .gt0_rxuserrdy_in               (1'b1), // input wire gt0_rxuserrdy_in
//------------------------ RX Margin Analysis Ports ------------------------
    .gt0_eyescandataerror_out       (), // output wire gt0_eyescandataerror_out
    .gt0_eyescantrigger_in          (1'b0), // input wire gt0_eyescantrigger_in
//---------------- Receive Ports - FPGA RX interface Ports -----------------
    .gt0_rxdata_out                 (), // output wire [15:0] gt0_rxdata_out
//------------------------- Receive Ports - RX AFE -------------------------
    .gt0_gtxrxp_in                  (1'b0), // input wire gt0_gtxrxp_in
//---------------------- Receive Ports - RX AFE Ports ----------------------
    .gt0_gtxrxn_in                  (1'b0), // input wire gt0_gtxrxn_in
//------------------- Receive Ports - RX Equalizer Ports -------------------
    .gt0_rxdfelpmreset_in           (1'b0), // input wire gt0_rxdfelpmreset_in
    .gt0_rxmonitorout_out           (), // output wire [6:0] gt0_rxmonitorout_out
    .gt0_rxmonitorsel_in            (2'b0), // input wire [1:0] gt0_rxmonitorsel_in
//------------- Receive Ports - RX Fabric Output Control Ports -------------
    .gt0_rxoutclkfabric_out         (), // output wire gt0_rxoutclkfabric_out
//----------- Receive Ports - RX Initialization and Reset Ports ------------
    .gt0_gtrxreset_in               (1'b0), // input wire gt0_gtrxreset_in
    .gt0_rxpmareset_in              (1'b0), // input wire gt0_rxpmareset_in
//------------ Receive Ports -RX Initialization and Reset Ports ------------
    .gt0_rxresetdone_out            (), // output wire gt0_rxresetdone_out
//------------------- TX Initialization and Reset Ports --------------------
    .gt0_gttxreset_in               (1'b0), // input wire gt0_gttxreset_in
    .gt0_txuserrdy_in               (1'b1), // input wire gt0_txuserrdy_in
//---------------- Transmit Ports - TX Data Path interface -----------------
    .gt0_txdata_in                  (16'h00FF), // input wire [15:0] gt0_txdata_in
//-------------- Transmit Ports - TX Driver and OOB signaling --------------
    .gt0_gtxtxn_out                 (), // output wire gt0_gtxtxn_out
    .gt0_gtxtxp_out                 (), // output wire gt0_gtxtxp_out
//--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
    .gt0_txoutclkfabric_out         (), // output wire gt0_txoutclkfabric_out
    .gt0_txoutclkpcs_out            (), // output wire gt0_txoutclkpcs_out
//----------- Transmit Ports - TX Initialization and Reset Ports -----------
    .gt0_txresetdone_out            (), // output wire gt0_txresetdone_out

//____________________________COMMON PORTS________________________________
.gt0_qplllock_out(), // output wire gt0_qplllock_out
.gt0_qpllrefclklost_out(), // output wire gt0_qpllrefclklost_out
.gt0_qplloutclk_out(), // output wire gt0_qplloutclk_out 
.gt0_qplloutrefclk_out(), // output wire gt0_qplloutrefclk_out
 .sysclk_in(REC_CLOCK_C_P) // input wire sysclk_in
 );

endmodule
