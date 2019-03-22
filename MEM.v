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
`include "define.v"

module MEM(
    input wire [31:0] wdata_i,
    input wire [4:0] wd_i,
    input wire wreg_i,
	input wire whilo_i,
	input wire [31:0] hi_i,
	input wire [31:0] lo_i,
	input wire resetn,

	input wire [7:0] aluop_i,
	input wire [31:0] mem_addr_i,
	input wire [31:0] reg2_i,
	input wire [31:0] mem_data_i,
	
	input wire cp0_reg_we_i,
	input wire [4:0] cp0_reg_write_addr_i,
	input wire [31:0] cp0_reg_data_i,

    output reg [31:0] wdata_o,
    output reg [4:0] wd_o,
    output reg wreg_o,
	output reg whilo_o,
	output reg [31:0] hi_o,
	output reg [31:0] lo_o,
	
	output reg [31:0] mem_addr_o,
	output wire mem_we_o,
	output reg [31:0] mem_data_o
	
	output reg cp0_reg_we_o,
	output reg [4:0] cp0_reg_write_addr_o,
	output reg [31:0] cp0_reg_data_o
    );
	reg mem_we;
	assign mem_we_o	 = mem_we;
	
	always@(*) begin
		if (resetn == `RstEnable) begin
			wd_o	<= `NOPRegAddr;
			wreg_o	<= `WriteDisable;
			wdata_o	<= `ZeroWord;
			whilo_o <= `WriteDisable;
			hi_o	<= `ZeroWord;
			lo_o	<= `ZeroWord;
			
			mem_addr_o	<= `ZeroWord;
			mem_we		<= `WriteDisable;
			mem_data_o	<= `ZeroWord;
			
			cp0_reg_data_o 			<= `ZeroWord;
			cp0_reg_we_o			<= `WriteDisable;
			cp0_reg_write_addr_o 	<= 5'b00000;

		end else begin
			wd_o 	<= wd_i;
			wreg_o	<=	wreg_i;
			wdata_o	<= wdata_i;
			whilo_o <= whilo_i;
			hi_o	<= hi_i;
			lo_o	<= lo_i;
			
			mem_addr_o	<= `ZeroWord;
			mem_we		<= `WriteDisable;
			
			cp0_reg_data_o 			<= cp0_reg_data_i;
			cp0_reg_we_o			<= cp0_reg_we_i;
			cp0_reg_write_addr_o 	<= cp0_reg_write_addr_i;

			case (aluop_i)
				`EXE_LW_OP: begin
					mem_addr_o <= mem_addr_i;
					mem_we		<= `WriteDisable;
					wdata_o		<= mem_data_i;
				end
				`EXE_SW_OP: begin
					mem_addr_o <= mem_addr_i;
					mem_we		<= 	`WriteEnable;
					mem_data_o	<=reg2_i;
				end
				default:begin
				end
			endcase
		end
	end

endmodule
