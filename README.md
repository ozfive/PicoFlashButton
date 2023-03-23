# PicoFlashButton
This project involves using assembly and C code to create an alarm interrupt that periodically flashes an LED on a Raspberry Pi Pico board, with additional functionality for button presses to modify the flashing rate and state.

## Summary

This Github repository contains the source code and documentation for a project that uses ARM assembly and C code to control the LED built into a Raspberry Pi Pico. The LED flashes every second, alternating between on and off.

The project includes an interrupt service routine to handle button presses on the MAKER-PI-PICO board. Pressing button GP21 stops and starts the flashing behavior, while pressing GP20 or GP22 adjusts the flashing rate. The current interval value and LED flashing state are stored in shared data segments.

The project is written entirely in ARM assembly, with C header-files and wrapper functions.
