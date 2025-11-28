# PS-Driven On-Board Testbench for RTL Validation over UART  
Using the Zynq Processing System as a Live Stimulus/Response Engine

![main_setup](https://github.com/user-attachments/assets/954b1508-f5f8-49d9-b39f-7f9cb4c84dae)

## Overview
This project repurposes the Zynq Processing System (PS) as an active, on-board testbench for validating RTL running in the Programmable Logic (PL). Instead of relying on external simulation environments, the embedded CPU injects stimulus into the PL at runtime, receives processed responses, and performs immediate checking or logging. This method enables hardware-speed validation, continuous interaction, and rapid iteration without external test equipment.

UART serves as the communication backbone. Data enters through MIO-mapped UART, reaches the PS, is forwarded to the PL through UART EMIO, processed by the target RTL, and is returned through the same path. Software running in Vitis orchestrates stimulus generation and response capture, using straightforward C-based drivers and console output functions such as `xil_printf()`.

This workflow demonstrates how Zynq-class SoCs eliminate traditional verification bottlenecks by letting the embedded CPU operate as the integrated testbench for real hardware.

---
<img width="624" height="177" alt="Full_Diagram" src="https://github.com/user-attachments/assets/0bfa4337-a140-4955-ba69-825566d8a14c" />

## Architecture Summary
- **MIO UART Interface**: Carries external stimulus into the PS.  
- **PS Software Testbench**: C code running on ARM generates, forwards, and validates data.  
- **EMIO UART Interface**: Bridges PS to PL through the fabric.  
- **RTL Processing Block**: Example inverter RTL with UART driver for encode/decode.  
- **Round-Trip Validation**: PL sends processed results back to PS for immediate capture and display.

---

## Reproduction Steps  
The full setup is documented in a three-part blog series:

### **Blog 1 — Designing the UART Driver for the RTL Module**  
UART framing, FSM design, PL-side receiver/transmitter architecture.  
**Link:** *https://shreyadatir30.github.io/posts/2025/09/uart-design-part1/*
<img width="626" height="248" alt="ZyNQ_Top" src="https://github.com/user-attachments/assets/08122755-d69f-44ec-b770-ec27dd1cab6e" />


### **Blog 2 — Constructing and Exporting the PS–PL Integrated Design in Vivado**  
Block design creation, EMIO configuration, address mapping, .xsa export.  
**Link:** *https://shreyadatir30.github.io/posts/2025/09/uart-design-part2/*

### **Blog 3 — Embedded Programming with Vitis for UART-Based Stimulus and Response Capture**  
PS as live testbench, C-based stimulus generation, console I/O capture.  
**Link:** *https://shreyadatir30.github.io/posts/2025/09/uart-ps-pl-vitis/*

---

## Purpose of the Project Name
**PS-Driven On-Board Testbench for RTL Validation over UART** captures the technique’s intention: the CPU actively drives and verifies hardware in the fabric, transforming the Zynq SoC into a self-contained verification platform that replaces external benches with real-time embedded execution.
