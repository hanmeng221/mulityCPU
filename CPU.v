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
	
	wire whilo;
	wire [31:0] hi_i;
	wire [31:0] lo_i;
	wire [31:0] hi_o;
	wire [31:0] lo_o;
	
	wire mem_whilo;
	wire [31:0] mem_hi;
	wire [31:0] mem_lo;
	
	wire ex_whilo;
	wire [31:0] ex_hi;
	wire [31:0] ex_lo;
	
	wire ex_whilo_o;
	wire [31:0] ex_hi_o;
	wire [31:0] ex_lo_o;
	
	wire id_stallreq,ex_stallreq;
	wire [5:0] stall;
	
	wire id_is_in_delayslot_o;
	wire [31:0]id_link_addr_o;
	wire id_next_inst_in_delayslot_o;
	wire [31:0] id_branch_target_address_o;
	wire id_branch_flag_o;
	
	wire id_ex_is_in_delayslot;
	wire [31:0] id_ex_link_address;
	wire id_ex_is_in_delayslot_o;
	
	wire [31:0] id_inst_o;
	wire [31:0] ex_inst_i;
	
	wire  [7:0] exe_aluop_o;
	wire  [31:0] exe_mem_addr_o;
	wire  [31:0] exe_ex_reg2;
	
	wire  [7:0] exe_mem_aluop_o;
	wire  [31:0] exe_mem_mem_addr_o;
	wire  [31:0] exe_mem_ex_reg2;
	
	wire [31:0] mem_data_i;
	
	wire [31:0] mem_mem_addr_o;
	wire mem_mem_we;
	wire [31:0] mem_mem_data;
	
	
	PC mypc(.clk(clk),.resetn(resetn),
			.stall(stall),
			.branch_target_address_i(id_branch_target_address_o),.branch_flag_i(id_branch_flag_o),
			.pc(if_pc));
	
	IM myim(.pc_in(if_pc),
			.inst_out(if_inst));
	
	IF_ID myif_id(.if_pc(if_pc),.if_inst(if_inst),
				.clk(clk),.resetn(resetn),
				.stall(stall),
				.id_pc(id_pc),.id_inst(id_inst));
	
	
	ID	myid(.pc_i(id_pc),.inst_i(id_inst),.reg1_data(reg1_o),.reg2_data(reg2_o),
			.resetn(resetn),
			.ex_wdata(ex_wdata),.ex_wd(ex_wd_o),.ex_wreg(ex_wreg_o),
			.mem_wdata(mem_wdata_o),.mem_wd(mem_wd_o),.mem_wreg(mem_wreg_o),
			.is_in_delayslot_i(id_ex_is_in_delayslot_o),
			.ex_aluop_i(exe_aluop_o),
			.aluop_o(id_aluop),.alusel_o(id_alusel),.reg1_o(id_reg1),.reg2_o(id_reg2),
			.wd_o(id_wd),.wreg_o(id_wreg),
			.reg1_read_o(id_reg1_read),.reg2_read_o(id_reg2_read),
			.stallreq(id_stallreq),
			.is_in_delayslot_o(id_is_in_delayslot_o),.link_addr_o(id_link_addr_o),.next_inst_in_delayslot_o(id_next_inst_in_delayslot_o),
			.branch_target_address_o(id_branch_target_address_o),.branch_flag_o(id_branch_flag_o),
			.inst_o(id_inst_o));
		
	REG myreg(.raddr1(id_reg1_read),.raddr2(id_reg2_read),
			.clk(clk),.resetn(resetn),
			.wreg(wb_wreg),.waddr(wb_wd),.wdata(wb_wdata),
			.rdata1(reg1_o),.rdata2(reg2_o));
			
			
	ID_EX myid_ex(.id_aluop(id_aluop),.id_alusel(id_alusel),.id_reg1_i(id_reg1),.id_reg2_i(id_reg2),
					.id_wd_i(id_wd),.id_wreg(id_wreg),
					.clk(clk),.resetn(resetn),
					.stall(stall),
					.id_is_in_delayslot(id_is_in_delayslot_o),.id_link_address(id_link_addr_o),.next_inst_in_delayslot_i(id_next_inst_in_delayslot_o),
					.id_inst(id_inst_o),
					.ex_aluop(ex_aluop),.ex_alusel(ex_alusel),.ex_reg1_o(ex_reg1),.ex_reg2_o(ex_reg2),
					.ex_wd_o(ex_wd_i),.ex_wreg(ex_wreg_i),
					.ex_is_in_delayslot(id_ex_is_in_delayslot),.ex_link_address(id_ex_link_address),.is_in_delayslot_o(id_ex_is_in_delayslot_o),
					.ex_inst(ex_inst_i));
					
	EXE myexe(.aluop_o(ex_aluop),.alusel_i(ex_alusel),.reg1_i(ex_reg1),.reg2_i(ex_reg2),.wd_i(ex_wd_i),.wreg_i(ex_wreg_i),
			.hi_i(hi_o),.lo_i(lo_o),
			.wb_whilo_i(whilo),.wb_hi_i(hi_i),.wb_lo_i(lo_i),
			.mem_whilo_i(mem_whilo),.mem_hi_i(mem_hi),.mem_lo_i(mem_lo),
			.resetn(resetn),
			.is_in_delayslot_i(id_ex_is_in_delayslot),.link_address_i(id_ex_link_address),.inst_i(ex_inst_i),
			.wdata_o(ex_wdata),.wd_o(ex_wd_o),.wreg_o(ex_wreg_o),
			.whilo_o(ex_whilo_o),.hi_o(ex_hi_o),.lo_o(ex_lo_o),
			.stallreq(ex_stallreq),.aluop_o(exe_aluop_o),.mem_addr_o(exe_mem_addr_o),.ex_reg2(exe_ex_reg2));	
	
	EX_MEM myex_mem(.ex_wdata(ex_wdata),.ex_wd(ex_wd_o),.ex_wreg(ex_wreg_o),
					.ex_whilo(ex_whilo_o),.ex_hi(ex_hi_o),.ex_lo(ex_lo_o),
					.clk(clk),.resetn(resetn),
					.stall(stall),
					.ex_aluop(exe_aluop_o),.ex_mem_addr(exe_mem_addr_o),.ex_reg2(exe_ex_reg2),
					.mem_wdata(mem_wdata_i),.mem_wd(mem_wd_i),.mem_wreg(mem_wreg_i),
					.mem_whilo(ex_whilo),.mem_hi(ex_hi),.mem_lo(ex_lo),
					.mem_aluop(exe_mem_aluop_o),.mem_mem_addr(exe_mem_mem_addr_o),.mem_reg2(exe_mem_ex_reg2));
	
	MEM mymem(.wdata_i(mem_wdata_i),.wd_i(mem_wd_i),.wreg_i(mem_wreg_i),
			.whilo_i(ex_whilo),.hi_i(ex_hi),.lo_i(ex_lo),
			.resetn(resetn),
			.aluop_i(exe_mem_aluop_o),.mem_addr_i(exe_mem_mem_addr_o),.reg2_i(exe_mem_ex_reg2),.mem_data_i(mem_data_i),
			.wdata_o(mem_wdata_o),.wd_o(mem_wd_o),.wreg_o(mem_wreg_o),
			.whilo_o(mem_whilo),.hi_o(mem_hi),.lo_o(mem_lo),
			.mem_addr_o(mem_mem_addr_o),.mem_we_o(mem_mem_we),.mem_data_o(mem_mem_data));
			
	MEM_WB mymem_wb(.mem_wdata(mem_wdata_o),.mem_wd(mem_wd_o),.mem_wreg(mem_wreg_o),
					.mem_whilo(mem_whilo),.mem_hi(mem_hi),.mem_lo(mem_lo),
					.clk(clk),.resetn(resetn),
					.stall(stall),
					.wb_wdata(wb_wdata),.wb_wd(wb_wd),.wb_wreg(wb_wreg),
					.wb_whilo(whilo),.wb_hi(hi_i),.wb_lo(lo_i));
						
	
	HILO myhilo(.we(whilo),.hi_i(hi_i),.lo_i(lo_i),
				.resetn(resetn),.clk(clk),
				.hi_o(hi_o),.lo_o(lo_o));
					
	CTRL myctrl(.resetn(resetn),
				.stallreq_from_id(id_stallreq),.stallreq_from_ex(ex_stallreq),
				.stall(stall));
	
	DATAMEM mydatamem(.addr(mem_mem_addr_o),.data(mem_mem_data),.we(mem_mem_we),
					.clk(clk),
					.data_o(mem_data_i));
	
	
	assign pc = if_pc;
	assign inst = if_inst;
	assign result = ex_wdata;
endmodule