// No overflow and carry out detection...

module DFF8(output [7:0] Dout, input [7:0] Din, input clk, rst, w_en);
	reg [7:0] Dout;

	always@(posedge clk or negedge rst) begin
		if(!rst)
			Dout <= 8'd0;
		else
			Dout <= (w_en)? Din : Dout;
	end
endmodule

module Acc8(output [7:0] Dout, input [7:0] Din, input clk, rst, w_en);
	assign Din = Dout + 8'd1;

	DFF8 dff(.Dout(Dout), .Din(Din), .clk(clk), .rst(rst), .w_en(w_en));
endmodule