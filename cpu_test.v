`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:20:15 03/11/2019
// Design Name:   CPU
// Module Name:   /home/ise/openMIPS/cpu_test.v
// Project Name:  openMIPS
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: CPU
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module cpu_test;

	// Inputs
	reg clk;
	reg resetn;

	// Outputs
	wire [31:0] result;
	wire [31:0] pc;
	wire [31:0] inst;

	// Instantiate the Unit Under Test (UUT)
	CPU uut (
		.clk(clk), 
		.resetn(resetn), 
		.result(result), 
		.pc(pc), 
		.inst(inst)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		resetn = 0;

		// Wait 100 ns for global reset to finish
		#10 resetn = 1;clk = 1;
		#10 resetn = 0;
        
		// Add stimulus here

	end
	
	initial begin
		forever #25 clk = ~clk;
	end
      
endmodule

