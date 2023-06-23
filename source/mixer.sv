/*////////////////////////////////////////////////////////////////////////////////
Module - Mixer
Author - Emily Moreno
Date   - June 22, 2023 
////////////////////////////////////////////////////////////////////////////////*/
module mixer(input logic [7:0]n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, output logic [11:0]mixed_sample);


logic [11:0]max;
logic [1:0]num_active;
logic s1, s2, s3 , s4, s5, s6, s7, s8, s9, s10, s11, s12, s13;

assign max = '1;

always_comb begin

mixed_sample = {n1 + n2 + n3 + n4 + n5 + n6 + n7 + n8 + n9 + n10 + n11 + n12 + n13};
mixed_sample = mixed_sample > max ? max : mixed_sample;

n1 ? s1 == 1 : s1 == 0;
n2 ? s2 == 1 : s2 == 0;
n3 ? s3 == 1 : s3 == 0;
n4 ? s4 == 1 : s4 == 0;
n5 ? s5 == 1 : s5 == 0;
n6 ? s6 == 1 : s6 == 0;
n7 ? s7 == 1 : s7 == 0;
n8 ? s8 == 1 : s8 == 0;
n9 ? s9 == 1 : s9 == 0;
n10 ? s10 == 1 : s10 == 0;
n11 ? s11 == 1 : s11 == 0;
n12 ? s12 == 1 : s12 == 0;
n13 ? s13 == 1 : s13 == 0;

if(n1 | n2 | n3 | n4 | n5 | n6 | n7 | n8 | n9 | n10  | n11 | n12 | n13) begin
num_active = 2'd1;
mixed_sample = mixed_sample / num_active;
    if(n1 | n2 | n3 | n4 | n5 | n6 | n7 | n8 | n9 | n10  | n11 | n12 | n13) begin
        num_active = 2'd2;
        mixed_sample = mixed_sample / num_active;
        if(n1 | n2 | n3 | n4 | n5 | n6 | n7 | n8 | n9 | n10  | n11 | n12 | n13) begin
            num_active = 2'd3;
            mixed_sample = mixed_sample / num_active;
        end
    end
end

end

// mr code pls work

endmodule