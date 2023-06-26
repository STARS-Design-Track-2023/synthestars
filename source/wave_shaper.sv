/********************************************************************************
Module - Wave Shaper
Author - Diego Lopez
Date   - June 23, 2023 
*********************************************************************************/
module wave_shaper(input logic [7:0] wave_in, input logic [1:0] wave_form,
                     output logic [7:0] wave_out);
    logic [8:0] tri_wave_up;
    logic [9:0] tri_wave_down;
    always_comb begin
        tri_wave_up = {wave_in, 1'b0};
        tri_wave_down = (wave_in > 128) ? 512 - tri_wave_up : 0;
        case (wave_form)
            2'b10: wave_out = wave_in;
            2'b11: wave_out = (wave_in < 128) ? tri_wave_up[7:0] : ((wave_in == 128) ? 255 : tri_wave_down[7:0]);
            2'b01: wave_out = (wave_in < 128) ? 0 : 255;
            default: wave_out = 0;
        endcase
    end
endmodule