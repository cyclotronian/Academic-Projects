#Disk Scheduling Algorithms

The objective of this project were 3-fold:<br>

1.  Installation of DiskSim software in Linux

2.  Measure the performance of `SSTF_LBN` (Shortest Seek Time
First via Logical Block Number) and `PRI_VSCAN_LBN`

3.  Implement the `SSTF_LBN` and `PRI_VSCAN_LBN` algorithms
above by writing a simulator in Java

DiskSim-3.0 was successfully installed in a Linux 32-bit environment.<br>

The output file for `SSTF_LBN` and `PRI_VSCAN_LBN` are [_sstf.out_](./output/sstf.out)
 and [_vscan.out_](./output/vscan.out) respectively.<br>

The simulation code in java can be found in [SchedulingAlgo.java](./src/SchedulingAlgo.java).<br> 
The input for which are in [input1.conf](./input/input1.conf) and [input2.conf](./input/input2.conf).
Copy the input parameters to [input.conf](./input/input.conf) before execution.

* Observation 1: `PRI_VSCAN_LBN` schedules LBN 25 before LBN 15 as the head was moving in the forward direction.
* Observation 2: The scheduling of LBNs for `PRI_VSCAN_LBN` and `SSTF_LBN` are the same as R value is zero.