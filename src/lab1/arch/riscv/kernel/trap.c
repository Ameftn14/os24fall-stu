#include "stdint.h"
#include "printk.h"
#include "clock.h"

void trap_handler(uint64_t scause, uint64_t sepc)
{
    // 通过 `scause` 判断 trap 类型
    // 如果是 interrupt 判断是否是 timer interrupt
    // 如果是 timer interrupt 则打印输出相关信息，并通过 `clock_set_next_event()` 设置下一次时钟中断
    // `clock_set_next_event()` 见 4.3.4 节
    // 其他 interrupt / exception 可以直接忽略，推荐打印出来供以后调试
    if (scause == 0x8000000000000005)
    {
        // Supervisor software interrupt from a machine-mode timer
        printk("Supervisor software interrupt from a machine-mode timer\n");
        // 设置下一次时钟中断
        clock_set_next_event();
        return;
    }
    else
    {
        printk("Unhandled trap: scause=0x%lx, sepc=0x%lx\n", scause, sepc);
        return;
    }
}