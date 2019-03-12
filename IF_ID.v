`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    03:58:05 03/11/2019 
// Design Name: 
// Module Name:    IF_ID 
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
module IF_ID(
    input wire[31:0] if_pc,
    input wire [31:0] if_inst,
    input wire clk,
    input wire resetn,
    output reg [31:0] id_pc,
    output reg [31:0] id_inst
    );
	always @(posedge clk) begin
		if (resetn == `RstEnable) begin
			id_pc <= `ZeroWord;
			id_inst <= `ZeroWord;
		end else begin
			id_pc <= if_pc;
			id_inst <= if_inst;
		end
	end
	

endmodule
