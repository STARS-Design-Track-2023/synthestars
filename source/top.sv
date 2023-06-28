`default_nettype none

module top 
(
  // I/O ports
  input  logic hz12M, reset,
  input  logic [20:0] pb,
  output logic [7:0] left, right,
         ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0,
  output logic red, green, blue,

  // UART ports
  output logic [7:0] txdata,
  input  logic [7:0] rxdata,
  output logic txclk, rxclk,
  input  logic txready, rxready
);
  logic [12:0] NOTES;
  logic [7:0] OSC_OUT [12:0];
  logic [7:0] SHAPER_OUT [12:0];
  logic [7:0] mixed_sample;
  logic [1:0] oct_state, mode_state;
  logic NRST, OCTAVE, octave_enc, MODE, mode_enc, PWM_OUT;

  assign NRST = pb[19];
  assign OCTAVE = pb[18];
  assign MODE = pb[17];
  assign NOTES = pb[12:0];

  keypad_encoder ency (
    .clk(hz12M),
    .octave(OCTAVE),
    .mode(MODE),
    .octave_out(octave_enc),
    .mode_out(mode_enc)
  );


  octave_FSM octy( 
    .clk(hz12M), 
    .nrst(NRST),
    .oct_down(octave_enc),
    .oct_switch(oct_state)
  );
  wavetype_sel_fsm modey(
    .clk(hz12M),
    .nrst(NRST),
    .wave_type(mode_enc),
    .type_switch(mode_state)
  );


  oscillator #(.COUNTS(75)) osc_01 (
    .clk(hz12M), .nRst(NRST), .enable(NOTES[0]), .oct_dwn(oct_state), .saw_wave(OSC_OUT[0]));
  oscillator #(.COUNTS(70)) osc_02 (
    .clk(hz12M), .nRst(NRST), .enable(NOTES[1]), .oct_dwn(oct_state), .saw_wave(OSC_OUT[1]));
  oscillator #(.COUNTS(67)) osc_03 (
    .clk(hz12M), .nRst(NRST), .enable(NOTES[2]), .oct_dwn(oct_state), .saw_wave(OSC_OUT[2]));
  oscillator #(.COUNTS(63)) osc_04 (
    .clk(hz12M), .nRst(NRST), .enable(NOTES[3]), .oct_dwn(oct_state), .saw_wave(OSC_OUT[3]));
  oscillator #(.COUNTS(59)) osc_05 (
    .clk(hz12M), .nRst(NRST), .enable(NOTES[4]), .oct_dwn(oct_state), .saw_wave(OSC_OUT[4]));
  oscillator #(.COUNTS(56)) osc_06 (
    .clk(hz12M), .nRst(NRST), .enable(NOTES[5]), .oct_dwn(oct_state), .saw_wave(OSC_OUT[5]));
  oscillator #(.COUNTS(53)) osc_07 (
    .clk(hz12M), .nRst(NRST), .enable(NOTES[6]), .oct_dwn(oct_state), .saw_wave(OSC_OUT[6]));
  oscillator #(.COUNTS(50)) osc_08 (
    .clk(hz12M), .nRst(NRST), .enable(NOTES[7]), .oct_dwn(oct_state), .saw_wave(OSC_OUT[7]));
  oscillator #(.COUNTS(47)) osc_09 (
    .clk(hz12M), .nRst(NRST), .enable(NOTES[8]), .oct_dwn(oct_state), .saw_wave(OSC_OUT[8]));
  oscillator #(.COUNTS(44)) osc_10 (
    .clk(hz12M), .nRst(NRST), .enable(NOTES[9]), .oct_dwn(oct_state), .saw_wave(OSC_OUT[9]));
  oscillator #(.COUNTS(42)) osc_11 (
    .clk(hz12M), .nRst(NRST), .enable(NOTES[10]), .oct_dwn(oct_state), .saw_wave(OSC_OUT[10]));
  oscillator #(.COUNTS(40)) osc_12 (
    .clk(hz12M), .nRst(NRST), .enable(NOTES[11]), .oct_dwn(oct_state), .saw_wave(OSC_OUT[11]));
  oscillator #(.COUNTS(37)) osc_13 (
    .clk(hz12M), .nRst(NRST), .enable(NOTES[12]), .oct_dwn(oct_state), .saw_wave(OSC_OUT[12]));
  

  wave_shaper shaper_01 (
    .saw_in(OSC_OUT[0]), .wave_form(mode_state), .wave_out(SHAPER_OUT[0]));
  wave_shaper shaper_02 (
    .saw_in(OSC_OUT[1]), .wave_form(mode_state), .wave_out(SHAPER_OUT[1]));
  wave_shaper shaper_03 (
    .saw_in(OSC_OUT[2]), .wave_form(mode_state), .wave_out(SHAPER_OUT[2]));
  wave_shaper shaper_04 (
    .saw_in(OSC_OUT[3]), .wave_form(mode_state), .wave_out(SHAPER_OUT[3]));
  wave_shaper shaper_05 (
    .saw_in(OSC_OUT[4]), .wave_form(mode_state), .wave_out(SHAPER_OUT[4]));
  wave_shaper shaper_06 (
    .saw_in(OSC_OUT[5]), .wave_form(mode_state), .wave_out(SHAPER_OUT[5]));
  wave_shaper shaper_07 (
    .saw_in(OSC_OUT[6]), .wave_form(mode_state), .wave_out(SHAPER_OUT[6]));
  wave_shaper shaper_08 (
    .saw_in(OSC_OUT[7]), .wave_form(mode_state), .wave_out(SHAPER_OUT[7]));
  wave_shaper shaper_09 (
    .saw_in(OSC_OUT[8]), .wave_form(mode_state), .wave_out(SHAPER_OUT[8]));
  wave_shaper shaper_10 (
    .saw_in(OSC_OUT[9]), .wave_form(mode_state), .wave_out(SHAPER_OUT[9]));
  wave_shaper shaper_11 (
    .saw_in(OSC_OUT[10]), .wave_form(mode_state), .wave_out(SHAPER_OUT[10]));
  wave_shaper shaper_12 (
    .saw_in(OSC_OUT[11]), .wave_form(mode_state), .wave_out(SHAPER_OUT[11]));
  wave_shaper shaper_13 (
    .saw_in(OSC_OUT[12]), .wave_form(mode_state), .wave_out(SHAPER_OUT[12]));
  
  
  mixer mixo(
    .n1(SHAPER_OUT[0]),
    .n2(SHAPER_OUT[1]),
    .n3(SHAPER_OUT[2]),
    .n4(SHAPER_OUT[3]),
    .n5(SHAPER_OUT[4]),
    .n6(SHAPER_OUT[5]),
    .n7(SHAPER_OUT[6]),
    .n8(SHAPER_OUT[7]),
    .n9(SHAPER_OUT[8]),
    .n10(SHAPER_OUT[9]),
    .n11(SHAPER_OUT[10]),
    .n12(SHAPER_OUT[11]),
    .n13(SHAPER_OUT[12]),
    .mixed_sample(mixed_sample)
  );

  pwm pwmy(
    .clk(hz12M), 
    .nrst(NRST), 
    .enable(1'b1),
    .mixed_sample(mixed_sample),
    .PWM_o(PWM_OUT)
  );

endmodule
