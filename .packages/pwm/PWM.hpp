#pragma once
#include <stdint.h>

class PWM {
  volatile uint32_t* reg;
public:
  PWM(volatile uint32_t* addr) : reg(addr) {}
  void duty(uint32_t val) { reg[0] = val; }
};

void pwm_blink(PWM& pwm_out, uint32_t rpt = 5, uint32_t delay_us = 1000);
