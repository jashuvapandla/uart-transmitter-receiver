# uart-transmitter-receiver
Designed a UART Transmitter and Receiver in Verilog for serial communication. Implemented configurable clock and baud-rate generation, 8-bit data transmission, start/stop bit handling, TX/RX control logic, and a testbench to verify serial data transfer between transmitter and receiver.
# UART Transmitter and Receiver using Verilog

## Overview

This project implements a UART (Universal Asynchronous Receiver/Transmitter) communication system using Verilog HDL.

The design consists of a UART transmitter and receiver. The transmitter converts 8-bit parallel data into serial data, while the receiver converts the serial data back into 8-bit parallel data.

The transmitter and receiver are connected together in the testbench to verify the complete data transmission and reception process.

---

## Main Functions

### UART Transmitter

- Accepts 8-bit parallel input data
- Generates the UART start bit and stop bit
- Converts parallel data into serial data
- Controls transmission timing using the baud rate
- Provides a `busy` signal during transmission

### UART Receiver

- Detects the UART start bit
- Samples the incoming serial data
- Receives 8 data bits
- Converts serial data back into 8-bit parallel data
- Provides a `valid` signal when a complete byte is received

---

## UART Frame Format

Each transmitted byte follows the UART frame format:

```text
        1 Bit          8 Data Bits          1 Bit
          │                  │                 │
          ▼                  ▼                 ▼

## Data flow
       8-bit Parallel Data
                │
                ▼
       ┌─────────────────┐
       │ UART Transmitter│
       └────────┬────────┘
                │
                │ Serial Data
                ▼
       ┌─────────────────┐
       │   UART Receiver │
       └────────┬────────┘
                │
                ▼
       8-bit Parallel Data

       START              DATA               STOP
          0              D0 → D7                1
