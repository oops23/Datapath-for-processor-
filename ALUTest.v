`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:02:47 03/05/2009
// Design Name:   ALU
// Module Name:   E:/350/Lab8/ALU/ALUTest.v
// Project Name:  ALU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ALU
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

`define STRLEN 32
module ALUTest_v;

  initial
    begin
      $dumpfile("ALUTest.vcd");
      $dumpvars(0,ALUTest_v);
    end


	task passTest;
		input [64:0] actualOut, expectedOut;
		input [`STRLEN*8:0] testType;
		inout [7:0] passed;
	
		if(actualOut == expectedOut) begin $display ("%s passed", testType); passed = passed + 1; end
		else $display ("%s failed: %x should be %x", testType, actualOut, expectedOut);
	endtask
	
	task allPassed;
		input [7:0] passed;
		input [7:0] numTests;
		
		if(passed == numTests) $display ("All tests passed");
		else $display("Some tests failed");
	endtask

	// Inputs
	reg [63:0] BusA;
	reg [63:0] BusB;
	reg [3:0] ALUCtrl;
	reg [7:0] passed;

	// Outputs
	wire [63:0] BusW;
	wire Zero;

	// Instantiate the Unit Under Test (UUT)
	ALU uut (
		.BusW(BusW), 
		.Zero(Zero), 
		.BusA(BusA), 
		.BusB(BusB), 
		.ALUCtrl(ALUCtrl)
	);

	initial begin
		// Initialize Inputs
		BusA = 0;
		BusB = 0;
		ALUCtrl = 0;
		passed = 0;

     // Here is one example test vector, testing the ADD instruction:
                
		{BusA, BusB, ALUCtrl} = {64'h1234, 64'hABCD0000, 4'h2}; #40; passTest({Zero, BusW}, 65'h0ABCD1234, "ADD 0x1234,0xABCD0000", passed);
   
		//Reformate and add your test vectors from the prelab here following the example of the testvector above.	
   
  	{BusA, BusB, ALUCtrl} = {64'h0, 64'h0, 4'h0}; #40; passTest({Zero, BusW}, {1'b1, 64'h000000000000000}, "AND1", passed); // 0x0 AND1 0x0
		{BusA, BusB, ALUCtrl} = {64'h20, 64'h20, 4'h0}; #40; passTest({Zero, BusW}, 65'h0000000000000020, "AND2", passed); // 0x20 AND2 0x20
		{BusA, BusB, ALUCtrl} = {64'h100, 64'h20, 4'h0}; #40; passTest({Zero, BusW}, {1'b1, 64'h000000000000000}, "AND3", passed); //0x100 AND3 0x20

		{BusA, BusB, ALUCtrl} = {64'h1, 64'h0, 4'h1}; #40; passTest({Zero, BusW}, 65'h0000000000000001, "ORR1", passed); // 0x1 ORR1 0x0
		{BusA, BusB, ALUCtrl} = {64'h11, 64'h10, 4'h1}; #40; passTest({Zero, BusW}, 65'h0000000000000011, "ORR2", passed); // 0x11 ORR2 0x10
		{BusA, BusB, ALUCtrl} = {64'h35, 64'h25, 4'h1}; #40; passTest({Zero, BusW}, 65'h0000000000000035, "ORR3", passed); // 0x35 ORR3 0x25

		{BusA, BusB, ALUCtrl} = {64'h20, 64'h4501, 4'h2}; #40; passTest({Zero, BusW}, 65'h0000000000004521, "ADD1", passed); // 0x20 ADD1 0x4501
		{BusA, BusB, ALUCtrl} = {64'h0, 64'h1, 4'h2}; #40; passTest({Zero, BusW}, 65'h0000000000000001, "ADD2", passed); // 0x0 ADD2 0x1
		{BusA, BusB, ALUCtrl} = {64'h10, 64'h10, 4'h2}; #40; passTest({Zero, BusW}, 65'h0000000000000020, "ADD3", passed); // 0x10 ADD3 0x10

		{BusA, BusB, ALUCtrl} = {64'h10, 64'h10, 4'h6}; #40; passTest({Zero, BusW}, {1'b1, 64'h000000000000000}, "SUB1", passed); // 0x10 SUB1 0x10
		{BusA, BusB, ALUCtrl} = {64'h90, 64'h10, 4'h6}; #40; passTest({Zero, BusW}, 65'h0000000000000080, "SUB2", passed); // 0x90 SUB2 0x10
		{BusA, BusB, ALUCtrl} = {64'h80, 64'h20, 4'h6}; #40; passTest({Zero, BusW}, 65'h000000000000060, "SUB3", passed); // 0x80 SUB3 0x20

		{BusA, BusB, ALUCtrl} = {64'h4, 64'h1, 4'h7}; #40; passTest({Zero, BusW}, 65'h0000000000000001, "PassB1", passed); // 0x4, 0x1 PassB1
		{BusA, BusB, ALUCtrl} = {64'h3, 64'h10, 4'h7}; #40; passTest({Zero, BusW}, 65'h0000000000000010, "PassB2", passed); // 0x3, 0x10 PassB2
		{BusA, BusB, ALUCtrl} = {64'h2, 64'h15, 4'h7}; #40; passTest({Zero, BusW}, 65'h0000000000000015, "PassB3", passed); // 0x2, 0x15 PassB3
		#10;
   
		allPassed(passed, 16);  //check to see if all tests are passed
   
	end
      
endmodule

