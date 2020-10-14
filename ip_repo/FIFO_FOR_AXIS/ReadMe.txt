1. V1.0:
it's for debugging, and the IP core can't work normally.

2. V1.1:
I found a syntax bug from simulation.
It's related to fifo_din, and I can't understand why it didn't work.
*former:
   assign s_axis_tdata = fifo_din[31:0];
   assign s_axis_tkeep = fifo_din[35:32];
   ...
*now:
   assign fifo_din = {s_axis_tdata, s_axis_tkeep,...}

3. V1.1.1:
add a simulation file to confirm that the IP core can work!
will test it tomorrow

4. V1.2:
change the logic, and now it works!
