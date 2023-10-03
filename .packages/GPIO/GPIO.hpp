#pragma once
#include <stdint.h>

class GPIO {
  volatile uint32_t* reg;
  enum Regs {
    Reg_IOSEL = 0,
    Reg_OUT = 1,
    Reg_IN = 2
  };
public:
  enum Mode {
    IN = 0,
    OUT = 1
  };
  GPIO(volatile uint32_t* addr) : reg(addr) {}
  void mode(Mode mode) { reg[Reg_IOSEL] = mode; }

  void in_mode() { reg[Reg_IOSEL] = Mode::IN; }
  uint32_t read() { return reg[Reg_IN]; }

  void out_mode() { reg[Reg_IOSEL] = Mode::OUT; }
  void write(uint32_t val) { reg[Reg_OUT] = val; }
  void on() { write(1); }
  void off() { write(0); }
};

void gpio_blink(GPIO& gpio_out, uint32_t rpt = 5, uint32_t delay_ms = 500);
void gpio_test(GPIO& gpio_out, GPIO& gpio_in, uint32_t time = 0x1'0000);
