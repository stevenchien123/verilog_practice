// The Stack is combined with 8 4-bit registers
module Stack(output full, empty, output [3:0] data_out,
		    input clk, reset, enable, push_pop, input [3:0] data_in);
	wire [2:0] w_sp;
	
	reg [2:0] sp;
	reg empty;
	reg [3:0] stack_mem [0:7];
	
	always@(posedge clk or negedge reset) begin
		if(enable) begin
			if(!reset) begin
				sp <= 3'd0;
				empty <= 1'b1;
			end
			else begin
				if(push_pop) begin	// push
					sp <= w_sp;
					stack_mem[w_sp] <= (full)? stack_mem[w_sp] : data_in;
					empty <= 1'b0;
				end
				else begin			// pop
					sp <= (empty)? 3'd0 : sp - 3'd1;
					empty <= (sp == 3'd0);	// we didn't assign empty like full
											// cuz empty would be rise when sp == 0 and doing pop operation
											// empty should be written into pop logic
				end
			end
		end
		else begin	// keep the same state
			sp <= sp;
			empty <= empty;
		end
	end
	
	assign w_sp = (empty)? 3'd0 : ((full)? sp : sp + 3'd1);
	assign full = (sp == 3'd7);
	assign data_out = (empty)? 4'd0 : stack_mem[sp];

endmodule