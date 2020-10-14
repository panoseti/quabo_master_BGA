`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/10/2020 03:45:54 PM
// Design Name: 
// Module Name: SignalSwitch
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


module SignalSwitch#(
    parameter integer C_M_AXI_IM_Config_ADDR_WIDTH	= 32,
	parameter integer C_M_AXI_IM_Config_DATA_WIDTH	= 32
)(
//port_sel for the selection of 16-bit mode or 8-bit mode
    input wire [1:0] port_sel,
//16-bit mode signals
    input wire [31:0] m_axis_tdata_8,
    input wire m_axis_tvalid_8,
    input wire [3:0] m_axis_tkeep_8,
    input wire m_axis_tlast_8,
    input wire start_to_read_8,
    input wire [C_M_AXI_IM_Config_ADDR_WIDTH-1 : 0] araddr_from_user_8,
    input wire [27:0] hs_im_state_8,
    input wire [4:0] ram_dpra_8,
    output wire port_sel_8,
//8-bit mode signals
    input wire [31:0] m_axis_tdata_16,
    input wire m_axis_tvalid_16,
    input wire [3:0] m_axis_tkeep_16,
    input wire m_axis_tlast_16,
    input wire start_to_read_16,
    input wire [C_M_AXI_IM_Config_ADDR_WIDTH-1 : 0] araddr_from_user_16,
    input wire [27:0] hs_im_state_16,
    input wire [4:0] ram_dpra_16,
    output wire port_sel_16,
//output signals     
    output reg [31:0] m_axis_tdata,
    output reg m_axis_tvalid,
    output reg [3:0] m_axis_tkeep,
    output reg m_axis_tlast,
    output reg start_to_read,
    output reg [C_M_AXI_IM_Config_ADDR_WIDTH-1 : 0] araddr_from_user,
    output reg [27:0] hs_im_state,
    output reg [4:0] ram_dpra
    );
parameter IDLE          = 2'b00;
parameter MODE_16BIT    = 2'b01;
parameter MODE_8BIT     = 2'b10;
    
//always @(port_sel or m_axis_tdata or m_axis_tvalid or m_axis_tkeep or m_axis_tlast or start_to_read or araddr_from_user or hs_im_state or ram_dpra)
always @(*)
    begin
    case(port_sel)
        IDLE:
            begin
                m_axis_tdata        = 32'b0;
                m_axis_tvalid       = 1'b0;
                m_axis_tkeep        = 4'b0;
                m_axis_tlast        = 1'b0;
                start_to_read       = 1'b0;
                araddr_from_user    = 32'b0;
                hs_im_state         = 28'b0;
                ram_dpra            = 5'b0;
            end
        MODE_16BIT:
            begin
                m_axis_tdata        = m_axis_tdata_16;
                m_axis_tvalid       = m_axis_tvalid_16;
                m_axis_tkeep        = m_axis_tkeep_16;
                m_axis_tlast        = m_axis_tlast_16;
                start_to_read       = start_to_read_16;
                araddr_from_user    = araddr_from_user_16;
                hs_im_state         = hs_im_state_16;
                ram_dpra            = ram_dpra_16;
                
            end
        MODE_8BIT:
            begin
                m_axis_tdata        = m_axis_tdata_8;
                m_axis_tvalid       = m_axis_tvalid_8;
                m_axis_tkeep        = m_axis_tkeep_8;
                m_axis_tlast        = m_axis_tlast_8;
                start_to_read       = start_to_read_8;
                araddr_from_user    = araddr_from_user_8;
                hs_im_state         = hs_im_state_8;
                ram_dpra            = ram_dpra_8;
            end
        default:
            begin
                m_axis_tdata        = 32'b0;
                m_axis_tvalid       = 1'b0;
                m_axis_tkeep        = 4'b0;
                m_axis_tlast        = 1'b0;
                start_to_read       = 1'b0;
                araddr_from_user    = 32'b0;
                hs_im_state         = 28'b0;
                ram_dpra            = 5'b0;
            end
        endcase
    end
    
assign port_sel_16  = port_sel[0:0];
assign port_sel_8   = port_sel[1:1];

endmodule
