// Full Adder Design
module FA(output S, Cout, input A, B, Cin);
	assign S = A ^ B ^ Cin;
	assign Cout = (A&B) | (A&Cin) | (B&Cin);
endmodule

// CLA4 Design
module CLA4(output [3:0] S, output Cout, input [3:0] A, B, input Cin);
	// CLA4 Logic here...
endmodule

// BCD number add 6 Design
module BCDADD6(output [7:0] S, output Cout, input [7:0] A, B);
	wire CLA_Cout0, CLA_Cout1, ADD6_Cout0, ADD6_Cout1, CLA_Cin1;
	wire [3:0] S0, S1, S0_add6, S1_add6;
	
	CLA4 C0(.S(S0), .Cout(CLA_Cout0), .A(A[3:0]), .B(B[3:0]), .Cin(1'b0));
	ADD6 A0(.S(S0_add6), .Cout(ADD6_Cout0), .A(S0));
	
	assign CLA_Cin1 = CLA_Cout0 | ADD6_Cout0;
	CLA4 C1(.S(S1), .Cout(CLA_Cout1), .A(A[7:4]), .B(B[7:4]), .Cin(CLA_Cin1));
	ADD6 A1(.S(S1_add6), .Cout(ADD6_Cout1), .A(S1));
	
	assign Cout = CLA_Cout1 | ADD6_Cout1;
	// convert S to BCD code
	assign S[3:0] = (CLA_Cin1)? S0_add6 : S0;
	assign S[7:4] = (Cout)? S1_add6 : S1;
endmodule

// Add 6 Circuit Design
module ADD6(output [3:0] S, output Cout, input [3:0] A);
	assign S[0] = A[0];
	assign S[1] = !A[1];
	assign S[2] = !(A[1] ^ A[2]);
	assign S[3] = (A[1] | A[2]) ^ A[3];
	assign Cout = (A[1] | A[2]) & A[3];
endmodule


// Top Design
module Binary2BCD(output [11:0] BCD, input [7:0] Binary);
	wire ADD6_Cout, BCDADD6_Cout0, BCDADD6_Cout1, BCDADD6_Cout2, BCDADD6_Cout3, FA_Cout;
	wire [3:0] A_add6;
	wire [7:0] B0, B1, B2, B3, FA_S;
	wire [7:0] ADD6_S, BCDADD6_S0, BCDADD6_S1, BCDADD6_S2, BCDADD6_S3;
	
	ADD6 A0(.S(A_add6), .Cout(ADD6_Cout), .A(Binary[3:0]));
	assign ADD6_S[3:0] = (ADD6_Cout)? A_add6 : Binary[3:0];
	assign ADD6_S[4] = ADD6_Cout;
	assign ADD6_S[7:5] = 3'b000;
	
	assign B0 = (Binary[4])? 8'h16 : 8'h00;
	BCDADD6 BADD0(.S(BCDADD6_S0), .Cout(BCDADD6_Cout0), .A(ADD6_S), .B(B0));
	
	assign B1 = (Binary[5])? 8'h32 : 8'h00;
	BCDADD6 BADD1(.S(BCDADD6_S1), .Cout(BCDADD6_Cout1), .A(BCDADD6_S0), .B(B1));
	
	assign B2 = (Binary[6])? 8'h64 : 8'h00;
	BCDADD6 BADD2(.S(BCDADD6_S2), .Cout(BCDADD6_Cout2), .A(BCDADD6_S1), .B(B2));
	
	assign B3 = (Binary[7])? 8'h28 : 8'h00;
	BCDADD6 BADD3(.S(BCDADD6_S3), .Cout(BCDADD6_Cout3), .A(BCDADD6_S2), .B(B3));
	
	FA FA0(.S(FA_S), .Cout(FA_Cout), .A(Binary[7]), .B(BCDADD6_Cout2|BCDADD6_Cout3), .Cin(1'b0));
	assign BCD[7:0] = BCDADD6_S3;
	assign BCD[8] = FA_S;
	assign BCD[9] = FA_Cout;
	assign BCD[11:10] = 2'b00;
	
endmodule