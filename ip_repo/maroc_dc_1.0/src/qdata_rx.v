`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/14/2018 12:27:49 PM
// Design Name: 
// Module Name: qdata_rx
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// Receive four lanes of data from the LTC2170 and output 4 * 12b parallel data plus a strobe
//////////////////////////////////////////////////////////////////////////////////


module qdata_rx(
    input [3:0] adc_sdin,
    input bit_clk,
    input ref_clk,
    input frame_clk,
    output [11:0] adc_par_data0,
    output [11:0] adc_par_data1,
    output [11:0] adc_par_data2,
    output [11:0] adc_par_data3,
    output adc_frame,
    output adc_par_dav
    );
 
 //Range of IODELAY is 2.5ns with a 200 MHz clock; 20 is about 1.5ns
 parameter IDELAY = 20;   
    wire [11:0] adc_par_out [3:0];
    reg [5:0]sr_rise [3:0];
    reg [5:0]sr_fall [3:0];
    wire frame_rise;

   IDELAYCTRL ADC_data (
      .RDY(),       // 1-bit output: Ready output
      .REFCLK(ref_clk), // 1-bit input: Reference clock input
      .RST(1'b0)        // 1-bit input: Active high reset input
   );

wire [3:0] adc_sdin_del;
wire frame_clk_del;

    //IDDRs to receive the data.  clock is aligned to center of bit time
    wire [3:0] iddr_out_rise;
    wire [3:0] iddr_out_fall;
    genvar gg;
     generate
       for (gg=0; gg < 4; gg=gg+1)
       begin: QDATA_RX   
  IDELAYE2 #(
      .CINVCTRL_SEL("FALSE"),          // Enable dynamic clock inversion (FALSE, TRUE)
      .DELAY_SRC("IDATAIN"),           // Delay input (IDATAIN, DATAIN)
      .HIGH_PERFORMANCE_MODE("FALSE"), // Reduced jitter ("TRUE"), Reduced power ("FALSE")
      .IDELAY_TYPE("FIXED"),           // FIXED, VARIABLE, VAR_LOAD, VAR_LOAD_PIPE
      .IDELAY_VALUE(IDELAY),                // Input delay tap setting (0-31)
      .PIPE_SEL("FALSE"),              // Select pipelined mode, FALSE, TRUE
      .REFCLK_FREQUENCY(200.0),        // IDELAYCTRL clock input frequency in MHz (190.0-210.0, 290.0-310.0).
      .SIGNAL_PATTERN("DATA")          // DATA, CLOCK input signal
   )
   IDELAYE2_ADC_data (
      .CNTVALUEOUT(), // 5-bit output: Counter value output
      .DATAOUT(adc_sdin_del[gg]),         // 1-bit output: Delayed data output
      .C(1'b0),                     // 1-bit input: Clock input
      .CE(1'b0),                   // 1-bit input: Active high enable increment/decrement input
      .CINVCTRL(1'b0),       // 1-bit input: Dynamic clock inversion input
      .CNTVALUEIN(5'b0),   // 5-bit input: Counter value input
      .DATAIN(1'b0),           // 1-bit input: Internal delay data input
      .IDATAIN(adc_sdin[gg]),         // 1-bit input: Data input from the I/O
      .INC(1'b0),                 // 1-bit input: Increment / Decrement tap delay input
      .LD(1'b0),                   // 1-bit input: Load IDELAY_VALUE input
      .LDPIPEEN(1'b0),       // 1-bit input: Enable PIPELINE register to load data input
      .REGRST(1'b0)            // 1-bit input: Active-high reset tap-delay input
   );
     IDDR #(
               .DDR_CLK_EDGE("OPPOSITE_EDGE"), // "OPPOSITE_EDGE", "SAME_EDGE" 
                                               //    or "SAME_EDGE_PIPELINED" 
               .INIT_Q1(1'b0), // Initial value of Q1: 1'b0 or 1'b1
               .INIT_Q2(1'b0), // Initial value of Q2: 1'b0 or 1'b1
               .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC" 
            ) IDDR_DATA (
               .Q1(iddr_out_rise[gg]), // 1-bit output for positive edge of clock 
               .Q2(iddr_out_fall[gg]), // 1-bit output for negative edge of clock
               .C(bit_clk),   // 1-bit clock input
               .CE(1'b1), // 1-bit clock enable input
               .D(adc_sdin_del[gg]),   // 1-bit DDR data input
               .R(1'b0),   // 1-bit reset
               .S(1'b0)    // 1-bit set
    );

        always @ (posedge bit_clk) begin
                sr_rise[gg] <= {sr_rise[gg][4:0], iddr_out_rise[gg]};
                sr_fall[gg] <= {sr_fall[gg][4:0], iddr_out_fall[gg]};
        end
        assign adc_par_out[gg] = {
                                    sr_rise[gg][5], sr_fall[gg][5], 
                                    sr_rise[gg][4], sr_fall[gg][4], 
                                    sr_rise[gg][3], sr_fall[gg][3], 
                                    sr_rise[gg][2], sr_fall[gg][2], 
                                    sr_rise[gg][1], sr_fall[gg][1], 
                                    sr_rise[gg][0], sr_fall[gg][0]};
    end
   endgenerate

  IDELAYE2 #(
      .CINVCTRL_SEL("FALSE"),          // Enable dynamic clock inversion (FALSE, TRUE)
      .DELAY_SRC("IDATAIN"),           // Delay input (IDATAIN, DATAIN)
      .HIGH_PERFORMANCE_MODE("FALSE"), // Reduced jitter ("TRUE"), Reduced power ("FALSE")
      .IDELAY_TYPE("FIXED"),           // FIXED, VARIABLE, VAR_LOAD, VAR_LOAD_PIPE
      .IDELAY_VALUE(IDELAY),                // Input delay tap setting (0-31)
      .PIPE_SEL("FALSE"),              // Select pipelined mode, FALSE, TRUE
      .REFCLK_FREQUENCY(200.0),        // IDELAYCTRL clock input frequency in MHz (190.0-210.0, 290.0-310.0).
      .SIGNAL_PATTERN("DATA")          // DATA, CLOCK input signal
   )
   IDELAYE2_frame (
      .CNTVALUEOUT(), // 5-bit output: Counter value output
      .DATAOUT(frame_clk_del),         // 1-bit output: Delayed data output
      .C(1'b0),                     // 1-bit input: Clock input
      .CE(1'b0),                   // 1-bit input: Active high enable increment/decrement input
      .CINVCTRL(1'b0),       // 1-bit input: Dynamic clock inversion input
      .CNTVALUEIN(5'b0),   // 5-bit input: Counter value input
      .DATAIN(1'b0),           // 1-bit input: Internal delay data input
      .IDATAIN(frame_clk),         // 1-bit input: Data input from the I/O
      .INC(1'b0),                 // 1-bit input: Increment / Decrement tap delay input
      .LD(1'b0),                   // 1-bit input: Load IDELAY_VALUE input
      .LDPIPEEN(1'b0),       // 1-bit input: Enable PIPELINE register to load data input
      .REGRST(1'b0)            // 1-bit input: Active-high reset tap-delay input
   );

             IDDR #(
               .DDR_CLK_EDGE("OPPOSITE_EDGE"), // "OPPOSITE_EDGE", "SAME_EDGE" 
                                               //    or "SAME_EDGE_PIPELINED" 
               .INIT_Q1(1'b0), // Initial value of Q1: 1'b0 or 1'b1
               .INIT_Q2(1'b0), // Initial value of Q2: 1'b0 or 1'b1
               .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC" 
            ) IDDR_FRAME (
               .Q1(frame_rise), // 1-bit output for positive edge of clock 
               .Q2(), // 1-bit output for negative edge of clock
               .C(bit_clk),   // 1-bit clock input
               .CE(1'b1), // 1-bit clock enable input
               .D(frame_clk_del),   // 1-bit DDR data input
               .R(1'b0),   // 1-bit reset
               .S(1'b0)    // 1-bit set
    );

//differentiate the frame signal to make a dav pulse
reg frame_rise_d1;
always @ (posedge bit_clk) frame_rise_d1 <=frame_rise;

assign adc_par_dav = frame_rise && !frame_rise_d1;
assign adc_frame = frame_rise;

//register the outputs on frame
reg [11:0] adc_par_data_reg0;
reg [11:0] adc_par_data_reg1;
reg [11:0] adc_par_data_reg2;
reg [11:0] adc_par_data_reg3;
always @ (posedge bit_clk) begin
    if (adc_par_dav) begin
        adc_par_data_reg0 <= adc_par_out[0];
        adc_par_data_reg1 <= adc_par_out[1];
        adc_par_data_reg2 <= adc_par_out[2];
        adc_par_data_reg3 <= adc_par_out[3];
    end
end
assign adc_par_data0 = adc_par_data_reg0;
assign adc_par_data1 = adc_par_data_reg1;
assign adc_par_data2 = adc_par_data_reg2;
assign adc_par_data3 = adc_par_data_reg3;
wire QDATA_RX_adc_frame = adc_frame;
endmodule
