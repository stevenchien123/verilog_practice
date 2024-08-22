// D Flip Flop design
module DFF32(output [31:0] Dout, input [31:0] Din, input clk, reset, w_en);

	reg [31:0] Dout;

	always@(posedge clk) begin
		if(reset)
			Dout <= 32'd0;
		else
			Dout <= (w_en)? Din : Dout;
	end

endmodule

// 32-bit Accumulator design
module Accu32(output [31:0] Acc_out,input clk, reset, w_en);

	wire [31:0] Din;
	assign Acc_out = Din + 32'd1;

	DFF32 D0(.Dout(Acc_out),
		 .Din(Din),
		 .clk(clk),
		 .reset(reset),
		 .w_en(w_en));

endmodule

// Divider Decoder design
module Div_Dec3to8(output [31:0] Dout, input [2:0] Din);

	reg [31:0] Dout;

	always@(Din) begin
		case(Din)
		3'd0:
			Dout = 32'd200000000;
		3'd1:
			Dout = 32'd150000000;
		3'd2:
			Dout = 32'd100000000;
		3'd3:
			Dout = 32'd50000000;
		3'd4:
			Dout = 32'd25000000;
		3'd5:
			Dout = 32'd16666666;
		3'd6:
			Dout = 32'd10000000;
		3'd7:
			Dout = 32'd6250000;
		endcase
	end
	
endmodule

// Frequency Divider design
module FDiv(output Fout, input Fin, input [2:0] Fsel);

	wire [31:0] Acc_out, Dout, Dout_h;
	wire reset, F_t;

	assign reset = (Acc_out >= Dout)? 1'b1 : 1'b0;
	assign Dout_h = Dout >> 1;
	assign F_t = (Acc_out > Dout_h)? 1'b1 : 1'b0;

	Acc32 A0(.Acc_out(Acc_out),
		 .clk(Fin),
		 .reset(reset),
		 .w_en(1'b1));

	Div_Dec3to8 D0(.Dout(Dout), .Din(Fsel));

	DFF32 D1(.Dout(Fout),
		 .Din(F_t),
		 .clk(Fin),
		 .reset(reset),
		 .w_en(1'b1));

endmodule