`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    04:00:49 03/11/2019 
// Design Name: 
// Module Name:    ID 
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
`define ZeroWord 			32'h00000000
`define REGEnable			1'b1
`define REGDisable		1'b0
`define WriteEnable		1'b1
`define WriteDisable		1'b0


`define NOPRegAddr		5'b00000

`define EXE_SPECIAL_INST 6'b000000
`define EXE_AND			6'b100100
`define EXE_OR			6'b100101
`define EXE_XOR			6'b100110
`define EXE_NOR			6'b100111
`define EXE_ANDI		6'b001100
`define EXE_ORI			6'b001101
`define EXE_XORI		6'b001110
`define EXE_LUI			6'b001111

`define EXE_SLL			6'b000000
`define EXE_SLLV		6'b000100
`define EXE_SRL			6'b000010
`define EXE_SRLV		6'b000110
`define EXE_SRA			6'b000011
`define EXE_SRAV		6'b000111

`define EXE_SYNC		6'b001111
`define EXE_PREF		6'b110011

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


module ID(
    input wire[31:0] pc_i,
    input wire[31:0] inst_i,
    input wire[31:0] reg1_data,
    input wire[31:0] reg2_data,
    input wire resetn,
	
	input wire[31:0] ex_wdata,
	input wire[4:0] ex_wd,
	input wire ex_wreg,
	
	input wire[31:0] mem_wdata,
	input wire[4:0] mem_wd,
	input wire mem_wreg,
	
    output reg [7:0] aluop_o,
    output reg[2:0] alusel_o,
    output reg[31:0] reg1_o,
    output reg[31:0] reg2_o,
    output reg[4:0] wd_o,
    output reg wreg_o,
    output reg[4:0] reg1_read_o,
    output reg[4:0] reg2_read_o
    );

	wire [5:0] op = inst_i[31:26];
	wire [4:0] op2 = inst_i[10:6];
	wire [5:0] op3 = inst_i[5:0];
	wire [4:0] op4 = inst_i[20:16];
	reg [31:0] imm;
	reg reg1_en,reg2_en;
	
	always@(*) begin
		if (resetn == `RstEnable) begin
			aluop_o 	<= `EXE_NOP_OP;
			alusel_o 	<= `EXE_RES_NOP;
			wd_o 		<= `NOPRegAddr;
			wreg_o 		<= `WriteDisable;
			reg1_read_o <=	`NOPRegAddr;
			reg2_read_o <=	`NOPRegAddr;
			reg1_en 	<= `REGDisable;
			reg2_en 	<= `REGDisable;
			imm 		<= `ZeroWord;
		end else begin
			case (op)
				`EXE_SPECIAL_INST: begin
					case (op2) 
						5'b00000:	begin
							case (op3)
								`EXE_OR: begin
									wreg_o 	<= 	`WriteEnable;
									wd_o	<=  inst_i[15:11];
									aluop_o <=	`EXE_OR_OP;
									alusel_o<= 	`EXE_RES_LOGIC;
									reg1_en <=	`REGEnable;
									reg2_en <= 	`REGEnable;
									reg1_read_o <=	inst_i[25:21];
									reg2_read_o <=	inst_i[20:16];
								end
								`EXE_AND:begin
									wreg_o 	<= 	`WriteEnable;
									wd_o	<=  inst_i[15:11];
									aluop_o <=	`EXE_AND_OP;
									alusel_o<= 	`EXE_RES_LOGIC;
									reg1_en <=	`REGEnable;
									reg2_en <= 	`REGEnable;
									reg1_read_o <=	inst_i[25:21];
									reg2_read_o <=	inst_i[20:16];
								end
								`EXE_XOR:begin
									wreg_o 	<= 	`WriteEnable;
									wd_o	<=  inst_i[15:11];
									aluop_o <=	`EXE_XOR_OP;
									alusel_o<= 	`EXE_RES_LOGIC;
									reg1_en <=	`REGEnable;
									reg2_en <= 	`REGEnable;
									reg1_read_o <=	inst_i[25:21];
									reg2_read_o <=	inst_i[20:16];
								end
								`EXE_NOR:begin
									wreg_o 	<= 	`WriteEnable;
									wd_o	<=  inst_i[15:11];
									aluop_o <=	`EXE_NOR_OP;
									alusel_o<= 	`EXE_RES_LOGIC;
									reg1_en <=	`REGEnable;
									reg2_en <= 	`REGEnable;
									reg1_read_o <=	inst_i[25:21];
									reg2_read_o <=	inst_i[20:16];
								end
								`EXE_SLLV:begin
									wreg_o 	<= 	`WriteEnable;
									wd_o	<=  inst_i[15:11];
									aluop_o <=	`EXE_SLL_OP;
									alusel_o<= 	`EXE_RES_SHIFT;
									reg1_en <=	`REGEnable;
									reg2_en <= 	`REGEnable;
									reg1_read_o <=	inst_i[25:21];
									reg2_read_o <=	inst_i[20:16];
								end
								`EXE_SRLV:begin
									wreg_o 	<= 	`WriteEnable;
									wd_o	<=  inst_i[15:11];
									aluop_o <=	`EXE_SRL_OP;
									alusel_o<= 	`EXE_RES_SHIFT;
									reg1_en <=	`REGEnable;
									reg2_en <= 	`REGEnable;
									reg1_read_o <=	inst_i[25:21];
									reg2_read_o <=	inst_i[20:16];
								end
								`EXE_SRAV:begin
									wreg_o 	<= 	`WriteEnable;
									wd_o	<=  inst_i[15:11];
									aluop_o <=	`EXE_SRA_OP;
									alusel_o<= 	`EXE_RES_SHIFT;
									reg1_en <=	`REGEnable;
									reg2_en <= 	`REGEnable;
									reg1_read_o <=	inst_i[25:21];
									reg2_read_o <=	inst_i[20:16];
								end
								`EXE_SYNC:begin
									wreg_o 	<= 	`WriteDisable;
									aluop_o <=	`EXE_NOP_OP;
									alusel_o<= 	`EXE_RES_NOP;
									reg1_en <=	`REGDisable;
									reg2_en <= 	`REGEnable;
									reg1_read_o <=	inst_i[25:21];
									reg2_read_o <=	inst_i[20:16];
									
								end
								default:begin
								end
							endcase
						end
						default:begin
						end
					endcase
				end
				`EXE_ORI: begin
					aluop_o 	<= `EXE_OR_OP;
					alusel_o 	<= `EXE_RES_LOGIC;
					wd_o 		<= inst_i[20:16];
					wreg_o 		<= `WriteEnable;
					reg1_read_o <=	inst_i[25:21];
					reg2_read_o <=	inst_i[20:16];
					reg1_en 	<= `REGEnable;
					reg2_en		<= `REGDisable;
					imm 		<= {16'h0,inst_i[15:0]};
				end
				`EXE_ANDI:begin
					aluop_o 	<= `EXE_AND_OP;
					alusel_o 	<= `EXE_RES_LOGIC;
					wd_o 		<= inst_i[20:16];
					wreg_o 		<= `WriteEnable;
					reg1_read_o <=	inst_i[25:21];
					reg2_read_o <=	inst_i[20:16];
					reg1_en 	<= `REGEnable;
					reg2_en		<= `REGDisable;
					imm 		<= {16'h0,inst_i[15:0]};
				end
				`EXE_XORI:begin
					aluop_o 	<= `EXE_XOR_OP;
					alusel_o 	<= `EXE_RES_LOGIC;
					wd_o 		<= inst_i[20:16];
					wreg_o 		<= `WriteEnable;
					reg1_read_o <=	inst_i[25:21];
					reg2_read_o <=	inst_i[20:16];
					reg1_en 	<= `REGEnable;
					reg2_en		<= `REGDisable;
					imm 		<= {16'h0,inst_i[15:0]};
				end
				`EXE_LUI:begin
					aluop_o 	<= `EXE_OR_OP;
					alusel_o 	<= `EXE_RES_LOGIC;
					wd_o 		<= inst_i[20:16];
					wreg_o 		<= `WriteEnable;
					reg1_read_o <=	inst_i[25:21];
					reg2_read_o <=	inst_i[20:16];
					reg1_en 	<= `REGEnable;
					reg2_en		<= `REGDisable;
					imm 		<= {inst_i[15:0],16'h0};
				end
				`EXE_PREF:begin
					aluop_o 	<= `EXE_NOP_OP;
					alusel_o 	<= `EXE_RES_NOP;
					wd_o 		<= inst_i[20:16];
					wreg_o 		<= `WriteDisable;
					reg1_read_o <=	inst_i[25:21];
					reg2_read_o <=	inst_i[20:16];
					reg1_en 	<= `REGDisable;
					reg2_en		<= `REGDisable;
					imm 		<= {16'h0,inst_i[15:0]};
				end
				default:begin
				end
			endcase
			if(inst_i[31:21] == 11'b00000000000) begin
				case(op3)
					`EXE_SLL:begin
						aluop_o 	<= `EXE_SLL_OP;
						alusel_o 	<= `EXE_RES_SHIFT;
						wd_o 		<= inst_i[15:11];
						wreg_o 		<= `WriteEnable;
						reg1_read_o <=	inst_i[25:21];
						reg2_read_o <=	inst_i[20:16];
						reg1_en 	<= `REGDisable;
						reg2_en		<= `REGEnable;
						imm 		<= {27'h0,inst_i[10:6]};
					end
					`EXE_SRL:begin
						aluop_o 	<= `EXE_SRL_OP;
						alusel_o 	<= `EXE_RES_SHIFT;
						wd_o 		<= inst_i[15:11];
						wreg_o 		<= `WriteEnable;
						reg1_read_o <=	inst_i[25:21];
						reg2_read_o <=	inst_i[20:16];
						reg1_en 	<= `REGDisable;
						reg2_en		<= `REGEnable;
						imm 		<= {27'h0,inst_i[10:6]};
					end
					`EXE_SRA:begin
						aluop_o 	<= `EXE_SRA_OP;
						alusel_o 	<= `EXE_RES_SHIFT;
						wd_o 		<= inst_i[15:11];
						wreg_o 		<= `WriteEnable;
						reg1_read_o <=	inst_i[25:21];
						reg2_read_o <=	inst_i[20:16];
						reg1_en 	<= `REGDisable;
						reg2_en		<= `REGEnable;
						imm 		<= {27'h0,inst_i[10:6]};
					end
					default:begin
					end
				endcase
			end
		end
	end
	
	always@(*) begin
		if(resetn == `RstEnable) begin
			reg1_o <= `ZeroWord;
		end else if((ex_wreg == `WriteEnable) && (ex_wd == reg1_read_o) && ( reg1_en == `REGEnable)) begin
			reg1_o <= ex_wdata;
		end else if((mem_wreg == `WriteEnable) && (mem_wd == reg1_read_o) && (reg1_en == `REGEnable)) begin
			reg1_o <= mem_wdata;
		end else if(reg1_en	== `REGEnable)begin
			reg1_o <= reg1_data;
		end else if(reg1_en == `REGDisable) begin
			reg1_o <= imm;
		end else begin
			reg1_o <= `ZeroWord;
		end
	end
	
	always@(*) begin
		if(resetn == `RstEnable) begin
			reg2_o <= `ZeroWord;
		end else if((ex_wreg == `WriteEnable) && (ex_wd == reg2_read_o) && ( reg2_en == `REGEnable)) begin
			reg2_o <= ex_wdata;
		end else if((mem_wreg == `WriteEnable) && (mem_wd == reg2_read_o) && (reg2_en == `REGEnable)) begin
			reg2_o <= mem_wdata;
		end else if(reg2_en	== `REGEnable)begin
			reg2_o <= reg2_data;
		end else if(reg2_en == `REGDisable) begin
			reg2_o <= imm;
		end else begin
			reg2_o <= `ZeroWord;
		end
	end
endmodule
