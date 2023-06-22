module synchronizer (
	input logic in, clk,
	output logic out
);
	always_ff @(posedge clk)
		out <= in;
endmodule
