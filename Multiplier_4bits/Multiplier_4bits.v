// Have to define module CLA4...

module MULUnit(output [3:0] P, input [3:0] A, input Bi);
	and a0(P[0], A[0], Bi);
	and a1(P[1], A[1], Bi);
	and a2(P[2], A[2], Bi);
	and a3(P[3], A[3], Bi);
endmodule

module MUL4(output [7:0] P, input [3:0] A, B);
	wire [3:0] P0, P1, P2, P3;
	wire [3:0] CLAsum0, CLAsum1, CLAsum2;
	wire CLAout1, CLAout2, CLAout3;

	MULUnit MU0(.P(P0), .A(A), .Bi(B[0]));
	MULUnit MU1(.P(P1), .A(A), .Bi(B[1]));
	MULUnit MU2(.P(P2), .A(A), .Bi(B[2]));
	MULUnit MU3(.P(P3), .A(A), .Bi(B[3]));

	CLA4 CLA0(.S(CLAsum0), .Cout(CLAout1), .A({1'b0, P0[3:1]}), .B(P1), .Cin(1'b0));
	CLA4 CLA1(.S(CLAsum1), .Cout(CLAout2), .A({CLAout1, CLAsum0[3:1]}), .B(P2), .Cin(1'b0));
	CLA4 CLA2(.S(CLAsum2), .Cout(CLAout3), .A({CLAout2, CLAsum1[3:1]}), .B(P3), .Cin(1'b0));

	assign P[0] = P0[0];
	assign P[1] = CLAsum0[0];
	assign P[2] = CLAsum1[0];
	assign P[6:3] = CLAsum2;
	assign P[7] = CLAout3;
endmodule