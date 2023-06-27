/********************************************************************************
Module - Mixer
Author - Emily Moreno
Date   - June 22, 2023 
********************************************************************************/
module mixer(input logic [7:0]n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, output logic [11:0]mixed_sample);



logic [11:0]max;
logic [3:0]N_active;
logic [12:0]active_notes;
logic s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13;

reg [1:0] register [3];
reg [1:0] queue [3];
assign max = '1;

always_comb begin
mixed_sample = {n1 + n2 + n3 + n4 + n5 + n6 + n7 + n8 + n9 + n10 + n11 + n12 + n13};
mixed_sample = mixed_sample > max ? max : mixed_sample; //prevents pain

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

mixed_sample = mixed_sample / N_active;

end

//to do list: kept for reference but prob will b deleted 
    
    //Determine "on/off"logic for every key
    //condition tbd
   /*
    always @(n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, register) begin
        case(n)
            4'b0000: out = n1;
            4'b0001: out = n2;
            4'b0010: out = n3;
            4'b0011: out = n4;
            4'b0100: out = n5;
            4'b0101: out = n6;
            4'b0110: out = n7;
            4'b0111: out = n8;
            4'b1000: out = n9;
            4'b1001: out = n10;
            4'b1010: out = n11;
            4'b1011: out = n12;
            4'b1100: out = n13;
        endcase
    initial
    begin
        //fill up space initially in order
        register[0] = user_;
        register[1] = new_note;
        register[2] = new_note;

        //while(oscillator > 0):
        //discard oldest note, shift existing notes
            register[0] = register[1];
            register[1] = register[2];
            register[2] = new_note;

        //
        //replace in cycles
        if (i == 3)
            i = 0;
        register[i] = new_note;

    end
    //if input given:
    //register = [0,0,0]
    // al = 0, a2 = 0, a3 = 0
    //register = [a1, a2, a3]
    //loop? initial starting point
    //a1 = 0;
    //register[a1+1]
    //if new input
    //register[a1, a2, a3] --> a1 = a2, a2 = a3, a3 = new input (shifitng values over)

    //Determine logic to only play max 3 keys; ignoring any
    //other keys that are pressed afterwards

    //Divide mixed_sample by the number of active keys

    //Determine output logic
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

    */
 
endmodule