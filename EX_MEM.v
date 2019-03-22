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
`include "define.v"

module EX_MEM(
    input wire [31:0] ex_wdata,
    input wire [4:0] ex_wd,
    input wire ex_wreg,
	input wire ex_whilo,
	input wire [31:0] ex_hi,
	input wire [31:0] ex_lo,
    input wire clk,
    input wire resetn,
	input wire [5:0] stall,  
	input wire [7:0] ex_aluop,
	input wire [31:0] ex_mem_addr,
	input wire [31:0] ex_reg2,
    output reg [31:0] mem_wdata,
    output reg [4:0] mem_wd,
    output reg mem_wreg,
	output reg mem_whilo,
	output reg [31:0] mem_hi,
	output reg [31:0] mem_lo,
	output reg [7:0] mem_aluop,
	output reg [31:0] mem_mem_addr,
	output reg [31:0] mem_reg2
    );

	always @(posedge clk) begin
		if(resetn == `RstEnable) begin
			mem_wd		<= `NOPRegAddr;
			mem_wreg 	<= `WriteDisable;
			mem_wdata 	<= `ZeroWord;
			mem_whilo	<= `WriteDisable;
			mem_hi		<= `ZeroWord;
			mem_lo		<= `ZeroWord;
			mem_aluop	<= `EXE_NOP_OP;
			mem_mem_addr<= `ZeroWord;
			mem_reg2	<= `ZeroWord;
			
		end else if(stall[3] == `Stop && stall[4] == `NoStop ) begin
			mem_wd		<= `NOPRegAddr;
			mem_wreg 	<= `WriteDisable;
			mem_wdata 	<= `ZeroWord;
			mem_whilo	<= `WriteDisable;
			mem_hi		<= `ZeroWord;
			mem_lo		<= `ZeroWord;
			mem_aluop	<= `EXE_NOP_OP;
			mem_mem_addr<= `ZeroWord;
			mem_reg2	<= `ZeroWord;
			
		end else if(stall[3] == `NoStop) begin
			mem_wd		<= ex_wd;
			mem_wreg	<= ex_wreg;
			mem_wdata	<= ex_wdata;
			mem_whilo	<= ex_whilo;
			mem_hi		<= ex_hi;
			mem_lo		<= ex_lo;
			mem_aluop	<= ex_aluop;
			mem_mem_addr<= ex_mem_addr;
			mem_reg2	<= ex_reg2;
		end
	end
	
endmodule
