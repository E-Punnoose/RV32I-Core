# RV32I-Core

A 5-stage pipelined RV32I RISC-V CPU core implemented in Verilog, with data hazard detection, forwarding, and branch handling. Built and verified as part of an FYP (Final Year Project) targeting Intel FPGA (Cyclone V) using Quartus Prime and ModelSim.

## Overview

This core implements the classic 5-stage RISC pipeline:

**IF → ID → EX → MEM → WB**

with support for:
- Full RV32I base integer instruction set (R-type, I-type, loads, stores, branches, JAL/JALR)
- Data hazard detection and stalling (load-use hazards)
- Operand forwarding (EX/MEM → EX and MEM/WB → EX)
- Branch resolution in the EX stage with pipeline flush on taken branches/jumps

## Pipeline Stages & Modules

| Stage | Module | Description |
|---|---|---|
| IF | `msrv32_pc.v` | Program counter register |
| IF | `msrv32_imem.v` | Instruction memory |
| IF/ID | `msrv32_if_id.v` | IF/ID pipeline register (stall/flush capable) |
| ID | `msrv32_main_control.v` | Main control unit — decodes opcode into control signals |
| ID | `msrv32_alu_control.v` | ALU control — derives ALU operation from funct3/funct7/ALUOp |
| ID | `msrv32_integer_file.v` | 32×32-bit register file |
| ID | `msrv32_imm_gen.v` | Immediate generator (I/S/B/U/J-type formats) |
| ID | `msrv32_hazard_unit.v` | Load-use hazard detection; controls stalling |
| ID/EX | `msrv32_id_ex.v` | ID/EX pipeline register |
| EX | `msrv32_alu.v` | Arithmetic logic unit |
| EX | `msrv32_forwarding_unit.v` | Forwarding logic for ALU operands |
| EX | `msrv32_branch_logic.v` | Branch condition evaluation |
| EX/MEM | `msrv32_ex_mem.v` | EX/MEM pipeline register |
| MEM | `msrv32_dmem.v` | Data memory (byte/half/word addressable, sign/zero extension) |
| MEM/WB | `msrv32_mem_wb.v` | MEM/WB pipeline register |
| Top | `msrv32_core.v` | Top-level module wiring all stages together |

## Hazard Handling

**Data hazards** are resolved via a combination of forwarding and stalling:

- **EX/MEM → EX** and **MEM/WB → EX** forwarding paths handle most RAW hazards without stalling (`msrv32_forwarding_unit.v`).
- **Load-use hazards** (an instruction immediately following a `lw`/`lb`/`lh` that depends on the loaded value) cannot be resolved by forwarding alone, since the loaded data isn't available until the MEM stage completes. `msrv32_hazard_unit.v` detects this case and stalls the pipeline for one cycle by:
  - Holding the PC and IF/ID register (`pc_write` / `if_id_write` = 0)
  - Inserting a bubble into ID/EX via `hazard_mux_sel`

**Control hazards** (branches/jumps) are resolved in the EX stage. On a taken branch or jump, the fetched instruction in IF/ID is flushed.

## Verification

Each module has an individual testbench (`*_tb.v`) with a corresponding waveform capture (`waveform_*.png`) confirming correct standalone behavior:

- ALU (`msrv32_alu_tb.v`)
- ALU control (`msrv32_alu_control_tb.v`)
- Branch logic (`msrv32_branch_logic_tb.v`)
- Forwarding unit (`msrv32_forwarding_unit_tb.v`)
- Hazard unit (`msrv32_hazard_unit_tb.v`)
- Immediate generator (`msrv32_imm_gen_tb.v`)
- Register file (`msrv32_integer_file_tb.v`)
- Main control (`msrv32_main_control_tb.v`)

### Core-level integration test

`msrv32_core_tb.v` runs a short instruction sequence through the full pipeline and checks final register/memory state:

```
addi x1, x0, 5      # x1 = 5
addi x2, x0, 10     # x2 = 10
add  x3, x1, x2     # x3 = 15
sw   x3, 0(x2)      # mem[10] = 15
lw   x4, 0(x2)      # x4 = mem[10] = 15   (load-use hazard below)
addi x4, x4, 1      # x4 = x4 + 1 = 16    <- depends on lw result in the very next instruction
beq  x4, x3, ...    # not taken (16 != 15)
addi x5, x0, 1      # x5 = 1
```

Expected final state: `x1=5, x2=10, x3=15, x4=16, x5=1, dmem[2]=15`

This specific sequence exercises the **load-use hazard stall path** (`lw` immediately followed by an instruction using its result) end-to-end.

**Result:** `ALL PASS` — see `waveform_Core1.png` and `waveform_Core2.png` for the full simulation waveform.

## Running the Simulation

From ModelSim (Intel FPGA Edition), in the project directory:

```tcl
vlib work
vmap work work

vlog -vlog01compat -work work msrv32_alu.v
vlog -vlog01compat -work work msrv32_integer_file.v
vlog -vlog01compat -work work msrv32_imm_gen.v
vlog -vlog01compat -work work msrv32_alu_control.v
vlog -vlog01compat -work work msrv32_main_control.v
vlog -vlog01compat -work work msrv32_branch_logic.v
vlog -vlog01compat -work work msrv32_pc.v
vlog -vlog01compat -work work msrv32_if_id.v
vlog -vlog01compat -work work msrv32_id_ex.v
vlog -vlog01compat -work work msrv32_ex_mem.v
vlog -vlog01compat -work work msrv32_mem_wb.v
vlog -vlog01compat -work work msrv32_forwarding_unit.v
vlog -vlog01compat -work work msrv32_hazard_unit.v
vlog -vlog01compat -work work msrv32_dmem.v
vlog -vlog01compat -work work msrv32_core.v
vlog -vlog01compat -work work msrv32_imem.v
vlog -work work msrv32_core_tb.v

vsim work.msrv32_core_tb
add wave -radix decimal /msrv32_core_tb/uut/reg_file_inst/reg_file
run -all
```

Individual module testbenches can be run the same way by substituting the relevant `_tb.v` file as the top-level simulation target.

## Known Limitations / Not Yet Covered

- Branch-taken path (only branch-not-taken has been verified at the core level so far)
- JAL / JALR (implemented in hardware, not yet exercised by a core-level test)
- CSR instructions, exceptions, and interrupts are not implemented
- Data memory is uninitialized at simulation start (reads before any write return `X` in simulation)

## Toolchain

- **Synthesis:** Intel Quartus Prime (Lite), targeting Cyclone V
- **Simulation:** ModelSim — Intel FPGA Edition 2020.1

## Author

Emmanuel Punnoose
