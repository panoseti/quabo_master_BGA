`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2018 06:06:46 PM
// Design Name: 
// Module Name: sync_it
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
// 
//////////////////////////////////////////////////////////////////////////////////


module sync_it(
    input din,
    input clk,
    output dout
    );
//   SYNC_STAGES     - Integer value for number of synchronizing registers, must be 2 or higher
    //   PIPELINE_STAGES - Integer value for number of registers on the output of the
    //                     synchronizer for the purpose of improveing performance.
    //                     Particularly useful for high-fanout nets.
    //   INIT            - Initial value of synchronizer registers upon startup, 1'b0 or 1'b1.
    
       parameter SYNC_STAGES = 2;
       parameter PIPELINE_STAGES = 1;
       parameter INIT = 1'b0;
    
       wire sync_out;
    
       (* ASYNC_REG="TRUE" *) reg [SYNC_STAGES-1:0] sreg = {SYNC_STAGES{INIT}};
    
       always @(posedge clk)
         sreg <= {sreg[SYNC_STAGES-2:0], din};
    
       generate
          if (PIPELINE_STAGES==0) begin: no_pipeline
    
             assign sync_out = sreg[SYNC_STAGES-1];
    
          end else if (PIPELINE_STAGES==1) begin: one_pipeline
    
             reg sreg_pipe = INIT;
    
             always @(posedge clk)
                sreg_pipe <= sreg[SYNC_STAGES-1];
    
             assign sync_out = sreg_pipe;
    
          end else begin: multiple_pipeline
    
            (* shreg_extract = "no" *) reg [PIPELINE_STAGES-1:0] sreg_pipe = {PIPELINE_STAGES{INIT}};
    
             always @(posedge clk)
                sreg_pipe <= {sreg_pipe[PIPELINE_STAGES-2:0], sreg[SYNC_STAGES-1]};
    
             assign sync_out = sreg_pipe[PIPELINE_STAGES-1];
    
          end
       endgenerate
 assign dout = sync_out;
 
endmodule
