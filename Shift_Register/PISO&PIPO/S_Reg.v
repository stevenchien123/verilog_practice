module S_Reg(output [7:0] Pout, output Sout, input [7:0] Pin, input clk, rst, SW, PS, Sin);
	reg SReg [7:0];	// Shift Register itself
	
	assign Pout = SReg;
	assign Sout = SReg[7];
	
	always@(posedge clk or negedge rst) begin
		if(!rst)
			SReg <= 8'd0;
		else if(SW)
			SReg <= {SReg[6:0], SReg[7]};
		else
			SReg <= (PS)? Pin : {SReg[6:0], Sin};
	end
endmodule
