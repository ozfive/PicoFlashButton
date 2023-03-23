.section .text
.globl _start

_start:
    bl gpio_init
    
    ...

gpio_init:
    ldr r0, =0x40014000  @ Load address of GPIO base register
    ldr r1, =0x55555555  @ Set pins GP20, GP21, and GP22 as inputs
    str r1, [r0, #0x00]  @ Write to GPCLR0 register to clear the pins
    ldr r1, =0x02000000  @ Set pin GP25 as output
    str r1, [r0, #0x08]  @ Write to GPSET0 register to set the pin
    bx lr                @ Return from function

.section .data
flashing_state: .word 0
interval: .word 2

.section .bss