`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/02/2020 11:30:27 AM
// Design Name: 
// Module Name: StateMachine_16
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


module StateMachine_16#(
    parameter integer C_M_AXI_IM_Config_ADDR_WIDTH	= 32,
	parameter integer C_M_AXI_IM_Config_DATA_WIDTH	= 32
)
(
    //clk & rst
    input wire aclk,
    input wire aresetn,
    //elapsed_time
    input wire [28:0] elapsed_time,
    //port_sel
    input wire port_sel,
    //hs_state
    output reg [27:0]  hs_im_state,
    //ram
    input wire [31:0] ram_qdpo,
    output reg [4:0] ram_dpra,
    //acq_mode
    input wire [7:0]  acq_mode,
    //axis interface
    output reg m_axis_tvalid,
    output reg [31:0]m_axis_tdata,
    output reg [3:0]m_axis_tkeep,
    output reg m_axis_tlast,
    input wire m_axis_tready,
    //read from IM_fifo
    output reg start_to_read,
    input wire ready_to_read,
    input wire [C_M_AXI_IM_Config_DATA_WIDTH-1 : 0]rdata_to_user 
    );


//This fifo is for storing data for checksum
reg checksum_fifo_rd_en;
reg checksum_fifo_wr_en;
reg [31:0]checksum_fifo_din;
wire checksum_fifo_empty;
wire [31:0] pixel_data;
fifo_for_checksum checkfifo_fifo (
  .clk(aclk),      // input wire clk
  .srst(~aresetn),    // input wire srst
  .din(checksum_fifo_din),      // input wire [31 : 0] din
  .wr_en(checksum_fifo_wr_en),  // input wire wr_en
  .rd_en(checksum_fifo_rd_en),  // input wire rd_en
  .dout(pixel_data),    // output wire [31 : 0] dout
  .full(),    // output wire full
  .empty(checksum_fifo_empty)  // output wire empty
);

// Add user logic here
//state machine is here
parameter [27:0]IDLE                   =   28'h0000000,
                CHECK_FIFO              =   28'h0000001,
                PREPARE_FOR_READING     =   28'h0000002,
                READY_TO_READ           =   28'h0000004,
                GET_DATA_FROM_FIFO      =   28'h0000008,
                GET_CHECKSUM_PART       =   28'h0000010,
                GET_ELAPSED_TIME        =   28'h0000020,
                CAL_UDP_CHECKSUM1       =   28'h0000040,
                CAL_UDP_CHECKSUM2       =   28'h0000080,
                CAL_UDP_CHECKSUM3       =   28'h0000100,
                CAL_UDP_IP_CHECKSUM     =   28'h0000200,
                CAL_IP_CHECKSUM         =   28'h0000400,
                PUT_MAC0                =   28'h0000800,
                PUT_MAC1                =   28'h0001000,
                PUT_MAC2                =   28'h0002000,
                PUT_TYPE_VER_SERVICE    =   28'h0004000,
                PUT_TOTAL_LEN_ID        =   28'h0008000,
                PUT_FLAGS_TTL_PROTOCOL  =   28'h0010000,
                PUT_CHECKSUM_SRC_IP0    =   28'h0020000,
                PUT_SRC_IP1_DST_IP0     =   28'h0040000,
                PUT_DST_IP1_SRC_PORT    =   28'h0080000,
                PUT_DST_PORT_LENGTH     =   28'h0100000,
                PUT_CHECKSUM_ACQMODE    =   28'h0200000,
                PUT_PACKET_NO_BOARD_LOC =   28'h0400000,
                PUT_UTC                 =   28'h0800000,
                PUT_NANOSEC             =   28'h1000000,
                PUT_UNUSED_PIXEL_DATA   =   28'h2000000,
                PUT_PIXEL_DATA          =   28'h4000000,
                PUT_LAST                =   28'h8000000;



//Receive data length from im_fifo
parameter [31:0]  FIFO_RECV_TOTAL = 32'd1024;
parameter [31:0]  FIFO_RECV_LEN = 32'd256;
parameter [31:0]  FIFO_RECV_LEN_32BIT = 32'd128;

//ACQ_MODE here is a fixed value--0x02
//parameter [7:0]   ACQ_MODE_HS_IM   = 8'h02;

//The length of packet header is 42 bytes in ram
//The data width is 32bits, so we need to read data from the ram 11 times                
parameter [3:0] PACKET_HEADER_LEN = 4'd11;

//we use capital letter to show it's a input signal 
wire M_AXIS_TREADY;
assign M_AXIS_TREADY = m_axis_tready;
wire [31:0] elapsed_time_wire;
assign elapsed_time_wire = {3'b0,elapsed_time};
//this is packet_no, and will increase every packet 
reg [15:0] packet_no;
reg [15:0] packet_no_reg0,
           packet_no_reg1;

//delay of the data from im_fifo
reg [31:0] pixel_d0;

//this is a reg for storing the received length of im_fifo 
reg [31:0] fifo_recv_len;

reg [31:0] elapsed_time_reg;
reg [15:0] elapsed_time_reg0,
           elapsed_time_reg1,
           elapsed_time_reg2,
           elapsed_time_reg3;
//This is for udp check sum, and it will be added to the sum of fake udp header part,
//then we can get the whole 
reg [31:0] udp_checksum;
reg [31:0] ip_checksum;

reg [27:0]  next_state;

always @(posedge aclk)
    begin
        if (aresetn == 1'b0) 
            hs_im_state <= IDLE;
        else
            hs_im_state <= next_state;
    end

always @(hs_im_state or port_sel or ready_to_read or fifo_recv_len or udp_checksum)
    begin
        if (aresetn == 1'b0) 
            next_state = IDLE;
        else
            begin
                case(hs_im_state)
                    IDLE:
                        begin
                            if(port_sel == 1'b1)
                                next_state = CHECK_FIFO;
                            else
                                next_state = IDLE;
                        end
                     CHECK_FIFO:
                        begin
                            if(ready_to_read == 1'b1)
                                next_state = PREPARE_FOR_READING;
                            else
                                next_state = CHECK_FIFO;
                        end
                     PREPARE_FOR_READING:
                        begin
                            next_state = READY_TO_READ;
                        end
                     READY_TO_READ:
                        begin
                            next_state = GET_DATA_FROM_FIFO;
                        end
                     GET_DATA_FROM_FIFO:
                        begin
                            if(fifo_recv_len == 32'b1)
                                next_state = GET_CHECKSUM_PART;
                            else
                                next_state = GET_DATA_FROM_FIFO;
                        end
                     GET_CHECKSUM_PART:
                        begin
                            next_state = GET_ELAPSED_TIME;
                        end
                     GET_ELAPSED_TIME:
                        begin
                            next_state = CAL_UDP_CHECKSUM1;
                        end
                     CAL_UDP_CHECKSUM1:
                        begin
                            next_state = CAL_UDP_CHECKSUM2;
                        end
                     CAL_UDP_CHECKSUM2:
                        begin
                            next_state = CAL_UDP_CHECKSUM3;
                        end
                     CAL_UDP_CHECKSUM3:
                        begin
                            next_state = CAL_UDP_IP_CHECKSUM;
                        end
                     CAL_UDP_IP_CHECKSUM:
                        begin
                            if(udp_checksum[31:16] == 16'b0)
                                next_state = CAL_IP_CHECKSUM;
                            else
                                next_state = CAL_UDP_IP_CHECKSUM;
                        end
                     CAL_IP_CHECKSUM:
                        begin
                            if(ip_checksum[31:16] == 16'b0)
                                next_state = PUT_MAC0;
                            else
                                next_state = CAL_IP_CHECKSUM;
                        end
                     PUT_MAC0:
                        begin
                            if(M_AXIS_TREADY == 1'b1)
                                next_state = PUT_MAC1;
                            else
                                next_state = PUT_MAC0;
                        end
                     PUT_MAC1:
                        begin
                            if(M_AXIS_TREADY == 1'b1)
                                next_state = PUT_MAC2;
                            else
                                next_state = PUT_MAC1;
                        end
                     PUT_MAC2:
                        begin
                            if(M_AXIS_TREADY == 1'b1)
                                next_state = PUT_TYPE_VER_SERVICE;
                            else
                                next_state = PUT_MAC2;
                        end
                     PUT_TYPE_VER_SERVICE:
                        begin
                            if(M_AXIS_TREADY == 1'b1)
                                next_state = PUT_TOTAL_LEN_ID;
                            else
                                next_state = PUT_TYPE_VER_SERVICE;
                        end
                     PUT_TOTAL_LEN_ID:
                        begin
                            if(M_AXIS_TREADY == 1'b1)
                                next_state = PUT_FLAGS_TTL_PROTOCOL;
                            else
                                next_state = PUT_TOTAL_LEN_ID;
                        end
                     PUT_FLAGS_TTL_PROTOCOL:
                        begin
                            if(M_AXIS_TREADY == 1'b1)
                                next_state = PUT_CHECKSUM_SRC_IP0;
                            else
                                next_state = PUT_FLAGS_TTL_PROTOCOL;
                        end
                     PUT_CHECKSUM_SRC_IP0:
                        begin
                            if(M_AXIS_TREADY == 1'b1)
                                next_state = PUT_SRC_IP1_DST_IP0;
                            else
                                next_state = PUT_CHECKSUM_SRC_IP0;
                        end
                     PUT_SRC_IP1_DST_IP0:
                        begin
                            if(M_AXIS_TREADY == 1'b1)
                                next_state = PUT_DST_IP1_SRC_PORT;
                            else
                                next_state = PUT_SRC_IP1_DST_IP0;
                        end
                     PUT_DST_IP1_SRC_PORT:
                        begin
                            if(M_AXIS_TREADY == 1'b1)
                                next_state = PUT_DST_PORT_LENGTH;
                            else
                                next_state = PUT_DST_IP1_SRC_PORT;
                        end
                     PUT_DST_PORT_LENGTH:
                        begin
                            if(M_AXIS_TREADY == 1'b1)
                                next_state = PUT_CHECKSUM_ACQMODE;
                            else
                                next_state = PUT_DST_PORT_LENGTH;
                        end
                     PUT_CHECKSUM_ACQMODE:
                        begin
                            if(M_AXIS_TREADY == 1'b1)
                                next_state = PUT_PACKET_NO_BOARD_LOC;
                            else
                                next_state = PUT_CHECKSUM_ACQMODE;
                        end
                     PUT_PACKET_NO_BOARD_LOC:
                        begin
                            if(M_AXIS_TREADY == 1'b1)
                                next_state = PUT_UTC;
                            else
                                next_state = PUT_PACKET_NO_BOARD_LOC;
                        end
                     PUT_UTC:
                        begin
                            if(M_AXIS_TREADY == 1'b1)
                                next_state = PUT_NANOSEC;
                            else
                                next_state = PUT_UTC;
                        end
                     PUT_NANOSEC:
                        begin
                            if(M_AXIS_TREADY == 1'b1)
                                next_state = PUT_UNUSED_PIXEL_DATA;
                            else
                                next_state = PUT_NANOSEC;
                        end
                     PUT_UNUSED_PIXEL_DATA:
                            if(M_AXIS_TREADY == 1'b1)
                                next_state = PUT_PIXEL_DATA;
                            else
                                next_state = PUT_UNUSED_PIXEL_DATA;
                     PUT_PIXEL_DATA:
                        begin
                            if((M_AXIS_TREADY == 1'b1) && (fifo_recv_len == 32'd1))
                                next_state = PUT_LAST;
                            else
                                next_state = PUT_PIXEL_DATA;  
                        end
                     PUT_LAST:
                        begin
                            if((M_AXIS_TREADY == 1'b1) && (port_sel == 1'b1))
                                next_state = CHECK_FIFO;
                            else if((M_AXIS_TREADY == 1'b1) && (port_sel == 1'b0))
                                next_state = IDLE;
                            else
                                next_state = PUT_LAST;
                        end
                     default:
                        begin
                            next_state = IDLE;
                        end
                endcase
            end
    end
    
always @(posedge aclk)                                                    
    begin                                                                             
        if (aresetn == 1'b0)                                                     
	       begin                                                                         
	           // reset condition                                                                   
	           start_to_read       <= 1'b0;
	           fifo_recv_len       <= 32'b0;
	           //we dont care about the following signals until the hs_im_state goes to CORRECT_LEN 
	           ram_dpra            <= 5'b0;
	           m_axis_tvalid       <= 1'b0;
               m_axis_tdata        <= 32'b0;
               m_axis_tkeep        <= 4'b0;
               m_axis_tlast        <= 1'b0;
               packet_no           <= 16'b0;
               packet_no_reg0      <= 16'b0;
               packet_no_reg1      <= 16'b0;
               elapsed_time_reg    <= 32'b0;
               elapsed_time_reg0   <= 16'b0;
               elapsed_time_reg1   <= 16'b0;
               elapsed_time_reg2   <= 16'b0;
               elapsed_time_reg3   <= 16'b0;
               pixel_d0            <= 32'b0;
               udp_checksum        <= 32'b0;
               ip_checksum         <= 32'b0;
               checksum_fifo_rd_en <= 1'b0;  
               checksum_fifo_wr_en <= 1'b0;
               checksum_fifo_din   <= 32'b0;                                                                                         
	       end                                                                           
	    else                                                                            
	       begin                                                                         
	           // state transition                                                          
	           case (hs_im_state)                                                                                                                                                                                                                                                          
	               IDLE:
	                   begin
	                        start_to_read       <= 1'b0;
	                        fifo_recv_len       <= 32'b0;
	                        //we dont care about the following signals until the hs_im_state goes to CORRECT_LEN
	                        ram_dpra            <= 5'b0;
	                        m_axis_tvalid       <= 1'b0;
                            m_axis_tdata        <= 32'b0;
                            m_axis_tkeep        <= 4'b0;
                            m_axis_tlast        <= 1'b0;
                            packet_no           <= 16'b0;
                            packet_no_reg0      <= 16'b0;
                            packet_no_reg1      <= 16'b0;
                            pixel_d0            <= 32'b0;
                            elapsed_time_reg    <= 32'b0;
                            elapsed_time_reg0   <= 16'b0;
                            elapsed_time_reg1   <= 16'b0;
                            elapsed_time_reg2   <= 16'b0;
                            elapsed_time_reg3   <= 16'b0;
                            udp_checksum        <= 32'b0;
                            ip_checksum         <= 32'b0;
                            checksum_fifo_rd_en <= 1'b0;
                            checksum_fifo_wr_en <= 1'b0;
                            checksum_fifo_din   <= 32'b0; 
	                   end
	               CHECK_FIFO:
	                   begin
	                       start_to_read       <= 1'b0;
	                       fifo_recv_len       <= 32'b0;
	                       //we dont care about the following signals until the hs_im_state goes to CORRECT_LEN
	                       ram_dpra            <= 5'b0;
	                       m_axis_tvalid       <= 1'b0;
                           m_axis_tdata        <= 32'b0;
                           m_axis_tkeep        <= 4'b0;
                           m_axis_tlast        <= 1'b0;
                           packet_no           <= packet_no;
                           packet_no_reg0      <= {packet_no[7:0], 8'b0};
                           packet_no_reg1      <= {8'b0, packet_no[15:8]};
                           elapsed_time_reg    <= 32'b0;
                           elapsed_time_reg0   <= 16'b0;
                           elapsed_time_reg1   <= 16'b0;
                           elapsed_time_reg2   <= 16'b0;
                           elapsed_time_reg3   <= 16'b0;
                           pixel_d0            <= 32'b0; 
                           udp_checksum        <= 32'b0;
                           ip_checksum         <= 32'b0;
                           checksum_fifo_rd_en <= 1'b0;
                           checksum_fifo_wr_en <= 1'b0;
                           checksum_fifo_din   <= 32'b0;
	                    end
	               PREPARE_FOR_READING:
	                   begin
	                       start_to_read       <= 1'b1;
	                       fifo_recv_len       <= FIFO_RECV_LEN;
	                       //we dont care about the following signals until the hs_im_state goes to CORRECT_LEN
	                       ram_dpra            <= 5'b0;
	                       m_axis_tvalid       <= 1'b0;
                           m_axis_tdata        <= 32'b0;
                           m_axis_tkeep        <= 4'b0;
                           m_axis_tlast        <= 1'b0;
                           packet_no           <= packet_no;
                           packet_no_reg0      <= {packet_no[7:0], 8'b0};
                           packet_no_reg1      <= {8'b0, packet_no[15:8]};
                           elapsed_time_reg    <= 32'b0;
                           elapsed_time_reg0   <= 16'b0;
                           elapsed_time_reg1   <= 16'b0;
                           elapsed_time_reg2   <= 16'b0;
                           elapsed_time_reg3   <= 16'b0;
                           pixel_d0            <= 32'b0; 
                           udp_checksum        <= 32'b0;
                           ip_checksum         <= 32'b0;
                           checksum_fifo_rd_en <= 1'b0;
                           checksum_fifo_wr_en <= 1'b0;
                           checksum_fifo_din   <= 32'b0;
	                   end
	               READY_TO_READ:
	                   begin
	                       start_to_read       <= 1'b1;
	                       fifo_recv_len       <= FIFO_RECV_LEN;
	                       //we dont care about the following signals until the hs_im_state goes to CORRECT_LEN
	                       ram_dpra            <= 5'b0;
	                       m_axis_tvalid       <= 1'b0;
                           m_axis_tdata        <= 32'b0;
                           m_axis_tkeep        <= 4'b0;
                           m_axis_tlast        <= 1'b0;
                           packet_no           <= packet_no;
                           packet_no_reg0      <= {packet_no[7:0], 8'b0};
                           packet_no_reg1      <= {8'b0, packet_no[15:8]};
                           elapsed_time_reg    <= 32'b0;
                           elapsed_time_reg0   <= 16'b0;
                           elapsed_time_reg1   <= 16'b0;
                           elapsed_time_reg2   <= 16'b0;
                           elapsed_time_reg3   <= 16'b0;
                           pixel_d0            <= 32'b0; 
                           udp_checksum        <= 32'b0;
                           ip_checksum         <= 32'b0;
                           checksum_fifo_rd_en <= 1'b0;
                           checksum_fifo_wr_en <= 1'b0;
                           checksum_fifo_din   <= 32'b0;
	                   end
	               GET_DATA_FROM_FIFO:
	                   begin        
	                       fifo_recv_len       <= fifo_recv_len - 1;
	                       udp_checksum        <= udp_checksum + (rdata_to_user[7:0]<<8) + rdata_to_user[15:8];
	                       pixel_d0            <= rdata_to_user; 
	                       start_to_read       <= 1'b1;                          //put data to tmp fifo, and calculate checksum_part(sum data)            
	                       ram_dpra            <= 5'b0;
	                       m_axis_tvalid       <= 1'b0;
                           m_axis_tdata        <= 32'b0;
                           m_axis_tkeep        <= 4'b0;
                           m_axis_tlast        <= 1'b0;  
                           ip_checksum         <= 32'b0;
                           packet_no           <= packet_no;
                           packet_no_reg0      <= {packet_no[7:0], 8'b0};
                           packet_no_reg1      <= {8'b0, packet_no[15:8]};
                           elapsed_time_reg    <= 32'b0;
                           elapsed_time_reg0   <= 16'b0;
                           elapsed_time_reg1   <= 16'b0;
                           elapsed_time_reg2   <= 16'b0;
                           elapsed_time_reg3   <= 16'b0;
                           checksum_fifo_rd_en <= 1'b0;
                           checksum_fifo_wr_en <= fifo_recv_len[0:0];
                           checksum_fifo_din   <= {rdata_to_user[15:0], pixel_d0[15:0]}; //put data from im_fifo in a tmp fifo here, we need to use the data for checksum
	                   end
	               GET_CHECKSUM_PART:
	                   begin
	                       fifo_recv_len       <= fifo_recv_len;
	                       udp_checksum        <= udp_checksum + ram_qdpo;            //put data from im_fifo in a tmp fifo here, we need to use the data fro checksum
	                       start_to_read       <= 1'b0;                               //put data to tmp fifo, and calculate checksum_part(sum data)          
	                       ram_dpra            <= 5'b0;
	                       m_axis_tvalid       <= 1'b0;
                           m_axis_tdata        <= 32'b0;
                           m_axis_tkeep        <= 4'b0;
                           m_axis_tlast        <= 1'b0;  
                           ip_checksum         <= 32'b0;
                           packet_no           <= packet_no;
                           packet_no_reg0      <= {packet_no[7:0], 8'b0};
                           packet_no_reg1      <= {8'b0, packet_no[15:8]};
                           elapsed_time_reg    <= {(elapsed_time_wire<<2)}-256;
                           elapsed_time_reg0   <= {elapsed_time_reg[7:0], 8'b0};
                           elapsed_time_reg1   <= {8'b0, elapsed_time_reg[15:8]};
                           elapsed_time_reg2   <= {elapsed_time_reg[23:16],8'b0};
                           elapsed_time_reg3   <= {8'b0,elapsed_time_reg[31:24]};
                           pixel_d0            <= 32'b0; 
                           checksum_fifo_rd_en <= 1'b0;
                           checksum_fifo_wr_en <= 1'b0;
                           checksum_fifo_din   <= 32'b0;
	                   end
	               GET_ELAPSED_TIME:
	                   begin
	                       fifo_recv_len       <= fifo_recv_len;
	                       udp_checksum        <= udp_checksum;            //put data from im_fifo in a tmp fifo here, we need to use the data fro checksum
	                       start_to_read       <= 1'b0;                                          
	                       ram_dpra            <= 5'b0;
	                       m_axis_tvalid       <= 1'b0;
                           m_axis_tdata        <= 32'b0;
                           m_axis_tkeep        <= 4'b0;
                           m_axis_tlast        <= 1'b0;  
                           ip_checksum         <= 32'b0;
                           packet_no           <= packet_no;
                           packet_no_reg0      <= {packet_no[7:0], 8'b0};
                           packet_no_reg1      <= {8'b0, packet_no[15:8]};
                           elapsed_time_reg    <= elapsed_time_reg;
                           elapsed_time_reg0   <= {elapsed_time_reg[7:0], 8'b0};
                           elapsed_time_reg1   <= {8'b0, elapsed_time_reg[15:8]};
                           elapsed_time_reg2   <= {elapsed_time_reg[23:16],8'b0};
                           elapsed_time_reg3   <= {8'b0,elapsed_time_reg[31:24]};
                           pixel_d0            <= 32'b0; 
                           checksum_fifo_rd_en <= 1'b0;
                           checksum_fifo_wr_en <= 1'b0;
                           checksum_fifo_din   <= 32'b0;
	                   end
	               CAL_UDP_CHECKSUM1:
	                   begin
	                       fifo_recv_len       <= fifo_recv_len;
	                       udp_checksum        <= udp_checksum + packet_no_reg0 + packet_no_reg1;            //put data from im_fifo in a tmp fifo here, we need to use the data fro checksum
	                       start_to_read       <= 1'b0;                                        
	                       ram_dpra            <= 5'b0;
	                       m_axis_tvalid       <= 1'b0;
                           m_axis_tdata        <= 32'b0;
                           m_axis_tkeep        <= 4'b0;
                           m_axis_tlast        <= 1'b0;  
                           ip_checksum         <= 32'b0;
                           packet_no           <= packet_no;
                           packet_no_reg0      <= {packet_no[7:0], 8'b0};
                           packet_no_reg1      <= {8'b0, packet_no[15:8]};
                           elapsed_time_reg    <= elapsed_time_reg;
                           elapsed_time_reg0   <= {elapsed_time_reg[7:0], 8'b0};
                           elapsed_time_reg1   <= {8'b0, elapsed_time_reg[15:8]};
                           elapsed_time_reg2   <= {elapsed_time_reg[23:16],8'b0};
                           elapsed_time_reg3   <= {8'b0,elapsed_time_reg[31:24]};
                           pixel_d0            <= 32'b0; 
                           checksum_fifo_rd_en <= 1'b0;
                           checksum_fifo_wr_en <= 1'b0;
                           checksum_fifo_din   <= 32'b0;
	                   end
	               CAL_UDP_CHECKSUM2:
	                   begin
	                       fifo_recv_len       <= fifo_recv_len;
	                       udp_checksum        <= udp_checksum + elapsed_time_reg0 + elapsed_time_reg1;            //put data from im_fifo in a tmp fifo here, we need to use the data fro checksum
	                       start_to_read       <= 1'b0;                                      
	                       ram_dpra            <= 5'd1;
	                       m_axis_tvalid       <= 1'b0;
                           m_axis_tdata        <= 32'b0;
                           m_axis_tkeep        <= 4'b0;
                           m_axis_tlast        <= 1'b0;  
                           ip_checksum         <= 32'b0;
                           packet_no           <= packet_no;
                           packet_no_reg0      <= {packet_no[7:0], 8'b0};
                           packet_no_reg1      <= {8'b0, packet_no[15:8]};
                           elapsed_time_reg    <= elapsed_time_reg;
                           elapsed_time_reg0   <= {elapsed_time_reg[7:0], 8'b0};
                           elapsed_time_reg1   <= {8'b0, elapsed_time_reg[15:8]};
                           elapsed_time_reg2   <= {elapsed_time_reg[23:16],8'b0};
                           elapsed_time_reg3   <= {8'b0,elapsed_time_reg[31:24]};
                           pixel_d0            <= 32'b0; 
                           checksum_fifo_rd_en <= 1'b0;
                           checksum_fifo_wr_en <= 1'b0;
                           checksum_fifo_din   <= 32'b0;
	                   end
	               CAL_UDP_CHECKSUM3:
	                   begin
	                       fifo_recv_len       <= fifo_recv_len;
	                       udp_checksum        <= udp_checksum + elapsed_time_reg2 + elapsed_time_reg3;            //put data from im_fifo in a tmp fifo here, we need to use the data fro checksum
	                       start_to_read       <= 1'b0;                                         
	                       ram_dpra            <= 5'd2;
	                       m_axis_tvalid       <= 1'b0;
                           m_axis_tdata        <= 32'b0;
                           m_axis_tkeep        <= 4'b0;
                           m_axis_tlast        <= 1'b0;  
                           ip_checksum         <= ram_qdpo+packet_no;
                           packet_no           <= packet_no;
                           packet_no_reg0      <= {packet_no[7:0], 8'b0};
                           packet_no_reg1      <= {8'b0, packet_no[15:8]};
                           elapsed_time_reg    <= elapsed_time_reg;
                           elapsed_time_reg0   <= {elapsed_time_reg[7:0], 8'b0};
                           elapsed_time_reg1   <= {8'b0, elapsed_time_reg[15:8]};
                           elapsed_time_reg2   <= {elapsed_time_reg[23:16],8'b0};
                           elapsed_time_reg3   <= {8'b0,elapsed_time_reg[31:24]};
                           pixel_d0            <= 32'b0; 
                           checksum_fifo_rd_en <= 1'b0;
                           checksum_fifo_wr_en <= 1'b0;
                           checksum_fifo_din   <= 32'b0;
	                   end
	               CAL_UDP_IP_CHECKSUM:
	                   begin
	                       start_to_read       <= 1'b0;                                        
	                       fifo_recv_len       <= FIFO_RECV_LEN_32BIT;           //im_fifo receive 256*4 bytes
	                       ram_dpra            <= 5'd2;                //keep the address, we need the third and forth byte read from the ram later
	                       // data here is special, two bytes are from the ram, and the other two bytes are acq_mode and unused
	                       m_axis_tdata        <= 32'h00; 
	                       m_axis_tvalid       <= 1'b0;                    // the data is valid now
                           m_axis_tkeep        <= 4'h0;                    // all the four byes are valid
                           m_axis_tlast        <= 1'b0;                    // it's not the last byte transfer to the axis interface
                           packet_no           <= packet_no;
                           packet_no_reg0      <= {packet_no[7:0], 8'b0};
                           packet_no_reg1      <= {8'b0, packet_no[15:8]};
                           elapsed_time_reg    <= elapsed_time_reg;
                           elapsed_time_reg0   <= {elapsed_time_reg[7:0], 8'b0};
                           elapsed_time_reg1   <= {8'b0, elapsed_time_reg[15:8]};
                           elapsed_time_reg2   <= {elapsed_time_reg[23:16],8'b0};
                           elapsed_time_reg3   <= {8'b0,elapsed_time_reg[31:24]};
                           pixel_d0            <= 32'b0; 
                           udp_checksum        <= udp_checksum[31:16] + udp_checksum[15:0];//if we don't get the correct checksum, keep calculating
                           ip_checksum         <= ip_checksum;
                           checksum_fifo_rd_en <= 1'b0;
                           checksum_fifo_wr_en <= 1'b0;
                           checksum_fifo_din   <= 32'b0;
	                   end
	               CAL_IP_CHECKSUM:
	                   begin
	                       start_to_read       <= 1'b0;                                         
	                       fifo_recv_len       <= fifo_recv_len;           //im_fifo receive 256*4 bytes
	                       ram_dpra            <= 5'd2;                //keep the address, we need the third and forth byte read from the ram later
	                       // data here is special, two bytes are from the ram, and the other two bytes are acq_mode and unused
	                       m_axis_tdata        <= 32'h00; 
	                       m_axis_tvalid       <= 1'b0;                    // the data is valid now
                           m_axis_tkeep        <= 4'h0;                    // all the four byes are valid
                           m_axis_tlast        <= 1'b0;                    // it's not the last byte transfer to the axis interface
                           packet_no           <= packet_no;
                           packet_no_reg0      <= {packet_no[7:0], 8'b0};
                           packet_no_reg1      <= {8'b0, packet_no[15:8]};
                           elapsed_time_reg    <= elapsed_time_reg;
                           elapsed_time_reg0   <= {elapsed_time_reg[7:0], 8'b0};
                           elapsed_time_reg1   <= {8'b0, elapsed_time_reg[15:8]};
                           elapsed_time_reg2   <= {elapsed_time_reg[23:16],8'b0};
                           elapsed_time_reg3   <= {8'b0,elapsed_time_reg[31:24]};
                           pixel_d0            <= 32'b0; 
                           udp_checksum        <= udp_checksum;            //if we don't get the correct checksum, keep calculating
                           ip_checksum         <= ip_checksum[31:16] + ip_checksum[15:0];
                           checksum_fifo_rd_en <= 1'b0;
                           checksum_fifo_wr_en <= 1'b0;
                           checksum_fifo_din   <= 32'b0;
                       end
	               PUT_MAC0:
	                   begin
	                       if(M_AXIS_TREADY == 1'b1)
	                           begin
	                               ram_dpra            <= ram_dpra + 1;
	                               m_axis_tvalid       <= 1'b0;
	                           end
	                       else
	                           begin
	                               ram_dpra            <= ram_dpra;
	                               m_axis_tvalid       <= 1'b1;
	                           end
	                       start_to_read       <= 1'b0;                                           
	                       fifo_recv_len       <= fifo_recv_len;           //im_fifo receive 256*4 bytes
                           m_axis_tdata        <= ram_qdpo;
                           m_axis_tkeep        <= 4'hf;
                           m_axis_tlast        <= 1'b0;
                           packet_no           <= packet_no;
                           packet_no_reg0      <= {packet_no[7:0], 8'b0};
                           packet_no_reg1      <= {8'b0, packet_no[15:8]};
                           elapsed_time_reg    <= elapsed_time_reg;
                           elapsed_time_reg0   <= {elapsed_time_reg[7:0], 8'b0};
                           elapsed_time_reg1   <= {8'b0, elapsed_time_reg[15:8]};
                           elapsed_time_reg2   <= {elapsed_time_reg[23:16],8'b0};
                           elapsed_time_reg3   <= {8'b0,elapsed_time_reg[31:24]};
                           pixel_d0            <= 32'b0; 
                           udp_checksum        <= udp_checksum;
                           ip_checksum         <= ip_checksum;
                           checksum_fifo_rd_en <= 1'b0;
                           checksum_fifo_wr_en <= 1'b0;
                           checksum_fifo_din   <= 32'b0;
	                   end
	               PUT_MAC1:
                        begin
                           if(M_AXIS_TREADY == 1'b1)
	                           begin
	                               ram_dpra            <= ram_dpra + 1;
	                           end
	                       else
	                           begin
	                               ram_dpra            <= ram_dpra;
	                           end
	                       start_to_read       <= 1'b0;                                           
	                       fifo_recv_len       <= fifo_recv_len;           //im_fifo receive 256*4 bytes
	                       m_axis_tvalid       <= 1'b1;
                           m_axis_tdata        <= ram_qdpo;
                           m_axis_tkeep        <= 4'hf;
                           m_axis_tlast        <= 1'b0;
                           packet_no           <= packet_no;
                           packet_no_reg0      <= {packet_no[7:0], 8'b0};
                           packet_no_reg1      <= {8'b0, packet_no[15:8]};
                           elapsed_time_reg    <= elapsed_time_reg;
                           elapsed_time_reg0   <= {elapsed_time_reg[7:0], 8'b0};
                           elapsed_time_reg1   <= {8'b0, elapsed_time_reg[15:8]};
                           elapsed_time_reg2   <= {elapsed_time_reg[23:16],8'b0};
                           elapsed_time_reg3   <= {8'b0,elapsed_time_reg[31:24]};
                           pixel_d0            <= 32'b0; 
                           udp_checksum        <= udp_checksum;
                           ip_checksum         <= ip_checksum;
                           checksum_fifo_rd_en <= 1'b0;
                           checksum_fifo_wr_en <= 1'b0;
                           checksum_fifo_din   <= 32'b0;
                        end
                   PUT_MAC2:
                        begin
                           if(M_AXIS_TREADY == 1'b1)
	                           begin
	                               ram_dpra            <= ram_dpra + 1;
	                           end
	                       else
	                           begin
	                               ram_dpra            <= ram_dpra;
	                           end
	                       start_to_read       <= 1'b0;                                          
	                       fifo_recv_len       <= fifo_recv_len;           //im_fifo receive 256*4 bytes
	                       m_axis_tvalid       <= 1'b1;
                           m_axis_tdata        <= ram_qdpo;
                           m_axis_tkeep        <= 4'hf;
                           m_axis_tlast        <= 1'b0;
                           packet_no           <= packet_no;
                           packet_no_reg0      <= {packet_no[7:0], 8'b0};
                           packet_no_reg1      <= {8'b0, packet_no[15:8]};
                           elapsed_time_reg    <= elapsed_time_reg;
                           elapsed_time_reg0   <= {elapsed_time_reg[7:0], 8'b0};
                           elapsed_time_reg1   <= {8'b0, elapsed_time_reg[15:8]};
                           elapsed_time_reg2   <= {elapsed_time_reg[23:16],8'b0};
                           elapsed_time_reg3   <= {8'b0,elapsed_time_reg[31:24]};
                           pixel_d0            <= 32'b0; 
                           udp_checksum        <= udp_checksum;
                           ip_checksum         <= ip_checksum;
                           checksum_fifo_rd_en <= 1'b0;
                           checksum_fifo_wr_en <= 1'b0;
                           checksum_fifo_din   <= 32'b0;
                        end
	               PUT_TYPE_VER_SERVICE:
                        begin
                           if(M_AXIS_TREADY == 1'b1)
	                           begin
	                               ram_dpra            <= ram_dpra + 1;
	                           end
	                       else
	                           begin
	                               ram_dpra            <= ram_dpra;
	                           end
	                       start_to_read       <= 1'b0;                                      
	                       fifo_recv_len       <= fifo_recv_len;           //im_fifo receive 256*4 bytes
	                       m_axis_tvalid       <= 1'b1;
                           m_axis_tdata        <= ram_qdpo;
                           m_axis_tkeep        <= 4'hf;
                           m_axis_tlast        <= 1'b0;
                           packet_no           <= packet_no;
                           packet_no_reg0      <= {packet_no[7:0], 8'b0};
                           packet_no_reg1      <= {8'b0, packet_no[15:8]};
                           elapsed_time_reg    <= elapsed_time_reg;
                           elapsed_time_reg0   <= {elapsed_time_reg[7:0], 8'b0};
                           elapsed_time_reg1   <= {8'b0, elapsed_time_reg[15:8]};
                           elapsed_time_reg2   <= {elapsed_time_reg[23:16],8'b0};
                           elapsed_time_reg3   <= {8'b0,elapsed_time_reg[31:24]};
                           pixel_d0            <= 32'b0; 
                           udp_checksum        <= udp_checksum;
                           ip_checksum         <= ip_checksum;
                           checksum_fifo_rd_en <= 1'b0;
                           checksum_fifo_wr_en <= 1'b0;
                           checksum_fifo_din   <= 32'b0;
                        end
                   PUT_TOTAL_LEN_ID:
                        begin
                           if(M_AXIS_TREADY == 1'b1)
	                           begin
	                               ram_dpra            <= ram_dpra + 1;
	                           end
	                       else
	                           begin
	                               ram_dpra            <= ram_dpra;
	                           end
	                       start_to_read       <= 1'b0;                                           
	                       fifo_recv_len       <= fifo_recv_len;           //im_fifo receive 256*4 bytes
	                       m_axis_tvalid       <= 1'b1;
                           m_axis_tdata        <= {packet_no[7:0], packet_no[15:8], ram_qdpo[15:0]};
                           m_axis_tkeep        <= 4'hf;
                           m_axis_tlast        <= 1'b0;
                           packet_no           <= packet_no;
                           packet_no_reg0      <= {packet_no[7:0], 8'b0};
                           packet_no_reg1      <= {8'b0, packet_no[15:8]};
                           elapsed_time_reg    <= elapsed_time_reg;
                           elapsed_time_reg0   <= {elapsed_time_reg[7:0], 8'b0};
                           elapsed_time_reg1   <= {8'b0, elapsed_time_reg[15:8]};
                           elapsed_time_reg2   <= {elapsed_time_reg[23:16],8'b0};
                           elapsed_time_reg3   <= {8'b0,elapsed_time_reg[31:24]};
                           pixel_d0            <= 32'b0; 
                           udp_checksum        <= udp_checksum;
                           ip_checksum         <= ip_checksum;
                           checksum_fifo_rd_en <= 1'b0;
                           checksum_fifo_wr_en <= 1'b0;
                           checksum_fifo_din   <= 32'b0;
                        end
                   PUT_FLAGS_TTL_PROTOCOL:
                        begin
                           if(M_AXIS_TREADY == 1'b1)
	                           begin
	                               ram_dpra            <= ram_dpra + 1;
	                           end
	                       else
	                           begin
	                               ram_dpra            <= ram_dpra;
	                           end
	                       start_to_read       <= 1'b0;                                            
	                       fifo_recv_len       <= fifo_recv_len;           //im_fifo receive 256*4 bytes
	                       m_axis_tvalid       <= 1'b1;
                           m_axis_tdata        <= ram_qdpo;
                           m_axis_tkeep        <= 4'hf;
                           m_axis_tlast        <= 1'b0;
                           packet_no           <= packet_no;
                           packet_no_reg0      <= {packet_no[7:0], 8'b0};
                           packet_no_reg1      <= {8'b0, packet_no[15:8]};
                           elapsed_time_reg    <= elapsed_time_reg;
                           elapsed_time_reg0   <= {elapsed_time_reg[7:0], 8'b0};
                           elapsed_time_reg1   <= {8'b0, elapsed_time_reg[15:8]};
                           elapsed_time_reg2   <= {elapsed_time_reg[23:16],8'b0};
                           elapsed_time_reg3   <= {8'b0,elapsed_time_reg[31:24]};
                           pixel_d0            <= 32'b0; 
                           udp_checksum        <= udp_checksum;
                           ip_checksum         <= ip_checksum;
                           checksum_fifo_rd_en <= 1'b0;
                           checksum_fifo_wr_en <= 1'b0;
                           checksum_fifo_din   <= 32'b0; 
                        end
                   PUT_CHECKSUM_SRC_IP0:
                        begin
                           if(M_AXIS_TREADY == 1'b1)
	                           begin
	                               ram_dpra            <= ram_dpra + 1;
	                           end
	                       start_to_read       <= 1'b0;                               	                               
	                       fifo_recv_len       <= fifo_recv_len;           //im_fifo receive 256*4 bytes
	                       m_axis_tvalid       <= 1'b1;
                           m_axis_tdata        <= {ram_qdpo[31:16], ~ip_checksum[7:0],~ip_checksum[15:8]};
                           m_axis_tkeep        <= 4'hf;
                           m_axis_tlast        <= 1'b0;
                           packet_no           <= packet_no;
                           packet_no_reg0      <= {packet_no[7:0], 8'b0};
                           packet_no_reg1      <= {8'b0, packet_no[15:8]};
                           elapsed_time_reg    <= elapsed_time_reg;
                           elapsed_time_reg0   <= {elapsed_time_reg[7:0], 8'b0};
                           elapsed_time_reg1   <= {8'b0, elapsed_time_reg[15:8]};
                           elapsed_time_reg2   <= {elapsed_time_reg[23:16],8'b0};
                           elapsed_time_reg3   <= {8'b0,elapsed_time_reg[31:24]};
                           pixel_d0            <= 32'b0; 
                           udp_checksum        <= udp_checksum;
                           ip_checksum         <= ip_checksum;
                           checksum_fifo_rd_en <= 1'b0;
                           checksum_fifo_wr_en <= 1'b0;
                           checksum_fifo_din   <= 32'b0; 
                        end
                   PUT_SRC_IP1_DST_IP0:
                        begin
                           if(M_AXIS_TREADY == 1'b1)
	                           begin
	                               ram_dpra            <= ram_dpra + 1;
	                           end
	                       else
	                           begin
	                               ram_dpra            <= ram_dpra;
	                           end
	                       start_to_read       <= 1'b0;                                           
	                       fifo_recv_len       <= fifo_recv_len;           //im_fifo receive 256*4 bytes
	                       m_axis_tvalid       <= 1'b1;
                           m_axis_tdata        <= ram_qdpo;
                           m_axis_tkeep        <= 4'hf;
                           m_axis_tlast        <= 1'b0;
                           packet_no           <= packet_no;
                           packet_no_reg0      <= {packet_no[7:0], 8'b0};
                           packet_no_reg1      <= {8'b0, packet_no[15:8]};
                           elapsed_time_reg    <= elapsed_time_reg;
                           elapsed_time_reg0   <= {elapsed_time_reg[7:0], 8'b0};
                           elapsed_time_reg1   <= {8'b0, elapsed_time_reg[15:8]};
                           elapsed_time_reg2   <= {elapsed_time_reg[23:16],8'b0};
                           elapsed_time_reg3   <= {8'b0,elapsed_time_reg[31:24]};
                           pixel_d0            <= 32'b0; 
                           udp_checksum        <= udp_checksum;
                           ip_checksum         <= ip_checksum;
                           checksum_fifo_rd_en <= 1'b0;
                           checksum_fifo_wr_en <= 1'b0;
                           checksum_fifo_din   <= 32'b0; 
                        end
                   PUT_DST_IP1_SRC_PORT:
                        begin
                           if(M_AXIS_TREADY == 1'b1)
	                           begin
	                               ram_dpra            <= ram_dpra + 1;
	                           end
	                       else
	                           begin
	                               ram_dpra            <= ram_dpra;
	                           end
	                       start_to_read       <= 1'b0;                                           
	                       fifo_recv_len       <= fifo_recv_len;           //im_fifo receive 256*4 bytes
	                       m_axis_tvalid       <= 1'b1;
                           m_axis_tdata        <= ram_qdpo;
                           m_axis_tkeep        <= 4'hf;
                           m_axis_tlast        <= 1'b0;
                           packet_no           <= packet_no;
                           packet_no_reg0      <= {packet_no[7:0], 8'b0};
                           packet_no_reg1      <= {8'b0, packet_no[15:8]};
                           elapsed_time_reg    <= elapsed_time_reg;
                           elapsed_time_reg0   <= {elapsed_time_reg[7:0], 8'b0};
                           elapsed_time_reg1   <= {8'b0, elapsed_time_reg[15:8]};
                           elapsed_time_reg2   <= {elapsed_time_reg[23:16],8'b0};
                           elapsed_time_reg3   <= {8'b0,elapsed_time_reg[31:24]};
                           pixel_d0            <= 32'b0; 
                           udp_checksum        <= udp_checksum;
                           ip_checksum         <= ip_checksum;
                           checksum_fifo_rd_en <= 1'b0;
                           checksum_fifo_wr_en <= 1'b0;
                           checksum_fifo_din   <= 32'b0;
                        end
                   PUT_DST_PORT_LENGTH:
                        begin
                           if(M_AXIS_TREADY == 1'b1)
	                           begin
	                               ram_dpra            <= ram_dpra + 1;
	                           end
	                       else
	                           begin
	                               ram_dpra            <= ram_dpra;
	                           end
	                       start_to_read       <= 1'b0;                                          
	                       fifo_recv_len       <= fifo_recv_len;           //im_fifo receive 256*4 bytes
	                       m_axis_tvalid       <= 1'b1;
                           m_axis_tdata        <= ram_qdpo;
                           m_axis_tkeep        <= 4'hf;
                           m_axis_tlast        <= 1'b0;
                           packet_no           <= packet_no;
                           packet_no_reg0      <= {packet_no[7:0], 8'b0};
                           packet_no_reg1      <= {8'b0, packet_no[15:8]};
                           elapsed_time_reg    <= elapsed_time_reg;
                           elapsed_time_reg0   <= {elapsed_time_reg[7:0], 8'b0};
                           elapsed_time_reg1   <= {8'b0, elapsed_time_reg[15:8]};
                           elapsed_time_reg2   <= {elapsed_time_reg[23:16],8'b0};
                           elapsed_time_reg3   <= {8'b0,elapsed_time_reg[31:24]};
                           pixel_d0            <= 32'b0; 
                           udp_checksum        <= udp_checksum;
                           ip_checksum         <= ip_checksum;
                           checksum_fifo_rd_en <= 1'b0;
                           checksum_fifo_wr_en <= 1'b0;
                           checksum_fifo_din   <= 32'b0;
                        end
                   PUT_CHECKSUM_ACQMODE:
                        begin
	                       ram_dpra            <= ram_dpra;
	                       start_to_read       <= 1'b0;                                           
	                       fifo_recv_len       <= fifo_recv_len;           //im_fifo receive 256*4 bytes
	                       m_axis_tvalid       <= 1'b1;
                           //m_axis_tdata        <= {8'h00, ACQ_MODE_HS_IM, ~udp_checksum[7:0], ~udp_checksum[15:8]};
                           m_axis_tdata        <= {8'h00, acq_mode, ~udp_checksum[7:0], ~udp_checksum[15:8]};
                           m_axis_tkeep        <= 4'hf;
                           m_axis_tlast        <= 1'b0;
                           packet_no           <= packet_no;
                           packet_no_reg0      <= {packet_no[7:0], 8'b0};
                           packet_no_reg1      <= {8'b0, packet_no[15:8]};
                           elapsed_time_reg    <= elapsed_time_reg;
                           elapsed_time_reg0   <= {elapsed_time_reg[7:0], 8'b0};
                           elapsed_time_reg1   <= {8'b0, elapsed_time_reg[15:8]};
                           elapsed_time_reg2   <= {elapsed_time_reg[23:16],8'b0};
                           elapsed_time_reg3   <= {8'b0,elapsed_time_reg[31:24]};
                           pixel_d0            <= 32'b0; 
                           udp_checksum        <= udp_checksum;
                           ip_checksum         <= ip_checksum;
                           checksum_fifo_rd_en <= 1'b0;
                           checksum_fifo_wr_en <= 1'b0;
                           checksum_fifo_din   <= 32'b0;
                        end
	               PUT_PACKET_NO_BOARD_LOC:                                        //board loc is from the ram, which is written by sdk,                                                          
	                   begin        
	                       if(M_AXIS_TREADY == 1'b1)
	                           begin
	                               packet_no           <= packet_no + 1;               // packet_no plus 1 
	                           end
	                       else
	                           begin
	                               packet_no           <= packet_no;
	                           end                                              //so we don't need hardware connection here
	                       start_to_read       <= 1'b0;                                           
	                       fifo_recv_len       <= fifo_recv_len;           //im_fifo receive 256*4 bytes
	                       ram_dpra            <= ram_dpra;                //keep the address, we need the third and forth byte read from the ram later
	                       m_axis_tdata        <= {ram_qdpo[15:0], packet_no}; 
	                       m_axis_tvalid       <= 1'b1;                    
                           m_axis_tkeep        <= 4'hf;                    // all the four byes are valid
                           m_axis_tlast        <= 1'b0;                    // it's not the last byte transfer to the axis interface
                           pixel_d0            <= 32'b0; 
                           packet_no_reg0      <= {packet_no[7:0], 8'b0};
                           packet_no_reg1      <= {8'b0, packet_no[15:8]};
                           elapsed_time_reg    <= elapsed_time_reg;
                           elapsed_time_reg0   <= {elapsed_time_reg[7:0], 8'b0};
                           elapsed_time_reg1   <= {8'b0, elapsed_time_reg[15:8]};
                           elapsed_time_reg2   <= {elapsed_time_reg[23:16],8'b0};
                           elapsed_time_reg3   <= {8'b0,elapsed_time_reg[31:24]};
                           udp_checksum        <= 32'b0;
                           ip_checksum         <= 32'b0;
                           checksum_fifo_rd_en <= 1'b0;
                           checksum_fifo_wr_en <= 1'b0;
                           checksum_fifo_din   <= 32'b0;
	                   end
	               PUT_UTC:
	                   begin
	                       start_to_read       <= 1'b0;                                            
	                       fifo_recv_len       <= fifo_recv_len;           //im_fifo receive 256*4 bytes
	                       ram_dpra            <= 5'b0;                    // reset the ram_dpra for next cycle
	                       m_axis_tdata        <= {32'b0}; 
	                       m_axis_tvalid       <= 1'b1;                    
                           m_axis_tkeep        <= 4'hf;                    // all the four byes are valid
                           m_axis_tlast        <= 1'b0;                    // it's not the last byte transfer to the axis interface
                           packet_no           <= packet_no;               // packet_no plus 1
                           packet_no_reg0      <= {packet_no[7:0], 8'b0};
                           packet_no_reg1      <= {8'b0, packet_no[15:8]};
                           elapsed_time_reg    <= elapsed_time_reg;
                           elapsed_time_reg0   <= {elapsed_time_reg[7:0], 8'b0};
                           elapsed_time_reg1   <= {8'b0, elapsed_time_reg[15:8]};
                           elapsed_time_reg2   <= {elapsed_time_reg[23:16],8'b0};
                           elapsed_time_reg3   <= {8'b0,elapsed_time_reg[31:24]};
                           pixel_d0            <= 32'b0;
                           udp_checksum        <= 32'b0;
                           ip_checksum         <= 32'b0;
                           checksum_fifo_rd_en <= 1'b0;
                           checksum_fifo_wr_en <= 1'b0;
                           checksum_fifo_din   <= 32'b0; 
	                   end
	               PUT_NANOSEC:
	                   begin
	                       start_to_read       <= 1'b0;                                           
	                       fifo_recv_len       <= fifo_recv_len;           //im_fifo receive 256*4 bytes
	                       ram_dpra            <= 5'b0;                    // reset the ram_dpra for next cycle
	                       m_axis_tdata        <= elapsed_time_reg; //time resolution here is 1ns
	                       m_axis_tvalid       <= 1'b1;                    
                           m_axis_tkeep        <= 4'hf;                    // all the four byes are valid
                           m_axis_tlast        <= 1'b0;                    // it's not the last byte transfer to the axis interface
                           packet_no           <= packet_no;               // packet_no plus 1
                           packet_no_reg0      <= {packet_no[7:0], 8'b0};
                           packet_no_reg1      <= {8'b0, packet_no[15:8]};
                           elapsed_time_reg    <= elapsed_time_reg;
                           elapsed_time_reg0   <= {elapsed_time_reg[7:0], 8'b0};
                           elapsed_time_reg1   <= {8'b0, elapsed_time_reg[15:8]};
                           elapsed_time_reg2   <= {elapsed_time_reg[23:16],8'b0};
                           elapsed_time_reg3   <= {8'b0,elapsed_time_reg[31:24]};
                           pixel_d0            <= 32'b0; 
                           udp_checksum        <= 32'b0;
                           ip_checksum         <= 32'b0;
                           checksum_fifo_rd_en <= M_AXIS_TREADY;
                           checksum_fifo_wr_en <= 1'b0;
                           checksum_fifo_din   <= 32'b0;
	                   end
	               PUT_UNUSED_PIXEL_DATA:
	                   begin
	                       if(M_AXIS_TREADY == 1'b1)
	                           begin
	                               fifo_recv_len       <= fifo_recv_len-1;           //im_fifo receive 256*4 bytes
	                           end
	                       else
	                           begin
	                               fifo_recv_len       <= fifo_recv_len;
	                           end
	                       start_to_read       <= 1'b0;                                           
	                       ram_dpra            <= 5'b0;                    // reset the ram_dpra for next cycle
	                       m_axis_tdata        <= {pixel_data[15:0], 16'b0}; 
	                       m_axis_tvalid       <= 1'b1;                    
                           m_axis_tkeep        <= 4'hf;                    // all the four byes are valid
                           m_axis_tlast        <= 1'b0;                    // it's not the last byte transfer to the axis interface
                           packet_no           <= packet_no;               // packet_no plus 1
                           packet_no_reg0      <= {packet_no[7:0], 8'b0};
                           packet_no_reg1      <= {8'b0, packet_no[15:8]};
                           elapsed_time_reg    <= elapsed_time_reg;
                           elapsed_time_reg0   <= {elapsed_time_reg[7:0], 8'b0};
                           elapsed_time_reg1   <= {8'b0, elapsed_time_reg[15:8]};
                           elapsed_time_reg2   <= {elapsed_time_reg[23:16],8'b0};
                           elapsed_time_reg3   <= {8'b0,elapsed_time_reg[31:24]};
                           pixel_d0            <= pixel_data; 
                           udp_checksum        <= 32'b0;
                           ip_checksum         <= 32'b0;
                           checksum_fifo_rd_en <= M_AXIS_TREADY;
                           checksum_fifo_wr_en <= 1'b0;
                           checksum_fifo_din   <= 32'b0;
	                   end
	               PUT_PIXEL_DATA:
	                   begin
	                       if(M_AXIS_TREADY == 1'b1)
	                           begin
	                               fifo_recv_len       <= fifo_recv_len-1;           //im_fifo receive 256*4 bytes
	                           end
	                       else
	                           begin
	                               fifo_recv_len       <= fifo_recv_len;
	                           end
	                       start_to_read       <= 1'b0;                                            
	                       ram_dpra            <= 5'b0;                    // reset the ram_dpra for next cycle
	                       m_axis_tdata        <= {pixel_data[15:0],pixel_d0[31:16]}; 
	                       m_axis_tvalid       <= 1'b1;                    
                           m_axis_tkeep        <= 4'hf;                    // all the four byes are valid
                           m_axis_tlast        <= 1'b0;                    // it's not the last byte transfer to the axis interface
                           packet_no           <= packet_no;               // packet_no plus 1
                           packet_no_reg0      <= {packet_no[7:0], 8'b0};
                           packet_no_reg1      <= {8'b0, packet_no[15:8]};
                           elapsed_time_reg    <= elapsed_time_reg;
                           elapsed_time_reg0   <= {elapsed_time_reg[7:0], 8'b0};
                           elapsed_time_reg1   <= {8'b0, elapsed_time_reg[15:8]};
                           elapsed_time_reg2   <= {elapsed_time_reg[23:16],8'b0};
                           elapsed_time_reg3   <= {8'b0,elapsed_time_reg[31:24]};
                           pixel_d0            <= pixel_data; 
                           udp_checksum        <= 32'b0;
                           ip_checksum         <= 32'b0;
                           checksum_fifo_rd_en <= M_AXIS_TREADY;
                           checksum_fifo_wr_en <= 1'b0;
                           checksum_fifo_din   <= 32'b0;
	                   end
	               PUT_LAST:
	                   begin
	                       start_to_read       <= 1'b0;                                           
	                       fifo_recv_len       <= fifo_recv_len;           //im_fifo receive 256*4 bytes
	                       ram_dpra            <= 5'b0;                    // reset the ram_dpra for next cycle
	                       m_axis_tdata        <= {16'b0, pixel_d0[31:16]}; 
	                       m_axis_tvalid       <= 1'b1;                    
                           m_axis_tkeep        <= 4'h3;                    // all the four byes are valid
                           m_axis_tlast        <= 1'b1;                    // it's not the last byte transfer to the axis interface
                           packet_no           <= packet_no;               // packet_no plus 1
                           packet_no_reg0      <= {packet_no[7:0], 8'b0};
                           packet_no_reg1      <= {8'b0, packet_no[15:8]};
                           elapsed_time_reg    <= elapsed_time_reg;
                           elapsed_time_reg0   <= {elapsed_time_reg[7:0], 8'b0};
                           elapsed_time_reg1   <= {8'b0, elapsed_time_reg[15:8]};
                           elapsed_time_reg2   <= {elapsed_time_reg[23:16],8'b0};
                           elapsed_time_reg3   <= {8'b0,elapsed_time_reg[31:24]};
                           pixel_d0            <= pixel_data; 
                           udp_checksum        <= 32'b0;
                           ip_checksum         <= 32'b0;
                           checksum_fifo_rd_en <= M_AXIS_TREADY;
                           checksum_fifo_wr_en <= 1'b0;
                           checksum_fifo_din   <= 32'b0;
	                   end
	               default:
	                   begin
	                       start_to_read       <= 1'b0;
	                       fifo_recv_len       <= 32'b0;
	                       //we dont care about the following signals until the hs_im_state goes to CORRECT_LEN 
	                       ram_dpra            <= 5'b0;
	                       m_axis_tvalid       <= 1'b0;
                           m_axis_tdata        <= 32'b0;
                           m_axis_tkeep        <= 4'b0;
                           m_axis_tlast        <= 1'b0;
                           packet_no           <= 16'b0;
                           packet_no_reg0      <= 16'b0;
                           packet_no_reg1      <= 16'b0;
                           elapsed_time_reg    <= 32'b0;
                           elapsed_time_reg0   <= 16'b0;
                           elapsed_time_reg1   <= 16'b0;
                           elapsed_time_reg2   <= 16'b0;
                           elapsed_time_reg3   <= 16'b0;
                           pixel_d0            <= 32'b0; 
                           udp_checksum        <= 32'b0;
                           ip_checksum         <= 32'b0;
                           checksum_fifo_rd_en <= 1'b0;
                           checksum_fifo_wr_en <= 1'b0;
                           checksum_fifo_din   <= 32'b0;
	                   end
            endcase   
        end   
    end     
endmodule
