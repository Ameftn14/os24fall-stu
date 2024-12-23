#ifndef _VM_H_
#define _VM_H_

#include "stdint.h"

void setup_vm(void);
void setup_vm_final(void);

uint64_t get_pa(uint64_t *pgtbl, uint64_t va);

void create_mapping(uint64_t *, uint64_t, uint64_t, uint64_t, uint64_t);

void page_deep_copy(uint64_t *pgtbl);
void page_deep_copy_rec(uint64_t *pgtbl, int level);

#endif