module SignExtender(BusImm, Imm26, Ctrl);
	output [63:0] BusImm;
	input [25:0] Imm26;
	input [2:0] Ctrl;

        assign BusImm = (Ctrl == 3'b000) ? {{52{1'b0}}, Imm26[21:10]} : //I-type
                        (Ctrl == 3'b001) ? {{55{Imm26[20]}}, Imm26[20:12]} : //D-type
                        (Ctrl == 3'b010) ? {{38{Imm26[25]}}, Imm26[25:0]} : //B-type
                        (Ctrl == 3'b011) ? {{45{Imm26[23]}}, Imm26[23:5]} : //CBZ
                        
                        
                        (Ctrl == 3'b100) ? {{48{1'b0}}, Imm26[20:5]}} : //MOV-Z type shift left by 0
                        (Ctrl == 3'b101) ? {{32{1'b0}}, Imm26[20:5],{16{1'b0}}} : //MOV-Z type shift left by 16
                        (Ctrl == 3'b110) ? {{16{1'b0}},Imm26[20:5],{32{1'b0}}} : //MOV-Z type shift left by 32
                        (Ctrl == 3'b111) ? {Imm26[20:5],{48{1'b0}}} : //MOV-Z type shift left by 48
                        64'h0000000000000000;
endmodule
 