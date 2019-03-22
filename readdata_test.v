`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:00:12 03/16/2019
// Design Name:   DATAMEM
// Module Name:   /home/ise/openMIPS/readdata_test.v
// Project Name:  openMIPS
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: DATAMEM
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module readdata_test;

	// Inputs
	reg [31:0] addr;
	reg [31:0] data;
	reg we;
	reg clk;

	// Outputs
	wire [31:0] data_o;

	// Instantiate the Unit Under Test (UUT)
	DATAMEM uut (
		.addr(addr), 
		.data(data), 
		.we(we), 
		.clk(clk), 
		.data_o(data_o)
	);

	initial begin
		// Initialize Inputs
		addr = 0;
		data = 0;
		we = 0;
		clk = 0;

		// Wait 100 ns for global reset to finish
		#100 addr= 32'h0;
		#100 addr= 32'h4;
        
		// Add stimulus here

	end
      
endmodule

