#pragma once
#include <stdint.h>

class ROM_CFG {
  volatile uint32_t* reg;
public:
  ROM_CFG(volatile uint32_t* addr) : reg(addr) {}
  void dual_io() { reg[0] = ((reg[0] & ~0x007F0000) | 0x00400000); };
};
