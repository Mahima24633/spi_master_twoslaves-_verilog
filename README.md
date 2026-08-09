# SPI Master with Two Slaves using Verilog

## Project Overview

This project implements an SPI Master communicating with two SPI Slaves using Verilog HDL.

The design was simulated using Icarus Verilog and verified using GTKWave.

## Features

- 8-bit SPI communication
- One SPI Master
- Two SPI Slaves
- Separate Slave Select signals
- SCLK generation
- MOSI transmission
- MISO reception
- Busy and Done status signals
- Verilog testbench
- GTKWave waveform verification

## System Architecture

The SPI Master communicates with two slaves.

- `SS_0 = 0` → Slave 0 selected
- `SS_1 = 0` → Slave 1 selected
- `SCLK` → SPI clock
- `MOSI` → Master to Slave
- `MISO` → Slave to Master

## Project Files

| File | Description |
|---|---|
| `spi_master.v` | SPI Master module |
| `spi_slave.v` | SPI Slave module |
| `spi_system.v` | Top-level Master and two Slaves |
| `tb_spi_master.v` | Simulation testbench |

## Simulation

Compile the project using Icarus Verilog:
'''bash
iverilog -o spi_sim spi_master.v spi_slve.v spi_system.v th_spi_master.v


```bash
iverilog -o spi_sim spi_master.v spi_slave.v spi_system.v tb_spi_master.v
