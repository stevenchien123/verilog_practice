module Traffic_Light(output [2:0] LightA, LightB, input clk, reset);
	reg [2:0] LightA, LightB;	     // 100: Green, 010: Yellow, 001: Red
	reg [1:0] next_state, current_state; // 4 bits for 4 states
	reg [3:0] next_count, current_count; // 4 bits fot count, count at most to 10

	// next state logic...
	always@(*) begin
		case(current_state)
		2'b00:
		begin
			next_state = (current_count < 4'd8)? 2'b00 : 2'b01;

			// check if current_state satisfy the condition of next_state
			// if not yet，next_count = current_count + 1
			// if satisfid，next_state = 1
			// the reason why assign next_count to 1 is buz assign need 1 clock period
			// so the counter value would be correct (set to 0 would slow 1 sec)
			next_count = (current_count < 4'd8)? current_count + 4'd1 : 4'd1;
		end
		2'b01:
		begin
			next_state = (current_count < 4'd3)? 2'b01 : 2'b10;
			next_count = (current_count < 4'd3)? current_count + 4'd1 : 4'd1;
		end
		2'b10:
		begin
			next_state = (current_count < 4'd10)? 2'b10 : 2'b11;
			next_count = (current_count < 4'd10)? current_count + 4'd1 : 4'd1;
		end
		2'b11:
		begin
			next_state = (current_count < 4'd3)? 2'b11 : 2'b00;
			next_count = (current_count < 4'd3)? current_count + 4'd1 : 4'd1;
		end
		endcase

	end

	// state register...
	always@(posedge clk or negedge reset) begin
		if(!reset) begin
			current_state <= 2'b00;
			current_count <= 4'd1;
		end
		else begin
			current_state <= next_state;
			current_count <= next_count;
		end

	end

	// output logic...
	always@(*) begin
		case(current_state)
		2'b00:
		begin
			LightA = 3'b100;
			LightB = 3'b001;
		end
		2'b01:
		begin
			LightA = 3'b010;
			LightB = 3'b001;
		end
		2'b10:
		begin
			LightA = 3'b001;
			LightB = 3'b100;
		end
		2'b11:
		begin
			LightA = 3'b001;
			LightB = 3'b010;
		end

	end
endmodule