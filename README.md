# RISC-V Single-Cycle Processor with Full Control Path

A complete single-cycle RISC-V CPU implementation in Verilog, featuring a full control path, data memory, and address decoder. Built with Xilinx Vivado, targeting an FPGA development board.

## Components

- `Main_Control_Unit.v` — generates control signals from opcode/funct fields
- `ALU_Control_Unit.v` — secondary decoder for the ALU op
- `Top_Control_Path.v` — wires control signals to the datapath
- `DataMemory.v` — byte-addressable RAM with load/store support
- `addressDecoderTop.v` — memory-mapped I/O decoding
- `register.v` — pipeline-style register primitive
- `top_cpu.v` — top-level module

## Testbenches

`single-cycle-processor/single-cycle-processor.srcs/sim_1/new/` covers:
- `tb_Control_Unit.v` — control-unit signal correctness
- `MemorySystem_tb.v` — load/store behavior
- `topCPU_tb.v` — integration smoke test

## Open in Vivado

1. Open `single-cycle-processor/single-cycle-processor.xpr` in Vivado 2020+.
2. Sources → pick a `*_tb.v` → **Run Simulation**.
3. **Run Synthesis → Implementation → Generate Bitstream** to deploy.

## Tech Stack

Verilog · Xilinx Vivado · RISC-V

## License

MIT — see [LICENSE](LICENSE).
