/*
 * pico_asm.S - assembly code for the Raspberry Pi Pico
 */

/*
 * Declare sections for linker script
 */
.section .text
.globl _start

.section .data
flashing_state: .word 0
interval: .word 2

.section .bss

/*
 * _start - the entry point of the program
 */
_start:
    bl gpio_init
    
    ...

/*
 * gpio_init - initialize GPIO pins
 */
gpio_init:
    ldr r0, =0x40014000  @ Load address of GPIO base register
    ldr r1, =0x55555555  @ Set pins GP20, GP21, and GP22 as inputs
    str r1, [r0, #0x00]  @ Write to GPCLR0 register to clear the pins
    ldr r1, =0x02000000  @ Set pin GP25 as output
    str r1, [r0, #0x08]  @ Write to GPSET0 register to set the pin
    bx lr                @ Return from function

/*
 * button_init - initialize button interrupts
 */
button_init:
    ldr r0, =0x40014000  @ Load address of GPIO base register
    ldr r1, =0x00c00000  @ Set pins GP20, GP21, and GP22 as edge-sensitive
    str r1, [r0, #0x04]  @ Write to GPAREN0 and GPAFEN0 registers to enable interrupts
    ldr r1, =0x00700000  @ Enable interrupt for pins GP20, GP21, and GP22
    str r1, [r0, #0x1c]  @ Write to GPIOINT0 register to enable interrupts
    bx lr                @ Return from function

/*
 * alarm_init - initialize SysTick timer
 */
alarm_init:
    ldr r0, =0xe000e010  @ Load address of SysTick control and status register
    mov r1, #0x00000004  @ Set clock source to processor clock, enable SysTick interrupt
    str r1, [r0, #0x00]  @ Write to the control register to configure SysTick
    ldr r1, =0x00400000  @ Set the reload value to 1 second
    str r1, [r0, #0x04]  @ Write to the reload value register
    bx lr                @ Return from function

/*
 * button_isr - interrupt service routine for button presses
 */
button_isr:
    ldr r0, =0x40014000  @ Load address of GPIO base register
    ldr r1, [r0, #0x10]  @ Load the interrupt status register
    and r1, #0x00700000  @ Mask the bits for GP20, GP21, and GP22
    cmp r1, #0x00400000  @ Check if GP21 is pressed
    beq toggle_flashing   @ If GP21 is pressed, toggle flashing state
    cmp r1, #0x00100000  @ Check if GP20 is pressed
    beq halve_interval    @ If GP20 is pressed, halve interval
    cmp r1, #0x00200000  @ Check if GP22 is pressed
    beq double_interval   @ If GP22 is pressed, double interval
    bx lr                @ Return from ISR if no buttons are