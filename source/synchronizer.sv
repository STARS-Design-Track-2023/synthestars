/**********************************
Module - Synchronizer
Author - Michael Foster
Date   - June 22, 2023 
**********************************/

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
