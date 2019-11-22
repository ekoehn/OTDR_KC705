`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Next Lab
// Elliott Koehn
// 
// LED Indicator FSM
// 
//////////////////////////////////////////////////////////////////////////////////


module led_indicator#(
        parameter flip = 32'd100_000_000
    ) (
        input clk,
        input rst,
        output led
    );

// FSM
localparam RESET=0, IDLE=1, ADD=2, CHECK=3;
reg [1:0] state;

// Variables
reg [31:0] count;
reg led_reg;
assign led = led_reg;

always @(posedge clk) begin
    if (rst) begin
        state <= RESET; // Initial state
        led_reg <= 0;
    end else begin
        case (state)
            RESET : begin
                count <= 32'b0;
                state <= ADD;
            end
            IDLE : begin
                state <= RESET;
            end
            ADD : begin
                count <= count + 32'b1;
                state <= CHECK;
            end
            CHECK : begin
                if (count >= flip) begin
                    led_reg <= ~led_reg;
                    state <= RESET;
                end else begin
                    state <= ADD;
                end
            end
            default : begin
                state <= RESET;
            end
        endcase
    end
end

endmodule
