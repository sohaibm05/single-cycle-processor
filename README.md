# RISC-V CPU with Control Path — Labs 5–9

Continuation of the single-cycle RISC-V CPU project, extending the labs 5–7 datapath (ALU + register file) into a fuller machine: **control unit, instruction memory, data memory, and address decoder.** Verilog + Xilinx Vivado, targeting the same FPGA dev board.

## What was added vs. earlier labs
- `Main_Control_Unit.v` — generates control signals from opcode/funct fields
- `ALU_Control_Unit.v` — secondary decoder for the ALU op
- `Top_Control_Path.v` — wires control signals to the datapath
- `DataMemory.v` — byte-addressable RAM with load/store support
- `addressDecoderTop.v` — memory-mapped I/O decoding
- `register.v` — pipeline-style register primitive
- `top_lab7.v`, `top_lab8.v` — per-lab top modules

## Testbenches
`CAlab5/CAlab5.srcs/sim_1/new/` covers:
- `tb_Control_Unit.v` — control-unit signal correctness
- `MemorySystem_tb.v` — load/store behavior
- `topLab7_tb.v` — integration smoke test

## Open in Vivado
1. Open `CAlab5/CAlab5.xpr` in Vivado 2020+.
2. Sources → pick a `*_tb.v` → **Run Simulation**.
3. **Run Synthesis → Implementation → Generate Bitstream** to deploy.

## Tech stack
Verilog · Xilinx Vivado · RISC-V

## Note on the name
This is the cumulative lab 5 → 9 project. The repo name `lab9` is the last lab number; the design covers everything from the ALU through the data memory.

## License
MIT — see [LICENSE](LICENSE).
