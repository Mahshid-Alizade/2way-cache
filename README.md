# Description
Here is the implementation of a 2-way set associative cache in VHDL ( a hardware description language )

## Features
- Cache size: 1KB 
- Each block size: 4Byte
- Method: 2-way set associative

## How does a 2-way set associative cache work?
In general, an N-way set associative cache reduces conflicts by providing N blocks in each set where data mapping to that set might be found. </br>
Each memory address still maps to a specific set, but it can map to any one of the N blocks in the set.
Here is an image of the hardware of a 2-way one:

![image](https://github.com/Mahshid-Alizade/2way-cache/assets/42897108/ff295ab8-d52c-4ee8-922c-62311b14b235)
