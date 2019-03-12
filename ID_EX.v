`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    04:04:39 03/11/2019 
// Design Name: 
// Module Name:    ID_EX 
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
`define EXE_NOP_OP			8'b00000000
`define EXE_RES_NOP			3'b000
`define NOPRegAddr			5'b00000
`define WriteDisable		1'b0
module ID_EX(
    input wire [7:0] id_aluop,
    input wire[2:0] id_alusel,
    input wire[31:0] id_reg1_i,
    input wire[31:0] id_reg2_i,
    input wire[4:0] id_wd_i,
    input wire id_wreg,
    input wire clk,
    input wire resetn,
    output reg [7:0] ex_aluop,
    output reg [2:0] ex_alusel,
    output reg [31:0] ex_reg1_o,
    output reg [31:0] ex_reg2_o,
    output reg [4:0] ex_wd_o,
    output reg ex_wreg
    );
	
	always@(posedge clk) begin
		if (resetn == `RstEnable) begin
			ex_aluop 	<= `EXE_NOP_OP;
			ex_alusel	<= `EXE_RES_NOP;
			ex_reg1_o	<= `ZeroWord;
			ex_reg2_o	<= `ZeroWord;
			ex_wd_o		<= `NOPRegAddr;
			ex_wreg		<= `WriteDisable;
		end else begin
			ex_aluop 	<= id_aluop;
			ex_alusel	<= id_alusel;
			ex_reg1_o	<= id_reg1_i;
			ex_reg2_o	<= id_reg2_i;
			ex_wd_o		<= id_wd_i;
			ex_wreg		<= id_wreg;
		end
	end
	
endmodule
