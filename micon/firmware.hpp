#include "cpu.hpp"
#include "spirom/ROM_CFG.hpp"
/* includes */
#include "GPIO/GPIO.hpp"
#include "UART/UART.hpp"
/* end */

extern ROM_CFG rom_cfg;
/* declarations */
extern UART uart;
extern GPIO gpio;
/* end */

void init();
void loop();
extern "C" uint32_t* irq(uint32_t* regs, uint32_t irqs);
