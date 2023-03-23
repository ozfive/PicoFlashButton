ENTRY(_start)

MEMORY
{
    RAM   (rwx) : ORIGIN = 0x20000000, LENGTH = 0x00010000
    FLASH (rx)  : ORIGIN = 0x10000000, LENGTH = 0x00040000
}

SECTIONS
{
    .text :
    {
        *(.text.startup)
        *(.text*)
    } > FLASH

    .data :
    {
        *(.data*)
    } > RAM AT > FLASH

    .bss :
    {
        *(.bss*)
    } > RAM

    /* Uncomment the following line to include the heap section */
    /* .heap : ALIGN(4) { *(.heap*) } > RAM */

    /* Uncomment the following line to include the stack section */
    /* .stack : { *(.stack*) } > RAM */
}
