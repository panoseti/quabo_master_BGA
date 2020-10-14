`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/13/2018 12:28:42 PM
// Design Name: 
// Module Name : maroc_dc
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
// mmm
//////////////////////////////////////////////////////////////////////////////////


module maroc_dc #(
    //Need to select which version of the Maroc we have: 0 = QFP, 1 = BGA
    parameter REMAP_FOR_BGA = 0)
(
    //System clocks and reset
    input axi_clk,
    input hs_clk,  //sync to axi_clk
    input ref_clk, //200MHz for IBUFDELAY
    input axi_areset_n,
    //from the MAROC chips
    input [255:0] maroc_trig,
    input [7:0] or_trig,
    output [3:0] hold1,
    output [3:0] hold2,
    output [3:0] CK_R,
    output [3:0] RSTB_R,
    output [3:0] D_R,
    
    //from the charge ADC
    input [3:0] adc_din,
    input bit_clk,
    input frm_clk,
    output adc_clk_out,
    //from the other quadrants
    input ext_trig,
    //Software trigger for the PH mode, so we can stop at a specific channel for monitor selection
    input sw_trig,
    //Signal to inhibit writing of data, to permit exercising control signals without having to read data from FIFO
    input inhibit_PH_write, 
    //parameters from the AXI interface
    input [264:0] mask,
    input [15:0] frame_interval,
    input [7:0] hold1_delay,
    input [7:0] hold2_delay,
    input [6:0] ph_stop_channel,
    input counter_reset,
    input [1:0] mode_enable, //00 for none, 01 for PH, 10 for IM, 11 for both
    input [3:0] adc_clk_phase_sel,
    //AXI-stream data interface for image mode
    output [31:0] image_m_axis_data,
    output image_m_axis_tvalid,
    output image_m_axis_tlast,
    input image_m_axis_tready,
    //AXI-stream data interface for pulsheight mode
    output [31:0] ph_m_axis_data,
    output ph_m_axis_tvalid,
    output ph_m_axis_tlast,
    input ph_m_axis_tready,
    //from the elapsed time module
    input ET_clk,
    input ET_clk_1,
    input ET_clk_2,
    input ET_clk_3,
    input [28:0] elapsed_time_0,
    input [28:0] elapsed_time_1,
    input [28:0] elapsed_time_2,
    input [28:0] elapsed_time_3,
    input one_pps,
    //Can connect to testpoints
    output [5:0] testpoint
    );

    localparam NUM_CHANNELS = 256;       //Maybe use this to speed compile when developing
    
    //Need to remap the triggers to match the actual PCB connections
    localparam REMAP_TRIGS = 1;
    //And need to select which version of the Maroc we have: 0 = QFP, 1 = BGA
    wire [255:0] maroc_trig_remapped;
    genvar gg;
    generate
       if ((REMAP_TRIGS==1) && (REMAP_FOR_BGA == 0)) begin: remap_qfp

            assign maroc_trig_remapped[0]=maroc_trig[113];
            assign maroc_trig_remapped[1]=maroc_trig[114];
            assign maroc_trig_remapped[2]=maroc_trig[117];
            assign maroc_trig_remapped[3]=maroc_trig[118];
            assign maroc_trig_remapped[4]=maroc_trig[121];
            assign maroc_trig_remapped[5]=maroc_trig[122];
            assign maroc_trig_remapped[6]=maroc_trig[125];
            assign maroc_trig_remapped[7]=maroc_trig[126];
            assign maroc_trig_remapped[8]=maroc_trig[1];
            assign maroc_trig_remapped[9]=maroc_trig[2];
            assign maroc_trig_remapped[10]=maroc_trig[5];
            assign maroc_trig_remapped[11]=maroc_trig[6];
            assign maroc_trig_remapped[12]=maroc_trig[9];
            assign maroc_trig_remapped[13]=maroc_trig[10];
            assign maroc_trig_remapped[14]=maroc_trig[13];
            assign maroc_trig_remapped[15]=maroc_trig[14];
            assign maroc_trig_remapped[16]=maroc_trig[112];
            assign maroc_trig_remapped[17]=maroc_trig[115];
            assign maroc_trig_remapped[18]=maroc_trig[116];
            assign maroc_trig_remapped[19]=maroc_trig[119];
            assign maroc_trig_remapped[20]=maroc_trig[120];
            assign maroc_trig_remapped[21]=maroc_trig[123];
            assign maroc_trig_remapped[22]=maroc_trig[124];
            assign maroc_trig_remapped[23]=maroc_trig[127];
            assign maroc_trig_remapped[24]=maroc_trig[0];
            assign maroc_trig_remapped[25]=maroc_trig[3];
            assign maroc_trig_remapped[26]=maroc_trig[4];
            assign maroc_trig_remapped[27]=maroc_trig[7];
            assign maroc_trig_remapped[28]=maroc_trig[8];
            assign maroc_trig_remapped[29]=maroc_trig[11];
            assign maroc_trig_remapped[30]=maroc_trig[12];
            assign maroc_trig_remapped[31]=maroc_trig[15];
            assign maroc_trig_remapped[32]=maroc_trig[96];
            assign maroc_trig_remapped[33]=maroc_trig[99];
            assign maroc_trig_remapped[34]=maroc_trig[100];
            assign maroc_trig_remapped[35]=maroc_trig[103];
            assign maroc_trig_remapped[36]=maroc_trig[104];
            assign maroc_trig_remapped[37]=maroc_trig[107];
            assign maroc_trig_remapped[38]=maroc_trig[108];
            assign maroc_trig_remapped[39]=maroc_trig[111];
            assign maroc_trig_remapped[40]=maroc_trig[16];
            assign maroc_trig_remapped[41]=maroc_trig[19];
            assign maroc_trig_remapped[42]=maroc_trig[20];
            assign maroc_trig_remapped[43]=maroc_trig[23];
            assign maroc_trig_remapped[44]=maroc_trig[24];
            assign maroc_trig_remapped[45]=maroc_trig[27];
            assign maroc_trig_remapped[46]=maroc_trig[28];
            assign maroc_trig_remapped[47]=maroc_trig[31];
            assign maroc_trig_remapped[48]=maroc_trig[97];
            assign maroc_trig_remapped[49]=maroc_trig[98];
            assign maroc_trig_remapped[50]=maroc_trig[101];
            assign maroc_trig_remapped[51]=maroc_trig[102];
            assign maroc_trig_remapped[52]=maroc_trig[105];
            assign maroc_trig_remapped[53]=maroc_trig[106];
            assign maroc_trig_remapped[54]=maroc_trig[109];
            assign maroc_trig_remapped[55]=maroc_trig[110];
            assign maroc_trig_remapped[56]=maroc_trig[17];
            assign maroc_trig_remapped[57]=maroc_trig[18];
            assign maroc_trig_remapped[58]=maroc_trig[21];
            assign maroc_trig_remapped[59]=maroc_trig[22];
            assign maroc_trig_remapped[60]=maroc_trig[25];
            assign maroc_trig_remapped[61]=maroc_trig[26];
            assign maroc_trig_remapped[62]=maroc_trig[29];
            assign maroc_trig_remapped[63]=maroc_trig[30];
            assign maroc_trig_remapped[64]=maroc_trig[81];
            assign maroc_trig_remapped[65]=maroc_trig[82];
            assign maroc_trig_remapped[66]=maroc_trig[85];
            assign maroc_trig_remapped[67]=maroc_trig[86];
            assign maroc_trig_remapped[68]=maroc_trig[89];
            assign maroc_trig_remapped[69]=maroc_trig[90];
            assign maroc_trig_remapped[70]=maroc_trig[93];
            assign maroc_trig_remapped[71]=maroc_trig[94];
            assign maroc_trig_remapped[72]=maroc_trig[33];
            assign maroc_trig_remapped[73]=maroc_trig[34];
            assign maroc_trig_remapped[74]=maroc_trig[37];
            assign maroc_trig_remapped[75]=maroc_trig[38];
            assign maroc_trig_remapped[76]=maroc_trig[41];
            assign maroc_trig_remapped[77]=maroc_trig[42];
            assign maroc_trig_remapped[78]=maroc_trig[45];
            assign maroc_trig_remapped[79]=maroc_trig[46];
            assign maroc_trig_remapped[80]=maroc_trig[80];
            assign maroc_trig_remapped[81]=maroc_trig[83];
            assign maroc_trig_remapped[82]=maroc_trig[84];
            assign maroc_trig_remapped[83]=maroc_trig[87];
            assign maroc_trig_remapped[84]=maroc_trig[88];
            assign maroc_trig_remapped[85]=maroc_trig[91];
            assign maroc_trig_remapped[86]=maroc_trig[92];
            assign maroc_trig_remapped[87]=maroc_trig[95];
            assign maroc_trig_remapped[88]=maroc_trig[32];
            assign maroc_trig_remapped[89]=maroc_trig[35];
            assign maroc_trig_remapped[90]=maroc_trig[36];
            assign maroc_trig_remapped[91]=maroc_trig[39];
            assign maroc_trig_remapped[92]=maroc_trig[40];
            assign maroc_trig_remapped[93]=maroc_trig[43];
            assign maroc_trig_remapped[94]=maroc_trig[44];
            assign maroc_trig_remapped[95]=maroc_trig[47];
            assign maroc_trig_remapped[96]=maroc_trig[64];
            assign maroc_trig_remapped[97]=maroc_trig[67];
            assign maroc_trig_remapped[98]=maroc_trig[68];
            assign maroc_trig_remapped[99]=maroc_trig[71];
            assign maroc_trig_remapped[100]=maroc_trig[72];
            assign maroc_trig_remapped[101]=maroc_trig[75];
            assign maroc_trig_remapped[102]=maroc_trig[76];
            assign maroc_trig_remapped[103]=maroc_trig[79];
            assign maroc_trig_remapped[104]=maroc_trig[48];
            assign maroc_trig_remapped[105]=maroc_trig[51];
            assign maroc_trig_remapped[106]=maroc_trig[52];
            assign maroc_trig_remapped[107]=maroc_trig[55];
            assign maroc_trig_remapped[108]=maroc_trig[56];
            assign maroc_trig_remapped[109]=maroc_trig[59];
            assign maroc_trig_remapped[110]=maroc_trig[60];
            assign maroc_trig_remapped[111]=maroc_trig[63];
            assign maroc_trig_remapped[112]=maroc_trig[65];
            assign maroc_trig_remapped[113]=maroc_trig[66];
            assign maroc_trig_remapped[114]=maroc_trig[69];
            assign maroc_trig_remapped[115]=maroc_trig[70];
            assign maroc_trig_remapped[116]=maroc_trig[73];
            assign maroc_trig_remapped[117]=maroc_trig[74];
            assign maroc_trig_remapped[118]=maroc_trig[77];
            assign maroc_trig_remapped[119]=maroc_trig[78];
            assign maroc_trig_remapped[120]=maroc_trig[49];
            assign maroc_trig_remapped[121]=maroc_trig[50];
            assign maroc_trig_remapped[122]=maroc_trig[53];
            assign maroc_trig_remapped[123]=maroc_trig[54];
            assign maroc_trig_remapped[124]=maroc_trig[57];
            assign maroc_trig_remapped[125]=maroc_trig[58];
            assign maroc_trig_remapped[126]=maroc_trig[61];
            assign maroc_trig_remapped[127]=maroc_trig[62];
            assign maroc_trig_remapped[128]=maroc_trig[143];
            assign maroc_trig_remapped[129]=maroc_trig[142];
            assign maroc_trig_remapped[130]=maroc_trig[158];
            assign maroc_trig_remapped[131]=maroc_trig[159];
            assign maroc_trig_remapped[132]=maroc_trig[175];
            assign maroc_trig_remapped[133]=maroc_trig[174];
            assign maroc_trig_remapped[134]=maroc_trig[190];
            assign maroc_trig_remapped[135]=maroc_trig[191];
            assign maroc_trig_remapped[136]=maroc_trig[255];
            assign maroc_trig_remapped[137]=maroc_trig[254];
            assign maroc_trig_remapped[138]=maroc_trig[238];
            assign maroc_trig_remapped[139]=maroc_trig[239];
            assign maroc_trig_remapped[140]=maroc_trig[223];
            assign maroc_trig_remapped[141]=maroc_trig[222];
            assign maroc_trig_remapped[142]=maroc_trig[206];
            assign maroc_trig_remapped[143]=maroc_trig[207];
            assign maroc_trig_remapped[144]=maroc_trig[140];
            assign maroc_trig_remapped[145]=maroc_trig[141];
            assign maroc_trig_remapped[146]=maroc_trig[157];
            assign maroc_trig_remapped[147]=maroc_trig[156];
            assign maroc_trig_remapped[148]=maroc_trig[172];
            assign maroc_trig_remapped[149]=maroc_trig[173];
            assign maroc_trig_remapped[150]=maroc_trig[189];
            assign maroc_trig_remapped[151]=maroc_trig[188];
            assign maroc_trig_remapped[152]=maroc_trig[252];
            assign maroc_trig_remapped[153]=maroc_trig[253];
            assign maroc_trig_remapped[154]=maroc_trig[237];
            assign maroc_trig_remapped[155]=maroc_trig[236];
            assign maroc_trig_remapped[156]=maroc_trig[220];
            assign maroc_trig_remapped[157]=maroc_trig[221];
            assign maroc_trig_remapped[158]=maroc_trig[205];
            assign maroc_trig_remapped[159]=maroc_trig[204];
            assign maroc_trig_remapped[160]=maroc_trig[139];
            assign maroc_trig_remapped[161]=maroc_trig[138];
            assign maroc_trig_remapped[162]=maroc_trig[154];
            assign maroc_trig_remapped[163]=maroc_trig[155];
            assign maroc_trig_remapped[164]=maroc_trig[171];
            assign maroc_trig_remapped[165]=maroc_trig[170];
            assign maroc_trig_remapped[166]=maroc_trig[186];
            assign maroc_trig_remapped[167]=maroc_trig[187];
            assign maroc_trig_remapped[168]=maroc_trig[251];
            assign maroc_trig_remapped[169]=maroc_trig[250];
            assign maroc_trig_remapped[170]=maroc_trig[234];
            assign maroc_trig_remapped[171]=maroc_trig[235];
            assign maroc_trig_remapped[172]=maroc_trig[219];
            assign maroc_trig_remapped[173]=maroc_trig[218];
            assign maroc_trig_remapped[174]=maroc_trig[202];
            assign maroc_trig_remapped[175]=maroc_trig[203];
            assign maroc_trig_remapped[176]=maroc_trig[136];
            assign maroc_trig_remapped[177]=maroc_trig[137];
            assign maroc_trig_remapped[178]=maroc_trig[153];
            assign maroc_trig_remapped[179]=maroc_trig[152];
            assign maroc_trig_remapped[180]=maroc_trig[168];
            assign maroc_trig_remapped[181]=maroc_trig[169];
            assign maroc_trig_remapped[182]=maroc_trig[185];
            assign maroc_trig_remapped[183]=maroc_trig[184];
            assign maroc_trig_remapped[184]=maroc_trig[248];
            assign maroc_trig_remapped[185]=maroc_trig[249];
            assign maroc_trig_remapped[186]=maroc_trig[233];
            assign maroc_trig_remapped[187]=maroc_trig[232];
            assign maroc_trig_remapped[188]=maroc_trig[216];
            assign maroc_trig_remapped[189]=maroc_trig[217];
            assign maroc_trig_remapped[190]=maroc_trig[201];
            assign maroc_trig_remapped[191]=maroc_trig[200];
            assign maroc_trig_remapped[192]=maroc_trig[135];
            assign maroc_trig_remapped[193]=maroc_trig[134];
            assign maroc_trig_remapped[194]=maroc_trig[150];
            assign maroc_trig_remapped[195]=maroc_trig[151];
            assign maroc_trig_remapped[196]=maroc_trig[167];
            assign maroc_trig_remapped[197]=maroc_trig[166];
            assign maroc_trig_remapped[198]=maroc_trig[182];
            assign maroc_trig_remapped[199]=maroc_trig[183];
            assign maroc_trig_remapped[200]=maroc_trig[247];
            assign maroc_trig_remapped[201]=maroc_trig[246];
            assign maroc_trig_remapped[202]=maroc_trig[230];
            assign maroc_trig_remapped[203]=maroc_trig[231];
            assign maroc_trig_remapped[204]=maroc_trig[215];
            assign maroc_trig_remapped[205]=maroc_trig[214];
            assign maroc_trig_remapped[206]=maroc_trig[198];
            assign maroc_trig_remapped[207]=maroc_trig[199];
            assign maroc_trig_remapped[208]=maroc_trig[132];
            assign maroc_trig_remapped[209]=maroc_trig[133];
            assign maroc_trig_remapped[210]=maroc_trig[149];
            assign maroc_trig_remapped[211]=maroc_trig[148];
            assign maroc_trig_remapped[212]=maroc_trig[164];
            assign maroc_trig_remapped[213]=maroc_trig[165];
            assign maroc_trig_remapped[214]=maroc_trig[181];
            assign maroc_trig_remapped[215]=maroc_trig[180];
            assign maroc_trig_remapped[216]=maroc_trig[244];
            assign maroc_trig_remapped[217]=maroc_trig[245];
            assign maroc_trig_remapped[218]=maroc_trig[229];
            assign maroc_trig_remapped[219]=maroc_trig[228];
            assign maroc_trig_remapped[220]=maroc_trig[212];
            assign maroc_trig_remapped[221]=maroc_trig[213];
            assign maroc_trig_remapped[222]=maroc_trig[197];
            assign maroc_trig_remapped[223]=maroc_trig[196];
            assign maroc_trig_remapped[224]=maroc_trig[131];
            assign maroc_trig_remapped[225]=maroc_trig[130];
            assign maroc_trig_remapped[226]=maroc_trig[146];
            assign maroc_trig_remapped[227]=maroc_trig[147];
            assign maroc_trig_remapped[228]=maroc_trig[163];
            assign maroc_trig_remapped[229]=maroc_trig[162];
            assign maroc_trig_remapped[230]=maroc_trig[178];
            assign maroc_trig_remapped[231]=maroc_trig[179];
            assign maroc_trig_remapped[232]=maroc_trig[243];
            assign maroc_trig_remapped[233]=maroc_trig[242];
            assign maroc_trig_remapped[234]=maroc_trig[226];
            assign maroc_trig_remapped[235]=maroc_trig[227];
            assign maroc_trig_remapped[236]=maroc_trig[211];
            assign maroc_trig_remapped[237]=maroc_trig[210];
            assign maroc_trig_remapped[238]=maroc_trig[194];
            assign maroc_trig_remapped[239]=maroc_trig[195];
            assign maroc_trig_remapped[240]=maroc_trig[128];
            assign maroc_trig_remapped[241]=maroc_trig[129];
            assign maroc_trig_remapped[242]=maroc_trig[145];
            assign maroc_trig_remapped[243]=maroc_trig[144];
            assign maroc_trig_remapped[244]=maroc_trig[160];
            assign maroc_trig_remapped[245]=maroc_trig[161];
            assign maroc_trig_remapped[246]=maroc_trig[177];
            assign maroc_trig_remapped[247]=maroc_trig[176];
            assign maroc_trig_remapped[248]=maroc_trig[240];
            assign maroc_trig_remapped[249]=maroc_trig[241];
            assign maroc_trig_remapped[250]=maroc_trig[225];
            assign maroc_trig_remapped[251]=maroc_trig[224];
            assign maroc_trig_remapped[252]=maroc_trig[208];
            assign maroc_trig_remapped[253]=maroc_trig[209];
            assign maroc_trig_remapped[254]=maroc_trig[193];
            assign maroc_trig_remapped[255]=maroc_trig[192];
       end
       else if ((REMAP_TRIGS==1) && (REMAP_FOR_BGA == 1)) begin: remap_bga
                assign maroc_trig_remapped[0]=maroc_trig[82];
                assign maroc_trig_remapped[1]=maroc_trig[83];
                assign maroc_trig_remapped[2]=maroc_trig[86];
                assign maroc_trig_remapped[3]=maroc_trig[88];
                assign maroc_trig_remapped[4]=maroc_trig[91];
                assign maroc_trig_remapped[5]=maroc_trig[92];
                assign maroc_trig_remapped[6]=maroc_trig[126];
                assign maroc_trig_remapped[7]=maroc_trig[94];
                assign maroc_trig_remapped[8]=maroc_trig[1];
                assign maroc_trig_remapped[9]=maroc_trig[2];
                assign maroc_trig_remapped[10]=maroc_trig[5];
                assign maroc_trig_remapped[11]=maroc_trig[6];
                assign maroc_trig_remapped[12]=maroc_trig[9];
                assign maroc_trig_remapped[13]=maroc_trig[10];
                assign maroc_trig_remapped[14]=maroc_trig[13];
                assign maroc_trig_remapped[15]=maroc_trig[14];
                assign maroc_trig_remapped[16]=maroc_trig[84];
                assign maroc_trig_remapped[17]=maroc_trig[85];
                assign maroc_trig_remapped[18]=maroc_trig[87];
                assign maroc_trig_remapped[19]=maroc_trig[89];
                assign maroc_trig_remapped[20]=maroc_trig[90];
                assign maroc_trig_remapped[21]=maroc_trig[93];
                assign maroc_trig_remapped[22]=maroc_trig[127];
                assign maroc_trig_remapped[23]=maroc_trig[95];
                assign maroc_trig_remapped[24]=maroc_trig[0];
                assign maroc_trig_remapped[25]=maroc_trig[3];
                assign maroc_trig_remapped[26]=maroc_trig[4];
                assign maroc_trig_remapped[27]=maroc_trig[7];
                assign maroc_trig_remapped[28]=maroc_trig[8];
                assign maroc_trig_remapped[29]=maroc_trig[11];
                assign maroc_trig_remapped[30]=maroc_trig[12];
                assign maroc_trig_remapped[31]=maroc_trig[15];
                assign maroc_trig_remapped[32]=maroc_trig[65];
                assign maroc_trig_remapped[33]=maroc_trig[67];
                assign maroc_trig_remapped[34]=maroc_trig[68];
                assign maroc_trig_remapped[35]=maroc_trig[72];
                assign maroc_trig_remapped[36]=maroc_trig[73];
                assign maroc_trig_remapped[37]=maroc_trig[78];
                assign maroc_trig_remapped[38]=maroc_trig[77];
                assign maroc_trig_remapped[39]=maroc_trig[80];
                assign maroc_trig_remapped[40]=maroc_trig[16];
                assign maroc_trig_remapped[41]=maroc_trig[19];
                assign maroc_trig_remapped[42]=maroc_trig[20];
                assign maroc_trig_remapped[43]=maroc_trig[23];
                assign maroc_trig_remapped[44]=maroc_trig[24];
                assign maroc_trig_remapped[45]=maroc_trig[27];
                assign maroc_trig_remapped[46]=maroc_trig[28];
                assign maroc_trig_remapped[47]=maroc_trig[31];
                assign maroc_trig_remapped[48]=maroc_trig[66];
                assign maroc_trig_remapped[49]=maroc_trig[69];
                assign maroc_trig_remapped[50]=maroc_trig[70];
                assign maroc_trig_remapped[51]=maroc_trig[71];
                assign maroc_trig_remapped[52]=maroc_trig[74];
                assign maroc_trig_remapped[53]=maroc_trig[76];
                assign maroc_trig_remapped[54]=maroc_trig[79];
                assign maroc_trig_remapped[55]=maroc_trig[81];
                assign maroc_trig_remapped[56]=maroc_trig[17];
                assign maroc_trig_remapped[57]=maroc_trig[18];
                assign maroc_trig_remapped[58]=maroc_trig[21];
                assign maroc_trig_remapped[59]=maroc_trig[22];
                assign maroc_trig_remapped[60]=maroc_trig[25];
                assign maroc_trig_remapped[61]=maroc_trig[26];
                assign maroc_trig_remapped[62]=maroc_trig[29];
                assign maroc_trig_remapped[63]=maroc_trig[30];
                assign maroc_trig_remapped[64]=maroc_trig[112];
                assign maroc_trig_remapped[65]=maroc_trig[113];
                assign maroc_trig_remapped[66]=maroc_trig[116];
                assign maroc_trig_remapped[67]=maroc_trig[75];
                assign maroc_trig_remapped[68]=maroc_trig[118];
                assign maroc_trig_remapped[69]=maroc_trig[119];
                assign maroc_trig_remapped[70]=maroc_trig[125];
                assign maroc_trig_remapped[71]=maroc_trig[122];
                assign maroc_trig_remapped[72]=maroc_trig[33];
                assign maroc_trig_remapped[73]=maroc_trig[34];
                assign maroc_trig_remapped[74]=maroc_trig[37];
                assign maroc_trig_remapped[75]=maroc_trig[38];
                assign maroc_trig_remapped[76]=maroc_trig[41];
                assign maroc_trig_remapped[77]=maroc_trig[42];
                assign maroc_trig_remapped[78]=maroc_trig[45];
                assign maroc_trig_remapped[79]=maroc_trig[46];
                assign maroc_trig_remapped[80]=maroc_trig[114];
                assign maroc_trig_remapped[81]=maroc_trig[117];
                assign maroc_trig_remapped[82]=maroc_trig[115];
                assign maroc_trig_remapped[83]=maroc_trig[121];
                assign maroc_trig_remapped[84]=maroc_trig[120];
                assign maroc_trig_remapped[85]=maroc_trig[123];
                assign maroc_trig_remapped[86]=maroc_trig[124];
                assign maroc_trig_remapped[87]=maroc_trig[64];
                assign maroc_trig_remapped[88]=maroc_trig[32];
                assign maroc_trig_remapped[89]=maroc_trig[35];
                assign maroc_trig_remapped[90]=maroc_trig[36];
                assign maroc_trig_remapped[91]=maroc_trig[39];
                assign maroc_trig_remapped[92]=maroc_trig[40];
                assign maroc_trig_remapped[93]=maroc_trig[43];
                assign maroc_trig_remapped[94]=maroc_trig[44];
                assign maroc_trig_remapped[95]=maroc_trig[47];
                assign maroc_trig_remapped[96]=maroc_trig[99];
                assign maroc_trig_remapped[97]=maroc_trig[100];
                assign maroc_trig_remapped[98]=maroc_trig[97];
                assign maroc_trig_remapped[99]=maroc_trig[103];
                assign maroc_trig_remapped[100]=maroc_trig[104];
                assign maroc_trig_remapped[101]=maroc_trig[106];
                assign maroc_trig_remapped[102]=maroc_trig[108];
                assign maroc_trig_remapped[103]=maroc_trig[110];
                assign maroc_trig_remapped[104]=maroc_trig[48];
                assign maroc_trig_remapped[105]=maroc_trig[51];
                assign maroc_trig_remapped[106]=maroc_trig[52];
                assign maroc_trig_remapped[107]=maroc_trig[55];
                assign maroc_trig_remapped[108]=maroc_trig[56];
                assign maroc_trig_remapped[109]=maroc_trig[59];
                assign maroc_trig_remapped[110]=maroc_trig[60];
                assign maroc_trig_remapped[111]=maroc_trig[63];
                assign maroc_trig_remapped[112]=maroc_trig[98];
                assign maroc_trig_remapped[113]=maroc_trig[96];
                assign maroc_trig_remapped[114]=maroc_trig[101];
                assign maroc_trig_remapped[115]=maroc_trig[102];
                assign maroc_trig_remapped[116]=maroc_trig[105];
                assign maroc_trig_remapped[117]=maroc_trig[107];
                assign maroc_trig_remapped[118]=maroc_trig[111];
                assign maroc_trig_remapped[119]=maroc_trig[109];
                assign maroc_trig_remapped[120]=maroc_trig[49];
                assign maroc_trig_remapped[121]=maroc_trig[50];
                assign maroc_trig_remapped[122]=maroc_trig[53];
                assign maroc_trig_remapped[123]=maroc_trig[54];
                assign maroc_trig_remapped[124]=maroc_trig[57];
                assign maroc_trig_remapped[125]=maroc_trig[58];
                assign maroc_trig_remapped[126]=maroc_trig[61];
                assign maroc_trig_remapped[127]=maroc_trig[62];
                assign maroc_trig_remapped[128]=maroc_trig[143];
                assign maroc_trig_remapped[129]=maroc_trig[142];
                assign maroc_trig_remapped[130]=maroc_trig[158];
                assign maroc_trig_remapped[131]=maroc_trig[159];
                assign maroc_trig_remapped[132]=maroc_trig[175];
                assign maroc_trig_remapped[133]=maroc_trig[174];
                assign maroc_trig_remapped[134]=maroc_trig[190];
                assign maroc_trig_remapped[135]=maroc_trig[191];
                assign maroc_trig_remapped[136]=maroc_trig[223];
                assign maroc_trig_remapped[137]=maroc_trig[222];
                assign maroc_trig_remapped[138]=maroc_trig[209];
                assign maroc_trig_remapped[139]=maroc_trig[208];
                assign maroc_trig_remapped[140]=maroc_trig[192];
                assign maroc_trig_remapped[141]=maroc_trig[250];
                assign maroc_trig_remapped[142]=maroc_trig[237];
                assign maroc_trig_remapped[143]=maroc_trig[238];
                assign maroc_trig_remapped[144]=maroc_trig[140];
                assign maroc_trig_remapped[145]=maroc_trig[141];
                assign maroc_trig_remapped[146]=maroc_trig[157];
                assign maroc_trig_remapped[147]=maroc_trig[156];
                assign maroc_trig_remapped[148]=maroc_trig[172];
                assign maroc_trig_remapped[149]=maroc_trig[173];
                assign maroc_trig_remapped[150]=maroc_trig[189];
                assign maroc_trig_remapped[151]=maroc_trig[188];
                assign maroc_trig_remapped[152]=maroc_trig[255];
                assign maroc_trig_remapped[153]=maroc_trig[254];
                assign maroc_trig_remapped[154]=maroc_trig[207];
                assign maroc_trig_remapped[155]=maroc_trig[205];
                assign maroc_trig_remapped[156]=maroc_trig[252];
                assign maroc_trig_remapped[157]=maroc_trig[253];
                assign maroc_trig_remapped[158]=maroc_trig[239];
                assign maroc_trig_remapped[159]=maroc_trig[235];
                assign maroc_trig_remapped[160]=maroc_trig[139];
                assign maroc_trig_remapped[161]=maroc_trig[138];
                assign maroc_trig_remapped[162]=maroc_trig[154];
                assign maroc_trig_remapped[163]=maroc_trig[155];
                assign maroc_trig_remapped[164]=maroc_trig[171];
                assign maroc_trig_remapped[165]=maroc_trig[170];
                assign maroc_trig_remapped[166]=maroc_trig[186];
                assign maroc_trig_remapped[167]=maroc_trig[187];
                assign maroc_trig_remapped[168]=maroc_trig[221];
                assign maroc_trig_remapped[169]=maroc_trig[220];
                assign maroc_trig_remapped[170]=maroc_trig[204];
                assign maroc_trig_remapped[171]=maroc_trig[206];
                assign maroc_trig_remapped[172]=maroc_trig[251];
                assign maroc_trig_remapped[173]=maroc_trig[247];
                assign maroc_trig_remapped[174]=maroc_trig[236];
                assign maroc_trig_remapped[175]=maroc_trig[234];
                assign maroc_trig_remapped[176]=maroc_trig[136];
                assign maroc_trig_remapped[177]=maroc_trig[137];
                assign maroc_trig_remapped[178]=maroc_trig[153];
                assign maroc_trig_remapped[179]=maroc_trig[152];
                assign maroc_trig_remapped[180]=maroc_trig[168];
                assign maroc_trig_remapped[181]=maroc_trig[169];
                assign maroc_trig_remapped[182]=maroc_trig[185];
                assign maroc_trig_remapped[183]=maroc_trig[184];
                assign maroc_trig_remapped[184]=maroc_trig[218];
                assign maroc_trig_remapped[185]=maroc_trig[219];
                assign maroc_trig_remapped[186]=maroc_trig[202];
                assign maroc_trig_remapped[187]=maroc_trig[201];
                assign maroc_trig_remapped[188]=maroc_trig[248];
                assign maroc_trig_remapped[189]=maroc_trig[246];
                assign maroc_trig_remapped[190]=maroc_trig[233];
                assign maroc_trig_remapped[191]=maroc_trig[232];
                assign maroc_trig_remapped[192]=maroc_trig[135];
                assign maroc_trig_remapped[193]=maroc_trig[134];
                assign maroc_trig_remapped[194]=maroc_trig[150];
                assign maroc_trig_remapped[195]=maroc_trig[151];
                assign maroc_trig_remapped[196]=maroc_trig[167];
                assign maroc_trig_remapped[197]=maroc_trig[166];
                assign maroc_trig_remapped[198]=maroc_trig[182];
                assign maroc_trig_remapped[199]=maroc_trig[183];
                assign maroc_trig_remapped[200]=maroc_trig[217];
                assign maroc_trig_remapped[201]=maroc_trig[216];
                assign maroc_trig_remapped[202]=maroc_trig[199];
                assign maroc_trig_remapped[203]=maroc_trig[200];
                assign maroc_trig_remapped[204]=maroc_trig[249];
                assign maroc_trig_remapped[205]=maroc_trig[203];
                assign maroc_trig_remapped[206]=maroc_trig[230];
                assign maroc_trig_remapped[207]=maroc_trig[231];
                assign maroc_trig_remapped[208]=maroc_trig[132];
                assign maroc_trig_remapped[209]=maroc_trig[133];
                assign maroc_trig_remapped[210]=maroc_trig[149];
                assign maroc_trig_remapped[211]=maroc_trig[148];
                assign maroc_trig_remapped[212]=maroc_trig[164];
                assign maroc_trig_remapped[213]=maroc_trig[165];
                assign maroc_trig_remapped[214]=maroc_trig[181];
                assign maroc_trig_remapped[215]=maroc_trig[180];
                assign maroc_trig_remapped[216]=maroc_trig[215];
                assign maroc_trig_remapped[217]=maroc_trig[214];
                assign maroc_trig_remapped[218]=maroc_trig[198];
                assign maroc_trig_remapped[219]=maroc_trig[196];
                assign maroc_trig_remapped[220]=maroc_trig[243];
                assign maroc_trig_remapped[221]=maroc_trig[244];
                assign maroc_trig_remapped[222]=maroc_trig[229];
                assign maroc_trig_remapped[223]=maroc_trig[225];
                assign maroc_trig_remapped[224]=maroc_trig[131];
                assign maroc_trig_remapped[225]=maroc_trig[130];
                assign maroc_trig_remapped[226]=maroc_trig[146];
                assign maroc_trig_remapped[227]=maroc_trig[147];
                assign maroc_trig_remapped[228]=maroc_trig[163];
                assign maroc_trig_remapped[229]=maroc_trig[162];
                assign maroc_trig_remapped[230]=maroc_trig[178];
                assign maroc_trig_remapped[231]=maroc_trig[179];
                assign maroc_trig_remapped[232]=maroc_trig[213];
                assign maroc_trig_remapped[233]=maroc_trig[211];
                assign maroc_trig_remapped[234]=maroc_trig[197];
                assign maroc_trig_remapped[235]=maroc_trig[195];
                assign maroc_trig_remapped[236]=maroc_trig[245];
                assign maroc_trig_remapped[237]=maroc_trig[241];
                assign maroc_trig_remapped[238]=maroc_trig[224];
                assign maroc_trig_remapped[239]=maroc_trig[228];
                assign maroc_trig_remapped[240]=maroc_trig[128];
                assign maroc_trig_remapped[241]=maroc_trig[129];
                assign maroc_trig_remapped[242]=maroc_trig[145];
                assign maroc_trig_remapped[243]=maroc_trig[144];
                assign maroc_trig_remapped[244]=maroc_trig[160];
                assign maroc_trig_remapped[245]=maroc_trig[161];
                assign maroc_trig_remapped[246]=maroc_trig[177];
                assign maroc_trig_remapped[247]=maroc_trig[176];
                assign maroc_trig_remapped[248]=maroc_trig[212];
                assign maroc_trig_remapped[249]=maroc_trig[210];
                assign maroc_trig_remapped[250]=maroc_trig[194];
                assign maroc_trig_remapped[251]=maroc_trig[193];
                assign maroc_trig_remapped[252]=maroc_trig[242];
                assign maroc_trig_remapped[253]=maroc_trig[240];
                assign maroc_trig_remapped[254]=maroc_trig[226];
                assign maroc_trig_remapped[255]=maroc_trig[227];
       end
        else begin: no_remap
          for (gg=0; gg< 256; gg=gg+1) begin
          assign maroc_trig_remapped[gg] = maroc_trig[gg];
          end
       end
    endgenerate

    //register the elapsed time when a trigger occurs
    //All needs to be sync to ET_clk
    wire ET0_load;
    reg [28:0] ET0_held;
    always @ (posedge ET_clk) if (ET0_load) ET0_held <= elapsed_time_0;
    wire ET1_load;
    reg [28:0] ET1_held;
    always @ (posedge ET_clk_1) if (ET1_load) ET1_held <= elapsed_time_1;
    wire ET2_load;
    reg [28:0] ET2_held;
    always @ (posedge ET_clk_2) if (ET2_load) ET2_held <= elapsed_time_2;
    wire ET3_load;
    reg [28:0] ET3_held;
    always @ (posedge ET_clk_3) if (ET3_load) ET3_held <= elapsed_time_3;
    
    //Edge-detect all of the asynch trigger inputs for the IMage mode counters, no need to mask these
    wire [255:0] chan_trig_pulse;
    generate
       for (gg=0; gg < NUM_CHANNELS; gg=gg+1)
       begin: EDGE_DET_CHAN
            async_edge_detect ED(
           .clk(hs_clk),
           .trig_in(maroc_trig_remapped[gg]),
           .trig_out(chan_trig_pulse[gg])
           );
       end
    endgenerate
    /*
    wire [7:0] or_trig_pulse;
    generate
       for (gg=0; gg < 8; gg=gg+1)
       begin: EDGE_DET_OR
            async_edge_detect ED(
           .clk(hs_clk),
           .trig_in(or_trig[gg]),
           .trig_out(or_trig_pulse[gg])
           );
       end
    endgenerate   
    wire ext_trig_pulse;   
      async_edge_detect EDGE_DET_EXT(
     .clk(hs_clk),
     .trig_in(ext_trig),
     .trig_out(ext_trig_pulse)
     );
    
    
    //There are 256 individual channel triggers, 8 or triggers (2 each MAROC), and an external trigger.
    //There's a mask bit for each.  A high mask bit forces that trigger bit inactive
    reg [255:0] masked_chan_trig;
    reg [7:0] masked_or_trig;
    reg masked_ext_trig;
    
    //Register for speed
    always @ (posedge hs_clk) begin
        masked_chan_trig <= chan_trig_pulse & (~mask[255:0]);
        masked_or_trig <= or_trig_pulse & (~mask[263:256]);
        masked_ext_trig <= ext_trig_pulse && (~mask[264]);
    end
    */
    
    //Select any combo for the pulseheight channel
    //(Not sure ORing 256 signals will meet timing...)
    //wire pulseheight_trigger = !inhibit_PH_write && ( |masked_chan_trig || |masked_or_trig || masked_ext_trig);
    
    //OR all of the raw signals together
    wire pulseheight_trigger_raw = |(maroc_trig_remapped & (~mask[255:0])) || |(or_trig& (~mask[263:256])) || (ext_trig && (~mask[264]));
    //Edge-detect the ORed Asynch trigger signal with all four clocks, for the elapsed-time counters
    wire PH_trig_sync0;
            async_edge_detect ED_ET0(
           .clk(ET_clk),
           .trig_in(pulseheight_trigger_raw),
           .trig_out(PH_trig_sync0)
           );
    wire PH_trig_sync1;
            async_edge_detect ED_ET1(
           .clk(ET_clk_1),
           .trig_in(pulseheight_trigger_raw),
           .trig_out(PH_trig_sync1)
           );
    wire PH_trig_sync2;
            async_edge_detect ED_ET2(
           .clk(ET_clk_2),
           .trig_in(pulseheight_trigger_raw),
           .trig_out(PH_trig_sync2)
           );
    wire PH_trig_sync3;
            async_edge_detect ED_ET3(
           .clk(ET_clk_3),
           .trig_in(pulseheight_trigger_raw),
           .trig_out(PH_trig_sync3)
           );
    
    //A counter for each trigger
    parameter COUNTER_BITS = 16;  
    wire [COUNTER_BITS-1:0] im_counter[NUM_CHANNELS-1:0];
    wire hold_count;
    
    //Reset the counters after every read
    reg hold_count_d1;
    always @ (posedge axi_clk) hold_count_d1 <= hold_count;
    wire reset_counters_after_read = !hold_count && hold_count_d1;
    //Sync the reset signal that goes to all the counters
    wire counter_reset_hs_sync;
    sync_it S5 (
    .clk(hs_clk),
    //.din(counter_reset || reset_counters_after_read),
    .din(counter_reset),
    .dout(counter_reset_hs_sync)
    );

    //A bufg to distribute the reset
    wire counter_reset_buf;
    BUFG BUFG_CTR_RST (
       .O(counter_reset_buf), // 1-bit output: Clock output
       .I(counter_reset_hs_sync)  // 1-bit input: Clock input
       //.I(counter_reset || reset_counters_after_read)
    );

    //A bufg to distribute the hold
    wire hold_count_buf;
    BUFG BUFG_CTR_HOLD (
       .O(hold_count_buf), // 1-bit output: Clock output
       .I(hold_count)  // 1-bit input: Clock input
    );

    generate
       for (gg=0; gg < NUM_CHANNELS; gg=gg+1)
       begin: CTR    
        bin_counter 
            BC(
            .pulse_in(chan_trig_pulse[gg]),
            .hold(hold_count_buf),
            .reset(counter_reset_buf),
            .clk(hs_clk),
            .count_out(im_counter[gg])
            );
       end
   endgenerate

    //A big MUX, formed of smaller MUXes, to permit a few clock cycles for propagation
    wire [15:0]mux_level_1_out[15:0];
    wire[15:0] im_mux_out;
    (*KEEP = "TRUE"*)wire [7:0] im_mux_sel;
    generate
       for (gg=0; gg < 16; gg=gg+1)
       begin: IM_MUX    
        MUX_16b_16to1_sync MUX_L(
        .clk(hs_clk),
        .din0(im_counter[16*gg]),
        .din1(im_counter[16*gg+1]),
        .din2(im_counter[16*gg+2]),
        .din3(im_counter[16*gg+3]),
        .din4(im_counter[16*gg+4]),
        .din5(im_counter[16*gg+5]),
        .din6(im_counter[16*gg+6]),
        .din7(im_counter[16*gg+7]),
        .din8(im_counter[16*gg+8]),
        .din9(im_counter[16*gg+9]),
        .din10(im_counter[16*gg+10]),
        .din11(im_counter[16*gg+11]),
        .din12(im_counter[16*gg+12]),
        .din13(im_counter[16*gg+13]),
        .din14(im_counter[16*gg+14]),
        .din15(im_counter[16*gg+15]),
        .sel(im_mux_sel[3:0]),
        .dout(mux_level_1_out[gg])
        );
       end
     endgenerate
    MUX_16b_16to1_sync MUX_H(
     .clk(hs_clk),
     .din0(mux_level_1_out[0]),
     .din1(mux_level_1_out[1]),
     .din2(mux_level_1_out[2]),
     .din3(mux_level_1_out[3]),
     .din4(mux_level_1_out[4]),
     .din5(mux_level_1_out[5]),
     .din6(mux_level_1_out[6]),
     .din7(mux_level_1_out[7]),
     .din8(mux_level_1_out[8]),
     .din9(mux_level_1_out[9]),
     .din10(mux_level_1_out[10]),
     .din11(mux_level_1_out[11]),
     .din12(mux_level_1_out[12]),
     .din13(mux_level_1_out[13]),
     .din14(mux_level_1_out[14]),
     .din15(mux_level_1_out[15]),
     .sel(im_mux_sel[7:4]),
     .dout(im_mux_out)
     );
reg one_pps_reg;
always @(posedge axi_clk)
    begin
        one_pps_reg <= one_pps;
    end
wire pps_rst;
assign pps_rst = one_pps & (~one_pps_reg);
//State machine will sequence through the counter data and pass it along to 
// an AXI stream FIFO
wire image_s_axis_tvalid;
wire image_s_axis_tlast;
wire image_s_axis_tready;
wire [9:0] im_fifo_data_count;
im_mode_state_machine IM_SM(
    .clk(axi_clk),
    .frame_int(frame_interval),
    //.frame_reset(counter_reset_buf || (!mode_enable[1])),
    //.frame_reset(counter_reset || reset_counters_after_read || (!mode_enable[1])),
    .frame_reset((!mode_enable[1]) || pps_rst),
    .first_word(),
    .word_sel(im_mux_sel),
    .hold(hold_count),
    .tvalid(image_s_axis_tvalid),
    .tlast(image_s_axis_tlast),
    .tready(image_s_axis_tready),
    .data_count(im_fifo_data_count)
    );

FIFO_32by512 IMAGE_FIFO (
  .wr_rst_busy(),          // output wire wr_rst_busy
  .rd_rst_busy(),          // output wire rd_rst_busy
  .s_aclk(axi_clk),                    // input wire s_aclk
  .s_aresetn(axi_areset_n),              // input wire s_aresetn
  .s_axis_tvalid(image_s_axis_tvalid),      // input wire s_axis_tvalid
  .s_axis_tready(image_s_axis_tready),      // output wire s_axis_tready
  .s_axis_tlast(image_s_axis_tlast),        // input wire s_axis_tlast
  .s_axis_tdata({16'b0, im_mux_out}),        // input wire [31 : 0] s_axis_tdata
  .m_axis_tvalid(image_m_axis_tvalid),      // output wire m_axis_tvalid
  .m_axis_tready(image_m_axis_tready),      // input wire m_axis_tready
  .m_axis_tlast(image_m_axis_tlast),        // output wire m_axis_tlast
  .m_axis_tdata(image_m_axis_data),        // output wire [31 : 0] m_axis_tdata
  .axis_data_count(im_fifo_data_count)  // output wire [9 : 0] axis_data_count
);

//A BUFH for the local clock
(* dont_touch="true" *)wire bit_clk_local;
   BUFH BUFH_bitclk (
      .O(bit_clk_local), // 1-bit output: Clock output
      .I(bit_clk)  // 1-bit input: Clock input
   );
//A BUFG for the rest
(* dont_touch="true" *)wire bit_clk_bufg;
   BUFG BUFG_bitclk (
      .O(bit_clk_bufg), // 1-bit output: Clock output
      .I(bit_clk)  // 1-bit input: Clock input
   );

//The Pulseheight mode stuff
//Receive the serial data from the QADC
wire [11:0] adc_par_data0;
wire [11:0] adc_par_data1;
wire [11:0] adc_par_data2;
wire [11:0] adc_par_data3;
wire adc_frame;
qdata_rx QDATA_RX(
    .adc_sdin(adc_din),
    .bit_clk(bit_clk_local),
    .frame_clk(frm_clk),
    .ref_clk(ref_clk),
    .adc_par_data0(adc_par_data0),
    .adc_par_data1(adc_par_data1),
    .adc_par_data2(adc_par_data2),
    .adc_par_data3(adc_par_data3),
    .adc_frame(adc_frame),
    .adc_par_dav()
    );

//The adc_frame signal will drive the PH State Machine.  It's sync to bit_clk, but at the
// ADC_CLK freq (10MHz).  Need to sync this to axi_clk
reg adc_frame_axi_sync;
always @ (posedge axi_clk) adc_frame_axi_sync <= adc_frame;

//We also need a pulse one bit_clk wide at the frame rate to write the cc_fifo
reg adc_frame_d1;
wire adc_frame_pulse = adc_frame && ! adc_frame_d1;
always @ (posedge bit_clk_local) adc_frame_d1 <= adc_frame;

//State machine will sequence the control lines to the MAROCs, and write data from the Q ADC to a FIFO 
// an AXI stream FIFO
wire ph_s_axis_tvalid;
wire ph_s_axis_tlast;
wire ph_s_axis_tready;
wire [9:0] ph_fifo_data_count;

//Need to stretch the trigger which is a single ET_clk pulse wide- OR all four phases together, and sync to AXI clock
wire all_PH_trigs = PH_trig_sync0 || PH_trig_sync1 || PH_trig_sync2 || PH_trig_sync3;
wire ph_trig_async;
FDPE #(
.INIT(1'b0) // Initial value of register (1'b0 or 1'b1)
) FDPE_PHTRIG (
.Q(ph_trig_async),      // 1-bit Data output
.C(axi_clk),      // 1-bit Clock input
.CE(1'b1),    // 1-bit Clock enable input
.PRE(all_PH_trigs),  // 1-bit Asynchronous preset input
.D(1'b0)       // 1-bit Data input
);
reg ph_trig_d1;
reg ph_trig_stretched;
reg sw_trig_d1;
always @ (posedge axi_clk) begin
    sw_trig_d1 <= sw_trig;
    ph_trig_d1 <= ph_trig_async;
    ph_trig_stretched <= ph_trig_d1;
end

wire sw_trig_pulse = sw_trig && !sw_trig_d1;
wire ck_r, rstb_r, d_r;
wire reset_hold;
wire reset_cc_fifo;
wire write_ET;
ph_state_machine PH_SM(
   .clk(axi_clk),
   .reset(1'b0),
   .inhibit_write(inhibit_PH_write),
   .trig((mode_enable[0] && ph_trig_stretched) || sw_trig_pulse),
   .stop_chan(ph_stop_channel),
   .adc_frame(adc_frame_axi_sync),
   .fifo_data_count(ph_fifo_data_count),
   .tvalid(ph_s_axis_tvalid),
   .tlast(ph_s_axis_tlast),
   .tready(ph_s_axis_tready),
   .CK_R(ck_r),
   .RSTB_R(rstb_r),
   .D_R(d_r),
   .reset_hold(reset_hold),
   .reset_cc_fifo(reset_cc_fifo),
   .write_ET(write_ET)
    );

//We only need elapsed_time in PH mode.  Make a pulse to load the ET_held reg.  
//Sync the PH trigger to ET_clk
/*
wire ph_trig_ET_sync;
sync_it S0 (
    .clk(ET_clk),
    .din(PH_trig_sync0),
    .dout(ph_trig_ET_sync)
    );
 */
    
//We need to hold the ET value from the time the trigger occurs until after it has been written into the FIFO
//We'll hold it on the rising edge of PH_trig
//And release it on the falling edge of write_ET
//Need to do this for each of the four phases
//PHASE0
reg hold_ET0, hold_ET0_d1;
assign ET0_load = hold_ET0 && !hold_ET0_d1;
wire  write_ET0_sync;
reg write_ET0_sync_d1;
 sync_it S1(
    .clk(ET_clk),
    .din(write_ET),
    .dout(write_ET0_sync)
    );
wire reset_hold_ET0 = !write_ET0_sync && write_ET0_sync_d1;
always @ (posedge ET_clk) begin
    if (reset_hold_ET0) hold_ET0 <= 0;
    else if (PH_trig_sync0) hold_ET0 <= 1;
    hold_ET0_d1 <= hold_ET0;
    write_ET0_sync_d1 <= write_ET0_sync;
end
//PHASE1
reg hold_ET1, hold_ET1_d1;
assign ET1_load = hold_ET1 && !hold_ET1_d1;
wire  write_ET1_sync;
reg write_ET1_sync_d1;
 sync_it S2(
    .clk(ET_clk_1),
    .din(write_ET),
    .dout(write_ET1_sync)
    );
wire reset_hold_ET1 = !write_ET1_sync && write_ET1_sync_d1;
always @ (posedge ET_clk_1) begin
    if (reset_hold_ET1) hold_ET1 <= 0;
    else if (PH_trig_sync1) hold_ET1 <= 1;
    hold_ET1_d1 <= hold_ET1;
    write_ET1_sync_d1 <= write_ET1_sync;
end
//PHASE2
reg hold_ET2, hold_ET2_d1;
assign ET2_load = hold_ET2 && !hold_ET2_d1;
wire  write_ET2_sync;
reg write_ET2_sync_d1;
 sync_it S3(
    .clk(ET_clk_2),
    .din(write_ET),
    .dout(write_ET2_sync)
    );
wire reset_hold_ET2 = !write_ET2_sync && write_ET2_sync_d1;
always @ (posedge ET_clk_2) begin
    if (reset_hold_ET2) hold_ET2 <= 0;
    else if (PH_trig_sync2) hold_ET2 <= 1;
    hold_ET2_d1 <= hold_ET2;
    write_ET2_sync_d1 <= write_ET2_sync;
end
//PHASE3
reg hold_ET3, hold_ET3_d1;
assign ET3_load = hold_ET3 && !hold_ET3_d1;
wire  write_ET3_sync;
reg write_ET3_sync_d1;
 sync_it S4(
    .clk(ET_clk_3),
    .din(write_ET),
    .dout(write_ET3_sync)
    );
wire reset_hold_ET3 = !write_ET3_sync && write_ET3_sync_d1;
always @ (posedge ET_clk_3) begin
    if (reset_hold_ET3) hold_ET3 <= 0;
    else if (PH_trig_sync3) hold_ET3 <= 1;
    hold_ET3_d1 <= hold_ET3;
    write_ET3_sync_d1 <= write_ET3_sync;
end

//A FIFO for crossing from the bit_clk to axi_clk domain 
wire [63:0] cc_fifo_in = {4'h3,adc_par_data3,4'h2,adc_par_data2,4'h1,adc_par_data1,4'h0,adc_par_data0};
wire [31:0] cc_fifo_out;
wire cc_fifo_full;
wire cc_fifo_empty;
wire cc_fifo_wr_rst_busy;
wire cc_fifo_rd_rst_busy;
(*KEEP = "TRUE"*)wire cc_fifo_read = ph_s_axis_tvalid && ph_s_axis_tready;
(*KEEP = "TRUE"*)wire cc_fifo_write = adc_frame_pulse && !cc_fifo_wr_rst_busy  && !cc_fifo_full;

FIFO_64_to_32 CC_FIFO (
  .rst(reset_cc_fifo),                  // input wire rst
  .wr_clk(bit_clk_bufg),            // input wire wr_clk
  .rd_clk(axi_clk),            // input wire rd_clk
  .din(cc_fifo_in),                  // input wire [63 : 0] din
  .wr_en(cc_fifo_write),              // input wire wr_en
  .rd_en(cc_fifo_read),              // input wire rd_en
  .dout(cc_fifo_out),                // output wire [31 : 0] dout
  .full(),                // output wire full
  .prog_full(cc_fifo_full),      // output wire prog_full
  .empty(cc_fifo_empty),              // output wire empty
  .wr_rst_busy(cc_fifo_wr_rst_busy),  // output wire wr_rst_busy
  .rd_rst_busy(cc_fifo_rd_rst_busy)  // output wire rd_rst_busy
);

//We'll generate the two LSBs combinatorially from the four phases of ET, calling them A, B, C, D
//No need to worry about timing here, since we have a lot of time while the ET values are held
wire A_gt_B = ET0_held > ET1_held;
wire B_gt_C = ET1_held > ET2_held;
wire C_gt_D = ET2_held > ET3_held;
reg ET_bit0;
reg ET_bit1;
always @ (A_gt_B, B_gt_C, C_gt_D)
    case ({A_gt_B, B_gt_C, C_gt_D})
    3'b000: ET_bit0 = 0;
    3'b100: ET_bit0 = 1;
    3'b010: ET_bit0 = 0;
    3'b001: ET_bit0 = 1;
    default:ET_bit0 = 1'bx;
    endcase
always @ (A_gt_B, B_gt_C, C_gt_D)
    case ({A_gt_B, B_gt_C, C_gt_D})
    3'b000: ET_bit1 = 0;
    3'b100: ET_bit1 = 0;
    3'b010: ET_bit1 = 1;
    3'b001: ET_bit1 = 1;
    default:ET_bit1 = 1'bx;
    endcase
    
wire [31:0] elapsed_time = {1'b0, ET3_held, ET_bit1, ET_bit0};
    
wire [31:0] ph_fifo_in = write_ET ? elapsed_time : cc_fifo_out;

FIFO_32by512 PH_FIFO (
  .wr_rst_busy(),          // output wire wr_rst_busy
  .rd_rst_busy(),          // output wire rd_rst_busy
  .s_aclk(axi_clk),                    // input wire s_aclk
  .s_aresetn(axi_areset_n),              // input wire s_aresetn
  .s_axis_tvalid(ph_s_axis_tvalid),      // input wire s_axis_tvalid
  .s_axis_tlast(ph_s_axis_tlast),        // input wire s_axis_tlast
  .s_axis_tready(ph_s_axis_tready),      // output wire s_axis_tready
  .s_axis_tdata(ph_fifo_in),        // input wire [31 : 0] s_axis_tdata
  .m_axis_tvalid(ph_m_axis_tvalid),      // output wire m_axis_tvalid
  .m_axis_tlast(ph_m_axis_tlast),                      // output wire m_axis_tlast
  .m_axis_tready(ph_m_axis_tready),      // input wire m_axis_tready
  .m_axis_tdata(ph_m_axis_data),        // output wire [31 : 0] m_axis_tdata
  .axis_data_count(ph_fifo_data_count)  // output wire [9 : 0] axis_data_count
);


assign RSTB_R = {!rstb_r, !rstb_r, !rstb_r, !rstb_r}; 
assign D_R = {d_r, d_r, d_r, d_r};

//We need to sync and edge-detect the masked PH trigger to drive the HOLD generators
wire PH_trig_hs_sync;
            async_edge_detect ED_HSCLK(
           .clk(hs_clk),
           .trig_in(pulseheight_trigger_raw),
           .trig_out(PH_trig_hs_sync)
           );

wire hold1_out;
delay_hold DELAY_HOLD1(
    .clk(hs_clk),
    .trig(PH_trig_hs_sync || sw_trig_pulse),
    .delay_time({4'h0,hold1_delay[3:0]}),
    .reset_hold(reset_hold),
    .trig_delayed(hold1_out)
    );

wire hold2_out;
delay_hold DELAY_HOLD2(
    .clk(hs_clk),
    .trig(PH_trig_hs_sync || sw_trig_pulse),
    .delay_time({4'h0,hold2_delay[3:0]}),
    .reset_hold(reset_hold),
    .trig_delayed(hold2_out)
    );

assign hold1 = {!hold1_out, !hold1_out, !hold1_out, !hold1_out};
assign hold2 = {!hold2_out, !hold2_out, !hold2_out, !hold2_out};

//QADC clock generation.  
//Generate clock as a submultiple of axi_clk
//If axi_clk is 100MHz, 4 gives 10ns * 2 * (4 + 1) = 100ns, 10MHz
//If axi_clk is 62.5MHz, 2 give 16ns * 2 * (2 + 1) = 96ns, 10.4MHz
//Allow phase control of ck_r at axi_clk increment
parameter ADC_CLK_DIV = 4;
reg adc_clk_reg = 0;
reg [8:0] ck_r_shift = 0;
reg [3:0] clk_div = 0;
always @ (posedge axi_clk) begin
    if (clk_div == ADC_CLK_DIV) clk_div <= 0;
    else clk_div <= clk_div + 1;
    if (clk_div == ADC_CLK_DIV) adc_clk_reg <= !adc_clk_reg;
    ck_r_shift <= {ck_r_shift[7:0], ck_r};
end
reg ck_r_mux_out;
always @ (ck_r_shift, adc_clk_phase_sel, ck_r)
    case (adc_clk_phase_sel)
        4'h0: ck_r_mux_out = ck_r;
        4'h1: ck_r_mux_out = ck_r_shift[0];
        4'h2: ck_r_mux_out = ck_r_shift[1];
        4'h3: ck_r_mux_out = ck_r_shift[2];
        4'h4: ck_r_mux_out = ck_r_shift[3];
        4'h5: ck_r_mux_out = ck_r_shift[4];
        4'h6: ck_r_mux_out = ck_r_shift[5];
        4'h7: ck_r_mux_out = ck_r_shift[6];
        4'h8: ck_r_mux_out = ck_r_shift[7];
        4'h9: ck_r_mux_out = ck_r_shift[8];
        default: ck_r_mux_out = 1'bx;
    endcase
assign CK_R = {ck_r_mux_out, ck_r_mux_out, ck_r_mux_out, ck_r_mux_out};
assign adc_clk_out = adc_clk_reg;

assign testpoint[0] = ET0_load;
assign testpoint[1] = PH_trig_hs_sync;
assign testpoint[2] = ph_trig_stretched;
assign testpoint[3] = 0;
assign testpoint[4] = 0;
assign testpoint[5] = 0;

/*
//A trigger signal sync'ed to bitclk, for the ILA
(*KEEP = "TRUE"*)wire debug_PH_trig_bitclk;
reg trig_bitclk_sync;
always @ (posedge bit_clk_bufg) trig_bitclk_sync <= pulseheight_trigger;
assign debug_PH_trig_bitclk = trig_bitclk_sync;
*/
endmodule
