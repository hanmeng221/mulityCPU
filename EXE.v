`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    04:05:58 03/11/2019 
// Design Name: 
// Module Name:    EXE 
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

`define EXE_RES_LOGIC	3'b001
`define EXE_RES_SHIFT	3'b010
`define EXE_RES_NOP		3'b000

`define EXE_NOP_OP		8'b00000000
`define EXE_OR_OP		8'b00100101
`define EXE_AND_OP		8'b00100100
`define EXE_XOR_OP		8'b00100110
`define EXE_NOR_OP		8'b00100111

`define EXE_SLL_OP		8'b01111100
`define EXE_SRL_OP		8'b00000010
`define EXE_SRA_OP		8'b00000011

module EXE(
    input wire[7:0] aluop_i,
    input wire [2:0] alusel_i,
    input wire [31:0] reg1_i,
    input wire [31:0] reg2_i,
    input wire [4:0] wd_i,
    input wire wreg_i,
    input wire resetn,
    output reg [31:0] wdata_o,
    output reg [4:0] wd_o,
    output reg wreg_o
    );
	reg [31:0] logicout;
	reg [31:0] shiftout;
	
	always @(*) begin
		if (resetn == `RstEnable) begin
			logicout <= `ZeroWord;
		end else begin
			case (aluop_i)
				`EXE_OR_OP: begin
					logicout <= reg1_i | reg2_i;
				end
				`EXE_AND_OP: begin
					logicout <= reg1_i & reg2_i;
				end
				`EXE_XOR_OP: begin
					logicout <= reg1_i ^ reg2_i;
				end
				`EXE_NOR_OP: begin
					logicout <= ~(reg1_i ^ reg2_i);
				end
				default: begin
					logicout <= `ZeroWord;
				end
			endcase
		end
	end
	
	always @(*) begin
		if (resetn == `RstEnable) begin
			shiftout <= `ZeroWord;
		end else begin
			case (aluop_i)
				`EXE_SLL_OP: begin
					shiftout <= reg1_i << reg2_i[4:0];
				end
				`EXE_SRL_OP: begin
					shiftout <= reg1_i >> reg2_i[4:0];
				end
				`EXE_SRA_OP: begin
					shiftout <= ({32{reg2_i[31]}}<<(6'd32-{1'b0,reg1_i[4:0]})) | reg2_i >>reg1_i[4:0];
				end
				default: begin
					shiftout <= `ZeroWord;
				end
			endcase
		end
	end
	
	
	always @(*) begin
		wd_o <= wd_i;
		wreg_o <= wreg_i;
		case (alusel_i)
			`EXE_RES_LOGIC: begin
				wdata_o <= logicout;
			end
			`EXE_RES_SHIFT:begin
				wdata_o <= shiftout;
			end
			default: begin
				wdata_o <= `ZeroWord;
			end
		endcase
	end

endmodule
