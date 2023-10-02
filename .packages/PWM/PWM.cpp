#include "PWM.hpp"
#include "cpu.hpp"

void pwm_blink(PWM& pwm_out, uint32_t rpt, uint32_t delay_us) {
  for(int rpt = 0; rpt < 5; ++rpt) {
    for(int i = 0; i < 256; ++i) {
      pwm_out.duty(i);
      delayUs(delay_us);
    }
    for(int i = 256; i >= 0; --i) {
      pwm_out.duty(i);
      delayUs(delay_us);
    }
  }
}
