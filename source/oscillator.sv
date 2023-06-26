/************************************************************************
Module - Oscillator
Author - Diego Lopez
Date   - June 22, 2023 
*************************************************************************/
module oscillator #(parameter COUNTS = 149)
        (input logic clk, nRst, enable, input logic [1:0] oct_dwn,
        output logic [7:0] saw_wave);
    logic [7:0] nxt_saw;
    logic [9:0] nxt_count, count;

    always_comb begin
        if(count >= COUNTS << oct_dwn)
            nxt_count = 1;
        else
            nxt_count = enable ? (count + 1) : 0;
    end
    always_ff @(posedge clk, posedge nRst) begin
        if(nRst)
            count = 0;
        else   
            count = nxt_count;
    end

    always_comb begin
        if (saw_wave >= 255)
            nxt_saw = 0;
        else if (count == COUNTS << oct_dwn)
            nxt_saw = enable ? saw_wave + 1 : 0;
        else
            nxt_saw = enable ? saw_wave : 0;
    end
    always_ff @(posedge clk, posedge nRst) begin
        if(nRst)
            saw_wave = 0;
        else
            saw_wave = nxt_saw;
    end
endmodule