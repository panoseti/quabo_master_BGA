`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
/*  Accepts 32-bit words from the CPU on par_data_in, written by pulsing wr_par_data
    After loading 104 such words, the GO signal is pulsed to send out the serial
    bit streams.  The LS bit is sent first.  Input words are interleaved by channel (MAROC chip) 0,1,2,3,0,1,2,3...
    chan_enable has a bit for each channel; set chan_en[chan] = 0 to force that channel's
    SC_CLK and SC_DOUT low during transmission.  Set to 4'b1111 to send all channels
    SC_RSTb is an asynch reset controlled by the reset_MAROC input; it's not automatically
    pulsed before sending setup data.
    The (synchronous to clk) reset input resets the logic and FIFOs
    The data coming back from the MAROCs is wrtten to a FIFO and can be read
    by the CPU by pulsing rd_par_data, and appears on par_data_out
    
*/

module maroc_slow_control(
    input clk,
    input reset,
    input reset_MAROC,
    input [31:0] par_data_in,
    output [3:0] SC_DOUT,
    output [3:0] SC_RSTb,
    output [3:0] SC_CLK,
    input [3:0] SC_DIN,
    output [31:0] par_data_out,
    input wr_par_data,
    input rd_par_data,
    input [3:0] chan_enable,
    input go
    );
    
    //A fifo to collect the data words to be sent
    wire [31:0] out_fifo_out;
    wire out_fifo_wen;
    wire out_fifo_ren;
    wire out_fifo_full;
    wire out_fifo_empty;
    
  fifo_32by128 SC_OUT_FIFO (
      .clk(clk),      // input wire clk
      .srst(reset),    // input wire srst
      .din(par_data_in),      // input wire [31 : 0] din
      .wr_en(out_fifo_wen),  // input wire wr_en
      .rd_en(out_fifo_ren),  // input wire rd_en
      .dout(out_fifo_out),    // output wire [31 : 0] dout
      .full(out_fifo_full),    // output wire full
      .empty(out_fifo_empty)  // output wire empty
    );

    //A fifo to collect the data words to be sent
    wire [31:0] in_fifo_in;
    wire in_fifo_wen;
    wire in_fifo_ren;
    wire in_fifo_full;
    wire in_fifo_empty;
    
  fifo_32by128 SC_IN_FIFO (
      .clk(clk),      // input wire clk
      .srst(reset),    // input wire srst
      .din(in_fifo_in),      // input wire [31 : 0] din
      .wr_en(in_fifo_wen),  // input wire wr_en
      .rd_en(in_fifo_ren),  // input wire rd_en
      .dout(par_data_out),    // output wire [31 : 0] dout
      .full(in_fifo_full),    // output wire full
      .empty(in_fifo_empty)  // output wire empty
    );


//Write the data into the OUTFIFO on the rising edge of wr_par_data
reg wr_par_data_d1 = 0;
always @ (posedge clk) wr_par_data_d1 <= wr_par_data;
assign out_fifo_wen = wr_par_data && !wr_par_data_d1;

//Read the data from the INFIFO on the rising edge of rd_par_data
reg rd_par_data_d1 = 0;
always @ (posedge clk) rd_par_data_d1 <= rd_par_data;
assign in_fifo_ren = rd_par_data && !rd_par_data_d1;

//Four par-to-ser shift registers for the data going out and four ser-to-par for the data coming back\
reg [31:0] out_shift_reg [3:0];
wire [3:0]load_out_SR;
wire shift_out_SR;
reg [31:0] in_shift_reg [3:0];
wire shift_in_SR;
//Four 3-bit shift registers to delay the output stream so that. after 832 shifts, the LSB
//  of the MAROC register will be the LSB of the input data
reg [2:0] pad_reg [3:0];
    always @ (posedge clk) begin
        if (reset) begin
            out_shift_reg[0] <= 0;
            out_shift_reg[1] <= 0;
            out_shift_reg[2] <= 0;
            out_shift_reg[3] <= 0;
            in_shift_reg[0] <= 0;
            in_shift_reg[1] <= 0;
            in_shift_reg[2] <= 0;
            in_shift_reg[3] <= 0;
            pad_reg[0] <= 0;
            pad_reg[1] <= 0;
            pad_reg[2] <= 0;
            pad_reg[3] <= 0;
        end
        else begin
            if (shift_out_SR) begin
                pad_reg[0] <= {out_shift_reg[0][0], pad_reg[0][2:1]};
                pad_reg[1] <= {out_shift_reg[1][0], pad_reg[1][2:1]};
                pad_reg[2] <= {out_shift_reg[2][0], pad_reg[2][2:1]};
                pad_reg[3] <= {out_shift_reg[3][0], pad_reg[3][2:1]};
            end         
            if (load_out_SR[0]) out_shift_reg[0] <= out_fifo_out;
            else if (shift_out_SR) out_shift_reg[0] <= {1'b0, out_shift_reg[0][31:1]};
            if (load_out_SR[1]) out_shift_reg[1] <= out_fifo_out;
            else if (shift_out_SR) out_shift_reg[1] <= {1'b0, out_shift_reg[1][31:1]};
            if (load_out_SR[2]) out_shift_reg[2] <= out_fifo_out;
            else if (shift_out_SR) out_shift_reg[2] <= {1'b0, out_shift_reg[2][31:1]};
            if (load_out_SR[3]) out_shift_reg[3] <= out_fifo_out;
            else if (shift_out_SR) out_shift_reg[3] <= {1'b0, out_shift_reg[3][31:1]};
            if (shift_in_SR) begin
                in_shift_reg[0] <= {SC_DIN[0], in_shift_reg[0][31:1]};
                in_shift_reg[1] <= {SC_DIN[1], in_shift_reg[1][31:1]};
                in_shift_reg[2] <= {SC_DIN[2], in_shift_reg[2][31:1]};
                in_shift_reg[3] <= {SC_DIN[3], in_shift_reg[3][31:1]};
            end
 	    end
 	end

//A MUX to select oneof the four 32-bit input shift reg outputs
reg [31:0] inmux;
wire [1:0] inmux_sel;
   always @*
   case (inmux_sel)
      2'b00: inmux = in_shift_reg[0];
      2'b01: inmux = in_shift_reg[1];
      2'b10: inmux = in_shift_reg[2];
      2'b11: inmux = in_shift_reg[3];
   endcase
assign in_fifo_in = inmux;

//Counters to count clock cycles per serial bit, and to count bits, and to count words
parameter CYCLES_PER_TICK = 50;
parameter BITS_PER_WORD = 32;
//We write 26 32-bit words to each channel, = 832b
parameter WORDS_PER_STREAM = 26;
reg [7:0] tick_counter = 0;
wire inc_tick_counter;
wire res_tick_counter;
wire tick = (tick_counter == CYCLES_PER_TICK - 1);
reg [5:0] bit_counter = 0;
wire inc_bit_counter;
wire res_bit_counter;
reg [6:0] word_counter = 0;
wire inc_word_counter;
wire res_word_counter;

always @ (posedge clk) begin
    if (reset || res_tick_counter || tick) tick_counter <= 0;
    else if (inc_tick_counter) tick_counter <= tick_counter + 1;
    if (reset || res_bit_counter) bit_counter <= 0;
    else if (inc_bit_counter) bit_counter <= bit_counter + 1;
    if (reset || res_word_counter) word_counter <= 0;
    else if (inc_word_counter) word_counter <= word_counter + 1;
end

//A state machine to manage the loading and shifting
   parameter IDLE = 8'b00000001;
   parameter RDFIFO = 8'b00000010;
   parameter WAIT4TICK1 = 8'b00000100;
   parameter WAIT4TICK2 = 8'b00001000;
   parameter WRITELASTWORDS = 8'b00010000;
   

   reg [7:0] state = IDLE;

   always @(posedge clk)
      if (reset)
         state <= IDLE;
      else
         case (state)
            IDLE : begin
               if (go)
                  state <= RDFIFO;
               else
                  state <= IDLE;
            end
            RDFIFO : begin
                if (tick_counter == 3)
                  state <= WAIT4TICK1;
                else
                    state <= RDFIFO;
            end
            WAIT4TICK1 : begin
               if (tick)
                  state <= WAIT4TICK2;
               else
                  state <= WAIT4TICK1;
            end
            WAIT4TICK2 : begin
               if (!tick)
                  state <= WAIT4TICK2;
               else if (bit_counter < BITS_PER_WORD-1)
                     state <= WAIT4TICK1;
               else if (word_counter < WORDS_PER_STREAM-1)
                        state <= RDFIFO;
               else
                  state <= WRITELASTWORDS;
            end
            WRITELASTWORDS : begin
               if (tick_counter < 3)
                  state <= WRITELASTWORDS;
               else
                  state <= IDLE;
            end
            default : begin  // Fault Recovery
               state <= IDLE;
            end
         endcase

assign res_tick_counter = (state == IDLE);
assign inc_tick_counter = 1;
assign res_bit_counter = (state == IDLE)|| (state == RDFIFO);
assign inc_bit_counter = ((state == WAIT4TICK2) && tick);
assign res_word_counter = (state == IDLE);
assign inc_word_counter = (state == WAIT4TICK2) && (bit_counter == BITS_PER_WORD-1) && tick;
//We read four words while in RDFIFO
assign out_fifo_ren = (state == RDFIFO);
//But write them to the shift registers one cycle after
assign load_out_SR[0] = (state == RDFIFO) && (tick_counter == 1);
assign load_out_SR[1] = (state == RDFIFO) && (tick_counter == 2);
assign load_out_SR[2] = (state == RDFIFO) && (tick_counter == 3);
assign load_out_SR[3] = (state == WAIT4TICK1) && (tick_counter == 4) && (bit_counter == 0);
//Change the DOUT at the falling edge of SC_CLK
assign shift_out_SR = (state == WAIT4TICK2) && tick;
//Register the return data at the rising edge of SC_CLK
assign shift_in_SR = (state == WAIT4TICK1) && tick;

//Cycle through the four readback words while reading the outfifo- the first set will be jumk
assign inmux_sel = tick_counter[1:0];
//Write those words in RDFIFO and WRITELASTWORDS
assign in_fifo_wen = (state == RDFIFO) || (state == WRITELASTWORDS);
//A DFF for the CLK, so no glitches
reg clk_reg = 0;
wire set_clk_reg;
wire res_clk_reg;
always @ (posedge clk) begin
    if (reset || res_clk_reg) clk_reg <= 0;
    else if (set_clk_reg) clk_reg <= 1;
end
assign set_clk_reg = (state == WAIT4TICK1) && tick;
assign res_clk_reg = (state == WAIT4TICK2) && tick;


    assign SC_CLK[0] = clk_reg && chan_enable[0];
    assign SC_CLK[1] = clk_reg && chan_enable[1];
    assign SC_CLK[2] = clk_reg && chan_enable[2];
    assign SC_CLK[3] = clk_reg && chan_enable[3];
    assign SC_DOUT[0] = pad_reg[0][0] && chan_enable[0];
    assign SC_DOUT[1] = pad_reg[1][0] && chan_enable[1];
    assign SC_DOUT[2] = pad_reg[2][0] && chan_enable[2];
    assign SC_DOUT[3] = pad_reg[3][0] && chan_enable[3];
    assign SC_RSTb[0] = !reset_MAROC;
    assign SC_RSTb[1] = !reset_MAROC;
    assign SC_RSTb[2] = !reset_MAROC;
    assign SC_RSTb[3] = !reset_MAROC;
    
endmodule
