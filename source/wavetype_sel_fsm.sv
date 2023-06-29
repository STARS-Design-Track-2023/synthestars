`default_nettype none
module wavetype_sel_fsm (input logic clk, nrst, wave_type, output logic [1:0]type_switch);

logic [1:0]next_q;

always_ff @ (posedge clk, negedge nrst) begin
if(!nrst) begin
    type_switch <= 2'b00;
end
else begin
    type_switch <= next_q;
end
end

always_comb begin
   case(type_switch)
    2'b00: next_q = (wave_type == 1) ? 2'b01 : 2'b00;
    2'b01: next_q = (wave_type == 1) ? 2'b10 : 2'b01; //square
    2'b10: next_q = (wave_type == 1) ? 2'b11 : 2'b10; //saw
    2'b11: next_q = (wave_type == 1) ? 2'b00 : 2'b11; //triangle

    default: next_q = 0;
   endcase
end

endmodule