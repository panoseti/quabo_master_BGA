#include "EthCore_Configuration.h"
#include "sleep.h"
/****************************************************************************/
/********************************Important!**********************************/
/****************************************************************************/

//This is the configuration area, where you need change to make the core work as you want!!!

#define Eth_No	0
//#define CONFIG_LINKSPEED_AUTODETECT 1
#define CONFIG_LINKSPEED1000		1
//Canonical definitions for peripheral AXI_ETHERNET_1 
#define XPAR_AXIETHERNET_1_MACADDRESS				{0x3c, 0x2c, 0x30, 0xa6, 0xa8, 0xb1}
#define XPAR_AXIETHERNET_1_DEVICE_ID 				1U
#define XPAR_AXIETHERNET_1_BASEADDR 				0x40C40000U
#define XPAR_AXIETHERNET_1_HIGHADDR 				0x40C7FFFFU
#define XPAR_AXIETHERNET_1_TEMAC_TYPE 				1U
#define XPAR_AXIETHERNET_1_TXCSUM 					0U
#define XPAR_AXIETHERNET_1_RXCSUM 					0U
#define XPAR_AXIETHERNET_1_PHY_TYPE 				5U
#define XPAR_AXIETHERNET_1_TXVLAN_TRAN 				0U
#define XPAR_AXIETHERNET_1_RXVLAN_TRAN 				0U
#define XPAR_AXIETHERNET_1_TXVLAN_TAG 				0U
#define XPAR_AXIETHERNET_1_RXVLAN_TAG 				0U
#define XPAR_AXIETHERNET_1_TXVLAN_STRP 				0U
#define XPAR_AXIETHERNET_1_RXVLAN_STRP 				0U
#define XPAR_AXIETHERNET_1_MCAST_EXTEND 			1U				//WEI
#define XPAR_AXIETHERNET_1_STATS 					1U
#define XPAR_AXIETHERNET_1_AVB 						0U
#define XPAR_AXIETHERNET_1_ENABLE_SGMII_OVER_LVDS 	0U
#define XPAR_AXIETHERNET_1_ENABLE_1588 				0U
#define XPAR_AXIETHERNET_1_SPEED 					1000U
#define XPAR_AXIETHERNET_1_NUM_TABLE_ENTRIES 		4U
#define XPAR_AXIETHERNET_1_PHYADDR 					1U
#define XPAR_AXIETHERNET_1_INTR 					0xFFU

u32 EthCore_DefaultOptions = (XAE_FLOW_CONTROL_OPTION 		|		
		 					  XAE_BROADCAST_OPTION 			|			
		 					  XAE_FCS_INSERT_OPTION 		|		
		 					  XAE_FCS_STRIP_OPTION 			|			
		 					  XAE_LENTYPE_ERR_OPTION 		|		
		 					  XAE_TRANSMITTER_ENABLE_OPTION | 	
		 					  XAE_RECEIVER_ENABLE_OPTION);

/****************************************************************************/
/****************************************************************************/
/****************************************************************************/
//The configuration table for devices
//EthCore_Config EthCore_ConfigTable[] =
//{
//	{
//		XPAR_AXIETHERNET_1_MACADDRESS,					//U8		MacAddress			/** Mac Address of the eth core */
//		XPAR_AXIETHERNET_1_DEVICE_ID,					//U16		DeviceId 			/**< DeviceId is the unique ID  of the device */
//		XPAR_AXIETHERNET_1_BASEADDR,					//UINTPTR	BaseAddress			/**< BaseAddress is the physical base address of the device's registers */
//		XPAR_AXIETHERNET_1_TEMAC_TYPE,					//U8		TemacType			/**< Temac Type can have 3 possible values: 0 for SoftTemac at 10/100 Mbps; 1 for SoftTemac at 10/100/1000 Mbps; 2 for Vitex6 Hard Temac */
//		XPAR_AXIETHERNET_1_TXCSUM,						//U8		TxCsum				/**< TxCsum indicates that the device has checksum offload on the Tx channel or not. */
//		XPAR_AXIETHERNET_1_RXCSUM,						//U8		RxCsum				/**< RxCsum indicates that the device has checksum offload on the Rx channel or not. */
//		XPAR_AXIETHERNET_1_PHY_TYPE,					//U8		PhyType				/**< PhyType indicates which type of PHY interface is used (MII, GMII, RGMII, etc.   */
//		XPAR_AXIETHERNET_1_TXVLAN_TRAN,					//U8		TxVlanTran			/**< TX VLAN Translation indication */
//		XPAR_AXIETHERNET_1_RXVLAN_TRAN,					//U8		RxVlanTran			/**< RX VLAN Translation indication */
//		XPAR_AXIETHERNET_1_TXVLAN_TAG,					//U8		TxVlanTag			/**< TX VLAN tagging indication */
//  	XPAR_AXIETHERNET_1_RXVLAN_TAG,					//U8		RxVlanTag			/**< RX VLAN tagging indication */
//		XPAR_AXIETHERNET_1_TXVLAN_STRP,					//U8		TxVlanStrp			/**< TX VLAN stripping indication */
//		XPAR_AXIETHERNET_1_RXVLAN_STRP,					//U8		RxVlanStrp			/**< RX VLAN stripping indication */
//		XPAR_AXIETHERNET_1_MCAST_EXTEND,				//U8		ExtMcast			/**< Extend multicast indication */
//		XPAR_AXIETHERNET_1_STATS,						//U8		Stats				/**< Statistics gathering option */
//		XPAR_AXIETHERNET_1_AVB,							//U8		Avb					/**< Avb option */
//		XPAR_AXIETHERNET_1_ENABLE_SGMII_OVER_LVDS,		//U8		EnableSgmiiOverLvds	/**< Enable LVDS option */
//		XPAR_AXIETHERNET_1_ENABLE_1588,					//U8		Enable_1588			/**< Enable 1588 option */
//		XPAR_AXIETHERNET_1_SPEED,						//U32		Speed					/**< Tells whether MAC is 1G or 2p5G */
//		XPAR_AXIETHERNET_1_NUM_TABLE_ENTRIES,			//U8		NumTableEntries		/**< Number of table entries */
//		XPAR_AXIETHERNET_1_INTR,						//U8		TemacIntr				/**< Axi Ethernet interrupt ID */
//		XPAR_AXIETHERNET_1_CONNECTED_TYPE,				//int		AxiDevType			/**< AxiDevType is the type of device attached to the Axi Ethernet's AXI4-Stream interface. */
//		XPAR_AXIETHERNET_1_CONNECTED_BASEADDR,			//UINTPTR	AxiDevBaseAddress		/**< AxiDevBaseAddress is the base address of the device attached to the Axi Ethernet's AXI4-Stream interface */
//		0xFF,			//U8		AxiFifoIntr			/**< AxiFifoIntr interrupt ID (unused if DMA) */
//		0xFF,											//U8		AxiDmaRxIntr			/**< Axi DMA RX interrupt ID (unused if FIFO) */
//		0xFF											//U8		AxiDmaTxIntr			/**< Axi DMA TX interrupt ID (unused if FIFO) */
														//U8		AxiMcDmaChan_Cnt		/**< Axi MCDMA Channel Count */
														//U8		AxiMcDmaRxIntr[16]	/**< Axi MCDMA Rx interrupt ID (unused if AXI DMA or FIFO) */
														//U8		AxiMcDmaTxIntr[16]	/**< AXI MCDMA TX interrupt ID (unused if AXIX DMA or FIFO) */
//	}
//};

EthCore_Config EthCore_ConfigTable[] =
{
	{
			XPAR_AXIETHERNET_1_MACADDRESS,					//U8		MacAddress			/** Mac Address of the eth core */
			XPAR_AXIETHERNET_1_DEVICE_ID,
			XPAR_AXIETHERNET_1_BASEADDR,
			XPAR_AXIETHERNET_1_TEMAC_TYPE,
			XPAR_AXIETHERNET_1_TXCSUM,
			XPAR_AXIETHERNET_1_RXCSUM,
			XPAR_AXIETHERNET_1_PHY_TYPE,
			XPAR_AXIETHERNET_1_TXVLAN_TRAN,
			XPAR_AXIETHERNET_1_RXVLAN_TRAN,
			XPAR_AXIETHERNET_1_TXVLAN_TAG,
			XPAR_AXIETHERNET_1_RXVLAN_TAG,
			XPAR_AXIETHERNET_1_TXVLAN_STRP,
			XPAR_AXIETHERNET_1_RXVLAN_STRP,
			XPAR_AXIETHERNET_1_MCAST_EXTEND,
			XPAR_AXIETHERNET_1_STATS,
			XPAR_AXIETHERNET_1_AVB,
			XPAR_AXIETHERNET_1_ENABLE_SGMII_OVER_LVDS,
			XPAR_AXIETHERNET_1_ENABLE_1588,
			XPAR_AXIETHERNET_1_SPEED,
			XPAR_AXIETHERNET_1_NUM_TABLE_ENTRIES,
			0xFF,
			XPAR_AXIETHERNET_1_CONNECTED_TYPE,
			XPAR_AXIETHERNET_1_CONNECTED_BASEADDR
	}
};
//check ready bit
#define Check_Rdy(IO_func, ADDR, VALUE, COND, TIMEOUT_US) \
 ( {	  \
	u64 timeout = TIMEOUT_US/100;    \
	if(TIMEOUT_US%100!=0)	\
		timeout++;   \
	for(;;) { \
		VALUE = IO_func(ADDR); \
		if(COND) \
			break; \
		else {    \
			usleep(100);  \
			timeout--; \
			if(timeout==0) \
			break;  \
		}  \
	}    \
	(timeout>0) ? 0 : -1;  \
 }  )

//AXI registers read/write
#define EthCore_WriteReg(BaseAddress, RegOffset, Data) 	Xil_Out32(((BaseAddress) + (RegOffset)), (Data))
#define EthCore_ReadReg(BaseAddress, RegOffset) 		(Xil_In32(((BaseAddress) + (RegOffset))))
/***************************************************************************
//EthCore_phyRead
//Decription: 	read data from phy 
//param:		BaseAddress	--EthCore baseaddress
				PhyAddress  --the address of the PHY to be read (multiple PHYs supported)
				RegisterNum	--the register number, 0-31, of the specific PHY register to read
				PhyDataPrt	--a reference to the location where the 16-bit result value is stored
****************************************************************************/
void EthCore_PhyRead(uintptr_t BaseAddress, u32 PhyAddress, u32 RegisterNum, u16 *PhyDataPtr)
{
	u32 MdioCtrlReg = 0;
	u32 value=0U;
	volatile s32 TimeoutLoops;

	/*
	 * Wait till MDIO interface is ready to accept a new transaction.
	 */
	TimeoutLoops = Check_Rdy(Xil_In32, 
						  	 BaseAddress + XAE_MDIO_MCR_OFFSET, 
						  	 value,
						  	 (value & XAE_MDIO_MCR_READY_MASK) != 0, 
						     XAE_RST_DEFAULT_TIMEOUT_VAL);
	if(-1 == TimeoutLoops){
		xil_printf("In phyRead: MDIO Interface is not ready!\n\r");
		return;
	}

	MdioCtrlReg =   ((PhyAddress << XAE_MDIO_MCR_PHYAD_SHIFT) 								&
					  XAE_MDIO_MCR_PHYAD_MASK) 												|
					((RegisterNum << XAE_MDIO_MCR_REGAD_SHIFT)& XAE_MDIO_MCR_REGAD_MASK ) 	|
					  XAE_MDIO_MCR_INITIATE_MASK 											|
			          XAE_MDIO_MCR_OP_READ_MASK;

	EthCore_WriteReg(BaseAddress, XAE_MDIO_MCR_OFFSET, MdioCtrlReg);


	/*
	 * Wait till MDIO transaction is completed.
	 */
	TimeoutLoops = Check_Rdy(Xil_In32,
							 BaseAddress+ XAE_MDIO_MCR_OFFSET, 
							 value,
							 (value & XAE_MDIO_MCR_READY_MASK)!=0,
							 XAE_RST_DEFAULT_TIMEOUT_VAL);
	if(-1 == TimeoutLoops) {
		xil_printf("In phyRead: MDIO transaction is not completed!\n\r");
		return;
	}

	/* Read data */
	*PhyDataPtr = (u16) EthCore_ReadReg(BaseAddress, XAE_MDIO_MRD_OFFSET);
}
/***************************************************************************
//EthCore_phyWrite
//Decription: 	read data from phy 
//param:		BaseAddress	--EthCore baseaddress
				PhyAddress  --the address of the PHY to be read (multiple PHYs supported)
				RegisterNum	--the register number, 0-31, of the specific PHY register to read
				PhyDataPrt	--a reference to the location where the 16-bit result value is stored
****************************************************************************/
void EthCore_PhyWrite(uintptr_t BaseAddress, u32 PhyAddress, u32 RegisterNum, u16 PhyData)
{
	u32 MdioCtrlReg = 0;
	u32 value=0U;
	volatile s32 TimeoutLoops;
	/*
	 * Wait till the MDIO interface is ready to accept a new transaction.
	 */
	TimeoutLoops = Check_Rdy(Xil_In32, 
							 BaseAddress + XAE_MDIO_MCR_OFFSET, 
							 value,
							 (value & XAE_MDIO_MCR_READY_MASK)!=0, 
							 XAE_RST_DEFAULT_TIMEOUT_VAL);
	if(-1 == TimeoutLoops) {
		xil_printf("In phyWrite: MDIO Interface is not ready!\n\r");
		return;
	}

	MdioCtrlReg =   ((PhyAddress << XAE_MDIO_MCR_PHYAD_SHIFT)								&
					XAE_MDIO_MCR_PHYAD_MASK) 												|
					((RegisterNum << XAE_MDIO_MCR_REGAD_SHIFT) & XAE_MDIO_MCR_REGAD_MASK) 	|
					XAE_MDIO_MCR_INITIATE_MASK 												|
					XAE_MDIO_MCR_OP_WRITE_MASK;

	EthCore_WriteReg(BaseAddress, XAE_MDIO_MWD_OFFSET, PhyData);
	EthCore_WriteReg(BaseAddress, XAE_MDIO_MCR_OFFSET, MdioCtrlReg);
	/*
	 * Wait till the MDIO interface is ready to accept a new transaction.
	 */
	TimeoutLoops = Check_Rdy(Xil_In32,
							 BaseAddress + XAE_MDIO_MCR_OFFSET, 
							 value,
							 (value & XAE_MDIO_MCR_READY_MASK)!=0,
							 XAE_RST_DEFAULT_TIMEOUT_VAL);
	
	if(-1 == TimeoutLoops) {
		xil_printf("In phyWrite: MDIO transaction is not completed!\n\r");
		return;
	}
}
/***************************************************************************
//EthCore_SetOptions
//Decription: 	Sets the MDIO clock divisor in the Axi Ethernet
				This function must be called once after each reset prior to accessing MII PHY registers.
				* 					f[HOSTCLK]
				*	f[MDC] = -----------------------
				*				(1 + Divisor) * 2
//param:		BaseAddress	--EthCore baseaddress
				options		--a bitmask of OR'd XAE_*_OPTION values for options to set. Options not specified are not affected.	
****************************************************************************/
void EthCore_PhySetMdioDivisor(uintptr_t BaseAddress, u8 Divisor)
{

	EthCore_WriteReg(BaseAddress,
				   	 XAE_MDIO_MC_OFFSET,
					(u32) Divisor | XAE_MDIO_MC_MDIOEN_MASK);
}
/***************************************************************************
//EthCore_UpdateDeoptions
//Decription: 	check and update dependent options for new/extended features from EthCore_ConfigTable
//param:		Deoptions--EthCore baseaddress	
****************************************************************************/
u32 EthCore_UpdateDepOptions(u32 options)
{
	u32 DepOptions = options;
		/*
	 * The extended/new features require some OPTIONS to be on/off per
	 * hardware design. We determine these extended/new functions here
	 * first and also on/off other OPTIONS later. So that dependent
	 * OPTIONS are in sync and _[Set|Clear]Options() can be performed
	 * seamlessly.
	 */

	/* Enable extended multicast option */
	if (DepOptions & XAE_EXT_MULTICAST_OPTION) {
		/*
		 * When extended multicast module is enabled in HW,
		 * XAE_PROMISC_OPTION is required to be enabled.
		 */
		if (EthCore_ConfigTable[Eth_No].ExtMcast) {
			DepOptions |= XAE_PROMISC_OPTION;
		}
	}

	/* Enable extended transmit VLAN translation option */
	if (DepOptions & XAE_EXT_TXVLAN_TRAN_OPTION) {
		/*
		 * Check if hardware is built with extend TX VLAN translation.
		 * if not, output an information message.
		 */
		if (EthCore_ConfigTable[Eth_No].TxVlanTran) {
			DepOptions |= XAE_FCS_INSERT_OPTION;
			DepOptions &= ~XAE_VLAN_OPTION;
		}
	}

	/* Enable extended receive VLAN translation option */
	if (DepOptions & XAE_EXT_RXVLAN_TRAN_OPTION) {
		/*
		 * Check if hardware is built with extend RX VLAN translation.
		 * if not, output an information message.
		 */
		if (EthCore_ConfigTable[Eth_No].RxVlanTran) {
			DepOptions |= XAE_FCS_STRIP_OPTION;
			DepOptions &= ~XAE_VLAN_OPTION;
		}
	}

	/* Enable extended transmit VLAN tag option */
	if (DepOptions & XAE_EXT_TXVLAN_TAG_OPTION) {
		/*
		 * Check if hardware is built with extend TX VLAN tagging.
		 * if not, output an information message.
		 */
		if (EthCore_ConfigTable[Eth_No].TxVlanTag) {
			DepOptions |= XAE_FCS_INSERT_OPTION;
			DepOptions &= ~XAE_VLAN_OPTION;
			DepOptions |= XAE_JUMBO_OPTION;
		}
	}

	/* Enable extended receive VLAN tag option */
	if (DepOptions & XAE_EXT_RXVLAN_TAG_OPTION) {
		/*
		 * Check if hardware is built with extend RX VLAN tagging.
		 * if not, output an information message.
		 */
		if (EthCore_ConfigTable[Eth_No].RxVlanTag) {
			DepOptions |= XAE_FCS_STRIP_OPTION;
			DepOptions &= ~XAE_VLAN_OPTION;
			DepOptions |= XAE_JUMBO_OPTION;
		}
	}

	/* Enable extended transmit VLAN strip option */
	if (DepOptions & XAE_EXT_TXVLAN_STRP_OPTION) {
		/*
		 * Check if hardware is built with extend TX VLAN stripping.
		 * if not, output an information message.
		 */
		if (EthCore_ConfigTable[Eth_No].TxVlanStrp) {
			DepOptions |= XAE_FCS_INSERT_OPTION;
			DepOptions &= ~XAE_VLAN_OPTION;
			DepOptions |= XAE_JUMBO_OPTION;
		}
	}

	/* Enable extended receive VLAN strip option */
	if (DepOptions & XAE_EXT_RXVLAN_STRP_OPTION) {
		/*
		 * Check if hardware is built with extend RX VLAN stripping.
		 * if not, output an information message.
		 */
		if (EthCore_ConfigTable[Eth_No].RxVlanStrp) {
			DepOptions |= XAE_FCS_STRIP_OPTION;
			DepOptions &= ~XAE_VLAN_OPTION;
			DepOptions |= XAE_JUMBO_OPTION;
		}
	}

	/*
	 * Options and dependent Options together is what hardware and user
	 * are happy with. But we still need to keep original options
	 * in case option(s) are set/cleared, overall options can be managed.
	 * Return DepOptions to XAxiEthernet_[Set|Clear]Options for final
	 * configuration.
	 */
	return(DepOptions);
}
/***************************************************************************
//EthCore_SetOptions
//Decription: 	enables the options.
			 	Eth Core should be stopped with EthCore_Stop() before changing options.
//param:		BaseAddress	--EthCore baseaddress
				options		--a bitmask of OR'd XAE_*_OPTION values for options to set. Options not specified are not affected.	
****************************************************************************/
void EthCore_SetOptions(uintptr_t BaseAddress, u32 Options)
{
	u32 Reg;	/* Generic register contents */
	u32 RegRcw1;	/* Reflects original contents of RCW1 */
	u32 RegTc;	/* Reflects original contents of TC  */
	u32 RegNewRcw1;	/* Reflects new contents of RCW1 */
	u32 RegNewTc;	/* Reflects new contents of TC  */
	u32 DepOptions;	/* Required dependent options for new features */
	/*
	 * Set options word to its new value.
	 * The step is required before calling _UpdateDepOptions() since
	 * we are operating on updated options.
	 */
	EthCore_DefaultOptions |= Options;

	/*
	 * There are options required to be on/off per hardware requirement.
	 * Invoke _UpdateDepOptions to check hardware availability and update
	 * options accordingly.
	 */
	DepOptions = EthCore_UpdateDepOptions(EthCore_DefaultOptions);

	/*
	 * New/extended function bit should be on if any new/extended features
	 * are on and hardware is built with them.
	 */
	if (DepOptions & (XAE_EXT_MULTICAST_OPTION   |
			  XAE_EXT_TXVLAN_TRAN_OPTION |
			  XAE_EXT_RXVLAN_TRAN_OPTION |
			  XAE_EXT_TXVLAN_TAG_OPTION  |
			  XAE_EXT_RXVLAN_TAG_OPTION  |
			  XAE_EXT_TXVLAN_STRP_OPTION |
			  XAE_EXT_RXVLAN_STRP_OPTION)) {

		EthCore_WriteReg(BaseAddress, XAE_RAF_OFFSET, EthCore_ReadReg(BaseAddress,XAE_RAF_OFFSET) | XAE_RAF_NEWFNCENBL_MASK);
	}

	/*
	 * Many of these options will change the RCW1 or TC registers.
	 * To reduce the amount of IO to the device, group these options here
	 * and change them all at once.
	 */
	/* Get current register contents */
	RegRcw1 = EthCore_ReadReg(BaseAddress, XAE_RCW1_OFFSET);
	RegTc = EthCore_ReadReg(BaseAddress, XAE_TC_OFFSET);
	RegNewRcw1 = RegRcw1;
	RegNewTc = RegTc;

	/* Turn on jumbo packet support for both Rx and Tx */
	if (DepOptions & XAE_JUMBO_OPTION) {
		RegNewTc |= XAE_TC_JUM_MASK;
		RegNewRcw1 |= XAE_RCW1_JUM_MASK;
	}

	/* Turn on VLAN packet support for both Rx and Tx */
	if (DepOptions & XAE_VLAN_OPTION) {
		RegNewTc |= XAE_TC_VLAN_MASK;
		RegNewRcw1 |= XAE_RCW1_VLAN_MASK;
	}

	/* Turn on FCS stripping on receive packets */
	if (DepOptions & XAE_FCS_STRIP_OPTION) {
		RegNewRcw1 &= ~XAE_RCW1_FCS_MASK;
	}

	/* Turn on FCS insertion on transmit packets */
	if (DepOptions & XAE_FCS_INSERT_OPTION) {
		RegNewTc &= ~XAE_TC_FCS_MASK;
	}

	/* Turn on length/type field checking on receive packets */
	if (DepOptions & XAE_LENTYPE_ERR_OPTION) {
		RegNewRcw1 &= ~XAE_RCW1_LT_DIS_MASK;
	}

	/* Enable transmitter */
	if (DepOptions & XAE_TRANSMITTER_ENABLE_OPTION) {
		RegNewTc |= XAE_TC_TX_MASK;
	}

	/* Enable receiver */
	if (DepOptions & XAE_RECEIVER_ENABLE_OPTION) {
		RegNewRcw1 |= XAE_RCW1_RX_MASK;
	}

	/* Change the TC or RCW1 registers if they need to be modified */
	if (RegTc != RegNewTc) {
		EthCore_WriteReg(BaseAddress,
						XAE_TC_OFFSET, RegNewTc);
	}

	if (RegRcw1 != RegNewRcw1) {
		EthCore_WriteReg(BaseAddress, XAE_RCW1_OFFSET, RegNewRcw1);
	}

	/*
	 * Rest of options twiddle bits of other registers. Handle them one at
	 * a time
	 */

	/* Turn on flow control */
	if (DepOptions & XAE_FLOW_CONTROL_OPTION) {
		Reg = EthCore_ReadReg(BaseAddress, XAE_FCC_OFFSET);
		Reg |= XAE_FCC_FCRX_MASK;
		EthCore_WriteReg(BaseAddress, XAE_FCC_OFFSET, Reg);
	}

	/* Turn on promiscuous frame filtering (all frames are received ) */
	if (DepOptions & XAE_PROMISC_OPTION) {
		Reg = EthCore_ReadReg(BaseAddress, XAE_FMI_OFFSET);
		Reg |= XAE_FMI_PM_MASK;
		EthCore_WriteReg(BaseAddress, XAE_FMI_OFFSET, Reg);
	}

	/* Allow broadcast address filtering */
	if (DepOptions & XAE_BROADCAST_OPTION) {
		Reg = EthCore_ReadReg(BaseAddress, XAE_RAF_OFFSET);
		Reg &= ~XAE_RAF_BCSTREJ_MASK;
		EthCore_WriteReg(BaseAddress, XAE_RAF_OFFSET, Reg);
	}


	/* Allow multicast address filtering */
	if (DepOptions & (XAE_MULTICAST_OPTION | XAE_EXT_MULTICAST_OPTION)) {
		Reg = EthCore_ReadReg(BaseAddress, XAE_RAF_OFFSET);
		Reg &= ~XAE_RAF_MCSTREJ_MASK;
		EthCore_WriteReg(BaseAddress, XAE_RAF_OFFSET, Reg);
	}

	/*
	 * The remaining options not handled here are managed elsewhere in the
	 * driver. No register modifications are needed at this time.
	 * Reflecting the option in InstancePtr->Options is good enough for
	 * now.
	 */
	/* Enable extended multicast option */
	if (DepOptions & XAE_EXT_MULTICAST_OPTION) {
		EthCore_WriteReg(BaseAddress,
						 XAE_RAF_OFFSET,
						 EthCore_ReadReg(BaseAddress, XAE_RAF_OFFSET) | XAE_RAF_EMULTIFLTRENBL_MASK);
	}

	/*
	 * New/extended [TX|RX] VLAN translation option does not have specific
	 * bits to on/off.
	 */
	/* Enable extended transmit VLAN tag option */
	if (DepOptions & XAE_EXT_TXVLAN_TAG_OPTION) {
		Reg = EthCore_ReadReg(BaseAddress, XAE_RAF_OFFSET);
		Reg = (Reg & ~XAE_RAF_TXVTAGMODE_MASK) | (XAE_DEFAULT_TXVTAG_MODE <<XAE_RAF_TXVTAGMODE_SHIFT);
		EthCore_WriteReg(BaseAddress, XAE_RAF_OFFSET, Reg);
	}

	/* Enable extended receive VLAN tag option */
	if (DepOptions & XAE_EXT_RXVLAN_TAG_OPTION) {
		Reg = EthCore_ReadReg(BaseAddress, XAE_RAF_OFFSET);
		Reg = (Reg & ~XAE_RAF_RXVTAGMODE_MASK) |
			  (XAE_DEFAULT_RXVTAG_MODE << XAE_RAF_RXVTAGMODE_SHIFT);
		EthCore_WriteReg(BaseAddress, XAE_RAF_OFFSET, Reg);
	}

	/* Enable extended transmit VLAN strip option */
	if (Options & XAE_EXT_TXVLAN_STRP_OPTION) {
		Reg = EthCore_ReadReg(BaseAddress, XAE_RAF_OFFSET);
		Reg = (Reg & ~XAE_RAF_TXVSTRPMODE_MASK) |
			  (XAE_DEFAULT_TXVSTRP_MODE << XAE_RAF_TXVSTRPMODE_SHIFT);
		EthCore_WriteReg(BaseAddress, XAE_RAF_OFFSET, Reg);
	}
	
	/* Enable extended receive VLAN strip option */
	if (Options & XAE_EXT_RXVLAN_STRP_OPTION) {
		Reg = EthCore_ReadReg(BaseAddress, XAE_RAF_OFFSET);
		Reg = (Reg & ~XAE_RAF_RXVSTRPMODE_MASK) | (XAE_DEFAULT_RXVSTRP_MODE <<XAE_RAF_RXVSTRPMODE_SHIFT);
		EthCore_WriteReg(BaseAddress, XAE_RAF_OFFSET, Reg);
	}
}
/***************************************************************************
//EthCore_ClearOptions
//Decription: 	enables the options.
			 	Eth Core should be stopped with EthCore_Stop() before changing options.
//param:		BaseAddress	--EthCore baseaddress
				options		--a bitmask of OR'd XAE_*_OPTION values for options to set. Options not specified are not affected.	
****************************************************************************/
void EthCore_ClearOptions(uintptr_t BaseAddress, u32 options)
{
	u32 Reg;	/* Generic */
	u32 RegRcw1;	/* Reflects original contents of RCW1 */
	u32 RegTc;	/* Reflects original contents of TC  */
	u32 RegNewRcw1;	/* Reflects new contents of RCW1 */
	u32 RegNewTc;	/* Reflects new contents of TC  */
	u32 DepOptions;	/* Required dependent options for new features */
	
	/*
	 * Set options word to its new value.
	 * The step is required before calling _UpdateDepOptions() since
	 * we are operating on updated options.
	 */
	EthCore_DefaultOptions &= ~options;

	/*
	 * There are options required to be on/off per hardware requirement.
	 * Invoke _UpdateDepOptions to check hardware availability and update
	 * options accordingly.
	 */
	DepOptions = ~(EthCore_UpdateDepOptions(EthCore_DefaultOptions));

	/*
	 * New/extended function bit should be off if none of new/extended
	 * features is on after hardware is validated and gone through
	 * _UpdateDepOptions().
	 */
	if (!(~(DepOptions) &  (XAE_EXT_MULTICAST_OPTION   |
							XAE_EXT_TXVLAN_TRAN_OPTION |
							XAE_EXT_RXVLAN_TRAN_OPTION |
							XAE_EXT_TXVLAN_TAG_OPTION  |
							XAE_EXT_RXVLAN_TAG_OPTION  |
							XAE_EXT_TXVLAN_STRP_OPTION |
							XAE_EXT_RXVLAN_STRP_OPTION)))
	{
		EthCore_WriteReg(BaseAddress,
							  XAE_RAF_OFFSET,
							  EthCore_ReadReg(BaseAddress, XAE_RAF_OFFSET) & ~XAE_RAF_NEWFNCENBL_MASK);
	}

	/*
	 * Many of these options will change the RCW1 or TC registers.
	 * Group these options here and change them all at once. What we are
	 * trying to accomplish is to reduce the amount of IO to the device
	 */

	/* Get the current register contents */
	RegRcw1 = EthCore_ReadReg(BaseAddress, XAE_RCW1_OFFSET);
	RegTc = EthCore_ReadReg(BaseAddress, XAE_TC_OFFSET);
	RegNewRcw1 = RegRcw1;
	RegNewTc = RegTc;

	/* Turn off jumbo packet support for both Rx and Tx */
	if (DepOptions & XAE_JUMBO_OPTION) 
	{
		RegNewTc &= ~XAE_TC_JUM_MASK;
		RegNewRcw1 &= ~XAE_RCW1_JUM_MASK;
	}

	/* Turn off VLAN packet support for both Rx and Tx */
	if (DepOptions & XAE_VLAN_OPTION) 
	{
		RegNewTc &= ~XAE_TC_VLAN_MASK;
		RegNewRcw1 &= ~XAE_RCW1_VLAN_MASK;
	}

	/* Turn off FCS stripping on receive packets */
	if (DepOptions & XAE_FCS_STRIP_OPTION)
	{
		RegNewRcw1 |= XAE_RCW1_FCS_MASK;
	}

	/* Turn off FCS insertion on transmit packets */
	if (DepOptions & XAE_FCS_INSERT_OPTION)
	{
		RegNewTc |= XAE_TC_FCS_MASK;
	}

	/* Turn off length/type field checking on receive packets */
	if (DepOptions & XAE_LENTYPE_ERR_OPTION) 
	{
		RegNewRcw1 |= XAE_RCW1_LT_DIS_MASK;
	}

	/* Disable transmitter */
	if (DepOptions & XAE_TRANSMITTER_ENABLE_OPTION)
	{
		RegNewTc &= ~XAE_TC_TX_MASK;
	}

	/* Disable receiver */
	if (DepOptions & XAE_RECEIVER_ENABLE_OPTION) {
		RegNewRcw1 &= ~XAE_RCW1_RX_MASK;
	}

	/* Change the TC and RCW1 registers if they need to be
	 * modified
	 */
	if (RegTc != RegNewTc) 
	{
		EthCore_WriteReg(BaseAddress, XAE_TC_OFFSET, RegNewTc);
	}

	if (RegRcw1 != RegNewRcw1) 
	{
		EthCore_WriteReg(BaseAddress, XAE_RCW1_OFFSET, RegNewRcw1);
	}

	/*
	 * Rest of options twiddle bits of other registers. Handle them one at
	 * a time
	 */

	/* Turn off flow control */
	if (DepOptions & XAE_FLOW_CONTROL_OPTION) {
		Reg = EthCore_ReadReg(BaseAddress, XAE_FCC_OFFSET);
		Reg &= ~XAE_FCC_FCRX_MASK;
		EthCore_WriteReg(BaseAddress, XAE_FCC_OFFSET, Reg);
	}

	/* Turn off promiscuous frame filtering */
	if (DepOptions & XAE_PROMISC_OPTION) {
		Reg = EthCore_ReadReg(BaseAddress, XAE_FMI_OFFSET);
		Reg &= ~XAE_FMI_PM_MASK;
		EthCore_WriteReg(BaseAddress, XAE_FMI_OFFSET, Reg);
	}

	/* Disable broadcast address filtering */
	if (DepOptions & XAE_BROADCAST_OPTION) {
		Reg = EthCore_ReadReg(BaseAddress, XAE_RAF_OFFSET);
		Reg |= XAE_RAF_BCSTREJ_MASK;
		EthCore_WriteReg(BaseAddress, XAE_RAF_OFFSET, Reg);
	}

	/* Disable multicast address filtering */
	if ((DepOptions & XAE_MULTICAST_OPTION) &&(DepOptions & XAE_EXT_MULTICAST_OPTION)) 
	{
		Reg = EthCore_ReadReg(BaseAddress, XAE_RAF_OFFSET);
		Reg |= XAE_RAF_MCSTREJ_MASK;
		EthCore_WriteReg(BaseAddress, XAE_RAF_OFFSET, Reg);
	}

	/* Disable extended multicast option */
	if (DepOptions & XAE_EXT_MULTICAST_OPTION) {
		EthCore_WriteReg(BaseAddress,
						 XAE_RAF_OFFSET,
						 EthCore_ReadReg(BaseAddress, XAE_RAF_OFFSET) & ~XAE_RAF_EMULTIFLTRENBL_MASK);
	}

	/* Disable extended transmit VLAN tag option */
	if (DepOptions & XAE_EXT_TXVLAN_TAG_OPTION) {
		EthCore_WriteReg(BaseAddress,
						 XAE_RAF_OFFSET,
						 EthCore_ReadReg(BaseAddress, XAE_RAF_OFFSET) & ~XAE_RAF_TXVTAGMODE_MASK);
	}

	/* Disable extended receive VLAN tag option */
	if (DepOptions & XAE_EXT_RXVLAN_TAG_OPTION) {
		EthCore_WriteReg(BaseAddress,
						 XAE_RAF_OFFSET,
						 EthCore_ReadReg(BaseAddress, XAE_RAF_OFFSET) & ~XAE_RAF_RXVTAGMODE_MASK);
	}

	/* Disable extended transmit VLAN strip option */
	if (DepOptions & XAE_EXT_TXVLAN_STRP_OPTION) {
		EthCore_WriteReg(BaseAddress,
						 XAE_RAF_OFFSET,
						 EthCore_ReadReg(BaseAddress, XAE_RAF_OFFSET) & ~XAE_RAF_TXVSTRPMODE_MASK);
	}

	/* Disable extended receive VLAN strip option */
	if (DepOptions & XAE_EXT_RXVLAN_STRP_OPTION) {
		EthCore_WriteReg(BaseAddress,
						 XAE_RAF_OFFSET,
						 EthCore_ReadReg(BaseAddress, XAE_RAF_OFFSET) & ~XAE_RAF_RXVSTRPMODE_MASK);
	}
}

/***************************************************************************
//EthCore_Stop
//Decription: 	Disable all interrupts from this device
			  	Disable the receiver
//param:		BaseAddress--EthCore baseaddress
****************************************************************************/
void EthCore_Stop(uintptr_t BaseAddress)
{
	//Disable interrupts
	EthCore_WriteReg(BaseAddress, XAE_IE_OFFSET, 0);
	//Disable the receiver
	u32 Reg;
	Reg = EthCore_ReadReg(BaseAddress, XAE_RCW1_OFFSET);
	Reg &= ~XAE_RCW1_RX_MASK;
	EthCore_WriteReg(BaseAddress, XAE_RCW1_OFFSET, Reg);
	//Stopping the receiver in mid-packet causes a dropped packet indication from HW. Clear it.
	//get the interrupt pending register
	Reg = EthCore_ReadReg(BaseAddress, XAE_IP_OFFSET);
	if(Reg & XAE_INT_RXRJECT_MASK){
	//set the interrupt status register to clear the interrupt
		EthCore_WriteReg(BaseAddress, XAE_IS_OFFSET, XAE_INT_RXRJECT_MASK);
	}
}
/***************************************************************************
//EthCore_InitHW
//Decription: 	Performs a one-time setup of a Axi Ethernet device.
			 	The setup performed here only need to occur once after any reset.
//param:		BaseAddress--EthCore baseaddress
****************************************************************************/
void EthCore_InitHW(uintptr_t BaseAddress)
{
	u32 Reg;
	//Dsiable the receiver
	Reg = EthCore_ReadReg(BaseAddress, XAE_RCW1_OFFSET);
	Reg &= ~XAE_RCW1_RX_MASK;
	EthCore_WriteReg(BaseAddress, XAE_RCW1_OFFSET, Reg);
	// Stopping the receiver in mid-packet causes a dropped packet indication from HW. Clear it.
	// Get the interrupt pending register
	Reg = EthCore_ReadReg(BaseAddress, XAE_IP_OFFSET);
	if (Reg & XAE_INT_RXRJECT_MASK) {
		///Set the interrupt status register to clear the pending interrupt
		EthCore_WriteReg(BaseAddress, XAE_IS_OFFSET, XAE_INT_RXRJECT_MASK);
	}
	//Sync default options with HW, but leave receiver and transmitter disable
	EthCore_SetOptions(BaseAddress,EthCore_DefaultOptions & ~(XAE_TRANSMITTER_ENABLE_OPTION | XAE_RECEIVER_ENABLE_OPTION));
	EthCore_ClearOptions(BaseAddress, ~EthCore_DefaultOptions);
	//set default MDIO divisor
	EthCore_PhySetMdioDivisor(BaseAddress, XAE_MDIO_DIV_DFT);
}
/***************************************************************************
//EthCore_SetMacAddress
//Decription: 	Set Mac Address
//param:		BaseAddress--EthCore baseaddress
				MacAddress--Mac Address
****************************************************************************/
void EthCore_SetMacAddress(uintptr_t BaseAddress, u8 *MacAddress)
{
	u32 MacAddr;
	u8 *Aptr = (u8 *)MacAddress;
	/* Prepare MAC bits in either UAW0/UAWL */
	MacAddr = Aptr[0];
	MacAddr |= Aptr[1] << 8;
	MacAddr |= Aptr[2] << 16;
	MacAddr |= Aptr[3] << 24;
	
	/* Check to see if it is in extended/new mode. */
	if (!(((EthCore_ReadReg(BaseAddress, XAE_RAF_OFFSET) & XAE_RAF_NEWFNCENBL_MASK) ?  TRUE : FALSE))) 
	{
		/*
		 * Set the MAC bits [31:0] in UAW0.
		 * Having Aptr be unsigned type prevents the following
		 * operations from sign extending.
		 */
		EthCore_WriteReg(BaseAddress, XAE_UAW0_OFFSET, MacAddr);
		/* There are reserved bits in UAW1 so don't affect them */
		MacAddr = EthCore_ReadReg(BaseAddress, XAE_UAW1_OFFSET);
		MacAddr &= ~XAE_UAW1_UNICASTADDR_MASK;
		/* Set MAC bits [47:32] in UAW1 */
		MacAddr |= Aptr[4];
		MacAddr |= Aptr[5] << 8;
		EthCore_WriteReg(BaseAddress, XAE_UAW1_OFFSET, MacAddr);
	} else { /* Extended mode */
		/*
		 * Set the MAC bits [31:0] in UAWL register.
		 * Having Aptr be unsigned type prevents the following
		 * operations from sign extending.
		 */
		EthCore_WriteReg(BaseAddress, XAE_UAWL_OFFSET, MacAddr);
		/* Set MAC bits [47:32] in UAWU register. */
		MacAddr  = 0;
		MacAddr |= Aptr[4];
		MacAddr |= Aptr[5] << 8;
		EthCore_WriteReg(BaseAddress, XAE_UAWU_OFFSET, MacAddr);
	}
}
/***************************************************************************
//detect_phy
//Decription: 	detect MDIO address
//param:		BaseAddress--EthCore baseaddress
****************************************************************************/
static int EthCore_DetectPhy(uintptr_t BaseAddress)
{
	u16 phy_reg;
	u16 phy_id;
	u32 phy_addr;

	for (phy_addr = 31; phy_addr > 0; phy_addr--) {
		EthCore_PhyRead(BaseAddress, phy_addr, PHY_DETECT_REG, &phy_reg);
		if ((phy_reg != 0xFFFF) &&
			((phy_reg & PHY_DETECT_MASK) == PHY_DETECT_MASK)) {
			EthCore_PhyRead(BaseAddress, phy_addr, PHY_IDENTIFIER_1_REG, &phy_reg);
			//phyaddrforemac = phy_addr;
			return phy_addr;
		}

		EthCore_PhyRead(BaseAddress, phy_addr, PHY_IDENTIFIER_1_REG, &phy_id);
		if (phy_id == PHY_XILINX_PCS_PMA_ID1) {
			EthCore_PhyRead(BaseAddress, phy_addr, PHY_IDENTIFIER_2_REG, &phy_id);
			if (phy_id == PHY_XILINX_PCS_PMA_ID2) {
				/* Found a valid PHY address */
				//phyaddrforemac = phy_addr;
				return phy_addr;
			}
		}
	}
	xil_printf("detect_phy: No PHY detected.  Assuming a PHY at address 0\r\n\r");
        /* default to zero */
	return 0;
}
/***************************************************************************
//EthCore_GetPhyNegotiatedSpeed
//Decription: 	get Negotiated speed from phy layer
//param: 		BaseAddress			--EthCore baseaddress
				phy_addr			--phy addr(different phy have different phy addr, so we need to use EthCore_DetectPhy to get it)
****************************************************************************/
unsigned int EthCore_GetPhyNegotiatedSpeed(uintptr_t BaseAddress, u32 phy_addr)
{
	u16 control;
	u16 status;
	u16 partner_capabilities;
	u16 partner_capabilities_1000;
	u16 phylinkspeed;
	u16 temp;
	
	phy_addr = XPAR_PCSPMA_1000BASEX_PHYADDR;
	EthCore_PhyRead(BaseAddress, phy_addr, IEEE_CONTROL_REG_OFFSET, &control);
	control |= IEEE_CTRL_AUTONEGOTIATE_ENABLE;
	control |= IEEE_STAT_AUTONEGOTIATE_RESTART;
	control &= IEEE_CTRL_ISOLATE_DISABLE;
	EthCore_PhyWrite(BaseAddress, phy_addr, IEEE_CONTROL_REG_OFFSET, control);
	EthCore_PhyRead(BaseAddress, phy_addr, IEEE_STATUS_REG_OFFSET, &status);
	xil_printf("Waiting for PHY to  complete autonegotiation \r\n\r");
	while ( !(status & IEEE_STAT_AUTONEGOTIATE_COMPLETE) ) {
		sleep(1);
		EthCore_PhyRead(BaseAddress, phy_addr, IEEE_STATUS_REG_OFFSET, &status);
	}
	xil_printf("Autonegotiation complete \r\n\r");
	
	if (EthCore_ConfigTable[Eth_No].Speed == XAE_SPEED_2500_MBPS)
		return XAE_SPEED_2500_MBPS;
	EthCore_PhyWrite(BaseAddress, phy_addr, IEEE_PAGE_ADDRESS_REGISTER, 1);
	EthCore_PhyRead(BaseAddress, phy_addr, IEEE_PARTNER_ABILITIES_1_REG_OFFSET, &temp);
	if ((temp & 0x0020) == 0x0020) {
		EthCore_PhyWrite(BaseAddress, phy_addr, IEEE_PAGE_ADDRESS_REGISTER, 0);
		return 1000;
	}
	else {
		EthCore_PhyWrite(BaseAddress, phy_addr, IEEE_PAGE_ADDRESS_REGISTER, 0);
		xil_printf("Link error, temp = %x\r\n\r", temp);
		return 0;
	}
	
	/* Read PHY control and status registers is successful. */
	EthCore_PhyRead(BaseAddress, phy_addr, IEEE_CONTROL_REG_OFFSET, &control);
	EthCore_PhyRead(BaseAddress, phy_addr, IEEE_STATUS_REG_OFFSET, &status);
	if ((control & IEEE_CTRL_AUTONEGOTIATE_ENABLE) && (status & IEEE_STAT_AUTONEGOTIATE_CAPABLE)) {
		xil_printf("Waiting for PHY to complete autonegotiation.\r\n\r");
		while ( !(status & IEEE_STAT_AUTONEGOTIATE_COMPLETE) ) 
		{
			EthCore_PhyRead(BaseAddress, phy_addr, IEEE_STATUS_REG_OFFSET, &status);
	    }
		
		xil_printf("Autonegotiation complete \r\n\r");

		EthCore_PhyRead(BaseAddress, phy_addr, IEEE_PARTNER_ABILITIES_1_REG_OFFSET, &partner_capabilities);
		if (status & IEEE_STAT_1GBPS_EXTENSIONS) {
			EthCore_PhyRead(BaseAddress, phy_addr, IEEE_PARTNER_ABILITIES_3_REG_OFFSET, &partner_capabilities_1000);
			if (partner_capabilities_1000 & IEEE_AN3_ABILITY_MASK_1GBPS)
				return 1000;
		}

		if (partner_capabilities & IEEE_AN1_ABILITY_MASK_100MBPS)
			return 100;
		if (partner_capabilities & IEEE_AN1_ABILITY_MASK_10MBPS)
			return 10;

		xil_printf("%s: unknown PHY link speed, setting TEMAC speed to be 10 Mbps\r\n\r",__FUNCTION__);
		return 10;
	} else {
		/* Update TEMAC speed accordingly */
		if (status & IEEE_STAT_1GBPS_EXTENSIONS) {

			/* Get commanded link speed */
			phylinkspeed = control &IEEE_CTRL_1GBPS_LINKSPEED_MASK;

			switch (phylinkspeed) {
				case (IEEE_CTRL_LINKSPEED_1000M):
					return 1000;
				case (IEEE_CTRL_LINKSPEED_100M):
					return 100;
				case (IEEE_CTRL_LINKSPEED_10M):
					return 10;
				default:
					xil_printf("%s: unknown PHY link speed (%d), setting TEMAC speed to be 10 Mbps\r\n\r",__FUNCTION__, phylinkspeed);
					return 10;
			}
		} else {
			return (control & IEEE_CTRL_LINKSPEED_MASK) ? 100 : 10;
		}
	}
}
/***************************************************************************
//EthCore_GetPhySpeed
//Decription: 	get phy speed from phy layer
//param: 		BaseAddress			--EthCore baseaddress
****************************************************************************/
unsigned EthCore_GetPhySpeed(uintptr_t BaseAddress)
{
	u32 phy_addr = EthCore_DetectPhy(BaseAddress);
	return EthCore_GetPhyNegotiatedSpeed(BaseAddress, phy_addr);
}
/***************************************************************************
//EthCore_ConfigurePhySpeed
//Decription: 	configure speed to phy
//param: 		BaseAddress			--EthCore baseaddress
				speed				--What do you think?? speed!
****************************************************************************/
unsigned EthCore_ConfigurePhySpeed(uintptr_t BaseAddress, unsigned speed)
{
	u16 control;
	u32 phy_addr = EthCore_DetectPhy(BaseAddress);

	EthCore_PhyRead(BaseAddress, phy_addr, IEEE_CONTROL_REG_OFFSET, &control);
	control &= ~IEEE_CTRL_LINKSPEED_1000M;
	control &= ~IEEE_CTRL_LINKSPEED_100M;
	control &= ~IEEE_CTRL_LINKSPEED_10M;

	if (speed == 1000) {
		control |= IEEE_CTRL_LINKSPEED_1000M;
	}

	else if (speed == 100) {
		control |= IEEE_CTRL_LINKSPEED_100M;
		/* Dont advertise PHY speed of 1000 Mbps */
		EthCore_PhyWrite(BaseAddress, phy_addr, IEEE_1000_ADVERTISE_REG_OFFSET, 0);
		/* Dont advertise PHY speed of 10 Mbps */
		EthCore_PhyWrite(BaseAddress, phy_addr, IEEE_AUTONEGO_ADVERTISE_REG, ADVERTISE_100);
	}
	else if (speed == 10) {
		control |= IEEE_CTRL_LINKSPEED_10M;
		/* Dont advertise PHY speed of 1000 Mbps */
		EthCore_PhyWrite(BaseAddress, phy_addr, IEEE_1000_ADVERTISE_REG_OFFSET, 0);
		/* Dont advertise PHY speed of 100 Mbps */
		EthCore_PhyWrite(BaseAddress, phy_addr, IEEE_AUTONEGO_ADVERTISE_REG, ADVERTISE_10);
	}

	EthCore_PhyWrite(BaseAddress, phy_addr, IEEE_CONTROL_REG_OFFSET, control | IEEE_CTRL_RESET_MASK);
	{
		volatile int wait;
		for (wait=0; wait < 100000; wait++);
		for (wait=0; wait < 100000; wait++);
	}
	return 0;
}
/***************************************************************************
//EthCore_PhySetup
//Decription: 	setup phy layer
//param: 		BaseAddress			--EthCore baseaddress
****************************************************************************/
unsigned EthCore_PhySetup(uintptr_t BaseAddress)
{
	unsigned link_speed = 1000;
	if(EthCore_ConfigTable[Eth_No].PhyType == XAE_PHY_TYPE_RGMII_1_3)
	{
		;// no need here	
	}else if(EthCore_ConfigTable[Eth_No].PhyType == XAE_PHY_TYPE_RGMII_2_0)
	{
		;//no need here	
	}else if(EthCore_ConfigTable[Eth_No].PhyType == XAE_PHY_TYPE_SGMII)
	{
		;// no need here
	}else if(EthCore_ConfigTable[Eth_No].PhyType == XAE_PHY_TYPE_1000BASE_X)
	{
		;// no need here
	}
	/* set PHY <--> MAC data clock */
	#ifdef  CONFIG_LINKSPEED_AUTODETECT
		link_speed = EthCore_GetPhySpeed(BaseAddress);
		xil_printf("auto-negotiated link speed: %d\r\n\r", link_speed);
	#elif	defined(CONFIG_LINKSPEED1000)
		link_speed = 1000;
		EthCore_ConfigurePhySpeed(BaseAddress, link_speed);
		xil_printf("link speed: %d\r\n\r", link_speed);
	#endif
		return link_speed;
}
/***************************************************************************
//EthCore_SetOperatingSpeed
//Decription: 	Set Operationg speed
//param: 		BaseAddress			--EthCore baseaddress
				speed				--What do you think?? speed!
****************************************************************************/
int EthCore_SetOperatingSpeed(uintptr_t BaseAddress, u16 Speed)
{
	u32 EmmcReg;
	
	/*
	* Get the current contents of the EMAC config register and
	* zero out speed bits
	*/
	EmmcReg = EthCore_ReadReg(BaseAddress, XAE_EMMC_OFFSET) & ~XAE_EMMC_LINKSPEED_MASK;

	switch (Speed) {
		case XAE_SPEED_1000_MBPS:
			EmmcReg |= XAE_EMMC_LINKSPD_1000;
			break;

		case XAE_SPEED_2500_MBPS:
			EmmcReg |= XAE_EMMC_LINKSPD_1000;
			break;

		default:
			return (1);
		}
		
		/* Set register and return */
	EthCore_WriteReg(BaseAddress, XAE_EMMC_OFFSET, EmmcReg);
	return (0);
}
/***************************************************************************
//EthCore_Start
//Decription: 	Enable transmitter if XAE_TRANSMIT_ENABLE_OPTION is set
				Enable receiver if XAE_RECEIVER_ENABLE_OPTION is set
//param: 		EthCore_ConfigTable	--configuration table
				options		--a bitmask of OR'd XAE_*_OPTION values for options to set. Options not specified are not affected.	
****************************************************************************/
void EthCore_Start(uintptr_t BaseAddress, u32 Options)
{
	u32 Reg;



	/* Enable transmitter if not already enabled */
	if (Options & XAE_TRANSMITTER_ENABLE_OPTION) {
		xil_printf("Enabling transmitter\n\r");
		Reg = EthCore_ReadReg(BaseAddress, XAE_TC_OFFSET);
		if (!(Reg & XAE_TC_TX_MASK)) {
			xil_printf("Transmitter not enabled, enabling now\n\r");
			EthCore_WriteReg(BaseAddress, XAE_TC_OFFSET, Reg | XAE_TC_TX_MASK);
		}
		xil_printf("Transmitter enabled\n\r");
	}
	
	/* Enable receiver */
	if (Options & XAE_RECEIVER_ENABLE_OPTION) {
		xil_printf("Enabling receiver\n\r");
		Reg = EthCore_ReadReg(BaseAddress, XAE_RCW1_OFFSET);
		if (!(Reg & XAE_RCW1_RX_MASK)) {
			xil_printf("Receiver not enabled, enabling now\n\r");
			EthCore_WriteReg(BaseAddress, XAE_RCW1_OFFSET, Reg | XAE_RCW1_RX_MASK);
		}
		xil_printf("Receiver enabled\n\r");
	}

	/* Mark as started */
	xil_printf("Eth Core Start: done\n\r");
}
/***************************************************************************
//EthCore_Init
//Decription: 	Init the Eth Core by using the Eth_ConfigTable
//param: 		EthCore_ConfigTable	--configuration table
				BaseAddress			--EthCore baseaddress
****************************************************************************/
void EthCore_Init(uintptr_t BaseAddress)
{
	volatile int32_t MgtRdy;
	unsigned link_speed = 1000;
	u32 value = 0U;
	//check MgtRdy bit
	MgtRdy = Check_Rdy(Xil_In32, 
					   BaseAddress + XAE_IS_OFFSET, 
					   value,
				   	   (value & XAE_INT_MGTRDY_MASK) != 0, 
					   XAE_RST_DEFAULT_TIMEOUT_VAL);
	if(-1 == MgtRdy){
		xil_printf("Eth Core is not ready!\n\r");
		return;
	}
	//Stop the eth core and reset HW
	EthCore_Stop(BaseAddress);
	//Setup HW 
	EthCore_InitHW(BaseAddress);
	//set options
	EthCore_DefaultOptions |= XAE_FLOW_CONTROL_OPTION;
	EthCore_DefaultOptions |= XAE_TRANSMITTER_ENABLE_OPTION;
	EthCore_DefaultOptions |= XAE_RECEIVER_ENABLE_OPTION;
	EthCore_DefaultOptions |= XAE_FCS_STRIP_OPTION;
	EthCore_DefaultOptions |= XAE_MULTICAST_OPTION;
	EthCore_DefaultOptions |= XAE_EXT_MULTICAST_OPTION; 			//WEI
	EthCore_SetOptions(BaseAddress, EthCore_DefaultOptions);
	EthCore_ClearOptions(BaseAddress, ~EthCore_DefaultOptions);
	//set macaddress
	EthCore_SetMacAddress(BaseAddress, EthCore_ConfigTable[Eth_No].MacAddress);
	link_speed = EthCore_PhySetup(BaseAddress);
	EthCore_SetOperatingSpeed(BaseAddress, link_speed);
	
	/* Setting the operating speed of the MAC needs a delay. */
	{
		volatile int wait;
		for (wait=0; wait < 100000; wait++);
		for (wait=0; wait < 100000; wait++);
	}
	/* start the temac */
	EthCore_Start(BaseAddress,EthCore_DefaultOptions);
	/* enable MAC interrupts */
	/*
	XAxiEthernet_WriteReg(BaseAddress,  
						  XAE_IE_OFFSET,						
				          EthCore_ReadReg(BaseAddress, XAE_IE_OFFSET) | ((Mask) & XAE_INT_ALL_MASK));
	*/
	xil_printf("Eth Core Init finished!\n\r");
}

