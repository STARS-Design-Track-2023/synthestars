/*////////////////////////////////////////////////////////////////////////////////
Module - PWM
Author - Diego Lopez
Date   - June 22, 2023 
////////////////////////////////////////////////////////////////////////////////*/
module PWM(input logic clk, nRst, input logic [7:0] mixed_sample,
             output logic PWM_o);
    logic [7:0] count, nxt_count;
    logic pwm;

    //Counter Flip-Flop
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
        pwm = (count < mixed_sample);

    always_ff @(posedge clk, negedge nRst) begin
        if(!nRst)
            PWM_o = 0;
        else
            PWM_o = pwm;
    end
endmodule