/************************************************************************
Module      - PWM
Author      - Diego Lopez
Last Update - June 23, 2023 
Passed TB?  - Yes
*************************************************************************/
module pwm(input logic clk, nrst, enable, input logic [7:0] mixed_sample,
             output logic PWM_o);
    logic [7:0] count, nxt_count;
    logic pwm;

    //Counter Flip-Flop
    always_ff @( posedge clk, negedge nrst ) begin
        if(!nrst)
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
        pwm = (count < mixed_sample);

    always_ff @(posedge clk, negedge nrst) begin
        if(!nrst)
            PWM_o = 0;
        else
            PWM_o = enable ? pwm : 0;
    end
endmodule