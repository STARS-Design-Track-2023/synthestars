/********************************************************************************
Module - Mixer
Author - Emily Moreno
Date   - June 22, 2023 
********************************************************************************/
module mixer(input logic [11:0]n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, input logic clk, nRst, en, dividened, output logic [11:0]mixed_sample);

logic [11:0]max;
logic [3:0]N_active;
logic [12:0]active_notes;
logic[11:0]final_sample;
logic s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13;

assign max = '1;

always_ff @ (posedge clk, negedge nRst) begin
if(nRst == 0) begin
    mixed_sample <= 12'b000000000000;
end
else begin
    mixed_sample <= 
end
end

always_comb begin
mixed_sample = {n1 + n2 + n3 + n4 + n5 + n6 + n7 + n8 + n9 + n10 + n11 + n12 + n13};
mixed_sample = mixed_sample > max ? max : mixed_sample;

    s1 = n1 > 0? 1 : 0;
    s2 = n2 > 0? 1 : 0;
    s3 = n3 > 0? 1 : 0;
    s4 = n4 > 0? 1 : 0;
    s5 = n5 > 0? 1 : 0;
    s6 = n6 > 0? 1 : 0;
    s7 = n7 > 0? 1 : 0;
    s8 = n8 > 0? 1 : 0;
    s9 = n9 > 0? 1 : 0;
    s10 = n10 > 0? 1 : 0;
    s11 = n11 > 0? 1 : 0;
    s12 = n12 > 0? 1 : 0;
    s13 = n13 > 0? 1 : 0;

    active_notes[0] = s1;
    active_notes[1] = s2;
    active_notes[2] = s3;
    active_notes[3] = s4;
    active_notes[4] = s5;
    active_notes[5] = s6;
    active_notes[6] = s7;
    active_notes[7] = s8;
    active_notes[8] = s9;
    active_notes[9] = s10;
    active_notes[10] = s11;
    active_notes[11] = s12;
    active_notes[12] = s13;

N_active = $countones(active_notes);
end

sequential_divider u1(.clk(clk), .nRst(nRst), .en(en), .divider(N_active), .dividend(mixed_sample), .quotient(final_sample));
endmodule