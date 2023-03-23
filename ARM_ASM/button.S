.section .text
.globl _start

_start:
    bl gpio_init
    bl alarm_init
    bl button_init

    ...

button_init:
    ldr r0, =0x40014000  @ Load address of GPIO base register
    ldr r1, =0x00c00000  @ Set pins GP20, GP21, and GP22 as edge-sensitive
    str r1, [r0, #0x04]  @ Write to GPAREN0 and GPAFEN0 registers to enable interrupts
    ldr r1, =0x00700000  @ Enable interrupt for pins GP20, GP21, and GP22
    str r1, [r0, #0x1c]  @ Write to GPIOINT0 register to enable interrupts
    bx lr                @ Return from function

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
    bx lr                @ Return from ISR if no buttons are pressed

toggle_flashing:
    ldr r0, =flashing_state  @ Load address of flashing_state variable
    ldr r1, [r0]             @ Load current flashing state
    cmp r1, #1               @ Check if LED is on
    beq turn_led_off         @ If LED is on, turn it off and set flashing state to off
    b turn_led_on            @ If LED is off, turn it on and set flashing state to on

halve_interval:
    ldr r0, =interval        @ Load address of interval variable
    ldr r1, [r0]             @ Load current interval value
    asr r1, #1               @ Halve the interval value
    cmp r1, #0               @ Check if interval value is zero
    beq reset_interval       @ If interval value is zero, reset it to default
    str r1, [r0]             @ Store halved interval value in shared memory
    bx lr                    @ Return from function

double_interval:
    ldr r0, =interval        @ Load address of interval variable
    ldr r1, [r0]             @ Load current interval value
    add r1, r1               @ Double the interval value
    cmp r1, #0               @ Check if interval value is zero
    beq reset_interval       @ If interval value is zero, reset it to default
    str r1, [r0]             @ Store doubled interval value in shared memory
    bx lr                    @ Return from function

reset_interval:
    ldr r0, =interval        @ Load address of interval variable
    ldr r1, =2               @ Load default interval value