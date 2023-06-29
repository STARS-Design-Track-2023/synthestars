/********************************************************************************
Module - Octave FSM
Author - Emily Moreno
Date   - June 22, 2023 
*********************************************************************************/
module octave_FSM (input logic clk, nrst, oct_down, output logic [1:0]oct_switch);

logic [1:0]next_q;

always_ff @ (posedge clk, negedge nrst) begin
if(!nrst) begin
    oct_switch <= 2'b00;
end
else begin
    oct_switch <= next_q;
end

end 
always_comb begin
   case(oct_switch)
    2'b00: next_q = (oct_down == 1) ? 2'b01 : 2'b00;
    2'b01: next_q = (oct_down == 1) ? 2'b10 : 2'b01;
    2'b10: next_q = (oct_down == 1) ? 2'b11 : 2'b10;
    2'b11: next_q = (oct_down == 1) ? 2'b00 : 2'b11;
    default: next_q = 0;
   endcase
end



endmodule