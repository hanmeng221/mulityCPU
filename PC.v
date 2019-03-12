`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    03:19:40 03/11/2019 
// Design Name: 
// Module Name:    PC 
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
`define RstEnable   		1'b1
`define RstDisable  		1'b0
`define InstBegin			32'h00000000


module PC(
    input clk,
    input resetn,
    output reg [31:0] pc
    );
	
	always @(posedge clk) begin
		if (resetn == `RstEnable) begin
			pc <= `InstBegin;
		end else begin
			pc <= pc + 4'h4;
		end
	end
	
endmodule
