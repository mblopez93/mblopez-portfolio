`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:14:07 01/29/2015
// Design Name:   fsm
// Module Name:   C:/Users/mblopez/Documents/Dropbox/CE125/lab2/lab2 1.26.15 1201/lab2 1.26.15 1201/lab2/fsm_tb3.v
// Project Name:  lab2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: fsm
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module fsm_tb3;

	// Inputs
	reg clock;
	reg U;
	reg D;
	reg L;
	reg R;
	reg C;

	// Outputs
	wire [7:0] lights;

	// Instantiate the Unit Under Test (UUT)
	fsm uut (
		.lights(lights), 
		.clock(clock), 
		.U(U), 
		.D(D), 
		.L(L), 
		.R(R), 
		.C(C)
	);

	initial begin
		// Initialize Inputs
		clock = 0;
		U = 0;
		D = 0;
		L = 0;
		R = 0;
		C = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		U = 1'b1;
		#50
		U = 1'b0;
		#100
		
		/* enter U2 */
		U = 1'b1;
		#50
		U = 1'b0;
		#100
		
		/* enter D1 */
		D = 1'b1;
		#50
		D = 1'b0;
		#100
		
		/* enter D2 */
		D = 1'b1;
		#50
		D = 1'b0;
		#100
		
		/* enter L1  */
		L = 1'b1;
		#50
		L = 1'b0;
		#100
		
		/* enter R1 */
		R = 1'b1;
		#50
		R = 1'b0;
		#100
		
		/* enter L2 */
		L = 1'b1;
		#50
		L = 1'b0;
		#100
	
		/* enter R1 */
		R = 1'b1;
		#50
		R = 1'b0;
		#100
		
		/* enter C1 */
		C = 1'b1;
		#50
		C = 1'b0;
		#100
		
		/* enter CELEBRATE */
		C = 1'b1;
		#50
		C = 1'b0;
		#100
		
		/*Go back to U1 */
		U = 1'b1;
		#50
		U = 1'b0;
	end
	
	always 
		#10 clock <= ~clock;
      
endmodule

