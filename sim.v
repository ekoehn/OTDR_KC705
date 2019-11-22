`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Next Lab
// Elliott Koehn
// 
// Simulation Testbench for SI5324 AutoConfig for KC705 FPGA
// 
//////////////////////////////////////////////////////////////////////////////////


module sim();

reg clk = 0, rst, en;
wire scl, sda;

initial begin
    rst = 1'b0;
    #20 rst = 1'b1;
 end
 
 initial begin
    en = 0'b0;
    #1000 en = 0'b1;
    #20 en = 1'b0;
 end
 
 always #5 clk = ~clk;
 
SI5324_Config_1_1_at_200MHz #(
    .clkFreq (100_000_000),
    .I2CFreq (10_000_000)
) inst_SI5324_AutoConfig (
    .clk        (clk),
	.rst_n      (rst),
	.RECONFIG   (en),
	.scl        (scl),
	.sda        (sda)
);
endmodule
