/**********************************
Module - Keypad Encoder
Author - Michael Foster
Date   - June 22, 2023 
**********************************/

module keypad_encoder (
	input logic octave, mode, clk,
	output logic octave_out, mode_out
);
	logic sync_octave, sync_mode;
	synchronizer syncy (
		.clk(clk),
		.in(octave),
		.out(sync_octave)
	);
	
	synchronizer synco (
		.clk(clk),
		.in(mode),
		.out(sync_mode)
	);

	
	edge_detector edgy(
		.clk(clk),
		.in(sync_octave),
		.out(octave_out)
	);

	edge_detector edgo(
		.clk(clk),
		.in(sync_mode),
		.out(mode_out)
	);
endmodule
