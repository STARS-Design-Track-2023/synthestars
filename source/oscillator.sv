/********************************************************************************
Module - Oscillator
Author - Diego Lopez
Date   - June 22, 2023 
*********************************************************************************/
module oscillator #(parameter COUNTS = 149)
        (input logic clk, nRst, enable, input logic [1:0] octve_dwn, 
        output logic [7:0] count, divisor);
    logic [9:0] nxt_sample, sample;
    logic [7:0] nxt_count;
    
    always @(octve_dwn) 
        divisor = enable ? ((COUNTS << 8) << octve_dwn): 0;

    // Clock Divider Sampler
    always_ff @(posedge clk, negedge nRst) begin
        if(!nRst)
            sample = 0;
        else
            sample = enable ? nxt_sample : 0;
    end
    always_comb
        if(count >= COUNTS)
            nxt_sample = 1;
        else
            nxt_sample = sample + 1;

    
    // Sample Output
    always_ff @ (posedge sample, negedge nRst) begin
        if(!nRst)
            count = 0;
        else
            count = enable ? nxt_count : 0;
    end

    always_comb begin
        if (count >= 255)
            nxt_count = 0;
        else
            nxt_count = count + 1;
    end
endmodule