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
- Testing FPGA Prototype
- 

## RTL Diagrams
All the stuff from the proposal goes here, obviously updated from the time you did the proposal to the final layout
Include more than just block diagrams, including sub-block diagrams, state-transition diagrams, flowcharts, and timing diagrams

Top level RTL: Full Chip Design
<img width="359" alt="Screenshot 2023-06-28 162310" src="https://github.com/STARS-Design-Track-2023/synthestars/assets/81669431/02c9bf65-2757-4d7a-bda4-8a73e11f866a">

Module RTL: Wave Shaper
<img width="248" alt="Screenshot 2023-06-28 162229" src="https://github.com/STARS-Design-Track-2023/synthestars/assets/81669431/7ccfb3d2-fafe-4218-a5bc-b6ad92344e6c">

Module RTL: Keypad Encoder
<img width="289" alt="Screenshot 2023-06-19 134852" src="https://github.com/STARS-Design-Track-2023/synthestars/assets/81669431/f602a960-aa5a-4bfc-9d91-bf8709d225ba">

Module RTL: Oscillator
<img width="558" alt="Screenshot 2023-06-19 134000" src="https://github.com/STARS-Design-Track-2023/synthestars/assets/81669431/9304cfe9-5d08-4634-ae92-cf16c0e5deaa">

Module RTL: Sample Rate Clock Divider
<img width="669" alt="Screenshot 2023-06-19 134053" src="https://github.com/STARS-Design-Track-2023/synthestars/assets/81669431/b70bbccf-9f75-43fa-9627-89cc9e569642">

Module RTL: Pulse Width Modulater
<img width="439" alt="Screenshot 2023-06-19 134750" src="https://github.com/STARS-Design-Track-2023/synthestars/assets/81669431/9bd56ad5-6428-4ec7-8580-180b5188dcef">

Module RTL: Mixer
<img width="368" alt="Screenshot 2023-06-28 154908" src="https://github.com/STARS-Design-Track-2023/synthestars/assets/81669431/70989a1a-6739-46f0-ae10-4cac8ac59ce1">

State Machine: Wave Type Selection FSM
<img width="425" alt="Screenshot 2023-06-19 135422" src="https://github.com/STARS-Design-Track-2023/synthestars/assets/81669431/9812ffd3-8a00-4a03-8571-3c72cedc31d9">

State Machine: Octave Step-Down FSM
<img width="333" alt="Screenshot 2023-06-19 134539" src="https://github.com/STARS-Design-Track-2023/synthestars/assets/81669431/df69535b-c09e-41fd-bd37-73db1b94aadb">

Most Recent Timing Diagram (I/O Pulses)
![IMG_0251](https://github.com/STARS-Design-Track-2023/synthestars/assets/81669431/482b9c31-5398-4119-be0a-81f605af46d0)

High Level Flowchart
<img width="275" alt="Screenshot 2023-06-28 163035" src="https://github.com/STARS-Design-Track-2023/synthestars/assets/81669431/3241edbd-f855-4efd-be74-4bbf8ceecb47">

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

### Wednesday - Friday, July 5th - 7th: Final Design Presentations

