`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Ma Lopez 
// Module Name:    lab1 
//////////////////////////////////////////////////////////////////////////////////

//TOP MODULE
module lab1(LED, A, B, LBTN, CBTN, RBTN);
	output [4:0] LED;
	
	input [3:0] A;
	input [3:0] B;
	input LBTN, CBTN, RBTN;
	
	wire [3:0] sum;
	wire [3:0] xOut;
	wire [4:0] mOut;
	wire cOut, SCLK;
	
	IBUFG IBUFG1 (.O(SCLK), .I(CBTN));
	
	//ADD and XOR options
	adder ADDOP(cOut, sum, A, B, 1'b0);
	eightXOR XOROP(xOut, A, B);
	
	//MUXING
	busMux muxALU(mOut, A, xOut, sum, cOut, LBTN, RBTN);
		
	//MUXING		
	dff FF0(LED[0], mOut[0], SCLK);
	dff FF1(LED[1], mOut[1], SCLK);
	dff FF2(LED[2], mOut[2], SCLK);
	dff FF3(LED[3], mOut[3], SCLK);
	dff FF4(LED[4], mOut[4], SCLK);

endmodule



//HALF ADDER
module half(hCout, hS, hA, hB);
	output hCout;
	output hS;
	
	input hA;
	input hB;

	xor (hS, hA, hB);
	and (hCout, hA, hB);
endmodule


//FULL ADDER
module full(fCout, fS, fA, fB, fCin);
	output  fCout;
	output fS;
	
	input fA, fB, fCin;
	wire ws1, wc1, wc2;

	half HA1(wc1, ws1, fA, fB);
	half HA2(wc2, fS, fCin, ws1);
	or (fCout, wc1, wc2);
endmodule


//RIPPLE CARRY ADDER
module adder(rCout, rS, rA, rB, rCin);
	output [3:0] rS;
	output rCout;
	
	input [3:0] rA;
	input [3:0] rB;
	input rCin;
	
	wire wC1, wC2, wC3;
	
	full FA0(wC1, rS[0], rA[0], rB[0], rCin);
	full FA1(wC2, rS[1], rA[1], rB[1], wC1);
	full FA2(wC3, rS[2], rA[2], rB[2], wC2);
	full FA3(rCout, rS[3], rA[3], rB[3], wC3);	
endmodule


// EIGHT INPUT XOR
module eightXOR(fXout, fA, fB);
	output [3:0] fXout;
	
	input [3:0] fA;
	input [3:0] fB;
	
	xor(fXout[0], fA[0], fB[0]);
	xor(fXout[1], fA[1], fB[1]);
	xor(fXout[2], fA[2], fB[2]);
	xor(fXout[3], fA[3], fB[3]);	
endmodule

//D FLIP FLOPS
module dff(q, d, clk);
	output q;
	
	input d, clk;
	
	reg q = 0; // a single-bit register, initial state is '0'
	always @(posedge clk) q <= d;
endmodule

//MUX
module fourInMux(fimOut, fimIn0, fimIn1, fimIn2, fimIn3, fmLft, fmRt);
	output fimOut;
	
	input fimIn0, fimIn1, fimIn2, fimIn3;
	input fmLft, fmRt;
	
	wire wout0, wout1, wout2, wout3, notLS, notRS;
	
	not(notfmLft, fmLft);
	not(notfmRt, fmRt);
	
	//sel: LR
	//sel: 00
	and (wout0, fimIn0, notfmLft, notfmRt);
	//sel: 01
	and (wout1, fimIn1, notfmLft, fmRt);
	//sel: 10
	and (wout2, fimIn2, fmLft, notfmRt);
	//sel: 11
	and (wout3, fimIn3, fmLft, fmRt);
	
	or (fimOut, wout0, wout1, wout2, wout3);
endmodule

//BUS MUX
module busMux(bmOut, bmInA, bmInXS, bmInAS, bmASCout, bmLft, bmRt);
	output [4:0] bmOut;
	
	input [3:0] bmInA;
	input [3:0] bmInXS;
	input [3:0] bmInAS;
	input bmASCout, bmLft, bmRt;
	
	wire notbmLft, notbmRt;
	
	//not(notbmLft, bmLft);
	//not(notbmRt, bmRt);
	
	//sel: LR
	//sel: 00	
	fourInMux zero(bmOut[0], bmInA[0], bmInXS[0], bmInAS[0], 1'b0, bmLft, bmRt);
	//sel: 01
	fourInMux one(bmOut[1], bmInA[1], bmInXS[1], bmInAS[1], 1'b0, bmLft, bmRt);
	//sel: 10
	fourInMux two(bmOut[2], bmInA[2], bmInXS[2], bmInAS[2], 1'b0, bmLft, bmRt);
	//sel: 11
	fourInMux three(bmOut[3], bmInA[3], bmInXS[3], bmInAS[3], 1'b0, bmLft, bmRt);
	
	//sel: Lft, Cout
	fourInMux four(bmOut[4], 1'b0, 1'b0, 1'b0, 1'b1, bmLft, bmASCout);
endmodule
