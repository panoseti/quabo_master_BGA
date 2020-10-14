#include "string.h"
#include "xil_io.h"
#include "packet_header.h"


//we want big-endian here, mb is a little-endian core
//ethpacketheader is used for sending to fpga
//don't change it manually!!!!
//you can change ethpacketheader_user, if you want.
Panoseti_EthPacketHeader ethpacketheader;
Panoseti_EthPacketHeader *ethpacketheader_ptr = &ethpacketheader;

//ethpacketheader_user is for user
Panoseti_EthPacketHeader ethpacketheader_user=
{
	0x00000000,							//checksum2, this paramter will be used in fpga,
										//so we need to change the byte sequence
	0x00000000,								//checksum1
	{0x00,0x00,0x00,0x00,0x00,0x00},	//dst_mac	keys
	{0x00,0x00,0x00,0x00,0x00,0x00},	//src_mac	keys
	0x0800,								//type
	0x45,								//version_headerlen
	0x00,								//servicefiled
	0x022c,								//total_len
	0x0000,								//ideftification
	0x0000,								//flags
	0xff,								//timelive
	0x11,								//protocol-udp
	0x0000,
	{192,168,0,0},						//src_ip	keys
	{192,168,1,100},					//dst_ip	keys
	0xc001,								//src_port	keys
	0xea61,								//dst_port	keys
	0x0218,								//length
	{0x00,0x00,0x00,0x00},				//board_loc	keys
	0x03								//acqmode
};
Panoseti_EthPacketHeader *ethpacketheader_user_ptr = &ethpacketheader_user;

//calcute the IP header checksum
void Cal_IP_Checksum(){
	unsigned int checksum_sum = 0;
	checksum_sum += ethpacketheader_user_ptr->version_headerlen *256;
	checksum_sum += ethpacketheader_user_ptr->servicefield;
	checksum_sum += ethpacketheader_user_ptr->total_len;
	checksum_sum += ethpacketheader_user_ptr->identification;
	checksum_sum += ethpacketheader_user_ptr->flags;
	checksum_sum += ethpacketheader_user_ptr->timelive *256;
	checksum_sum += ethpacketheader_user_ptr->protocol;
	checksum_sum += ethpacketheader_user_ptr->src_ip[0] *256;
	checksum_sum += ethpacketheader_user_ptr->src_ip[1];
	checksum_sum += ethpacketheader_user_ptr->src_ip[2] *256;
	checksum_sum += ethpacketheader_user_ptr->src_ip[3];
	checksum_sum += ethpacketheader_user_ptr->dst_ip[0] *256;
	checksum_sum += ethpacketheader_user_ptr->dst_ip[1];
	checksum_sum += ethpacketheader_user_ptr->dst_ip[2] *256;
	checksum_sum += ethpacketheader_user_ptr->dst_ip[3];
	//while((checksum_sum & (0xffff0000))>0)
	//{
		//checksum_sum = ((checksum_sum>>16) & (0x0000ffff)) + (checksum_sum & 0x0000ffff);
	//}
	//the checksum should be (ffff-checksum_sum &0x0000ffff), which is finished in fpga
	//ethpacketheader_user_ptr->ip_checksum_part = 65535-(checksum_sum & 0x0000ffff);
	ethpacketheader_user_ptr->ip_checksum_part = checksum_sum;
}

//cal the udp packet checksum
//it's not the final result, and this value will be used in fpga
void Cal_UDP_ChecksumPart(){
	unsigned int checksum_sum = 0;
	checksum_sum += ethpacketheader_user_ptr->src_ip[0] *256;
	checksum_sum += ethpacketheader_user_ptr->src_ip[1];
	checksum_sum += ethpacketheader_user_ptr->src_ip[2] *256;
	checksum_sum += ethpacketheader_user_ptr->src_ip[3];
	checksum_sum += ethpacketheader_user_ptr->dst_ip[0] *256;
	checksum_sum += ethpacketheader_user_ptr->dst_ip[1];
	checksum_sum += ethpacketheader_user_ptr->dst_ip[2] *256;
	checksum_sum += ethpacketheader_user_ptr->dst_ip[3];
	checksum_sum += ethpacketheader_user_ptr->protocol;
	checksum_sum += ethpacketheader_user_ptr->length;
	checksum_sum += ethpacketheader_user_ptr->src_port;
	checksum_sum += ethpacketheader_user_ptr->dst_port;
	checksum_sum += ethpacketheader_user_ptr->length;
	//the following is part of data
	checksum_sum += ethpacketheader_user_ptr->board_loc[0] *256;
	checksum_sum += ethpacketheader_user_ptr->board_loc[1];
	checksum_sum +=	ethpacketheader_user_ptr->acqmode *256;

	ethpacketheader_user_ptr->udp_checksum_part = checksum_sum;
}
//
void EthPacketHeader_for_FPGA_Init(){
	ethpacketheader_ptr->udp_checksum_part = ethpacketheader_user_ptr->udp_checksum_part;		//uint
	ethpacketheader_ptr->ip_checksum_part = ethpacketheader_user_ptr->ip_checksum_part;			//uint
	memcpy(ethpacketheader_ptr->dst_mac, ethpacketheader_user_ptr->dst_mac,6);					//*char
	memcpy(ethpacketheader_ptr->src_mac, ethpacketheader_user_ptr->src_mac,6);					//*char
	ethpacketheader_ptr->type = PP_HTONS(ethpacketheader_user_ptr->type);						//ushort
	ethpacketheader_ptr->version_headerlen = ethpacketheader_user_ptr->version_headerlen;		//char
	ethpacketheader_ptr->servicefield = ethpacketheader_user_ptr->servicefield;					//char
	ethpacketheader_ptr->total_len = PP_HTONS(ethpacketheader_user_ptr->total_len);				//ushort
	ethpacketheader_ptr->identification = PP_HTONS(ethpacketheader_user_ptr->identification);	//ushort
	ethpacketheader_ptr->flags = PP_HTONS(ethpacketheader_user_ptr->flags);						//ushort
	ethpacketheader_ptr->timelive = ethpacketheader_user_ptr->timelive;							//char
	ethpacketheader_ptr->protocol = ethpacketheader_user_ptr->protocol;							//char
	ethpacketheader_ptr->unused = 0x0000;														//ushort
	memcpy(ethpacketheader_ptr->src_ip, ethpacketheader_user_ptr->src_ip,4);					//*char
	memcpy(ethpacketheader_ptr->dst_ip, ethpacketheader_user_ptr->dst_ip,4);					//*char
	ethpacketheader_ptr->src_port = PP_HTONS(ethpacketheader_user_ptr->src_port);				//ushort
	ethpacketheader_ptr->dst_port = PP_HTONS(ethpacketheader_user_ptr->dst_port);				//ushort
	ethpacketheader_ptr->length = PP_HTONS(ethpacketheader_user_ptr->length);					//ushort
	memcpy(ethpacketheader_ptr->board_loc, ethpacketheader_user_ptr->board_loc,4);				//*char
}
//config the packet header struct
char Panoseti_EthPacketHeader_Init(EthPacketHeader_Keys *ethpacketheader_keys)
{
	memcpy(ethpacketheader_user_ptr->dst_mac, ethpacketheader_keys->dst_mac,6);
	memcpy(ethpacketheader_user_ptr->src_mac, ethpacketheader_keys->src_mac,6);
	memcpy(ethpacketheader_user_ptr->dst_ip, ethpacketheader_keys->dst_ip,4);
	memcpy(ethpacketheader_user_ptr->src_ip, ethpacketheader_keys->src_ip,4);
	ethpacketheader_user_ptr->dst_port  = ethpacketheader_keys->dst_port;
	ethpacketheader_user_ptr->src_port  = ethpacketheader_keys->src_port;
	memcpy(ethpacketheader_user_ptr->board_loc, ethpacketheader_keys->board_loc,4);
	ethpacketheader_user_ptr->acqmode = ethpacketheader_keys->acqmode;
	ethpacketheader_user_ptr->total_len = ethpacketheader_keys->total_len;
	ethpacketheader_user_ptr->length = ethpacketheader_keys->length;
	Cal_IP_Checksum();
	Cal_UDP_ChecksumPart();
	EthPacketHeader_for_FPGA_Init();
	//Wirte the parameters into ram in fpga
	Panoseti_WriteHeaderToRam();
	//Read the parameters back, and compare with the original paramters
	char state = 0;
	state = Panoseti_ReadHeaderFromRam();
	return state;
}

//write the packet header struct to ram in fpga
void Panoseti_WriteHeaderToRam()
{
	RAM_WE_EN();
	unsigned int *data =(unsigned int*)ethpacketheader_ptr;
	unsigned char addr = 0;
	//unsigned int tmp;
	for(addr=0; addr<EthPacketHeader_Word_Len; addr++)
	{
		WRITE_TO_RAM(addr, *(data+addr));
		//SELF_CHECK(tmp);
	}
	RAM_WE_DIS();
}

//read the packet header info back from the ram in fpga
char Panoseti_ReadHeaderFromRam()
{
	unsigned int *data = (unsigned int*)ethpacketheader_ptr;
	unsigned int tmp = 0;
	unsigned char addr = 0;
	for(addr=0; addr< EthPacketHeader_Word_Len; addr++)
	{
		READ_FROM_RAM(addr,tmp);
		if(tmp != *(data+addr))
			return -1;
	}
	return 0;
}

//get the state machine back
//because I'm working remotelt, and the jtag is connected to one quabo, which works well,
//but the other three can't work, and I don't know what happened,
//so what I can do is connect hs_im_state out, to understand what happened in fpga...
unsigned int Panoseti_GetStateMachine()
{
	unsigned int state;
	GET_STATE(state);
	return state;
}

//reset im fifo
void Panoseti_IMFIFO_Reset()
{
	int i = 0;
	Xil_Out32(AXI_RAM_ADDR+0,8);
	for(i=0; i<1000;i++); //this is for delay
	Xil_Out32(AXI_RAM_ADDR+0,0);
}
