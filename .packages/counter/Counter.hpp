#pragma once
#include <stdint.h>

class Counter {
  volatile uint32_t* reg;
public:
  Counter(volatile uint32_t* addr) : reg(addr) {}
  void set(uint32_t clk) { reg[0] = clk; }
};
