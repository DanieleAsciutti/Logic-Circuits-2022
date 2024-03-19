# Logic Circtuis 2022

The project is part of the "Reti Logiche" course at Polytechnic University of Milan. This project was part of the assessment for the academic year 2021-2022.

Final score: 30/30 with laude

# Project specification
The project aims to implement an hardware module (described in VHDL) that interfaces with a memory.
The module takes as input a continuous sequence of 8-bit words. Each word is serialized and each bit of the serialized stream is encoded in two bits following a final state machine.
The continuous stream in output is then deserialized in 8-bit words. In conclusion, for each word in input, the module creates two words as output.

Final State Machine used to encode the input:

<img src="https://github.com/DanieleAsciutti/Logic-Circuits-2022/blob/main/assets/fsa.png" width="250" height="150">

# Tools used
- [Xilinx Vivado](https://www.xilinx.com/products/design-tools/vivado.html) - used for synthesis and analysis
