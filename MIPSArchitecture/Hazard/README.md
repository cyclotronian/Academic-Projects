##Hazard Detection

The objective is to design and implement Data Forwarding and Hazard
Detection in a MIPS Pipeline implementation. Running the following
instructions will cause hazard and data forwarding errors:

<img src="./instr-memory.png", width=200>

The simulation results without Data Forwarding and Hazard Detection
would look as follows:

<img src="./output-old.png", width=700>

The Pipeline design with Data Forwarding and Hazard Detection is as follows:

<img src="./design.png", width=1000>

The simulation output of _Hazard.v_ (i.e. after implementing Data
Forwarding and Hazard Detection) is as follows:

<img src="./output-new.png", width=700>