#pragma once
#include "cpu.hpp"
#include <stdint.h>

class UART {
  volatile uint32_t* reg;
  enum Regs { Reg_Baud = 0,
              Reg_IO = 1 };
public:
  UART(volatile uint32_t* addr) : reg(addr) {}
  static const char endl = '\n';
  void baud(uint32_t baudrate) {
    reg[0] = CLK_FREQ / baudrate;
  }
  UART& print(char ch) {
    reg[Reg_IO] = ch;
    return *this;
  }
  UART& print(const char* ptr) {
    while(*ptr != 0) print(*(ptr++));
    return *this;
  }
  UART& dec(uint32_t val) {
    char buffer[10];
    char* ptr = buffer;
    while(val || ptr == buffer) {
      *(ptr++) = val % 10;
      val = val / 10;
    }
    while(ptr != buffer) {
      print('0' + *(--ptr));
    }
    return *this;
  }
  UART& hex(uint32_t val, int digits) {
    for(int i = (4 * digits) - 4; i >= 0; i -= 4)
      print("0123456789ABCDEF"[(val >> i) & 0xF]);
    return *this;
  }
  UART& operator<<(char ch) { return print(ch); }
  UART& operator<<(const char* ptr) { return print(ptr); }
  UART& operator<<(uint32_t val) { return dec(val); }

  char read();
  uint32_t read_int();
  UART& operator>>(char& c) {
    c = read();
    return *this;
  }
  UART& operator>>(uint32_t& i) {
    i = read_int();
    return *this;
  }
};

uint32_t char_to_int(char c);
