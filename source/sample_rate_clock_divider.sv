/*////////////////////////////////////////////////////////////////////////////////
Module - Sample Rate Clock Divider
Author - Diego Lopez
Date   - June 22, 2023 
////////////////////////////////////////////////////////////////////////////////*/
module sample_rate_clock_divider(input logic clk, nRst, output logic sample_now);
    logic [7:0] count, nxt_count;

    //Flip-Flop
    always_ff @( posedge clk, negedge nRst ) begin
        if(!nRst)
            count = 0;
        else
            count = nxt_count;
    end

    //Next State Logic
    always_comb begin
        if (count >= 255)
            nxt_count = 0;
        else
            nxt_count = count + 1;
    end

    //Output Logic
    always_comb 
        sample_now = (count == 255);
endmodule