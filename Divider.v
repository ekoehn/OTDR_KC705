`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/15/2019 11:17:50 AM
// Design Name: 
// Module Name: Divider
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Divider #(
	parameter PERIOD = 32'd156250000
	)(
	input clk,
	input rst_n,
	output square_out
    );
    localparam HALF_PERIOD = PERIOD >> 1;
	wire [31:0] counter;
	wire C_7_8;
	wire C_15_16;
	wire C_23_24;
	reg clr;

	adder8 inst_adder_7_0 (.clk(clk), .rst_n(rst_n), .counter(counter[7:0]), .C(C_7_8), .en(1), .clr(clr));
	adder8 inst_adder_15_8 (.clk(clk), .rst_n(rst_n), .counter(counter[15:8]), .C(C_15_16), .en(C_7_8), .clr(clr));
	adder8 inst_adder_23_16 (.clk(clk), .rst_n(rst_n), .counter(counter[23:16]), .C(C_23_24), .en(C_15_16), .clr(clr));
	adder8 inst_adder_31_24 (.clk(clk), .rst_n(rst_n), .counter(counter[31:24]), .C(), .en(C_23_24), .clr(clr));

	always @ (posedge clk or negedge rst_n) begin
		if(~rst_n) begin
			clr <= 0;
		end
		else if(counter == PERIOD) begin
			clr <= 1;
		end
		else begin
			clr <= 0;
		end
	end

	assign square_out = counter < HALF_PERIOD;

endmodule
