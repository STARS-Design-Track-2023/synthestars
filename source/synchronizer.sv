module synchronizer (
	input logic in, clk,
	output logic out
);
	logic delay;
	always_ff @(posedge clk)
		delay <= in;
	
	always_ff @(posedge clk)
		out <= delay;
endmodule
