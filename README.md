# PicoFlashButton
This project involves using assembly and C code to create an alarm interrupt that periodically flashes an LED on a Raspberry Pi Pico board, with additional functionality for button presses to modify the flashing rate and state.

## Summary

This Github repository contains the source code and documentation for a project that uses ARM assembly and C code to control the LED built into a Raspberry Pi Pico. The LED flashes every second, alternating between on and off.

The project includes an interrupt service routine to handle button presses on the MAKER-PI-PICO board. Pressing button GP21 stops and starts the flashing behavior, while pressing GP20 or GP22 adjusts the flashing rate. The current interval value and LED flashing state are stored in shared data segments.

The project is written entirely in ARM assembly, with C header-files and wrapper functions.


To compile the assembly code, you can use the following commands:

```shell
arm-none-eabi-as -o gpio.o gpio.S
arm-none-eabi-as -o alarm.o alarm.S
arm-none-eabi-as -o button.o button.S
arm-none-eabi-as -o pico.o pico.S
```

The pico.ld file includes the memory layout of the Raspberry Pi Pico and specifies the entry point for your program, while gpio.ld, button.ld, and alarm.ld files specify the memory regions for the code and data sections for their respective functions. By using all of these linker scripts together, you it ensures that the code and data sections are properly located in memory and that the entry point is correctly defined.

To link all of your object files, you would use a command similar to:

```shell
arm-none-eabi-ld -T pico.ld -T gpio.ld -T button.ld -T alarm.ld -o picoflashbutton.elf pico_asm.o gpio.o button.o alarm.o
```

Then to convert the picoflashbutton.elf file into a binary file format (picoflashbutton.bin). The -O option specifies the output format, and binary is the output format being used:

```shell
arm-none-eabi-objcopy -O binary picoflashbutton.elf picoflashbutton.bin
```