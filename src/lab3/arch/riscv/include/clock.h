#ifndef __CLOCK_H__
#define __CLOCK_H__

#include "stdint.h"

uint64_t get_cycles();

void clock_set_next_event();

#endif 
