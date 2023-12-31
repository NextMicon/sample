#include "firmware.hpp"

void init() {
  set_irq_mask(0);
  uart.baud(460800);
  gpio.out_mode();
  uart << "  _  _         _       __  __ ___ ___ ___  _  _  \n"
          " | \\| |_____ _| |_ ___|  \\/  |_ _/ __/ _ \\| \\| | \n"
          " | .` / -_) \\ /  _|___| |\\/| || | (_| (_) | .` | \n"
          " |_|\\_\\___/_\\_\\\\__|   |_|  |_|___\\___\\___/|_|\\_| \n"
          "\n"
          "        32bit RISC-V microcontroller\n"
          "           Supported by Next-MICON\n"
          "        https://github.com/Next-MICON \n\n";
}

void loop() {
  delayMs(1000);
  gpio.on();
  delayMs(1000);
  gpio.off();
}

uint32_t* irq(uint32_t* regs, uint32_t irqs) {
  static uint32_t irq_counts[32] = {0};
  uart << "\nIRQ:";
  for(uint32_t i = 0; i < 32; ++i) {
    if((irqs & (1 << i)) != 0) {
      ++irq_counts[i];
      uart << " #" << i << "*" << irq_counts[i];
    }
  }
  uart << "\n";
  return regs;
}
