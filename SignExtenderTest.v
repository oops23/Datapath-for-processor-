`define STRLEN 15
module SignExtenderTest_v;

        initial
                begin
                        $dumpfile("SignExtenderTest.vcd");
                        $dumpvars(0,SignExtenderTest_v);
                end

        task passTest;
                input [63:0] actualOut, expectedOut;
                input [`STRLEN*8:0] testType;
                inout [7:0] passed;

                if (actualOut == expectedOut) begin $display ("%s passed", testType); passed = passed + 1; end
                else $display ("%s failed: %d should be %d", testType, actualOut, expectedOut);
        endtask

        task allPassed;
                input [7:0] passed;
                input [7:0] numTests;

                if(passed == numTests) $display ("All tests passed");
                else $display("Some tests failed");
        endtask

        task stim;
                input [25:0] newImm26;
                input [1:0] newCtrl;
                output reg [25:0] setImm26;
                output reg [1:0] setCtrl;

                begin
                        #90;
                        setImm26 = newImm26;
                        setCtrl = newCtrl;
                end
        endtask

        // Inputs
        reg [25:0] Imm26;
        reg [1:0] Ctrl;
        reg [7:0] passed;

        // Outputs
        wire [63:0] BusImm;
        
        // Instantiate the Unit Under Test (UUT)
         SignExtender dut (
                .BusImm(BusImm),
                .Imm26(Imm26),
                .Ctrl(Ctrl)
        );

        initial begin
                // Initialize Input
                
                Imm26 = 0;
                Ctrl = 0;
                passed = 0;
                 
                 stim(26'b00000000000000000000000000, 2'b00, Imm26, Ctrl); #10; passTest(BusImm, 64'h0000000000000000, "I-type 0", passed); //zero, I-type
                 stim(26'b00000000000000000000000001, 2'b00, Imm26, Ctrl); #10; passTest(BusImm, 64'h0, "I-type +", passed); //positive 1, I-type
                 stim(26'b11111111111111111111111111, 2'b00, Imm26, Ctrl); #10; passTest(BusImm, 64'b000000000000000000000000000000000000000000000000000111111111111, "I-type -", passed); //negative1,I-type
                 stim(26'b00000000000000000000000000, 2'b01, Imm26, Ctrl); #10; passTest(BusImm, 64'h0000000000000000, "D-type 0", passed); //zero, D-type
                 stim(26'b00000000000000000000000001, 2'b01, Imm26, Ctrl); #10; passTest(BusImm, 64'h0000000000000000, "D-type +", passed); //positive 1, D-type
                 stim(26'b11111111111111111111111111, 2'b01, Imm26, Ctrl); #10; passTest(BusImm, 64'hffffffffffffffff, "D-type -", passed); //zero, D-type
                 stim(26'b00000000000000000000000000, 2'b10, Imm26, Ctrl); #10; passTest(BusImm, 64'h0000000000000000, "B-type 0", passed);//zero,B-type
		             stim(26'b00000000000000000000000001, 2'b10, Imm26, Ctrl); #10; passTest(BusImm, 64'h0000000000000001, "B-type +", passed);//+1, B-type
		             stim(26'b11111111111111111111111111, 2'b10, Imm26, Ctrl); #10; passTest(BusImm, 64'hffffffffffffffff, "B-type -", passed);//-1, B-type
		             stim(26'b00000000000000000000000000, 2'b11, Imm26, Ctrl); #10; passTest(BusImm, 64'h0000000000000000, "CB-type 0", passed);//zero, CB-type
		             stim(26'b00000000000000000000000001, 2'b11, Imm26, Ctrl); #10; passTest(BusImm, 64'h0000000000000000, "CB-type +", passed);//+1, CB-type
		             stim(26'b11111111111111111111111111, 2'b11, Imm26, Ctrl); #10; passTest(BusImm, 64'hffffffffffffffff, "CB-type -", passed);//-1, CB-type
                 #10;
                 allPassed(passed, 12);                                       
        end                     
endmodule