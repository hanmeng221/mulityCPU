`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    04:07:50 03/11/2019 
// Design Name: 
// Module Name:    MEM 
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

module MEM(
    input wire [31:0] wdata_i,
    input wire [4:0] wd_i,
    input wire wreg_i,
	input wire resetn,
    output reg [31:0] wdata_o,
    output reg [4:0] wd_o,
    output reg wreg_o
    );
	always@(*) begin
		if (resetn == `RstEnable) begin
			wd_o	<= `NOPRegAddr;
			wreg_o	<= `WriteDisable;
			wdata_o	<= `ZeroWord;
		end else begin
			wd_o 	<= wd_i;
			wreg_o	<=	wreg_i;
			wdata_o	<= wdata_i;
		end
	end

endmodule
