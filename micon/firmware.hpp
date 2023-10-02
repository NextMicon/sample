#include "cpu.hpp"
#include "spirom/ROM_CFG.hpp"
/* includes */
#include "GPIO/GPIO.hpp"
#include "PWM/PWM.hpp"
#include "UART/UART.hpp"
/* end */

extern ROM_CFG rom_cfg;
/* declarations */
extern UART serial;
extern GPIO led;
extern PWM pwm;
/* end */

void init();
void loop();
extern "C" uint32_t* irq(uint32_t* regs, uint32_t irqs);
