#include "cpu.hpp"
#include "spirom/ROM_CFG.hpp"
/* includes */
/* end */

extern ROM_CFG rom_cfg;
/* declarations */
/* end */

void init();
void loop();
extern "C" uint32_t* irq(uint32_t* regs, uint32_t irqs);
