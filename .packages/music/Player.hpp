#pragma once
#include "Mixier.hpp"
#include "Oscilator.hpp"
#include "cpu.hpp"

class Player {
  const int N_CH = 5;
  Oscilator* osc[5];
  Mixier* mix;
public:
  Player(Mixier* mixier, Oscilator* ch0, Oscilator* ch1, Oscilator* ch2, Oscilator* ch3, Oscilator* ch4) {
    mix = mixier;
    osc[0] = ch0;
    osc[1] = ch1;
    osc[2] = ch2;
    osc[3] = ch3;
    osc[4] = ch4;
  }

  void play(int ch, int note) {
    if(0 <= ch && ch < N_CH) osc[ch]->play(note);
  }

  void stop(int ch) {
    if(0 <= ch && ch < N_CH) osc[ch]->stop();
  }

  void arpeggio(uint32_t note0, uint32_t note1, uint32_t note2, uint32_t tempo) {
    uint32_t note4 = 1'000'000 * 60 / tempo;  // us
    play(0, note0);
    delayUs(note4 / 2);
    play(1, note1);
    delayUs(note4 / 2);
    play(2, note2);
    delayUs(note4 * 3);
    stop(0);
    stop(1);
    stop(2);
  }

  // Compressed MIDI
  // Data Format
  //          15 - 0:Delay 1:Sound
  //   IF Delay
  //     14 ~  0 - Delay Time [ms]
  //   IF Sound
  //     14 ~ 13 - Chip Sellect
  //     12 ~ 11 - Channel
  //     10 ~  4 - Note Number
  //      3 ~  0 - Velocity
  void cmidi(uint16_t data) {
    int type = data & (0b1 << 15);
    if(type) {
      int channel = (data >> 11) & 0b11;
      int note_number = (data >> 4) & 0b1111'111;
      int velocity = data & 0b1111;
      play(channel, velocity ? note_number : 0);
    } else {
      delayMs(data);
    }
    return;
  }

  void music(const uint16_t* m, uint32_t len) {
    for(int i = 0; i < len; ++i) {
      uint16_t data = m[i];
      cmidi(data);
    }
  }
};
