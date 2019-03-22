`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:05:07 03/13/2019 
// Design Name: 
// Module Name:    CTRL 
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
`include "define.v"

module CTRL(
    input resetn,
    input stallreq_from_id,
    input stallreq_from_ex,
    output reg [5:0] stall
    );
	always @(*) begin
		if (resetn == `RstEnable) begin
			stall <= 6'b000000;
		end else if (stallreq_from_ex == `Stop) begin
			stall <= 6'b001111;
		end else if (stallreq_from_id == `Stop ) begin
			stall <= 6'b000111;
		end else begin
			stall <= 6'b000000;
		end
	end
endmodule
