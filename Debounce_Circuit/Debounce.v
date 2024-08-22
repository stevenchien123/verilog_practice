module Debounce_Circuit(output Dout, input Din, clk, reset);
reg [2:0] ns, cs;
reg Dout

// next stage logic
always@(*) begin
	case(cs)
	3'd0:
		ns = (Din)? 3'd0 : 3'd1;
	3'd1:
		ns = (Din)? 3'd0 : 3'd2;
	3'd2:
		ns = (Din)? 3'd0 : 3'd3;
	3'd3:
		ns = (Din)? 3'd0 : 3'd4;
	3'd4:
		ns = (Din)? 3'd0 : 3'd5;
	3'd5:
		ns = (Din)? 3'd0 : 3'd5;
	default:
		ns = 3'd0;
	endcase
end

// state register
always@(posedge clk or negedge reset) begin
	if(!reset)
		cs <= 3'd0;
	else
		ns <= cs;
end

// output logic
always@(*) begin
	case(cs)
	3'd0:
		Dout = 1'b1;
	3'd1:
		Dout = 1'b1;
	3'd2:
		Dout = 1'b1;
	3'd3:
		Dout = 1'b1;
	3'd4:
		Dout = 1'b1;
	3'd5:
		Dout = 1'b0;
	default:
		Dout = 1'b1;
	endcase
end

endmodule