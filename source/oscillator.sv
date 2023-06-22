/*////////////////////////////////////////////////////////////////////////////////
Module - Oscillator
Author - Diego Lopez
Date   - June 22, 2023 
////////////////////////////////////////////////////////////////////////////////*/
module oscillator(input logic clk, nRst, en, input logic [17:0] divider, 
                    input logic [1:0] octve_dwn, 
                    output logic [17:0] count, divisor);
    logic [17:0] nxt_count;

    // Flip Flop
    always_ff @(posedge clk, negedge nRst) begin
        if(!nRst)
            count = 0;
        else
            count = nxt_count;
    end

    // Next State Logic
    always @(octve_dwn) 
        divisor = divider << octve_dwn;

    always_comb
        if(count >= divisor)
            nxt_count = 1;
        else
            nxt_count = count + 1;
endmodule