/************************************************************************
Module - Oscillator
Author - Diego Lopez
Date   - June 22, 2023 
*************************************************************************/
module oscillator #(parameter COUNTS = 149)
        (input logic clk, nRst, enable, input logic [1:0] oct_dwn,
        output logic [7:0] saw_wave);
    logic [7:0] nxt_saw, saw_temp;
    logic [9:0] nxt_count, count;

    always_comb begin
        if(count >= COUNTS << oct_dwn)
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
        if (saw_temp >= 255)
            nxt_saw = 0;
        else if (count == COUNTS << oct_dwn)
            nxt_saw = saw_temp + 1;
        else
            nxt_saw = saw_temp;
    end
    always_ff @(posedge clk, negedge nRst) begin
        if(!nRst)
            saw_temp = 0;
        else
            saw_temp = nxt_saw;
    end

    always_comb begin
        saw_wave = enable ? saw_temp : 0;
    end
endmodule