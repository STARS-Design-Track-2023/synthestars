module mixer(
    input logic [7:0] n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13,
    input logic [15:0] s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,
    input logic clk, nRst, en,
    output logic [7:0] mixed_sample
);
    logic [15:0]N_active;
    logic [12:0]active_notes;
    logic[15:0]final_sample;

    always_comb begin
        N_active = s1+s2+s3+s4+s5+s6+s7+s8+s9+s10+s11+s12+s13;

        final_sample = {8'b0, n1} + 
                       {8'b0, n2} + 
                       {8'b0, n3} + 
                       {8'b0, n4} + 
                       {8'b0, n5} + 
                       {8'b0, n6} + 
                       {8'b0, n7} + 
                       {8'b0, n8} + 
                       {8'b0, n9} + 
                       {8'b0, n10} + 
                       {8'b0, n11} + 
                       {8'b0, n12} + 
                       {8'b0, n13};
    end

    sequential_divider u1(.clk(clk), .nRst(nRst), .en(en), .divider((N_active << 8)), .dividend(final_sample), .quotient(mixed_sample));
endmodule