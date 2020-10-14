1. V1.0:
This IP core is used to switch the data from two AXI-Stream interface;
If one of the two interface has data to transfer, another interface is blocked, and waiting for the tready signal;
If the two interfaces have data to transfer at the same time, S0 has higher priority.
