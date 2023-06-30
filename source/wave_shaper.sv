/************************************************************************
Module - Wave Shaper
Author - Diego Lopez
Date   - June 23, 2023 
*************************************************************************/
module wave_shaper(input logic [7:0] saw_in, input logic [1:0] wave_form,
                     output logic [7:0] wave_out);
    logic [8:0] tri_wave_up, tri_wave_down;
    assign tri_wave_up = {saw_in, 1'b0};
    assign tri_wave_down = (saw_in > 128) ? 511 - tri_wave_up : 0;
    assign wave_out = (wave_form == 2'b00) ? 0 : 
        (wave_form == 2'b01) ? ((saw_in < 128) ? 0 : 255) :
        (wave_form == 2'b10) ? saw_in :
        (wave_form == 2'b11) ? ((saw_in < 128) ? tri_wave_up[7:0] : tri_wave_down[7:0]) :
        0;
endmodule