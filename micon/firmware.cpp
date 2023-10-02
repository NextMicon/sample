#include "firmware.hpp"

ROM_CFG rom_cfg((volatile uint32_t*)0x0200'0000);
/* definitions */
UART serial((volatile uint32_t*)0x100'0000);
GPIO led((volatile uint32_t*)0x200'0000);
PWM pwm((volatile uint32_t*)0x300'0000);
/* end */

void main() {
  init_data();
  init_bss();
  init_array();

#ifndef SIMU
  rom_cfg.dual_io();
#endif

  init();
  for(;;) loop();
}
