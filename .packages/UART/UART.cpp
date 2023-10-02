#include "UART.hpp"
#include "cpu.hpp"

// Receive

char UART::read() {
  int32_t c = -1;
  uint32_t cycles_begin, cycles_now, cycles;

  cycles_begin = rdcycle_l();
  while(c == -1) {
    cycles_now = rdcycle_l();
    cycles = cycles_now - cycles_begin;
    if(cycles > 12000000) {
      cycles_begin = cycles_now;
    }
    c = reg[Reg_IO];
  }
  return c;
}

uint32_t UART::read_int() {
  uint32_t ret = 0;
  uint32_t base = 10;
  char rcv;
  while(true) {
    rcv = read();
    if('0' <= rcv && rcv <= '9') {
      ret += ret * base + (rcv - '0');
    } else {
      break;
    }
  }
  return ret;
}

uint32_t char_to_int(char c) {
  if('0' <= c && c <= '9')
    return c - '0';
  else if('A' <= c && c <= 'F')
    return c - 'A' + 10;
  else if('a' <= c && c <= 'f')
    return c - 'a' + 10;
  else
    return -1;
}
