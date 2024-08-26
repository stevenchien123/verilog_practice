module Queue(output [3:0] data_out, output full, empty,
			input [3:0] data_in, input clk, reset, enable, enq_deq);
	
	reg empty;
	reg [2:0] r_index;
	reg [3:0] queue_mem [0:7];
	
	always@(posedge clk or negedge reset) begin
		if(!reset) begin
				r_index <= 3'd0;
				empty <= 1'b1;
		end
		else if(enable) begin
			else begin
				if(enq_deq) begin	 // enqueue
					if(!full) begin	 // if queue is not full, enqueue data (use shift register), else no-op
						queue_mem[7] <= queue_mem[6];
						queue_mem[6] <= queue_mem[5];
						queue_mem[5] <= queue_mem[4];
						queue_mem[4] <= queue_mem[3];
						queue_mem[3] <= queue_mem[2];
						queue_mem[2] <= queue_mem[1];
						queue_mem[1] <= queue_mem[0];
						queue_mem[0] <= data_in;
					end
					if(empty) begin
						r_index <= 3'd0;
						empty <= 1'b0;
					end
					else begin
						r_index <= (full)? 3'd7 : r_index + 3'd1;
					end
				end
				else begin			 // dequeue
					if(!empty) begin // if queue is not empty, dequeue, else no-op
						empty <= (r_index == 3'd0);
						r_index <= (r_index == 3'd0)? 3'd0 : r_index - 3'd1;
					end
				end
			end
		end
		else begin
			r_index <= r_index;
			empty <= empty;
		end
	end
	
	assign full = (r_index == 3'd7);
	assign data_out = (empty)? 4'd0 : queue_mem[r_index];
	
endmodule