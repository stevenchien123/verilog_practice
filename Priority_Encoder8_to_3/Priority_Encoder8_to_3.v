module PriorityEncoder4to2(output [1:0] Dout, input [3:0] Din, input Valid);
	assign Dout[0] = Din[3] | (Din[1] & !Din[2])
	assign Dout[1] = Din[2] | Din[3];
	assign Valid = |Din;	// same as Din[0] | Din[1] | Din[2] | Din[3]
endmodule

module PriorityEncoder8to3(output [2:0] Dout, input [7:0] Din, input Valid);
	wire Valid0, Valid1;
	wire [1:0] Dout0, Dout1;	

	PriorityEncoder4to2 P0(.Dout(Dout0), .Din(Din[3:0]), .Valid(Valid0));
	PriorityEncoder4to2 P1(.Dout(Dout1), .Din(Din[7:4]), .Valid(Valid1));

	assign Dout[1:0] = (Valid1) ? Dout1 : Dout0;
	assign Dout[2] = Valid1
	assign Valid = Valid0 | Valid1;
endmodule