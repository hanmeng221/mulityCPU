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
`define RstEnable   		1'b1
`define RstDisable  		1'b0
`define ZeroWord			32'h00000000
`define NOPRegAddr			5'b00000
`define WriteEnable			1'b1
`define WriteDisable		1'b0	


module MEM_WB(
    input wire [31:0] mem_wdata,
    input wire [4:0] mem_wd,
    input wire mem_wreg,
    input wire clk,
    input wire resetn,
    output reg [31:0] wb_wdata,
    output reg [4:0] wb_wd,
    output reg wb_wreg
    );

	always@(posedge clk) begin
		if(resetn == `RstEnable) begin
			wb_wd		<= `NOPRegAddr;
			wb_wdata	<= `ZeroWord;
			wb_wreg		<= `WriteDisable;
		end else begin
			wb_wd		<=	mem_wd;
			wb_wdata	<= 	mem_wdata;
			wb_wreg		<= 	mem_wreg;
		end
	end
	
endmodule
