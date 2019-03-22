`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    04:09:11 03/11/2019 
// Design Name: 
// Module Name:    MEM_WB 
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


module MEM_WB(
    input wire [31:0] mem_wdata,
    input wire [4:0] mem_wd,
    input wire mem_wreg,
	input wire mem_whilo,
	input wire [31:0] mem_hi,
	input wire [31:0] mem_lo,
    input wire clk,
    input wire resetn,
	input wire [5:0] stall,
    output reg [31:0] wb_wdata,
    output reg [4:0] wb_wd,
    output reg wb_wreg,
	output reg wb_whilo,
	output reg [31:0] wb_hi,
	output reg [31:0] wb_lo
    );

	always@(posedge clk) begin
		if(resetn == `RstEnable) begin
			wb_wd		<= `NOPRegAddr;
			wb_wdata	<= `ZeroWord;
			wb_wreg		<= `WriteDisable;
			wb_whilo	<= `WriteDisable;
			wb_hi		<= `ZeroWord;
			wb_lo		<= `ZeroWord;
		end else if (stall[4] == `Stop && stall[5] == `NoStop ) begin
			wb_wd		<= `NOPRegAddr;
			wb_wdata	<= `ZeroWord;
			wb_wreg		<= `WriteDisable;
			wb_whilo	<= `WriteDisable;
			wb_hi		<= `ZeroWord;
			wb_lo		<= `ZeroWord;
		end else if (stall[4] == `NoStop) begin
			wb_wd		<=	mem_wd;
			wb_wdata	<= 	mem_wdata;
			wb_wreg		<= 	mem_wreg;
			wb_whilo	<=  mem_whilo;
			wb_hi		<= 	mem_hi;
			wb_lo		<=  mem_lo;
		end
	end
	
endmodule
