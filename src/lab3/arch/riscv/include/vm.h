#ifndef _VM_H_
#define _VM_H_

#include "stdint.h"

void setup_vm(void);
void setup_vm_final(void);
void create_mapping(uint64_t *, uint64_t, uint64_t, uint64_t, uint64_t);

#endif