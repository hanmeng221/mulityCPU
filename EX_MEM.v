`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    04:06:56 03/11/2019 
// Design Name: 
// Module Name:    EX_MEM 
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
`define ZeroWord			32'h00000000
`define NOPRegAddr			5'b00000
`define WriteEnable			1'b1
`define WriteDisable		1'b0		
module EX_MEM(
    input wire [31:0] ex_wdata,
    input wire [4:0] ex_wd,
    input wire ex_wreg,
    input wire clk,
    input wire resetn,
    output reg [31:0] mem_wdata,
    output reg [4:0] mem_wd,
    output reg mem_wreg
    );

	always @(posedge clk) begin
		if(resetn == `RstEnable) begin
			mem_wd		<= `NOPRegAddr;
			mem_wreg 	<= `WriteDisable;
			mem_wdata 	<= `ZeroWord;
		end else begin
			mem_wd		<= ex_wd;
			mem_wreg	<= ex_wreg;
			mem_wdata	<= ex_wdata;
		end
	end
	
endmodule
