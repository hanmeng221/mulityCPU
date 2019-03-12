`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:36:51 03/11/2019 
// Design Name: 
// Module Name:    CPU 
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
module CPU(
    input wire clk,
    input wire resetn,
    output [31:0] result,
    output [31:0] pc,
	output [31:0] inst
    );
	wire [31:0] if_pc,if_inst;
	wire [31:0] id_pc,id_inst;
	
	wire [31:0] reg1_o,reg2_o;
	
	wire [7:0] id_aluop;
	wire [2:0] id_alusel;
	wire [31:0] id_reg1,id_reg2;
	wire [4:0] id_wd;
	wire id_wreg;
	wire [4:0] id_reg1_read,id_reg2_read;
	
	wire [4:0] wb_wd;
	wire [31:0] wb_wdata;
	wire  wb_wreg;
	
	wire [7:0] ex_aluop;
	wire [2:0] ex_alusel;
	wire [31:0] ex_reg1,ex_reg2;
	wire [4:0] ex_wd_i;
	wire ex_wreg_i;
    
	wire [31:0] ex_wdata;
	wire [4:0] ex_wd_o;
	wire ex_wreg_o;
	
	wire [31:0] mem_wdata_i;
	wire [4:0] mem_wd_i;
	wire mem_wreg_i;

	wire [31:0] mem_wdata_o;
	wire [4:0] mem_wd_o;
	wire mem_wreg_o;
	
	
	PC mypc(clk,resetn,if_pc);
	IM myim(if_pc,if_inst);
	IF_ID myif_id(if_pc,if_inst,clk,resetn,id_pc,id_inst);
	ID	myid(id_pc,id_inst,reg1_o,reg2_o,resetn,ex_wdata,ex_wd_o,ex_wreg_o,mem_wdata_o,mem_wd_o,mem_wreg_o,id_aluop,id_alusel,id_reg1,id_reg2,id_wd,id_wreg,id_reg1_read,id_reg2_read);
	REG myreg(id_reg1_read,id_reg2_read,clk,resetn,wb_wreg,wb_wd,wb_wdata,reg1_o,reg2_o);
	ID_EX myid_ex(id_aluop,id_alusel,id_reg1,id_reg2,id_wd,id_wreg,clk,resetn,ex_aluop,ex_alusel,ex_reg1,ex_reg2,ex_wd_i,ex_wreg_i);
	EXE myexe(ex_aluop,ex_alusel,ex_reg1,ex_reg2,ex_wd_i,ex_wreg_i,resetn,ex_wdata,ex_wd_o,ex_wreg_o);
	EX_MEM myex_mem(ex_wdata,ex_wd_o,ex_wreg_o,clk,resetn,mem_wdata_i,mem_wd_i,mem_wreg_i);
	MEM mymem(mem_wdata_i,mem_wd_i,mem_wreg_i,resetn,mem_wdata_o,mem_wd_o,mem_wreg_o);
	MEM_WB mymem_wb(mem_wdata_o,mem_wd_o,mem_wreg_o,clk,resetn,wb_wdata,wb_wd,wb_wreg);
	assign pc = if_pc;
	assign inst = if_inst;
	assign result = ex_wdata;
endmodule
