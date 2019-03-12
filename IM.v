`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    03:56:50 03/11/2019 
// Design Name: 
// Module Name:    IM 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module IM(
    input [31:0] pc_in,
    output reg [31:0] inst_out
    );
	always@(*) begin 
		case (pc_in) 
			32'h0 : inst_out = 32'b00110100000000010000000000001111;
			32'h4 : inst_out = 32'b00110100001000010000000011110000;
			32'h8 : inst_out = 32'b00110100001000010000111100000000;
			32'hc : inst_out = 32'b00110100001000011111000000000000;
			32'h10: inst_out = 32'b00110100001000011010101010101010;
		endcase
	end

endmodule
