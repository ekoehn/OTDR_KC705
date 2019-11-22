`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/23/2019 05:40:19 PM
// Design Name: 
// Module Name: SI5324_AutoConfig
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


module SI5324_AutoConfig#(

	parameter clkFreq = 100_000_000,
	parameter I2CFreq = 100_000

	)(
		input clk,
		input rst_n,
		input RECONFIG,
		output scl,
		inout sda
    );

	localparam IDLE = 3'd0; 
	localparam CHECK = 3'd1;
	localparam START = 3'd2;
	localparam WAIT_DONE = 3'd3;
	localparam CLR = 3'd4;
	localparam INC = 3'd5;
	localparam WAIT1 = 3'd6; 
	localparam DONE = 3'd7; 

	wire reset = ~rst_n;

	reg [15:0] SI_DATA;

	reg [4:0] counter;

	always @ (posedge clk or posedge reset) begin
		if(reset) begin
			counter <= 0;
		end
		else begin
			if(clr) begin
				counter <= 0;
			end
			else if (enc) begin
				counter <= counter + 1;
			end
		end
	end

	reg [2:0] state,nextstate;

	always @ (posedge clk or posedge reset) begin
		if(reset) begin
			state <= IDLE;
		end
		else begin
			state <= nextstate;
		end
	end
	reg clr;
	reg enc;
	reg start;
	wire done;
	always @ (*) begin
		clr = 0;
		enc = 0;
		start = 0;
		nextstate = state;
		case(state)
		IDLE:begin
			clr = 1;
			if(RECONFIG)
				nextstate <= CHECK;
		end
		CHECK:begin
			clr = 0;
			if(counter < 5'd26) begin
				nextstate = START;
			end
			else begin
				nextstate = DONE;
			end
		end
		START:begin
			start = 1;
			nextstate = WAIT_DONE;
		end
		WAIT_DONE:begin
			start = 1;
			if(done) begin
				nextstate = CLR;
			end
		end
		CLR:begin
			if(done == 0) begin
				nextstate = INC;
			end
		end
		INC:begin
			enc = 1;
			nextstate = WAIT1;
		end
		WAIT1:begin
			nextstate = CHECK;
		end
		DONE:begin
			if(~RECONFIG) begin
				nextstate = DONE;
			end
		end
		endcase
	end


	always @ (*) begin
		case(counter)
		5'd0: begin SI_DATA = {8'd0,8'h52}; end
		5'd1: begin SI_DATA = {8'd1,8'hf4}; end
		5'd2: begin SI_DATA = {8'd2,8'ha2}; end
		5'd3: begin SI_DATA = {8'd3,8'h15}; end
		5'd4: begin SI_DATA = {8'd4,8'h92}; end
		5'd5: begin SI_DATA = {8'd6,8'h0f}; end
		5'd6: begin SI_DATA = {8'd7,8'h0}; end
		5'd7: begin SI_DATA = {8'd10,8'h08}; end
		5'd8: begin SI_DATA = {8'd11,8'h42}; end
		5'd9: begin SI_DATA = {8'd25,8'h20}; end
		5'd10: begin SI_DATA = {8'd31,8'h0}; end
		5'd11: begin SI_DATA = {8'd32,8'h0}; end
		5'd12: begin SI_DATA = {8'd33,8'h5}; end
		5'd13: begin SI_DATA = {8'd34,8'h0}; end
		5'd14: begin SI_DATA = {8'd35,8'h0}; end
		5'd15: begin SI_DATA = {8'd36,8'h5}; end
		5'd16: begin SI_DATA = {8'd40,8'he0}; end
		5'd17: begin SI_DATA = {8'd41,8'h61}; end
		5'd18: begin SI_DATA = {8'd42,8'h9b}; end
		5'd19: begin SI_DATA = {8'd43,8'h0}; end
		5'd20: begin SI_DATA = {8'd44,8'h22}; end
		5'd21: begin SI_DATA = {8'd45,8'h68}; end
		5'd22: begin SI_DATA = {8'd46,8'h0}; end
		5'd23: begin SI_DATA = {8'd47,8'h22}; end
		5'd24: begin SI_DATA = {8'd48,8'h68}; end
		5'd25: begin SI_DATA = {8'd128,8'h01}; end
		5'd26: begin SI_DATA = {8'd134,8'h01}; end
		5'd27: begin SI_DATA = {8'd135,8'h42}; end
		5'd28: begin SI_DATA = {8'd55,8'h3}; end
		default: begin SI_DATA = {8'd0,8'h52}; end
		endcase
	end


	I2C_master #(
			.clkFreq(clkFreq),
			.I2CFreq(I2CFreq)
		) inst_I2C_master (
			.clk      (clk),
			.reset    (reset),
			.data_in  ({8'h68,SI_DATA}),
			.start    (start),
			.wr       (1),
			.scl      (scl),
			.sda      (sda),
			.busy     (),
			.done     (done),
			.error    (),
			.data_out ()
		);

endmodule
