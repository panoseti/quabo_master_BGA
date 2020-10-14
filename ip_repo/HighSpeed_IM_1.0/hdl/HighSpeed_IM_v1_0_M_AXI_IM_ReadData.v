
`timescale 1 ns / 1 ps

	module HighSpeed_IM_v1_0_M_AXI_IM_ReadData #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line

		// The master will start generating data from the C_M_START_DATA_VALUE value
		parameter  C_M_START_DATA_VALUE	= 32'hAA000000,
		// The master requires a target slave base address.
        // The master will initiate read and write transactions on the slave with base address specified here as a parameter.
		parameter  C_M_TARGET_SLAVE_BASE_ADDR	= 32'h44A00000,
		// Width of M_AXI address bus. 
        // The master generates the read and write addresses of width specified as C_M_AXI_ADDR_WIDTH.
		parameter integer C_M_AXI_ADDR_WIDTH	= 32,
		// Width of M_AXI data bus. 
        // The master issues write data and accept read data where the width of the data bus is C_M_AXI_DATA_WIDTH
		parameter integer C_M_AXI_DATA_WIDTH	= 32,
		// Transaction number is the number of write 
        // and read transactions the master will perform as a part of this example memory test.
		parameter integer C_M_TRANSACTIONS_NUM	= 4
	)
	(
		// Users to add ports here
       // This signal is used to start a read operation
		input wire start_to_read,
		// This signal shows it's ready to read the data
		output wire ready_to_read,
		//This is the register address we want to read data from 
		input wire [C_M_AXI_ADDR_WIDTH-1 : 0] araddr_from_user,
		//This is the data read from axi4-lite interface
		output [C_M_AXI_DATA_WIDTH-1 : 0] rdata_to_user,
		// User ports ends
		// Do not modify the ports beyond this line
		// Asserts when AXI transactions is complete
		// AXI clock signal
		input wire  M_AXI_ACLK,
		// AXI active low reset signal
		input wire  M_AXI_ARESETN,
		// Master Interface Write Address Channel ports. Write address (issued by master)
		output wire [C_M_AXI_ADDR_WIDTH-1 : 0] M_AXI_AWADDR,
		// Write channel Protection type.
        // This signal indicates the privilege and security level of the transaction,
        // and whether the transaction is a data access or an instruction access.
		output wire [2 : 0] M_AXI_AWPROT,
		// Write address valid. 
        // This signal indicates that the master signaling valid write address and control information.
		output wire  M_AXI_AWVALID,
		// Write address ready. 
        // This signal indicates that the slave is ready to accept an address and associated control signals.
		input wire  M_AXI_AWREADY,
		// Master Interface Write Data Channel ports. Write data (issued by master)
		output wire [C_M_AXI_DATA_WIDTH-1 : 0] M_AXI_WDATA,
		// Write strobes. 
        // This signal indicates which byte lanes hold valid data.
        // There is one write strobe bit for each eight bits of the write data bus.
		output wire [C_M_AXI_DATA_WIDTH/8-1 : 0] M_AXI_WSTRB,
		// Write valid. This signal indicates that valid write data and strobes are available.
		output wire  M_AXI_WVALID,
		// Write ready. This signal indicates that the slave can accept the write data.
		input wire  M_AXI_WREADY,
		// Master Interface Write Response Channel ports. 
        // This signal indicates the status of the write transaction.
		input wire [1 : 0] M_AXI_BRESP,
		// Write response valid. 
        // This signal indicates that the channel is signaling a valid write response
		input wire  M_AXI_BVALID,
		// Response ready. This signal indicates that the master can accept a write response.
		output wire  M_AXI_BREADY,
		// Master Interface Read Address Channel ports. Read address (issued by master)
		output wire [C_M_AXI_ADDR_WIDTH-1 : 0] M_AXI_ARADDR,
		// Protection type. 
        // This signal indicates the privilege and security level of the transaction, 
        // and whether the transaction is a data access or an instruction access.
		output wire [2 : 0] M_AXI_ARPROT,
		// Read address valid. 
        // This signal indicates that the channel is signaling valid read address and control information.
		output wire  M_AXI_ARVALID,
		// Read address ready. 
        // This signal indicates that the slave is ready to accept an address and associated control signals.
		input wire  M_AXI_ARREADY,
		// Master Interface Read Data Channel ports. Read data (issued by slave)
		input wire [C_M_AXI_DATA_WIDTH-1 : 0] M_AXI_RDATA,
		// Read response. This signal indicates the status of the read transfer.
		input wire [1 : 0] M_AXI_RRESP,
		// Read valid. This signal indicates that the channel is signaling the required read data.
		input wire  M_AXI_RVALID,
		// Read ready. This signal indicates that the master can accept the read data and response information.
		output wire  M_AXI_RREADY
	);

// function called clogb2 that returns an integer which has the
// value of the ceiling of the log base 2

function integer clogb2 (input integer bit_depth);
    begin
	   for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
	       bit_depth = bit_depth >> 1;
	end
endfunction

// TRANS_NUM_BITS is the width of the index counter for 
// number of write or read transaction.
localparam integer TRANS_NUM_BITS = clogb2(C_M_TRANSACTIONS_NUM-1);

// only two states here: Read and write.
// in our application, we only need read, so write state is for future use.
parameter [1:0]  INIT_READ  = 2'b00,
	             INIT_WRITE = 2'b01; 

reg [1:0] mst_exec_state;

// AXI4LITE signals
//write address valid
reg  	axi_awvalid;
//write data valid
reg  	axi_wvalid;
//read address valid
reg  	axi_arvalid;
//read data acceptance
reg  	axi_rready;
//write response acceptance
reg  	axi_bready;
//write address
reg [C_M_AXI_ADDR_WIDTH-1 : 0] 	axi_awaddr;
//write data
reg [C_M_AXI_DATA_WIDTH-1 : 0] 	axi_wdata;
//read addresss
reg [C_M_AXI_ADDR_WIDTH-1 : 0] 	axi_araddr;
//Asserts when there is a write response error
wire  	write_resp_error;
//Asserts when there is a read response error
wire  	read_resp_error;
//A pulse to initiate a write transaction
reg  	start_single_write;
//A pulse to initiate a read transaction
reg  	start_single_read;
//Asserts when a single beat write transaction is issued and remains asserted till the completion of write trasaction.
reg  	write_issued;
//Asserts when a single beat read transaction is issued and remains asserted till the completion of read trasaction.
reg  	read_issued;
//flag that marks the completion of write trasactions. The number of write transaction is user selected by the parameter C_M_TRANSACTIONS_NUM.
reg  	writes_done;
//flag that marks the completion of read trasactions. The number of read transaction is user selected by the parameter C_M_TRANSACTIONS_NUM
reg  	reads_done;
//The error register is asserted when any of the write response error, read response error or the data mismatch flags are asserted.
reg  	error_reg;
//This is used to delay start_to_read signal.
//We want to detect the rising edge of the start_to_read.
reg     start_to_read_d0;
// I/O Connections assignments

//Adding the offset address to the base addr of the slave
assign M_AXI_AWADDR	= C_M_TARGET_SLAVE_BASE_ADDR ;
//AXI 4 write data
assign M_AXI_WDATA	= 0;
assign M_AXI_AWPROT	= 3'b000;
assign M_AXI_AWVALID	= 1'b0;
//Write Data(W)
assign M_AXI_WVALID	= 1'b0;
//Set all byte strobes in this example
assign M_AXI_WSTRB	= 4'b1111;
//Write Response (B)
assign M_AXI_BREADY	= 1'b0;
//Read Address (AR)
//assign M_AXI_ARADDR	= C_M_TARGET_SLAVE_BASE_ADDR + axi_araddr;
assign M_AXI_ARADDR	= C_M_TARGET_SLAVE_BASE_ADDR + araddr_from_user;
assign M_AXI_ARVALID	= axi_arvalid;
assign M_AXI_ARPROT	= 3'b001;
//Read and Read Response (R)
assign M_AXI_RREADY	= axi_rready;
    
assign ready_to_read = M_AXI_RVALID;
assign rdata_to_user = M_AXI_RDATA;
                                                                       
//----------------------------
//Read Address Channel
//----------------------------
                                                                                                                                                           
// A new axi_arvalid is asserted when there is a valid read address              
// available by the master. start_single_read triggers a new read                
// transaction                                                                   
always @(posedge M_AXI_ACLK)                                                     
    begin                                                                            
	   if (M_AXI_ARESETN == 0)                                                       
	       begin                                                                        
	           axi_arvalid <= 1'b0;                                                       
	       end                                                                          
	   //Signal a new read address command is available by user logic                 
	   else if (start_single_read)                                                    
	       begin                                                                        
	           axi_arvalid <= 1'b1;                                                       
	       end                                                                          
	   //RAddress accepted by interconnect/slave (issue of M_AXI_ARREADY by slave)    
	   else if (M_AXI_ARREADY && axi_arvalid)                                         
	       begin                                                                        
	           axi_arvalid <= 1'b0;                                                       
	       end                                                                          
	       // retain the previous value                                                   
    end                                                                              


//--------------------------------
//Read Data (and Response) Channel
//--------------------------------

//The Read Data channel returns the results of the read request 
//The master will accept the read data by asserting axi_rready
//when there is a valid read data available.
//While not necessary per spec, it is advisable to reset READY signals in
//case of differing reset latencies between master/slave.
always @(posedge M_AXI_ACLK)                                    
    begin                                                                 
	   if (M_AXI_ARESETN == 0)                                            
	       begin                                                             
	           axi_rready <= 1'b0;                                             
	       end                                                               
	    // accept/acknowledge rdata/rresp with axi_rready by the master     
	    // when M_AXI_RVALID is asserted by slave                           
	   else if (start_single_read)                               
	       begin                                                             
	           axi_rready <= 1'b1;                                             
	       end                                                               
	    // deassert after one clock cycle                                   
	   else if (M_AXI_RVALID)                                                
	       begin                                                             
	           axi_rready <= 1'b0;                                             
	       end                                                               
	    // retain the previous value                                        
    end                                                                   
	                                                                        
//Flag write errors                                                     
assign read_resp_error = (axi_rready & M_AXI_RVALID & M_AXI_RRESP[1]);  

//--------------------------------
//User Logic
//--------------------------------
//detect the rising edge of start_to_read
always @(posedge M_AXI_ACLK)
    begin
        if(M_AXI_ARESETN == 1'b0)
            start_to_read_d0 <= 1'b0;
        else
            start_to_read_d0 <= start_to_read;
    end  
                                                                  	                                                                                                                                                                    
//implement master command interface state machine 
//This state machine only has one state, and we can have more states, if we want.                        
always @ ( posedge M_AXI_ACLK)                                                    
    begin                                                                             
        if (M_AXI_ARESETN == 1'b0)                                                     
	       begin                                                                         
	           // reset condition                                                            
	           // All the signals are assigned default values under reset condition  
	           //Because we only need to read, the init state is INIT_READ        
	           mst_exec_state  <= INIT_READ;                                                                                                
	           start_single_read  <= 1'b0;                                                 
	           read_issued   <= 1'b0;                                                                                                       
	       end                                                                           
	    else                                                                            
	       begin                                                                         
	           // state transition                                                          
	           case (mst_exec_state)                                                                                                                                                                                                                                                          
	               INIT_READ:                                                                
	               // This state is responsible to issue start_single_read pulse to        
	               // initiate a read transaction. Read transactions will be               
	               // issued until last_read signal is asserted.                           
	               // read controller                                                     
	               if ((start_to_read == 1) && (start_to_read_d0 ==0))                                                        
	                   begin
	                       mst_exec_state  <= INIT_READ;                                                                                                  
	                   if (~axi_arvalid && ~M_AXI_RVALID && ~start_single_read && ~read_issued)
	                       begin                                                            
	                           start_single_read <= 1'b1;                                     
	                           read_issued  <= 1'b1;                                          
	                       end                                                              
	                   else if (axi_rready)                                               
	                       begin                                                            
	                           read_issued  <= 1'b0;                                          
	                       end                                                              
	                   else                                                               
	                       begin                                                            
	                           start_single_read <= 1'b0; //Negate to generate a pulse        
	                       end                                                                                        
	                   end                                                                  
	               else                                                                   
	                   begin                                                                
	                       //mst_exec_state <= INIT_WRITE; 
	                       //we only need the read state in our application, we keep the state in INIT_READ  
	                       mst_exec_state <= INIT_READ;                                                            
	                   end                                                                                                                                 
	               default :                                                                
	                   begin                                                                  
	                       mst_exec_state  <= INIT_READ;                                     
	                   end                                                                    
            endcase                                                                     
        end                                                                             
    end //MASTER_EXECUTION_PROC                                                       

endmodule
