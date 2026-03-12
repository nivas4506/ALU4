# ALU_LL PCB Design (FPGA-Based)

This design note translates the provided `ALU_LL` + `ALU_LL_tb` workflow into a practical PCB implementation.

## 1) Architecture

Implement `ALU_LL` inside an FPGA and expose:
- Inputs: `A[31:0]`, `B[31:0]`, `G_sel[3:0]`
- Outputs: `G[31:0]` and `ZCNVFlags[3:0]`

A simple board-level partition:
1. **Power Stage**: 5V input → 3.3V and 1.2V rails
2. **FPGA Core**: hosts `ALU_LL` RTL
3. **I/O Section**:
   - DIP switches / headers for `A`, `B`, `G_sel`
   - LEDs or PMOD/UART for `G` and `ZCNVFlags`
4. **Programming/Debug**:
   - JTAG header
   - Optional USB-UART bridge for result logging

## 2) Recommended Components

- **FPGA**: Lattice iCE40HX8K (or Xilinx Artix-7 if available)
- **Flash**: SPI NOR (for FPGA bitstream)
- **Regulators**:
  - 3.3V buck/LDO for I/O
  - 1.2V regulator for FPGA core
- **Clock**: 12 MHz or 25 MHz oscillator
- **Connectors**:
  - 2x20 GPIO header (or PMODs)
  - JTAG 2x5 0.1" header
  - USB-C/USB micro (power + optional UART)
- **UI (optional)**:
  - 4 switches for `G_sel`
  - 8+8 switches for partial `A/B` entry (full 32-bit typically through UART/GPIO)
  - 8 LEDs for low-byte observation

## 3) Schematic-Level Connectivity

## FPGA I/O Mapping (example)

- `A[31:0]`   → GPIO bank A
- `B[31:0]`   → GPIO bank B
- `G_sel[3:0]`→ Switches/GPIO
- `G[31:0]`   → GPIO bank C / UART formatter
- `ZCNVFlags` → 4 LEDs

Use **33–100 Ω series resistors** on fast external digital lines to reduce ringing.

## Power and Decoupling

- Place **0.1 µF decoupling capacitors** at each FPGA VCC pin.
- Add bulk caps per rail: **10 µF + 47 µF** near regulator outputs.
- Keep regulator loops compact and follow regulator datasheet layout rules.

## Configuration

- SPI Flash connected to FPGA configuration pins.
- Pull-ups/pull-downs per FPGA boot-mode requirements.

## 4) PCB Layout Guidelines

- 4-layer stackup recommended:
  - L1: signals/components
  - L2: solid GND plane
  - L3: power + signals
  - L4: signals
- Keep oscillator close to FPGA clock pin.
- Keep JTAG traces short and grouped.
- Route power first, then clocks, then critical control lines.
- Maintain continuous GND return paths under high-speed traces.

## 5) Bring-Up Plan

1. Verify rails: 5V, 3.3V, 1.2V (no FPGA loaded).
2. Program FPGA with a LED blink sanity bitstream.
3. Load `ALU_LL` build.
4. Apply vectors from your testbench manually or over UART:
   - `A = 0x7FFFFFFF`, `B = 0x1`, ops: ADD/SUB/XOR/OR/AND
   - `A = 0xFFFFFFFF`, `B = 0xFFFFFFFF`, same ops
5. Check `G` and `ZCNVFlags` against simulation.

## 6) Notes

- A pure PCB cannot directly implement HDL arithmetic logic; it requires either:
  - FPGA/CPLD implementation of `ALU_LL`, or
  - A fully discrete logic redesign (impractical for 32-bit ALU).
- For educational projects, FPGA-based PCB is the fastest and most reliable route.
