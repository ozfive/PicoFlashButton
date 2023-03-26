.section .text
.globl _start

_start:
    bl gpio_init
    bl alarm_init

    ...

alarm_init:
    ldr r0, =0xe000e010  @ Load address of SysTick control and status register
    mov r1, #0x00000004  @ Set clock source to processor clock, enable SysTick interrupt
    str r1, [r0, #0x00]  @ Write to the control register to configure SysTick
    ldr r1, =0x07EC23FF  @ Set the reload value to 1 second if clock speed of processor is 133MHz
    str r1, [r0, #0x04]  @ Write to the reload value register
    bx lr                @ Return from function

alarm_isr:
    ldr r0, =flashing_state  @ Load address of flashing_state variable
    ldr r1, [r0]           @ Load current flashing state
    cmp r1, #1             @ Check if LED is on
    beq turn_led_off       @ If LED is on, turn it off
    b turn_led_on          @ If LED is off, turn it on

turn_led_on:
    ldr r0, =0x40014000  @ Load address of GPIO base register
    ldr r1, =0x02000000  @ Load value to set GP25 high
    str r1, [r0, #0x1c]  @ Write to GPSSET0 register to set GP25 high
    mov r1, #1            @ Set flashing state to on
    ldr r0, =flashing_state  @ Load address of flashing_state variable
    str r1, [r0]          @ Store flashing state in shared memory
    bx lr                 @ Return from function

turn_led_off:
    ldr r0, =0x40014000  @ Load address of GPIO base register
    ldr r1, =0x02000000  @ Load value to set GP25 low
    str r1, [r0, #0x28]  @ Write to GPCLR0 register to set GP25 low
    mov r1, #0            @ Set flashing state to off
    ldr r0, =flashing_state  @ Load address of flashing_state variable
    str r1, [r0]          @ Store flashing state in shared memory
    bx lr                 @ Return from function