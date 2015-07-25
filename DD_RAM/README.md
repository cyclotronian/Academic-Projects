MemoryBlock is a 8 bit RAM simulation in HDL Verilog.
It contains two testbenches: t_memoryblock1 and t_memoryblock2
Compile the code in ModelSim and Simulate the two testbenches

t_memoryblock1 simulates in the following manner:
Writes four values into the memory in first four cycles
Reads the four values from the memory in the next four cycles

t_memoryblock2 simulates in the following manner:
Writes one value into the memory in first cycle and reads it in the second
Writes next value into the memory in third cycle and reads it in the fourth
Writes and Reads other values in the remaining cycles