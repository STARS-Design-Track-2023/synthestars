module edge_detector (
	input logic clk, in,
	output logic out
)
	logic delay;
	always_ff @(posedge clk)
		delay <= in;
	assign out = ~delay && in;
endmodule
