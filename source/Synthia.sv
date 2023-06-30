/************************************************************************
Module - Synthia
Author - Diego Lopez
Date   - June 22, 2023 
TB Passed!
*************************************************************************/
module Synthia(input logic [12:0] pb, input logic clk, reset, modes, octaves, output logic PWM_o);
logic oct_down, wave_next;
logic [1:0] octave, wave_type;
logic [7:0] s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13; 
logic [7:0] n1,n2,n3,n4,n5,n6,n7,n8,n9,n10,n11,n12,n13, mixed_sample;

keypad_encoder m0(.octave(octaves), .mode(modes), .clk(clk), .octave_out(oct_down), .mode_out(wave_next));
octave_FSM e0(.clk(clk), .nrst(reset), .oct_down(oct_down), .oct_switch(octave));
wavetype_sel_fsm s0(.clk(clk), .nrst(reset), .wave_type(wave_next), .type_switch(wave_type));

// oscillator #(.COUNTS(90)) d1(.clk(clk), .nRst(reset), .enable(pb[0]), .oct_dwn(octave), .saw_wave(s1));
// wave_shaper w1(.saw_in(s1), .wave_form(wave_type), .wave_out(n1));

// oscillator #(.COUNTS(85)) d2(.clk(clk), .nRst(reset), .enable(pb[1]), .oct_dwn(octave), .saw_wave(s2));
// wave_shaper w2(.saw_in(s2), .wave_form(wave_type), .wave_out(n2));

// oscillator #(.COUNTS(80)) d3(.clk(clk), .nRst(reset), .enable(pb[2]), .oct_dwn(octave), .saw_wave(s3));
// wave_shaper w3(.saw_in(s3), .wave_form(wave_type), .wave_out(n3));

// oscillator #(.COUNTS(76)) d4(.clk(clk), .nRst(reset), .enable(pb[3]), .oct_dwn(octave), .saw_wave(s4));
// wave_shaper w4(.saw_in(s4), .wave_form(wave_type), .wave_out(n4));

// oscillator #(.COUNTS(72)) d5(.clk(clk), .nRst(reset), .enable(pb[4]), .oct_dwn(octave), .saw_wave(s5));
// wave_shaper w5(.saw_in(s5), .wave_form(wave_type), .wave_out(n5));

// oscillator #(.COUNTS(68)) d6(.clk(clk), .nRst(reset), .enable(pb[5]), .oct_dwn(octave), .saw_wave(s6));
// wave_shaper w6(.saw_in(s6), .wave_form(wave_type), .wave_out(n6));

// oscillator #(.COUNTS(64)) d7(.clk(clk), .nRst(reset), .enable(pb[6]), .oct_dwn(octave), .saw_wave(s7));
// wave_shaper w7(.saw_in(s7), .wave_form(wave_type), .wave_out(n7));

// oscillator #(.COUNTS(60)) d8(.clk(clk), .nRst(reset), .enable(pb[7]), .oct_dwn(octave), .saw_wave(s8));
// wave_shaper w8(.saw_in(s8), .wave_form(wave_type), .wave_out(n8));

// oscillator #(.COUNTS(57)) d9(.clk(clk), .nRst(reset), .enable(pb[8]), .oct_dwn(octave), .saw_wave(s9));
// wave_shaper w9(.saw_in(s9), .wave_form(wave_type), .wave_out(n9));

// oscillator #(.COUNTS(54)) d10(.clk(clk), .nRst(reset), .enable(pb[9]), .oct_dwn(octave), .saw_wave(s10));
// wave_shaper w10(.saw_in(s10), .wave_form(wave_type), .wave_out(n10));

// oscillator #(.COUNTS(51)) d11(.clk(clk), .nRst(reset), .enable(pb[10]), .oct_dwn(octave), .saw_wave(s11));
// wave_shaper w11(.saw_in(s11), .wave_form(wave_type), .wave_out(n11));

// oscillator #(.COUNTS(48)) d12(.clk(clk), .nRst(reset), .enable(pb[11]), .oct_dwn(octave), .saw_wave(s12));
// wave_shaper w12(.saw_in(s12), .wave_form(wave_type), .wave_out(n12));

// oscillator #(.COUNTS(45)) d13(.clk(clk), .nRst(reset), .enable(pb[12]), .oct_dwn(octave), .saw_wave(s13));
// wave_shaper w13(.saw_in(s13), .wave_form(wave_type), .wave_out(n13));


oscillator #(.COUNTS(75)) d1(.clk(clk), .nRst(reset), .enable(pb[0]), .oct_dwn(octave), .saw_wave(s1));
wave_shaper w1(.saw_in(s1), .wave_form(wave_type), .wave_out(n1));

oscillator #(.COUNTS(70)) d2(.clk(clk), .nRst(reset), .enable(pb[1]), .oct_dwn(octave), .saw_wave(s2));
wave_shaper w2(.saw_in(s2), .wave_form(wave_type), .wave_out(n2));

oscillator #(.COUNTS(67)) d3(.clk(clk), .nRst(reset), .enable(pb[2]), .oct_dwn(octave), .saw_wave(s3));
wave_shaper w3(.saw_in(s3), .wave_form(wave_type), .wave_out(n3));

oscillator #(.COUNTS(63)) d4(.clk(clk), .nRst(reset), .enable(pb[3]), .oct_dwn(octave), .saw_wave(s4));
wave_shaper w4(.saw_in(s4), .wave_form(wave_type), .wave_out(n4));

oscillator #(.COUNTS(59)) d5(.clk(clk), .nRst(reset), .enable(pb[4]), .oct_dwn(octave), .saw_wave(s5));
wave_shaper w5(.saw_in(s5), .wave_form(wave_type), .wave_out(n5));

oscillator #(.COUNTS(56)) d6(.clk(clk), .nRst(reset), .enable(pb[5]), .oct_dwn(octave), .saw_wave(s6));
wave_shaper w6(.saw_in(s6), .wave_form(wave_type), .wave_out(n6));

oscillator #(.COUNTS(53)) d7(.clk(clk), .nRst(reset), .enable(pb[6]), .oct_dwn(octave), .saw_wave(s7));
wave_shaper w7(.saw_in(s7), .wave_form(wave_type), .wave_out(n7));

oscillator #(.COUNTS(50)) d8(.clk(clk), .nRst(reset), .enable(pb[7]), .oct_dwn(octave), .saw_wave(s8));
wave_shaper w8(.saw_in(s8), .wave_form(wave_type), .wave_out(n8));

oscillator #(.COUNTS(47)) d9(.clk(clk), .nRst(reset), .enable(pb[8]), .oct_dwn(octave), .saw_wave(s9));
wave_shaper w9(.saw_in(s9), .wave_form(wave_type), .wave_out(n9));

oscillator #(.COUNTS(44)) d10(.clk(clk), .nRst(reset), .enable(pb[9]), .oct_dwn(octave), .saw_wave(s10));
wave_shaper w10(.saw_in(s10), .wave_form(wave_type), .wave_out(n10));

oscillator #(.COUNTS(42)) d11(.clk(clk), .nRst(reset), .enable(pb[10]), .oct_dwn(octave), .saw_wave(s11));
wave_shaper w11(.saw_in(s11), .wave_form(wave_type), .wave_out(n11));

oscillator #(.COUNTS(40)) d12(.clk(clk), .nRst(reset), .enable(pb[11]), .oct_dwn(octave), .saw_wave(s12));
wave_shaper w12(.saw_in(s12), .wave_form(wave_type), .wave_out(n12));

oscillator #(.COUNTS(37)) d13(.clk(clk), .nRst(reset), .enable(pb[12]), .oct_dwn(octave), .saw_wave(s13));
wave_shaper w13(.saw_in(s13), .wave_form(wave_type), .wave_out(n13));

mixer em0(.n1(n1), .n2(n2), .n3(n3), .n4(n4), .n5(n5), .n6(n6), .n7(n7), .n8(n8), .n9(n9), .n10(n10), .n11(n11), .n12(n12), .n13(n13),
            .s1({15'b0, pb[0]}), .s2({15'b0, pb[1]}), .s3({15'b0, pb[2]}),.s4({15'b0, pb[3]}),.s5({15'b0, pb[4]}),.s6({15'b0, pb[5]}),
            .s7({15'b0, pb[6]}),.s8({15'b0, pb[7]}),.s9({15'b0, pb[8]}),.s10({15'b0, pb[9]}),.s11({15'b0, pb[10]}),.s12({15'b0, pb[11]}),.s13({15'b0, pb[12]}),
      .clk(clk), .nRst(reset), .en(1'b1),.mixed_sample(mixed_sample));
pwm p0(.clk(clk), .nrst(reset), .enable(1'b1), .mixed_sample(mixed_sample), .PWM_o(PWM_o));

endmodule