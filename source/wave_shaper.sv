/********************************************************************************
Module - Wave Shaper
Author - Diego Lopez
Date   - June 23, 2023 
*********************************************************************************/
module wave_shaper(input logic [7:0] saw_in, input logic [1:0] wave_form,
                     output logic [7:0] wave_out);
    logic [8:0] tri_wave_up, tri_wave_down;
    always_comb begin
        tri_wave_up = {saw_in, 1'b0};
        tri_wave_down = (saw_in > 128) ? 511 - tri_wave_up : 0;
        case (wave_form)
            2'b10: wave_out = saw_in;
            2'b11: wave_out = (saw_in < 128) ? tri_wave_up[7:0] : tri_wave_down[7:0];
            2'b01: wave_out = (saw_in < 128) ? 0 : 255;
            default: wave_out = 0;
        endcase
    end
endmodule