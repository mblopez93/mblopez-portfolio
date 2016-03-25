`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Ma Lopez 
// Module Name:    lab2
//////////////////////////////////////////////////////////////////////////////////

module lab2(LED, gclk, up, dn, lt, rt, cr);
	output [7:0] LED;
	input gclk, up, dn, lt, rt, cr;
	
	wire clk, anyBTN, deebeeOUT;
	reg U, D, R, L, C;
	
	// CLOCK SETTINGS
	CLOCK cluck(.clk(clk),.gclk(gclk));

	assign anyBTN = up|dn|cr|lt|rt;
	
	// SEND BUTTONS THROUGH DEBOUNCER
	debouncer DeeBee(deebeeOUT,anyBTN,clk);
	
	always @(posedge clk)
		begin
			U = deebeeOUT & up;
			D = deebeeOUT & dn;
			L = deebeeOUT & lt;
			R = deebeeOUT & rt;
			C = deebeeOUT & cr;
	end
	
	// CALL FSM
	fsm Pattern(LED, clk, U, D, L, R, C);
		
endmodule

/*____________COUNTER___________*/
module counter(cTC, cBTN, cCLK);
	output reg cTC;
	input cBTN, cCLK;
	
	// STORE TOTAL COUNT
	reg [20:0] cC = 20'h000000; 
	
	// ADD, CLEAR OR DO NOTHING
	always @(posedge cCLK) 
		begin
			if (~cTC&cBTN)
				cC = cC + 1;
			else if (~cBTN) 
				cC = 20'h0000;
			else 
				cC = cC;
	end

	always @ (*)begin
		cTC = &cC;
	end	
endmodule

/*_____________DEBOUNCE_____________*/
module debouncer(dbOUT, dbIN, dbCLK);
	output reg dbOUT;
	input dbIN, dbCLK;
	
	reg ffOUT1, ffOUT2, finalOUT, btn;
	wire pushed;
	
	//EDGE DETECTION
	always @(posedge dbCLK)
		begin
			ffOUT1 <= btn;
			ffOUT2 <= ffOUT1;
	end

	always @(*)
		begin
			btn 		= pushed;
			dbOUT		= finalOUT & dbIN;
			finalOUT = ffOUT1 & ~ffOUT2;
	end
	
	counter dbCOUNT(pushed, dbIN, dbCLK);	

endmodule
	
/*________FINITE STATE MACHINE________*/
module fsm(lights, clock, U, D, L, R, C);
	output reg [7:0] lights; 
	input clock, U, D, L, R, C;
	wire none;
	
	//STATE DEFINITIONS W/ONE HOT
	parameter   SIZE 			= 11;
	parameter 	WAIT			= 11'd1,
					UP1			= 11'd2,
					UP2			= 11'd4,
					DN1			= 11'd8,
					DN2			= 11'd16,
					L1   			= 11'd32,
					R1				= 11'd64,
					L2				= 11'd128,
					R2				= 11'd256,
					C1				= 11'd512,
					CELEBRATE	= 11'd1028;
	
	//STATE REGISTERS					
	reg [SIZE-1:0] state; 
	reg [SIZE-1:0] next_state;
	

	assign none = ~U&~D&~C&~L&~R;
	
	//STATE LOGIC	
	always @(*)
		begin 
			case(state)
				WAIT:  	if (U) 				next_state = UP1;
							else 					next_state = WAIT;
				
				UP1: 		if(U)					next_state = UP2;
							else if (none)		next_state = UP1;
							else					next_state = WAIT;
								
				UP2: 		if(D)					next_state = DN1;
							else if(U)			next_state = UP1;
							else if(none)		next_state = UP2;
							else 					next_state = WAIT;
			
				DN1: 		if(D)					next_state = DN2;
							else if(U)			next_state = UP1;
							else if(none)		next_state = DN1;
							else 					next_state = WAIT;
								
				DN2: 		if(L)					next_state = L1;
							else if(U)			next_state = UP1;
							else if(none)		next_state = DN2;
							else					next_state = WAIT;
								
				L1:		if(R)					next_state = R1;
							else if(U)			next_state = UP1;
							else if(none)		next_state = L1;
							else 					next_state = WAIT;
				
				R1: 		if(L)					next_state = L2;
							else if(U)			next_state = UP1;
							else if(none) 		next_state = R1;
							else 					next_state = WAIT;
								
				L2: 		if(R)					next_state = R2;
							else if(U)			next_state = UP1;
							else if(none)		next_state = L2;
							else 					next_state = WAIT;
								
				R2: 		if(C)					next_state = C1;
							else if(U)			next_state = UP1;
							else if(none)		next_state = R2;
							else 					next_state = WAIT;
				
				C1: 		if(C)					next_state = CELEBRATE;
							else if(U)			next_state = UP1;
							else if(none)		next_state = C1;
							else 					next_state = WAIT;
				
				CELEBRATE: 		if(U)					next_state = UP1;
									else if(none)		next_state = CELEBRATE;
									else 					next_state = WAIT;	
									
				default: next_state = WAIT;
			endcase	
	end
		
	//SEQUENTIAL LOGIC
	always @ (posedge clock)
		begin
				state <= next_state;
	end
	
	//OUTPUT LOGIC
	always @(*)
		begin
		
		if (state==CELEBRATE) lights = 8'hFF;
		else lights = 8'h00;
			/* //DEBUG LEDS
			case(state)
				WAIT: lights = 8'h80;
				UP1: 	lights = 8'h01;
				UP2: 	lights = 8'h03;
				DN1:	lights = 8'h07;
				DN2: 	lights = 8'h0F;
				L1:	lights = 8'h1F;
				R1: 	lights =	8'h3F;
				L2:	lights = 8'h7F;
				C1: 	lights = 8'h00;
				CELEBRATE: lights = 8'hFF;
				default: lights = 8'h80;
			endcase
			*/
	end
			
endmodule


/*_____________CLOCK_______________*/
module CLOCK(	output clk,
					input gclk
					);
					
	IBUFG gclkin_buf(.O(clk_in), .I(gclk));
	
	DCM_SP clk_divider(	.CLKFB(feedback_clk2),
								.CLKIN(clk_in),
								.CLKDV(divided_clk),
								.CLK0(feedback_clk),
								.PSEN(1'b0),
								.LOCKED(locked_int),
								.RST(1'b0));
					  
	defparam clk_divider.CLKDV_DIVIDE = 2.0;
	defparam clk_divider.CLKIN_PERIOD = 10.0;
	defparam clk_divider.CLK_FEEDBACK = "1X";
	defparam clk_divider.CLKIN_DIVIDE_BY_2 = "FALSE";
	defparam clk_divider.CLKOUT_PHASE_SHIFT = "NONE";
	defparam clk_divider.DESKEW_ADJUST = "SYSTEM_SYNCHRONOUS";
	defparam clk_divider.DFS_FREQUENCY_MODE = "LOW";
	defparam clk_divider.DLL_FREQUENCY_MODE = "LOW";
	defparam clk_divider.DSS_MODE = "NONE";
	defparam clk_divider.DUTY_CYCLE_CORRECTION = "TRUE";
	defparam clk_divider.PHASE_SHIFT = 0;
	defparam clk_divider.STARTUP_WAIT = "FALSE";
	defparam clk_divider.FACTORY_JF = 16'hc080;
	BUFG feedback_BUFG (.I(feedback_clk), .O(feedback_clk2));
	BUFG out_BUFG (.I(divided_clk), .O(clk));
	
endmodule

//END OF FILE