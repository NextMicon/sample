#include "GPIO.hpp"
#include "cpu.hpp"

/// @brief Blink GPIO in 1 Hz
/// @param gpio_out
/// @param rpt repeat time
void gpio_blink(GPIO& gpio_out, uint32_t rpt, uint32_t delay_ms) {
  gpio_out.mode(GPIO::Mode::OUT);
  for(int i = 0; i < rpt; ++i) {
    gpio_out.on();
    delayMs(delay_ms);
    gpio_out.off();
    delayMs(delay_ms);
  }
}

/// @brief Read gpio_in and write to gpio_out
/// @note This test require 2 GPIO module
/// @param gpio_out
/// @param gpio_in
/// @param time Repeat time (depends on clock frequency)
void gpio_test(GPIO& gpio_out, GPIO& gpio_in, uint32_t time) {
  gpio_in.mode(GPIO::Mode::IN);
  gpio_out.mode(GPIO::Mode::OUT);
  for(int i = 0; i < time; ++i) {
    gpio_out.write(gpio_in.read());
  }
}
