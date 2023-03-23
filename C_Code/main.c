#include "pico.h"
#include "pico/stdlib.h"

#include "Header_Files/alarm.h"
#include "Header_Files/button.h"
#include "Header_Files/gpio.h"


extern void _start();
extern void button_isr();
extern void alarm_isr();

void alarm_init();
void button_init();

int main()
{
    stdio_init_all();
    gpio_init(0);

    irq_set_exclusive_handler(SYSTICK_IRQ, alarm_isr);
    irq_set_enabled(SYSTICK_IRQ, true);

    irq_set_exclusive_handler(GPIO_IRQ0, button_isr);
    irq_set_enabled(GPIO_IRQ0, true);

    _start();

    return 0;
}