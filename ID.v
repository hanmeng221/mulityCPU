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
`include  "define.v"
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
	
	input wire is_in_delayslot_i,
	
	input wire [7:0]ex_aluop_i,
	
    output reg [7:0] aluop_o,
    output reg[2:0] alusel_o,
    output reg[31:0] reg1_o,
    output reg[31:0] reg2_o,
    output reg[4:0] wd_o,
    output reg wreg_o,
    output reg[4:0] reg1_read_o,
    output reg[4:0] reg2_read_o,
	output wire stallreq,
	output reg is_in_delayslot_o,
	output reg [31:0] link_addr_o,
	output reg next_inst_in_delayslot_o,
	output reg [31:0] branch_target_address_o,
	output reg branch_flag_o,
	
	output  [31:0] inst_o,
	
	output wire [31:0] excepttype_o,
	output wire [31:0] current_inst_addr_o
    );

	wire [5:0] op = inst_i[31:26];
	wire [4:0] op2 = inst_i[10:6];
	wire [5:0] op3 = inst_i[5:0];
	wire [4:0] op4 = inst_i[20:16];
	reg [31:0] imm;
	reg reg1_en,reg2_en;
	wire [31:0] pc_plus_8;
	wire [31:0] pc_plus_4;
	wire [31:0] imm_sll2_signedext;
	
	assign pc_plus_8 = pc_i + 8;
	assign pc_plus_4 = pc_i + 4;
	assign imm_sll2_signedext  = {{14{inst_i[15]}},inst_i[15:0],2'b00};
	reg instvalid;
	
	reg excepttype_is_syscall;
	reg excepttype_is_eret;
	
	assign inst_o = inst_i;
	
	assign excepttype_o = {19'b0,excepttype_is_eret,2'b0,instvalid,excepttype_is_syscall,8'b0};
	assign current_inst_addr_o = pc_i;
	
	reg 	stallreq_for_reg1_loadrelate ;
	reg 	stallreq_for_reg2_loadrelate;
	wire pre_inst_is_load;
	
	assign pre_inst_is_load = ((ex_aluop_i == `EXE_LW_OP) ||(ex_aluop_i == `EXE_SW_OP))? 1'b1:1'b0;
	
	
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
		link_addr_o	<= `ZeroWord;
		branch_target_address_o	<= `ZeroWord;
		branch_flag_o	<= `NotBranch;
		next_inst_in_delayslot_o <= `NotInDelaySlot;
		instvalid 	<= `InstInvalid;
	end else begin
		aluop_o <= `EXE_NOP_OP;
		alusel_o<= `EXE_RES_NOP;
		wd_o	<=  inst_i[15:11];
		wreg_o	<= `WriteDisable;
		reg1_en	<= `REGDisable;
		reg2_en <= `REGDisable;
		reg1_read_o	<= inst_i[25:21];
		reg2_read_o	<= inst_i[20:16];
		imm			<= `ZeroWord;
		link_addr_o	<= `ZeroWord;
		branch_target_address_o	<= `ZeroWord;
		branch_flag_o	<= `NotBranch;
		next_inst_in_delayslot_o <= `NotInDelaySlot;
		instvalid	<= `InstInvalid;
		excepttype_is_eret <= `False_v;
		excepttype_is_syscall <= `False_v;
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
								instvalid	<= `InstValid;
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
								instvalid	<= `InstValid;
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
								instvalid	<= `InstValid;
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
								instvalid	<= `InstValid;
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
								instvalid	<= `InstValid;
							end
							`EXE_SRLV:begin
								wreg_o 		<= 	`WriteEnable;
								wd_o		<=  inst_i[15:11];
								aluop_o 	<=	`EXE_SRL_OP;
								alusel_o	<= 	`EXE_RES_SHIFT;
								reg1_en 	<=	`REGEnable;
								reg2_en 	<= 	`REGEnable;
								reg1_read_o <=	inst_i[25:21];
								reg2_read_o <=	inst_i[20:16];
								wd_o		<=  inst_i[15:11];
								instvalid	<= `InstValid;
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
								instvalid	<= `InstValid;
							end
							`EXE_SYNC:begin
								wreg_o 	<= 	`WriteDisable;
								aluop_o <=	`EXE_NOP_OP;
								alusel_o<= 	`EXE_RES_NOP;
								reg1_en <=	`REGDisable;
								reg2_en <= 	`REGEnable;
								reg1_read_o <=	inst_i[25:21];
								reg2_read_o <=	inst_i[20:16];
								instvalid	<= `InstValid;
								
							end
							`EXE_MFHI: begin
								wreg_o	<= `WriteEnable;
								aluop_o	<= `EXE_MFHI_OP;
								alusel_o<= `EXE_RES_MOVE;
								reg1_en	<= `REGDisable;
								reg2_en	<= `REGDisable;
								wd_o	<= inst_i[15:11];
								instvalid	<= `InstValid;
							end
							`EXE_MFLO: begin
								wreg_o	<= `WriteEnable;
								aluop_o	<= `EXE_MFLO_OP;
								alusel_o<= `EXE_RES_MOVE;
								reg1_en	<= `REGDisable;
								reg2_en	<= `REGDisable;
								wd_o	<= inst_i[15:11];
								instvalid	<= `InstValid;
							end
							`EXE_MTHI:begin
								wreg_o	<= `WriteDisable;
								aluop_o	<= `EXE_MTHI_OP;
								reg1_en	<= `REGEnable;
								reg2_en	<= `REGDisable;
								reg1_read_o <=	inst_i[25:21];
								reg2_read_o <=	inst_i[20:16];
								instvalid	<= `InstValid;
							end
							`EXE_MTLO:begin
								wreg_o	<= `WriteDisable;
								aluop_o	<= `EXE_MTLO_OP;
								reg1_en	<= `REGEnable;
								reg2_en	<= `REGDisable;
								reg1_read_o <=	inst_i[25:21];
								reg2_read_o <=	inst_i[20:16];
								instvalid	<= `InstValid;
							end
							`EXE_MOVN:begin
								aluop_o 	<= `EXE_MOVN_OP;
								alusel_o	<= `EXE_RES_MOVE;
								reg1_en		<= `REGEnable;
								reg2_en		<= `REGEnable;
								reg1_read_o <=	inst_i[25:21];
								reg2_read_o <=	inst_i[20:16];
								instvalid	<= `InstValid;
								if(reg2_o != `ZeroWord) begin
									wreg_o <= `WriteEnable;
								end else begin
									wreg_o <= `WriteDisable;
								end
							end
							`EXE_MOVZ:begin
								aluop_o 	<= `EXE_MOVZ_OP;
								alusel_o	<= `EXE_RES_MOVE;
								reg1_en		<= `REGEnable;
								reg2_en		<= `REGEnable;
								reg1_read_o <=	inst_i[25:21];
								reg2_read_o <=	inst_i[20:16];
								instvalid	<= `InstValid;
								if(reg2_o == `ZeroWord) begin
									wreg_o <= `WriteEnable;
								end else begin
									wreg_o <= `WriteDisable;
								end
							end
							`EXE_SLT: begin
								wreg_o 		<= `WriteEnable;
								aluop_o		<= `EXE_SLT_OP;
								alusel_o 	<= `EXE_RES_ARITHMETIC;
								reg1_en		<= `REGEnable;
								reg2_en		<= `REGEnable;
								reg1_read_o <=	inst_i[25:21];
								reg2_read_o <=	inst_i[20:16];
								wd_o		<= inst_i[15:11];
								instvalid	<= `InstValid;
							end
							`EXE_SLTU: begin
								wreg_o 		<= `WriteEnable;
								aluop_o		<= `EXE_SLTU_OP;
								alusel_o 	<= `EXE_RES_ARITHMETIC;
								reg1_en		<= `REGEnable;
								reg2_en		<= `REGEnable;
								reg1_read_o <=	inst_i[25:21];
								reg2_read_o <=	inst_i[20:16];
								wd_o		<= inst_i[15:11];
								instvalid	<= `InstValid;
							end
							`EXE_ADD: begin
								wreg_o 		<= `WriteEnable;
								aluop_o		<= `EXE_ADD_OP;
								alusel_o 	<= `EXE_RES_ARITHMETIC;
								reg1_en		<= `REGEnable;
								reg2_en		<= `REGEnable;
								reg1_read_o <=	inst_i[25:21];
								reg2_read_o <=	inst_i[20:16];
								wd_o		<= inst_i[15:11];
								instvalid	<= `InstValid;
							end
							`EXE_ADDU: begin
								wreg_o 		<= `WriteEnable;
								aluop_o		<= `EXE_ADDU_OP;
								alusel_o 	<= `EXE_RES_ARITHMETIC;
								reg1_en		<= `REGEnable;
								reg2_en		<= `REGEnable;
								reg1_read_o <=	inst_i[25:21];
								reg2_read_o <=	inst_i[20:16];
								wd_o		<= inst_i[15:11];
								instvalid	<= `InstValid;
							end
							`EXE_SUB: begin
								wreg_o 		<= `WriteEnable;
								aluop_o		<= `EXE_SUB_OP;
								alusel_o 	<= `EXE_RES_ARITHMETIC;
								reg1_en		<= `REGEnable;
								reg2_en		<= `REGEnable;
								reg1_read_o <=	inst_i[25:21];
								reg2_read_o <=	inst_i[20:16];
								wd_o		<= inst_i[15:11];
								instvalid	<= `InstValid;
							end
							`EXE_SUBU: begin
								wreg_o 		<= `WriteEnable;
								aluop_o		<= `EXE_SUBU_OP;
								alusel_o 	<= `EXE_RES_ARITHMETIC;
								reg1_en		<= `REGEnable;
								reg2_en		<= `REGEnable;
								reg1_read_o <=	inst_i[25:21];
								reg2_read_o <=	inst_i[20:16];
								wd_o		<= inst_i[15:11];
								instvalid	<= `InstValid;
							end
							`EXE_MULT: begin
								wreg_o 		<= `WriteDisable;
								aluop_o		<= `EXE_MULT_OP;
								alusel_o 	<= `EXE_RES_ARITHMETIC;
								reg1_en		<= `REGEnable;
								reg2_en		<= `REGEnable;
								reg1_read_o <=	inst_i[25:21];
								reg2_read_o <=	inst_i[20:16];
								instvalid	<= `InstValid;
							end
							`EXE_MULTU: begin
								wreg_o 		<= `WriteDisable;
								aluop_o		<= `EXE_MULTU_OP;
								alusel_o 	<= `EXE_RES_ARITHMETIC;
								reg1_en		<= `REGEnable;
								reg2_en		<= `REGEnable;
								reg1_read_o <=	inst_i[25:21];
								reg2_read_o <=	inst_i[20:16];
								instvalid	<= `InstValid;
							end
							`EXE_JR:begin
								wreg_o <= `WriteDisable;
								aluop_o<= `EXE_JR_OP;
								alusel_o<= `EXE_RES_JUMP_BRANCH;
								reg1_en	<= `REGEnable;
								reg2_en	<= `REGEnable;
								link_addr_o <= `ZeroWord;
								branch_target_address_o <= reg1_o;
								branch_flag_o <= `Branch;
								next_inst_in_delayslot_o <= `InDelaySlot;
								instvalid	<= `InstValid;
							end
							`EXE_JALR: begin
								wreg_o <= `WriteDisable;
								aluop_o<= `EXE_JALR_OP;
								alusel_o<= `EXE_RES_JUMP_BRANCH;
								reg1_en	<= `REGEnable;
								reg2_en	<= `REGEnable;
								wd_o	<= inst_i[15:11];
								link_addr_o <= pc_plus_8;
								branch_target_address_o <= reg1_o;
								branch_flag_o <= `Branch;
								next_inst_in_delayslot_o <= `InDelaySlot;
								instvalid	<= `InstValid;
							end
							`EXE_TEQ:begin
								wreg_o <= `WriteDisable;
								aluop_o <= `EXE_TEQ_OP;
								alusel_o <= `EXE_RES_NOP;
								reg1_en <= `REGEnable;
								reg2_en <= `REGEnable;
								instvalid <= `InstValid;
							end
							`EXE_TGE:begin
								wreg_o <= `WriteDisable;
								aluop_o <= `EXE_TGE_OP;
								alusel_o <= `EXE_RES_NOP;
								reg1_en <= `REGEnable;
								reg2_en <= `REGEnable;
								instvalid <= `InstValid;
							end
							`EXE_TGEU:begin
								wreg_o <= `WriteDisable;
								aluop_o <= `EXE_TGEU_OP;
								alusel_o <= `EXE_RES_NOP;
								reg1_en <= `REGEnable;
								reg2_en <= `REGEnable;
								instvalid <= `InstValid;
								
							end
							`EXE_TLT: begin
								wreg_o <= `WriteDisable;
								aluop_o <= `EXE_TLT_OP;
								alusel_o <= `EXE_RES_NOP;
								reg1_en <= `REGEnable;
								reg2_en <= `REGEnable;
								instvalid <= `InstValid;
							end
							`EXE_TLTU: begin
								wreg_o <= `WriteDisable;
								aluop_o <= `EXE_TLTU_OP;
								alusel_o <= `EXE_RES_NOP;
								reg1_en <= `REGEnable;
								reg2_en <= `REGEnable;
								instvalid <= `InstValid;
							end
							`EXE_TNE: begin
								wreg_o <= `WriteDisable;
								aluop_o <= `EXE_TNE_OP;
								alusel_o <= `EXE_RES_NOP;
								reg1_en <= `REGEnable;
								reg2_en <= `REGEnable;
								instvalid <= `InstValid;
								
							end
							`EXE_SYSCALL: begin
								wreg_o <= `WriteDisable;
								aluop_o <= `EXE_SYSCALL_OP;
								alusel_o <= `EXE_RES_NOP;
								reg1_en <= `REGDisable;
								reg2_en <= `REGDisable;
								instvalid <= `InstValid;
								excepttype_is_syscall <= `True_v;
								
							end
							default:begin
							end
						endcase//end  case op3
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
				instvalid	<= `InstValid;
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
				instvalid	<= `InstValid;
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
				instvalid	<= `InstValid;
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
				instvalid	<= `InstValid;
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
				instvalid	<= `InstValid;
			end
			`EXE_SLTI:begin
				wreg_o 		<= `WriteEnable;
				aluop_o		<= `EXE_SLT_OP;
				alusel_o 	<= `EXE_RES_ARITHMETIC;
				reg1_en		<= `REGEnable;
				reg2_en		<= `REGDisable;
				reg1_read_o <=	inst_i[25:21];
				imm 		<=  {{16{inst_i[15]}},inst_i[15:0]};
				wd_o		<= 	inst_i[20:16];
				instvalid	<= `InstValid;				
			end
			`EXE_SLTIU:begin
				wreg_o 		<= `WriteEnable;
				aluop_o		<= `EXE_SLTU_OP;
				alusel_o 	<= `EXE_RES_ARITHMETIC;
				reg1_en		<= `REGEnable;
				reg2_en		<= `REGDisable;
				reg1_read_o <=	inst_i[25:21];
				imm 		<=  {{16{inst_i[15]}},inst_i[15:0]};
				wd_o		<= 	inst_i[20:16];
				instvalid	<= `InstValid;
			end
			`EXE_ADDI:begin
				wreg_o 		<= `WriteEnable;
				aluop_o		<= `EXE_ADDI_OP;
				alusel_o 	<= `EXE_RES_ARITHMETIC;
				reg1_en		<= `REGEnable;
				reg2_en		<= `REGDisable;
				reg1_read_o <=	inst_i[25:21];
				imm 		<=  {{16{inst_i[15]}},inst_i[15:0]};
				wd_o		<= 	inst_i[20:16];
				instvalid	<= `InstValid;
			end
			`EXE_ADDIU:begin
				wreg_o 		<= `WriteEnable;
				aluop_o		<= `EXE_ADDIU_OP;
				alusel_o 	<= `EXE_RES_ARITHMETIC;
				reg1_en		<= `REGEnable;
				reg2_en		<= `REGDisable;
				reg1_read_o <=	inst_i[25:21];
				imm 		<=  {{16{inst_i[15]}},inst_i[15:0]};
				wd_o		<= 	inst_i[20:16];
				instvalid	<= `InstValid;
			end
			`EXE_J:begin
				wreg_o <= `WriteDisable;
				aluop_o<= `EXE_J_OP;
				alusel_o<= `EXE_RES_JUMP_BRANCH;
				reg1_en <= `WriteDisable;
				reg2_en <= `WriteDisable;
				link_addr_o <= `ZeroWord;
				branch_flag_o <= `Branch;
				next_inst_in_delayslot_o <= `InDelaySlot;
				branch_target_address_o <= {pc_plus_4[31:28],inst_i[25:0],2'b00};
				instvalid	<= `InstValid;
			end
			`EXE_JAL:begin
				wreg_o <= `WriteEnable;
				aluop_o<= `EXE_JAL_OP;
				alusel_o<= `EXE_RES_JUMP_BRANCH;
				reg1_en <= `WriteDisable;
				reg2_en <= `WriteDisable;
				wd_o	<= 5'b11111;
				link_addr_o <= pc_plus_8;
				branch_flag_o <= `Branch;
				next_inst_in_delayslot_o <= `InDelaySlot;
				branch_target_address_o <= {pc_plus_4[31:28],inst_i[25:0],2'b00};
				instvalid	<= `InstValid;
			end
			`EXE_BEQ:begin
				wreg_o <= `WriteDisable;
				aluop_o<= `EXE_BEQ_OP;
				alusel_o<= `EXE_RES_JUMP_BRANCH;
				reg1_en <= `REGEnable;
				reg2_en	<= `REGEnable;
				instvalid	<= `InstValid;
				if(reg1_o == reg2_o) begin
					branch_target_address_o <= pc_plus_4 + imm_sll2_signedext;
					branch_flag_o			<= `Branch;
					next_inst_in_delayslot_o<= `InDelaySlot;
				end
			end
			`EXE_BGTZ:begin
				wreg_o <= `WriteDisable;
				aluop_o<= `EXE_BGTZ_OP;
				alusel_o<= `EXE_RES_JUMP_BRANCH;
				reg1_en <= `REGEnable;
				reg2_en	<= `REGDisable;
				instvalid	<= `InstValid;
				if((reg1_o[31] == 1'b0) && (reg1_o != `ZeroWord)) begin
					branch_target_address_o <= pc_plus_4 + imm_sll2_signedext;
					branch_flag_o			<= `Branch;
					next_inst_in_delayslot_o<= `InDelaySlot;
				end
			end
			`EXE_BLEZ:begin
				wreg_o <= `WriteDisable;
				aluop_o<= `EXE_BLEZ_OP;
				alusel_o<= `EXE_RES_JUMP_BRANCH;
				reg1_en <= `REGEnable;
				reg2_en	<= `REGDisable;
				instvalid	<= `InstValid;
				if((reg1_o[31] == 1'b1) && (reg1_o != `ZeroWord)) begin
					branch_target_address_o <= pc_plus_4 + imm_sll2_signedext;
					branch_flag_o			<= `Branch;
					next_inst_in_delayslot_o<= `InDelaySlot;
				end
			end
			`EXE_BNE:begin
				wreg_o <= `WriteDisable;
				aluop_o<= `EXE_BNE_OP;
				alusel_o<= `EXE_RES_JUMP_BRANCH;
				reg1_en <= `REGEnable;
				reg2_en	<= `REGEnable;
				instvalid	<= `InstValid;
				if(reg1_o != reg2_o) begin
					branch_target_address_o <= pc_plus_4 + imm_sll2_signedext;
					branch_flag_o			<= `Branch;
					next_inst_in_delayslot_o<= `InDelaySlot;
				end
			end
			`EXE_REGIMM_INST:begin
				case (op4)
					`EXE_BLTZ:begin
						wreg_o <= `WriteDisable;
						aluop_o<= `EXE_BLTZ_OP;
						alusel_o<= `EXE_RES_JUMP_BRANCH;
						reg1_en<= `WriteEnable;
						reg2_en<= `WriteDisable;
						instvalid	<= `InstValid;
						if (reg1_o[31] == 1'b1) begin
							branch_target_address_o <= pc_plus_4 + imm_sll2_signedext;
							branch_flag_o			<= `Branch;
							next_inst_in_delayslot_o<= `InDelaySlot;
						end
					end
					`EXE_BLTZAL:begin
						wreg_o <= `WriteEnable;
						aluop_o<= `EXE_BLTZAL_OP;
						alusel_o<= `EXE_RES_JUMP_BRANCH;
						link_addr_o<= pc_plus_8;
						reg1_en<= `WriteEnable;
						reg2_en<= `WriteDisable;
						wd_o	<= 5'b11111;
						instvalid	<= `InstValid;
						if (reg1_o[31] == 1'b1) begin
							branch_target_address_o <= pc_plus_4 + imm_sll2_signedext;
							branch_flag_o			<= `Branch;
							next_inst_in_delayslot_o<= `InDelaySlot;
						end
					end
					`EXE_BGEZ:begin
						wreg_o <= `WriteDisable;
						aluop_o<= `EXE_BGEZ_OP;
						alusel_o<= `EXE_RES_JUMP_BRANCH;
						reg1_en<= `WriteEnable;
						reg2_en<= `WriteDisable;
						instvalid	<= `InstValid;
						if (reg1_o[31] == 1'b0) begin
							branch_target_address_o <= pc_plus_4 + imm_sll2_signedext;
							branch_flag_o			<= `Branch;
							next_inst_in_delayslot_o<= `InDelaySlot;
						end
					end
					`EXE_BGEZAL:begin
						wreg_o <= `WriteEnable;
						aluop_o<= `EXE_BGEZAL_OP;
						alusel_o<= `EXE_RES_JUMP_BRANCH;
						link_addr_o<= pc_plus_8;
						reg1_en<= `WriteEnable;
						reg2_en<= `WriteDisable;
						wd_o	<= 5'b11111;
						instvalid	<= `InstValid;
						if (reg1_o[31] == 1'b0) begin
							branch_target_address_o <= pc_plus_4 + imm_sll2_signedext;
							branch_flag_o			<= `Branch;
							next_inst_in_delayslot_o<= `InDelaySlot;
						end
					end
					`EXE_TEQI: begin
						wreg_o <= `WriteDisable;
						aluop_o <= `EXE_TEQI_OP;
						alusel_o <= `EXE_RES_NOP;
						reg1_en <= `REGEnable;
						reg2_en <= `REGDisable;
						imm <= {{16{inst_i[15]}},inst_i[15:0]};
						instvalid <= `InstValid;
					end
					`EXE_TGEI:begin
						wreg_o <= `WriteDisable;
						aluop_o <= `EXE_TEQI_OP;
						alusel_o <= `EXE_RES_NOP;
						reg1_en <= `REGEnable;
						reg2_en <= `REGDisable;
						imm <= {{16{inst_i[15]}},inst_i[15:0]};
						instvalid <= `InstValid;
					end
					`EXE_TGEIU:begin
						wreg_o <= `WriteDisable;
						aluop_o <= `EXE_TGEIU_OP;
						alusel_o <= `EXE_RES_NOP;
						reg1_en <= `REGEnable;
						reg2_en <= `REGDisable;
						imm <= {{16{inst_i[15]}},inst_i[15:0]};
						instvalid <= `InstValid;
					end
					`EXE_TLTI:begin
						wreg_o <= `WriteDisable;
						aluop_o <= `EXE_TLTI_OP;
						alusel_o <= `EXE_RES_NOP;
						reg1_en <= `REGEnable;
						reg2_en <= `REGDisable;
						imm <= {{16{inst_i[15]}},inst_i[15:0]};
						instvalid <= `InstValid;
					end
					`EXE_TLTIU: begin
						wreg_o <= `WriteDisable;
						aluop_o <= `EXE_TLTI_OP;
						alusel_o <= `EXE_RES_NOP;
						reg1_en <= `REGEnable;
						reg2_en <= `REGDisable;
						imm <= {{16{inst_i[15]}},inst_i[15:0]};
						instvalid <= `InstValid;
					end
					`EXE_TNEI:begin
						wreg_o <= `WriteDisable;
						aluop_o <= `EXE_TNEI_OP;
						alusel_o <= `EXE_RES_NOP;
						reg1_en <= `REGEnable;
						reg2_en <= `REGDisable;
						imm <= {{16{inst_i[15]}},inst_i[15:0]};
						instvalid <= `InstValid;
					end
					default:begin
					end
				endcase//endcase op4 
			end
			`EXE_SPECIAL2_INST: begin
				case (op3)
					`EXE_CLZ: begin
						wreg_o 		<= `WriteEnable;
						aluop_o		<= `EXE_CLZ_OP;
						alusel_o 	<= `EXE_RES_ARITHMETIC;
						reg1_en		<= `REGEnable;
						reg2_en		<= `REGDisable;
						reg1_read_o <=	inst_i[25:21];
						wd_o		<= 	inst_i[15:11];
						instvalid	<= `InstValid;
					end
					`EXE_CLO: begin
						wreg_o 		<= `WriteEnable;
						aluop_o		<= `EXE_CLO_OP;
						alusel_o 	<= `EXE_RES_ARITHMETIC;
						reg1_en		<= `REGEnable;
						reg2_en		<= `REGDisable;
						reg1_read_o <=	inst_i[25:21];
						wd_o		<= 	inst_i[15:11];
						instvalid	<= `InstValid;
					end
					`EXE_MUL: begin
						wreg_o 		<= `WriteEnable;
						aluop_o		<= `EXE_MUL_OP;
						alusel_o 	<= `EXE_RES_MUL;
						reg1_en		<= `REGEnable;
						reg2_en		<= `REGEnable;
						reg1_read_o <=	inst_i[25:21];
						reg2_read_o <=  inst_i[20:16];
						wd_o		<= 	inst_i[15:11];
						instvalid	<= `InstValid;
					end
					default: begin
					end
				endcase
			end
			`EXE_LW: begin
				wreg_o	<= `WriteEnable;
				aluop_o	<= `EXE_LW_OP;
				alusel_o<= `EXE_RES_LOAD_STORE;
				reg1_en	<= `REGEnable;
				reg2_en	<= `REGDisable;
				wd_o	<= inst_i[20:16];
				instvalid	<= `InstValid;
			end
			`EXE_SW: begin
				wreg_o	<= `WriteDisable;
				aluop_o	<= `EXE_SW_OP;
				alusel_o<= `EXE_RES_LOAD_STORE;
				reg1_en	<= `REGEnable;
				reg2_en	<= `REGEnable;
				instvalid	<= `InstValid;
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
					instvalid	<= `InstValid;
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
					instvalid	<= `InstValid;
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
					instvalid	<= `InstValid;
				end
				default:begin
				end
			endcase
		end
		if (inst_i == `EXE_ERET) begin
			wreg_o <= `WriteDisable;
			aluop_o <= `EXE_ERET_OP;
			alusel_o <= `EXE_RES_NOP;
			reg1_en <= `REGDisable;
			reg2_en <= `REGDisable;
			instvalid <= `InstValid;
			excepttype_is_syscall <= `True_v;
		end
		if(inst_i[31:21] == 11'b01000000000 && inst_i[10:0] == 11'b00000000000) begin
			aluop_o 	<= `EXE_MFC0_OP;
			alusel_o 	<= `EXE_RES_MOVE;
			wd_o	 	<= inst_i[20:16];
			wreg_o		<= `WriteEnable;
			reg1_en 	<= `REGDisable;
			reg2_en 	<= `REGDisable;
			instvalid	<= `InstValid;
		end else if(inst_i[31:21] == 11'b01000000100 && inst_i[10:0] == 11'b00000000000) begin
			aluop_o 	<= `EXE_MTC0_OP;
			alusel_o 	<= `EXE_RES_NOP;
			wreg_o		<= `WriteDisable;
			reg1_en 	<= `REGEnable;
			reg1_read_o <= inst_i[20:16];
			reg2_en 	<= `REGDisable;
			instvalid	<= `InstValid;
		end
	end	
end
	
	always@(*) begin
		stallreq_for_reg1_loadrelate <= `NoStop;
		
		if(resetn == `RstEnable) begin
			reg1_o <= `ZeroWord;
		end else if(pre_inst_is_load == 1'b1 && ex_wd == reg1_read_o && reg1_en == `REGEnable) begin
			stallreq_for_reg1_loadrelate <= `Stop;
			
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
		stallreq_for_reg2_loadrelate <= `NoStop;
		if(resetn == `RstEnable) begin
			reg2_o <= `ZeroWord;
		end else if(pre_inst_is_load == 1'b1 && ex_wd == reg2_read_o && reg2_en == `REGEnable) begin
			stallreq_for_reg2_loadrelate <= `Stop;
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
		
	always @(*) begin 
		if (resetn == `RstEnable ) begin
 			is_in_delayslot_o <= `NotInDelaySlot;
		end else begin
			is_in_delayslot_o <= is_in_delayslot_i;
		end
	end
	
	assign stallreq = stallreq_for_reg1_loadrelate | stallreq_for_reg2_loadrelate;
endmodule
