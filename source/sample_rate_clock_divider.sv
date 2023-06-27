/********************************************************************************
Module      - Sample Rate Clock Divider
Author      - Diego Lopez
Last Update - June 22, 2023 
Passed TB?  - Not Yet 
*********************************************************************************/
module sample_rate_clock_divider(input logic clk, nRst, enable, 
                                    output logic sample_now);
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
            nxt_count = enable ? (count + 1) : 0;
    end

    //Output Logic
    always_comb 
        sample_now = enable ? (count == 255) : 0;
endmodule