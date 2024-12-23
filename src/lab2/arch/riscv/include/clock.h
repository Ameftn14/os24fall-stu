#ifndef CLOCK_H
#define CLOCK_H

#include "stdint.h"

uint64_t get_cycles();

void clock_set_next_event();

#endif // CLOCK_H