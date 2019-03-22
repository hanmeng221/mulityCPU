`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   07:48:14 03/17/2019
// Design Name:   REG
// Module Name:   /home/ise/openMIPS/reg_test.v
// Project Name:  openMIPS
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: REG
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module reg_test;

	// Inputs
	reg [4:0] raddr1;
	reg [4:0] raddr2;
	reg clk;
	reg resetn;
	reg wreg;
	reg [4:0] waddr;
	reg [31:0] wdata;

	// Outputs
	wire [31:0] rdata1;
	wire [31:0] rdata2;

	// Instantiate the Unit Under Test (UUT)
	REG uut (
		.raddr1(raddr1), 
		.raddr2(raddr2), 
		.clk(clk), 
		.resetn(resetn), 
		.wreg(wreg), 
		.waddr(waddr), 
		.wdata(wdata), 
		.rdata1(rdata1), 
		.rdata2(rdata2)
	);

	initial begin
		// Initialize Inputs
		raddr1 = 0;
		raddr2 = 0;
		clk = 0;
		resetn = 0;
		wreg = 0;
		waddr = 0;
		wdata = 0;

		// Wait 100 ns for global reset to finish
		#1 resetn = 1;
		#1 resetn = 0;
		#10 wreg = 1;waddr = 5;wdata = 32'h1;
		#20 wreg = 0; raddr1 = 5;
		#20 wreg = 1; waddr = 6;wdata = 32'h10;raddr1 = 6;
		
        
		// Add stimulus here

	end
      
	initial begin 
		forever #10 clk = ~clk;
	end
	
endmodule

