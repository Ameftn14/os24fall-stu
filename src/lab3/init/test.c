#include "sbi.h"
#include "printk.h"
#include "defs.h"

void test() {
    int i = 0;

    // uint64_t sstatus_value;
    // sstatus_value = csr_read(sstatus);
    // printk("sstatus: 0x%lx\n", sstatus_value);

    // uint64_t data_to_write = 0x12345678;

    // // write
    // csr_write(sscratch, data_to_write);
    // // read
    // uint64_t read_value;
    // read_value = csr_read(sscratch);
    // // check
    // if (read_value == data_to_write) {
    //     printk("Success. sscratch : 0x%lx\n", read_value);
    // } else {
    //     printk("sscratch write failed: write=0x%lx, read=0x%lx\n", data_to_write, read_value);
    // }


    while (1) {
        if ((++i) % 100000000 == 0) {
            printk("kernel is running!\n");
            i = 0;
        }
    }
}
