ENTRY(gpio_init)

SECTIONS {
    . = 0x00000000;

    .text : {
        *(.text)
    }

    .data : {
        *(.data)
        *(.rodata)
    }

    .bss : {
        *(.bss)
    }

    __stack = ALIGN(4);
    __end = .;
}