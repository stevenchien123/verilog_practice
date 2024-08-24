module S_Reg(output [7:0] Pout, output Sout, input clk, rst, SW, Din);
	reg SReg [7:0];	// Shift Regist itself
	wire Sin
	
	assign Sin = (SW)? SReg[7] : Din;
	assign Pout = SReg;
	assign Sout = SReg[7];
	
	always@(posedge clk or negedge rst)
		if(!rst)
			SReg <= 8'd0;
		else
			// also can write in this way:
			// SReg <= (SW)? {SReg[6:0], SReg[7]} : {SReg[6:0], Sin};
			// then replace Din with Sin in parameter list and delete "assign Sin = (SW)? SReg[7] : Din;"
			SReg <= {SReg[6:0], Sin};
	end
endmodule