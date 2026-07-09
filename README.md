# CSRO-Based Green Physical Unclonable Function (PUF)

A Current-Starved Ring Oscillator (CSRO)-Based Physical Unclonable Function for Low-Power IoT Hardware Authentication.

![Cadence](https://img.shields.io/badge/Tool-Cadence%20Virtuoso-blue)
![Spectre](https://img.shields.io/badge/Simulator-Spectre-purple)
![Verilog](https://img.shields.io/badge/HDL-Verilog-green)
![Project](https://img.shields.io/badge/Domain-Hardware%20Security-orange)
> Developed as part of the **Samsung Chip Design Studio (IIIT Bangalore)** using Cadence Virtuoso, Spectre, and Verilog.

---

## Project Overview

This repository documents the design, simulation, and behavioural verification of a Current-Starved Ring Oscillator (CSRO) based Physical Unclonable Function (PUF). The project was carried out as part of the Samsung Chip Design Studio at IIIT Bangalore.

A Physical Unclonable Function uses small manufacturing variations in silicon to generate a unique hardware fingerprint. Instead of storing a secret key directly in memory, a PUF generates a device-specific response when a challenge input is applied.

Ring Oscillator PUFs compare the oscillation frequencies of different ring oscillators. Since each oscillator has slight delay variations due to process mismatch, the comparison output can be used to generate a response bit.

In this project, a Current-Starved Ring Oscillator was used to reduce power consumption and control oscillation delay. Unlike a normal ring oscillator where the inverters are directly connected to VDD and GND, the CSRO uses current-limiting transistors to restrict current flow and improve delay controllability.

The term Green PUF refers to a PUF architecture focused on low power consumption, reliability, and secure authentication for low-energy devices such as IoT nodes, wearables, and medical electronics.

---

## Motivation

The rapid growth of IoT devices creates a need for secure, lightweight, and energy-efficient hardware authentication. Traditional PUF designs can suffer from high power consumption, instability under temperature variation, and dependence on additional error correction logic.

The motivation of this project was to explore a low-power PUF design that reduces power consumption while maintaining reliable challenge-response behaviour.

---

## Objectives

The main objectives of this project were:

- Study the working principle of Ring Oscillator based PUFs.
- Design and simulate a Current-Starved Ring Oscillator using Cadence Virtuoso.
- Compare normal RO and CSRO behaviour through transient simulations.
- Perform device-level characterisation using DC and transient analysis.
- Analyse temperature sensitivity of the current-starved structure.
- Develop an RTL behavioural model for challenge-response verification.
- Connect transistor-level circuit behaviour with digital verification flow.

---

## Tools Used

| Category | Tools |
|---|---|
| Circuit Design | Cadence Virtuoso |
| Circuit Simulation | Spectre |
| RTL Design | Verilog |
| RTL Simulation | Vivado / NCLaunch |
| Documentation | GitHub Markdown, PowerPoint |

---

