/*////////////////////////////////////////////////////////////////////////////////
Module - Mixer
Author - Emily Moreno
Date   - June 22, 2023 
////////////////////////////////////////////////////////////////////////////////*/
module mixer(input logic [7:0]n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, output logic [11:0]mixed_sample);

logic [11:0]max;
assign max = '1;

always_comb begin

mixed_sample = n1 + n2 + n3 + n4 + n5 + n6 + n7 + n8 + n9 + n10 + n11 + n12 + n13;
mixed_sample = mixed_sample > max ? max : mixed_sample;
end 
// mr code pls work

endmodule