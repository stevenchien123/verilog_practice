// This file only designd "Mode_Control" and "Electronic_Clock".
// "Debounce Circuit" , "Frequency_Divider" , "Binary2BCD" are missed.

module Mode_Control(output [1:0] mode, input trigger, reset);
	reg [1:0] mode, next_mode;
	
	always@(posedge trigger or negedge reset) begin
		if(!reset)
			mode <= 2'd0;
		else
			mode = next_mode;
	end
	
	always@(*) begin
		case(mode)
		2'b00:
			next_mode <= 2'b01;
		2'b01:
			next_mode <= 2'b10;
		2'b10:
			next_mode <= 2'b00;
		default:
			next_mode <= 2'b00;
		endcase
	end
endmodule

module Electronic_Clock(output [7:0] display_number, input [7:0] wdata, input [1:0] mode, input clk, reset, w_en);
	wire [7:0] hour_n, minute_n, second_n;
	reg [7:0] hour, minute, second, display_number;
	
	always@(posedge clk or negedge reset) begin
		if(!reset)
			hour <= 8'd0;
			minute <= 8'd0;
			second <= 8'd0;
		else begin
			hour <= (w_en && (mode == 2'b10))? wdata : hour_n;
			minute <= (w_en && (mode == 2'b01))? wdata : minute_n;
			second <= (w_en && (mode == 2'b00))? wdata : second_n;
		end
	end
	
	assign hour_n = (second == 8'd59 && minute == 8'd59)? ((hour == 8'd23)? 8'd0 : hour + 8'd1) : hour;
	assign minute_n = (second == 8'59)? ((minute == 8'd59)? 8'd0 : minute + 8'd1) : minute;
	assign second_n = (second == 8'd59)? 8'd0 : second + 8'd1;
	
	always@(*) begin
		case(mode)
		2'b00:
			display_number = second;
		2'b01:
			display_number = minute;
		2'b10:
			display_number = hour;
		default:
			display_number = second;
		endcase
	end
	
endmodule