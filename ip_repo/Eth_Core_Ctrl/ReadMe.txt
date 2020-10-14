1. V1.0: 
(1) this is for sending data without AXI4-Stream FIFO
(2) this IP core includes a fifo inside, whose length is 1024
(3) after one data frame is sent to the fifo, then the data will be sent to eth core, or there will have some problem(read faster than write)

2. V1.1:
change the syntax related to fifo_din.
It seem the former syntax is not stable.
* former syntax:
  assign s_axis_tdata = fifo_din[31:0];
  assign s_axis_tkeep = fifo_din[35:32];
  ...
* now:
  assign fifo_din = {s_axis_tdata, s_axis_tkeep,...};

3. V1.1.1:(debuging)
add a simulation file to confirm that the IP core can work!
will test it tomorrow
