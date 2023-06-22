/*////////////////////////////////////////////////////////////////////////////////
Module - Mixer
Author - Emily Moreno
Date   - June 22, 2023 
////////////////////////////////////////////////////////////////////////////////*/
module mixer(input logic [12:0]note, output logic mixed_sample);

logic max;
assign max = 8'b11111111;

always_comb begin

mixed_sample = note[0] + note[1] + note[2] + note[3] + note[4] + note[5] + note[6] + note[7] + note[8] + note[9] + note[10] + note[11] + note[12]; 
mixed_sample = mixed_sample > max ? max : mixed_sample;
end 
// mr code pls work

endmodule