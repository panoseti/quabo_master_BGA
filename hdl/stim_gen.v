`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
/*
Generate a periodic pulse to drive the stim switch, and a PWM DAC signal to determine level

*/
//////////////////////////////////////////////////////////////////////////////////


module stim_gen(
    input clk,
    input [3:0] rate,
    input enable,
    input [7:0] level,
    output stim_drive,
    output stim_dac
    );
    
    //19-bit counter to make 100MHz into min 190 Hz, max 24.4kHz
    reg [18:0] stim_count = 0;
    reg stim_pulse = 1;
    //Use the 8 LSBs of that counter to set and reset a flop to generate the dac
    reg dac_reg = 0;
    reg stim_go;
    always @ (rate, stim_count)
        case (rate)
            3'd0: stim_go = &stim_count;
            3'd1: stim_go = &stim_count[17:0];
            3'd2: stim_go = &stim_count[16:0];
            3'd3: stim_go = &stim_count[15:0];
            3'd4: stim_go = &stim_count[14:0];
            3'd5: stim_go = &stim_count[13:0];
            3'd6: stim_go = &stim_count[12:0];
            3'd7: stim_go = &stim_count[11:0];
        endcase
    reg [3:0] shift_reg;
    always @ (posedge clk) begin
        shift_reg <= {shift_reg[2:0], stim_go};
        stim_count <= stim_count + 1;
        if (stim_go) stim_pulse <= 0;
        else if (shift_reg[3])stim_pulse <= 1;
        if (stim_count[7:0] == level) dac_reg <= 0;
        else if (stim_count[7:0] == 0) dac_reg <= 1;
    end
    
    assign stim_drive = enable && stim_pulse;
    assign stim_dac = dac_reg;
    
endmodule
