#pragma once
#include <stdint.h>

static const uint32_t FREQ_TABLE[] = {
    0, 9, 9, 10, 10, 11, 12, 12, 13, 14, 15, 15,
    16, 17, 18, 19, 21, 22, 23, 25, 26, 28, 29, 31,
    33, 35, 37, 39, 41, 44, 46, 49, 52, 55, 58, 62,
    65, 69, 73, 78, 82, 87, 93, 98, 104, 110, 117, 124,
    131, 139, 147, 156, 165, 175, 185, 196, 208, 220, 233, 247,
    262, 277, 294, 311, 330, 349, 370, 392, 415, 440, 466, 494,
    523, 554, 587, 622, 659, 699, 740, 784, 831, 880, 932, 988,
    1047, 1109, 1175, 1245, 1319, 1397, 1480, 1568, 1661, 1760, 1865, 1976,
    2093, 2218, 2349, 2489, 2637, 2794, 2960, 3136, 3322, 3520, 3729, 3951,
    4186, 4435, 4699, 4978, 5274, 5587, 5920, 6272, 6645, 7040, 7459, 7902,
    8372, 8870, 9397, 9956, 10548, 11175, 11840, 12544};

class Oscilator {
  volatile uint32_t* reg;
  uint32_t _clk;
public:
  Oscilator(volatile uint32_t* addr) : reg(addr) {}
  void set_clk(uint32_t clk) { _clk = clk; }

  /// @brief Start oscilating
  /// @param note_no MIDI Note number (0~127)
  void play(uint32_t note_no) {
    if(0 <= note_no && note_no < 128)
      reg[0] = _clk / FREQ_TABLE[note_no];
  }

  /// @brief Stop oscilating
  void stop() { reg[0] = 0; }
};
