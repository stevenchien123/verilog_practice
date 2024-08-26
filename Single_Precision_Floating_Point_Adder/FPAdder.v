// This design is adding two positive floating point number
module FPAdder(output [31:0] FR, input [31:0] FA, FB);
	wire FA_sign, FB_sign, FR_sign;
	wire [7:0] FA_exp, FB_exp, FR_exp;
	wire [22:0] FA_fra, FB_fra, FR_fra, FB_fra_shift;
	wire [24:0] FA_ext, FB_ext, FR_add;
	
	
	// Compare exponent of FA and FB, then assign value to FA, FB, FR
	// Place bigger exponent number at FA, smaller exponent number at FB
	assign {FA_sign, FA_exp, FA_fra} = (FA[30:23] > FB[30:23])? FA : FB;
	assign {FB_sign, FB_exp, FB_fra} = (FA[30:23] > FB[30:23])? FB : FA;
	assign FR = {FR_sign, FR_exp, FR_fra};
	
	// Extend fraction to check carry out
	// extend two bits buz fraction format is 1.fraction
	// if there is a carry out, it would be 10.fraction
	// and there are two bits in front of fraction
	FA_ext = {2'b01, FA_fra};
	FB_ext = {2'b01, FB_fra};
	
	// Shift smaller exponent FP number (FB)
	wire EXDiff = FA_exp - FB_exp;
	FB_fra_shift = FB_ext >> EXDiff;
	
	// Add FA and FB fraction
	assign FR_add = FA_ext + FB_fra_shift;
	
	// Normalization
	assign FR_sign = 1'b0;
		// After addition, the exponent would be the bigger exponent number (FA_exp) or FA_exp + 1
		// depends on if there is a carry out
	assign FR_exp = (FR_add[24])? FA_exp + 1 : FA_exp;
	assign FR_fra = (FR_add[24])? FR_add[23:1] : FR_add[22:0];
	
endmodule