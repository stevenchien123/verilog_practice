// Adder 16-bit design
module add16(output [15:0] S, output Cout, input [15:0] A, B, input Cin);
	wire C1, C2, C3;
	
	RCA4 A0(.S(S[3:0]), .Cout(C1), .A(A[3:0]), .B(B[3:0]), .Cin(Cin));
	RCA4 A1(.S(S[7:4]), .Cout(C2), .A(A[7:4]), .B(B[7:4]), .Cin(C1));
	RCA4 A2(.S(S[11:8]), .Cout(C3), .A(A[11:8]), .B(B[11:8]), .Cin(C2));
	RCA4 A3(.S(S[15:12]), .Cout(Cout), .A(A[15:12]), .B(B[15:12]), .Cin(C3));
endmodule

// Decoder 3 to 8 design
module Decoder3to8(output [7:0] Dout, input [2:0] Din);
	reg [7:0] Dout;
	
	always@(*) begin
		case(Din)
		3'b000:
			Dout = 8'b00000001;
		3'b001:
			Dout = 8'b00000010;
		3'b010:
			Dout = 8'b00000100;
		3'b011:
			Dout = 8'b00001000;
		3'b100:
			Dout = 8'b00010000;
		3'b101:
			Dout = 8'b00100000;
		3'b110:
			Dout = 8'b01000000;
		3'b111:
			Dout = 8'b10000000;
		endcase
	end
endmodule

// Register Files design
// w_en: Specify which register would be written.
module RegFile(output [15:0] A, B, output [3:0] read_value,
			   input [2:0] read_addr, input [7:0] w_en, input [3:0] data, input clk, rst);
	reg [3:0] reg_file [0:7];
	
	always@(posedge clk or negedge rst) begin
		if(!rst) begin
			reg_file[0] <= 4'd0;
			reg_file[1] <= 4'd0;
			reg_file[2] <= 4'd0;
			reg_file[3] <= 4'd0;
			reg_file[4] <= 4'd0;
			reg_file[5] <= 4'd0;
			reg_file[6] <= 4'd0;
			reg_file[7] <= 4'd0;
		end
		else begin
			reg_file[0] <= (w_en[0])? data : reg_file[0];
			reg_file[1] <= (w_en[1])? data : reg_file[1];
			reg_file[2] <= (w_en[2])? data : reg_file[2];
			reg_file[3] <= (w_en[3])? data : reg_file[3];
			reg_file[4] <= (w_en[4])? data : reg_file[4];
			reg_file[5] <= (w_en[5])? data : reg_file[5];
			reg_file[6] <= (w_en[6])? data : reg_file[6];
			reg_file[7] <= (w_en[7])? data : reg_file[7];
		end
	end

	assign A = {reg_file[3], reg_file[2], reg_file[1], reg_file[0]};
	assign B = {reg_file[7], reg_file[6], reg_file[5], reg_file[4]};
	assign read_value = reg_file[read_addr];
	
endmodule

/* Top design
 *   S: Sum of A and B.
 *   Cout: Carry out of A+B.
 *   read_value: Value of register at given read address.
 *   data: The value would be written into register files.
 *   read_addr: The address would be read in registe files.
 *   RW: Specify read or write for register files.
 */
module Reg_Add16(output [15:0] S, output Cout, output [3:0] read_value,
			    input [3:0] data, input [2:0] read_addr, input clk, rst, RW);
	wire [7:0] Dout, w_en;
	wire [15:0] add_in_A, add_in_B;
	
	Decoder3to8 D0(.Dout(Dout), .Din(read_addr));
	assign w_en = (RW)? 8'd0 : Dout;
	
	RegFile R0(.A(add_in_A),
			   .B(add_in_B),
			   .read_addr(read_addr),
			   .read_value(read_value),
			   .w_en(w_en),
			   .data(data),
			   .clk(clk),
			   .rst(rst));
	
	add16 A0(.S(S), .Cout(Cout), .A(add_in_A), .B(add_in_B), .Cin(1'b0));
endmodule