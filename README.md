# STARS 2023 Design Final Project

## SyntheSTARS
* Diego Jesus Lopez
* Emily Moreno
* Michael Foster
* Steph Close
* (TA) Aidan Prendergast

## 13-Channel Synthesizer
The (insert kewl chip name) is a digital polyphonic synthesizer.
With thirteen keys each representative of a single note in a standard octave,
a wave type selection mode, and an octave swithcing mode, the (insert kewl chip name) 
is the working product of our team's design.

## Base Source Files
Clock and nRst omitted from input lists.
- keypad_encoder.sv              : Synchronizer and Edge Detector Module. Routes to FSM and 13 Oscillators.
  - Inputs: [14:0] keypad_i
  - Outputs: [12:0] keypad_s, modekey_edge, octave_edge
- oscillator.sv                  : Parameterized oscillator module.
  - Parameter: DIVIDER (16-bit)
  - Inputs: enable, [1:0] octave
  - Outputs: [17:0] count
- sample_rate_clock_divider.sv   : Sample Rate Clock Divider module.
  - Inputs: enable
  - Outputs: flag
- sequential_divider.sv          : Sequential Divider module.
  - Inputs: enable, [15:0] divider, [17:0] count, flag
  - Outputs: [7:0] quotient
- waveshaper.sv                  : Wave shaping and enveloping module.
  - Inputs: [7:0] quotient, [1:0] mode
  - Outputs: [7:0] sample
- mixer.sv                       : Polyphonic wave mixer with sequential divider.
  - Inputs: enable, [12:0] [7:0] samples, [12:0] samples_enabled
  - Outputs: [7:0] sample_mixed
- pwm.sv                         : Pulse Width Modulation module.
  - Inputs: enable, [7:0] sample_mixed
  - Outputs: pwm_o (add pwm_o_n for differential pair?)
- wavetype_set_fsm.sv            : Wave Mode Controller FSM module.
  - Inputs: modekey_edge
  - Outputs: [1:0] mode
- octave_fsm.sv                    : Octave switching FSM module.
  - Inputs: oct_down
  - Outputs: [1:0] oct_switch
- edge_dectector.sv                    : Edge detection pulse module.
  - Inputs: in
  - Outputs: out 

## Testbenching
- tb_base.sv : Base test bench template for further adaptation.
- tb_pwm.sv : Test bench for the pulse width modifier.
- tb_sequential_divider.sv : Test bench for the sequential divider.

## Pin Layout
Put all the GPIO pin numbers, i/o/io determination, and labels

## Supporting Equipment
- FPGA Prototype: State machine testing
- GTKWave: Waveform timing block testing

## RTL Diagrams

All the stuff from the proposal goes here, obviously updated from the time you did the proposal to the final layout
Include more than just block diagrams, including sub-block diagrams, state-transition diagrams, flowcharts, and timing diagrams

## Extensions
Add possible extensions here...

# Deadlines and Events
### Monday June 19th: Design Review Presentations
  
  Present top-level and block-level diagrams to explain design function and timing behavior.
<br><b>Requirements:</b> Heirarchical RTL Diagrams, State Transition Diagrams, Flowcharts, Pseudocode in RTL, WaveDROM for timing specific blocks.
<br><b>Notes:</b> Share the presentation with instructors in advance.

### Friday, June 23rd: Feature Freeze and Integration Mark

  Complete individual blocks to the level of error-free synthesis and passing testbenches. Begin top level module creation, integration, and testing.
<br><b>Requirements:</b> Transcript of Passing Testbench Cases for each tested module, Organized GTKWave showcase of passing test cases.
<br><b>Notes:</b> Beautify GTKWave formatting for ease of demonstration.

### Wednesday, July 5th: Final Design Presentations

