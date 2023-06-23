/********************************************************************************
Module - Oscillator
Author - Diego Lopez
Date   - June 22, 2023 
*********************************************************************************/
module oscillator #(parameter COUNTS = 149)
        (input logic clk, nRst, enable, 
        output logic [7:0] saw_wave, divisor);
    logic [7:0] nxt_saw;
    logic [9:0] nxt_count, count;

    always_comb begin
        if(count >= COUNTS)
            nxt_count = 1;
        else
            nxt_count = count + 1;
    end
    always_ff @(posedge clk, negedge nRst) begin
        if(!nRst)
            count = 0;
        else   
            count = nxt_count;
    end

    always_comb begin
        if (saw_wave >= 255)
            nxt_saw = 0;
        else if (count == COUNTS)
            nxt_saw = saw_wave + 1;
        else
            nxt_saw = saw_wave;
    end
    always_ff @(posedge clk, negedge nRst) begin
        if(!nRst)
            saw_wave = 0;
        else
            saw_wave = nxt_saw;
    end
endmodule