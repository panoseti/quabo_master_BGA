v11.6B:
(1) In v11.6A, SPIx1 is changed to SPIx4, but it can't boot up;
In v11.6B, SPIx4 is changed back to SPIx1.
(2) Since v11.5, some code is added to fix negative value bug, and here is the code:
for (i = 0; i < 256; i++) if (ph_baseline_array[i] & 0x1000) ph_baseline_array[i] = ph_baseline_array[i] | 0xf000;

v11.6A:
(1) fix a IM packets bug--the nanosec in IM packets is not synced to PPS, which has been fixed here;
(2) fix a clock setting bug--In maroc_dc core, axi clk is regarded as 62.5MHz, but it's 100MHz;
a parameter(ADC_CLK_DIV) is changed from 2 to 4 for fixing this bug.

v11.5:
the default status of shutter_command pin is 3.3V, instead of 0V

v11.4:
add pull-down resistors for the 256 input pins

v11.3:
(1) fix the timing offset issue;
We fixed the timing offset bug--when integration time < 50us, here is a timing offset.
The reason is that we can get a pixel data from axi4-fifo every 8 clk, so it will take 2048 clk at least to get all 256 pixel data.
I chagne the axi4-fifo to a standard fifo, which is much faster.
(2) fix the ossasional udp checksum issue;
I found a bug in my state machine, and fixed it;

v11.2:
(1)implement shutter control 
Focus stage shares the 4 ports with shutter control, and it depends on the quabo position.
If it's quabo0, the 4 ports are used for focus stage; if it's quabo1, the 4 ports are used for shutter control;

v11.1:
(1) add mode 6--8-BIT IM mode;
(2) add mode 7--8-BIT IM mode simultaneous  with 16 pulse height mode;
(3) time tick is changed to 1us;
(4) acq_int is changed to 16 bit, so the max integration time is 65536us = 65.536ms;

v11.0:
It's the same as v10.5F.
Because we have a lot of new features, we release v11.0.

v10.5F:
(1) fix a reset bug
The elapsed_time counter is 29bits, and it increases every 4ns, so I move 2 bits to left, making the resolution 1ns in the packets.
In verilog , it's
             elapsed_time_reg    <= {(elapsed_time<<2)};
I thought (elapsed_time<<2) is 31bits, but it looks it's still 29bits, and the upper 2bits are cut,
that's why we lost some upper bits.

I made the changes like this:
wire [31:0] elapsed_time_wire;
assign elapsed_time_wire = {3'b0,elapsed_time};
elapsed_time_reg    <= {(elapsed_time_wire<<2)}

v10.5E:
(1) change the reset design of bin_counter.
	The reset will start before im_mode_state_machine sending data
	
v10.5D:
(1) fix ip checksum bug

v10.5C:
(1) constraints added in placement.xdc;
create_pblock pblock_ctr_reset
add_cells_to_pblock [get_pblocks pblock_ctr_reset] [get_cells -quiet [list base_mb_i/elapsed_time_gen_0/inst/counter_reset_1_reg base_mb_i/elapsed_time_gen_0/inst/counter_reset_2_reg base_mb_i/elapsed_time_gen_0/inst/counter_reset_3_reg]]
resize_pblock [get_pblocks pblock_ctr_reset] -add {SLICE_X30Y39:SLICE_X31Y40}
(2) constraints changed in timing.xdc;
     a) remove--#set_false_path -from [get_clocks -of_objects [get_pins base_mb_i/clk_wiz_0/inst/mmcm_adv_inst/CLKOUT5]] -to [get_clocks -of_objects [get_pins base_mb_i/clk_wiz_1/inst/mmcm_adv_inst/CLKOUT0]]
     b) remove--#set_false_path -from [get_clocks -of_objects [get_pins base_mb_i/clk_wiz_1/inst/mmcm_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins base_mb_i/clk_wiz_1/inst/mmcm_adv_inst/CLKOUT1]]
     c) add--set_false_path -from [get_clocks -of_objects [get_pins base_mb_i/clk_wiz_1/inst/mmcm_adv_inst/CLKOUT0]] -to [get_pins {base_mb_i/maroc_dc_0/inst/USR_LOGIC/IM_MUX[*].MUX_L/dout_reg[*]/D}]
(3) change some code in bin_counter for removing the deadtime;
(4) the reset of im state machine is changed to ".frame_reset((!mode_enable[1])),".

v10.5B:
Remove all debugging signals, and add placement constraints in placement.xdc

v10.5A:
(1) We get IM packets(ACQ_MODE=2) from hardware instead of software, so we can get high speed packets;
(2) We can set ACQ_MODE to 0, so that no packets will be sent out except HK packets.

v10.5:
(1) finish high speed IM mode(ACQ_MODE = 3).
	We can get PH packets and IM packets at the same time:
	when it's PH packet, its ACQ_MODE = 1;
	when it's IM packet, its ACQ_MODE = 3;
(2) I just finished function test,including UDP packets checksum, timing difference,
	but I'm not sure whether the scientific data is correct;
	We need more tests on it;

v10.4:
(1) replace set_focus function with rick's new code to solve issue of stage stops when it reacges tge upper optical switch;
(2) fix the system crashed issue(a fifo in eth_core_ctrl core was full...);
(3) fix the issue of losing connection to the last quabo on mobo;
    The second eth port on the last quabo is open, so it can't finish the auto-negotiation. I configure the second eth port to fixed 1000Mbps, not auto-negotiation;
(4) fix mac address issue;
    some mac addresses are illegal, and it's related to the first byte;
    I set the first byte of mac address to 0x00 to solve the issue;
(5) fix the issue about stage didn't work with more than 2 quabo on mobo;
    focus_limits_on(output) port is connected to bus, so I change is to three state, if it's quabo1/2/3; 
	

