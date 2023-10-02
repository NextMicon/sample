#include "firmware.hpp"

void init() {
  serial << "Hello World";
  led.out_mode();
}

void loop() {
  delayMs(1000);
  led.write(1);
  delayMs(1000);
  led.write(0);
}

uint32_t* irq(uint32_t* reg, uint32_t irq_flags) {
  serial << "Interrupt!";
  for(int i = 0; i < 32; ++i) {
    if(irq_flags & 1 << i) {
      serial << " #" << i;
    }
  }
  serial << "\n";
  return reg;
}
