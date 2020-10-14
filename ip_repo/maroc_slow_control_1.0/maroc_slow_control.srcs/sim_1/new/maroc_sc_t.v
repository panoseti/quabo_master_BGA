`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
/*
Testbench for the slow control module
*/

module maroc_sc_t();

//The interface:
//	wire [31:0] par_data_in = slv_reg0;
// wire [31:0] par_data_out = slv_reg1;
//	wire SC_reset = slv_reg2[0];
//	wire maroc_reset = slv_reg2[1];
//	wire wr_par_data = slv_reg2[2];
//	wire rd_par_data = slv_reg2[3];
//	wire [3:0] chan_enable = slv_reg2[7:4];
//	wire SC_go = slv_reg2[8];

wire [3:0] SC_DOUT;
wire [3:0] SC_RSTb;
wire [3:0] SC_CLK;
wire [3:0] SC_DIN;

integer ii;

//A memory structure to capture the data coming back
wire rd_par_data = UUT.maroc_slow_control_v1_0_S00_AXI_inst.slv_reg2[3];
wire [31:0] par_data_out = UUT.maroc_slow_control_v1_0_S00_AXI_inst.USR_LOGIC.par_data_out;

integer jj;
reg [31:0] readback[103:0];
always @ (negedge rd_par_data) begin
    for (jj = 0; jj < 103; jj = jj + 1)
        readback[jj] <= readback[jj+1];
    readback[103] <= par_data_out;
end
  

//The setup shift reg internal to each MAROC:
reg [828:0]maroc_shift_reg0;
reg [828:0]maroc_shift_reg1;
reg [828:0]maroc_shift_reg2;
reg [828:0]maroc_shift_reg3;
//The output changes state on the falling edge
reg maroc_sc_out0;
reg maroc_sc_out1;
reg maroc_sc_out2;
reg maroc_sc_out3;
always @ (posedge SC_CLK[0]) maroc_shift_reg0 <= {SC_DOUT[0], maroc_shift_reg0[828:1]};
always @ (posedge SC_CLK[1]) maroc_shift_reg1 <= {SC_DOUT[1], maroc_shift_reg1[828:1]};
always @ (posedge SC_CLK[2]) maroc_shift_reg2 <= {SC_DOUT[2], maroc_shift_reg2[828:1]};
always @ (posedge SC_CLK[3]) maroc_shift_reg3 <= {SC_DOUT[3], maroc_shift_reg3[828:1]};

always @ (negedge SC_CLK[0]) maroc_sc_out0 <= maroc_shift_reg0[0];
always @ (negedge SC_CLK[1]) maroc_sc_out1 <= maroc_shift_reg1[0];
always @ (negedge SC_CLK[2]) maroc_sc_out2 <= maroc_shift_reg2[0];
always @ (negedge SC_CLK[3]) maroc_sc_out3 <= maroc_shift_reg3[0];

assign SC_DIN[0] = maroc_sc_out0;
assign SC_DIN[1] = maroc_sc_out1;
assign SC_DIN[2] = maroc_sc_out2;
assign SC_DIN[3] = maroc_sc_out3;

reg clk;
reg axi_reset;
	maroc_slow_control_v1_0 UUT(
    .SC_DOUT(SC_DOUT),
    .SC_RSTb(SC_RSTb),
    .SC_CLK(SC_CLK),
    .SC_DIN(SC_DIN),
	.s00_axi_aclk(clk),
    .s00_axi_aresetn(!axi_reset)
    );

//100MHz axi clock
   always begin
   clk = 1'b0;
   #(5.0) clk = 1'b1;
   #(5.0);

end

integer setup_file; // file handler
integer scan_file;    //
reg [31:0] sample_val; //value read from the file

initial begin
setup_file = $fopen("setup_file.dat", "r");
    if (setup_file == 0) begin
        $display("setup_file handle was NULL");
        $finish;
    end

axi_reset = 1;
#101;
axi_reset = 0;
//Pulse the module reset
#100;
UUT.maroc_slow_control_v1_0_S00_AXI_inst.slv_reg2[0] = 1'b1;
#100;
UUT.maroc_slow_control_v1_0_S00_AXI_inst.slv_reg2[0] = 1'b0;
//Pulse the maroc reset
#100;
UUT.maroc_slow_control_v1_0_S00_AXI_inst.slv_reg2[1] = 1'b1;
#100;
UUT.maroc_slow_control_v1_0_S00_AXI_inst.slv_reg2[1] = 1'b0;

//Enable all channels
UUT.maroc_slow_control_v1_0_S00_AXI_inst.slv_reg2[7:4] = 4'b1111;
//Load up a bunch of words in the FIFO
    for (ii = 0;  ii < 104;  ii = ii + 1) begin
        scan_file = $fscanf(setup_file, "%x ", sample_val); 
        if (!$feof(setup_file)) begin
            UUT.maroc_slow_control_v1_0_S00_AXI_inst.slv_reg0=sample_val;
        end

        //UUT.maroc_slow_control_v1_0_S00_AXI_inst.slv_reg0 = ii;
        #50;
        UUT.maroc_slow_control_v1_0_S00_AXI_inst.slv_reg2[2] = 1'b1;
        #50;
        UUT.maroc_slow_control_v1_0_S00_AXI_inst.slv_reg2[2] = 1'b0;
        #50;      
    end
    $fclose(setup_file);
    setup_file = $fopen("setup_file.dat", "r");

//Pulse GO
UUT.maroc_slow_control_v1_0_S00_AXI_inst.slv_reg2[8] = 1'b1;
#50;
UUT.maroc_slow_control_v1_0_S00_AXI_inst.slv_reg2[8] = 1'b0;
#50;
//Wait for the stream to finish
#1000000;
//Do it again to test the readback
//Pulse the module reset
#100;
UUT.maroc_slow_control_v1_0_S00_AXI_inst.slv_reg2[0] = 1'b1;
#100;
UUT.maroc_slow_control_v1_0_S00_AXI_inst.slv_reg2[0] = 1'b0;
//Load up a bunch of words in the FIFO
    for (ii = 0;  ii < 104;  ii = ii + 1) begin
        scan_file = $fscanf(setup_file, "%x ", sample_val); 
        if (!$feof(setup_file)) begin
            UUT.maroc_slow_control_v1_0_S00_AXI_inst.slv_reg0<=sample_val;
        end

        //UUT.maroc_slow_control_v1_0_S00_AXI_inst.slv_reg0 = ii;
        #50;
        UUT.maroc_slow_control_v1_0_S00_AXI_inst.slv_reg2[2] = 1'b1;
        #50;
        UUT.maroc_slow_control_v1_0_S00_AXI_inst.slv_reg2[2] = 1'b0;
        #50;      
    end
//Pulse GO
UUT.maroc_slow_control_v1_0_S00_AXI_inst.slv_reg2[8] = 1'b1;
#50;
UUT.maroc_slow_control_v1_0_S00_AXI_inst.slv_reg2[8] = 1'b0;
#50;
//Wait for the stream to finish
#1000000;

//Now pulse the rd_par_data line 108 times to read back the data
    for (ii = 0;  ii < 108;  ii = ii + 1) begin
        UUT.maroc_slow_control_v1_0_S00_AXI_inst.slv_reg2[3] = 1'b1;
        #50;
        UUT.maroc_slow_control_v1_0_S00_AXI_inst.slv_reg2[3] = 1'b0;
        #50;    
    end  
end
endmodule
