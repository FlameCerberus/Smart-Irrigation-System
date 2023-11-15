# Smart Irrigation System

Smart Irrigation System using PIC18F6620, Water pumps and Relays. This project is a microcontroller-based moisture control system that controls three pumps based on the analog input from three sensors and displays the pump status on  seven segment displays. The system is controlled using assembly language and the pumps are connected to pins B5, B6, and B7, respectively. The analog sensors are connected to pins AN0, AN1, and AN2. When the moisture level is below a certain threshold, the corresponding pump is turned on, and its status is displayed as "ON" on the seven segment display using pins D0, D1, and D2. The threshold is detected using the analog input by determining the voltage value from the moisture sensor. The system also includes a delay subroutine for the delays required in the system which is set to 1 second and a switch interrupt service routine for the emergency stop button and restart button. This project is suitable for applications where precise moisture control and pump monitoring are required, such as in irrigation systems, hydroponics setups, or plant growth chambers using microcontrollers as its processing system.

## Table of Contents
- [Circuit Overview](#circuit-overview)
- [System Features](#system-features)
- [Demonstration](#demonstration)
- [Delay Subroutines and Calculations](#delay-subroutines-and-calculations)
    - [TIMER0 Calculation](#timer0-calculation)
    - [Delay Subroutine](#delay-subroutine)
    - [Tacq Calculation](#tacq-calculation)
- [Usage Instructions](#usage-instructions)
- [References](#references)

## Circuit Overview

![Circuit Diagram](https://github.com/FlameCerberus/Smart-Irrigation-System/blob/main/CircuitInProteusSS.png)

### Water Pumps and Relays

- The pumps in the system are powered by an AC voltage of 230V and are equipped with 12V-powered relays. These relays, serving as a protective measure against overvoltage to the microcontroller, are controlled through NPN transistors. The transistors act as an additional layer of protection, ensuring the relay voltage is not directly connected to the microcontroller.
- Each pump is associated with a dedicated input dictated by the microcontroller's digital output value. The inclusion of a potentiometer on each pump acts as a moisture sensor for the sake of the simulation. This setup allows for precise control of the pumps based on the microcontroller's digital signals and the simulated moisture levels provided by the potentiometers.

### 7-Segment Display and Buzzer

- The 7-Segment Display is connected and would only display ON whenever turned on by the microcontroller to reduce the number of connections/wire required for the system. Hence, the input would be connected to only one of the microcontroller's pin to power up the display.
- The buzzer used the same pin input for the 7-Segment Display for their respective water pump and requires an inverter for the transistor to isolate the 12V source used by the buzzer from the microcontroller.

## System Features

- Three water pumps controlled by the microcontroller based on moisture levels.
- Real-time status display on seven-segment displays.
- Emergency stop button and restart button for system control using intterrupt routine.
- Assembly language programming for microcontroller control.

## Demonstration

https://github.com/FlameCerberus/Smart-Irrigation-System/assets/96816249/1c7479c0-4991-46c5-ac8d-5c7be1302eff

## Delay Subroutines and Calculations

### TIMER0 Calculation

- period = 1/32M = 31.25ns
- 1 instruction = 4 period = 125ns
- Total instruction for 2µs = 2µs / 125ns = 16
- TMR0L value = 256 - 16 = D'240' = 0xF0

### Delay Subroutine

The delay subroutine is crucial for maintaining precise timing within the system. The calculation for the delay is as follows:

- Period: 1/32 MHz = 31.25 ns
- Total Instruction Time for 2 seconds: 1 second / 31.25 ns = 80000000
- 8M = (247+3 instruction) * 250 * 128

### Tacq Calculation

The Tacq (acquisition time) calculation is essential for the accuracy of the analog-to-digital conversion. The formula used is:

- Tacq > 1.6 µs + 64 * T_OSCC_Required

Where T_OSC_Required is calculated as:

- T_OSC_Required = 2 µs + 9.61 µs + (Temp - 25°C) * 0.05 µs/°C

Assuming a room temperature of 25°C, 

- Tacq = 2µs + 9.61µs
- Tacq = 11.61 µs
- Hence minimum required time for A/D conversion is 11.61µs. So we would use 16µs in the microcontroller.
- 64Fosc is used as the microcontroller is operating at 32MHz

## Usage Instructions

1. Connect water pumps to pins B5, B6, and B7.
2. Connect analog moisture sensors to pins AN0, AN1, and AN2.
3. Display pump status on seven-segment displays connected to pins D0, D1, and D2.

## References

1. https://ww1.microchip.com/downloads/aemDocuments/documents/MCU08/ProductDocuments/DataSheets/39609C.pdf
2. https://microcontrollerpicavr.blogspot.com/2017/08/pic18-timer-tutorial.html
