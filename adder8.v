`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/15/2019 11:25:59 AM
// Design Name: 
// Module Name: adder8
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


module adder8(
	input clk,
	input rst_n,
	output reg [7:0] counter,
	output C,
	input en,
	input clr
    );

	always @ (posedge clk or negedge rst_n) begin
		if(~rst_n) begin
			counter <= 0;
		end
		else begin
			if(clr) begin
				counter <= 0;
			end
			else begin
				if(en) begin
					counter <= counter + 1;
				end
			end
		end
	end

	assign  C = (counter == 8'hff) & en & (~clr);
endmodule
