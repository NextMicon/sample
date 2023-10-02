#pragma once
#include <stdint.h>

class Selector {
  volatile uint32_t* reg;
public:
  Selector(volatile uint32_t* addr) : reg(addr) {}
  void select(uint32_t ch) { reg[0] = (0b1 << ch); }
  void unselect() { reg[0] = (0); }
};
