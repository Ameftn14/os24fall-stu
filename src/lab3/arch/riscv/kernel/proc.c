#include "mm.h"
#include "defs.h"
#include "proc.h"
#include "stdlib.h"
#include "printk.h"

extern void __dummy();

struct task_struct *idle;           // idle process
struct task_struct *current;        // 指向当前运行线程的 task_struct
struct task_struct *task[NR_TASKS]; // 线程数组，所有的线程都保存在此

extern void __switch_to(struct task_struct *prev, struct task_struct *next);

void task_init() {
    srand(2024);

    // 1. 为 idle 分配一个物理页
    idle = (struct task_struct*)kalloc();

    // 2. 设置 state 为 TASK_RUNNING
    idle->state = TASK_RUNNING;

    // 3. counter 和 priority 设置为 0
    idle->counter = 0;
    idle->priority = 0;

    // 4. 设置 idle 的 pid 为 0
    idle->pid = 0;

    // 5. 将 current 和 task[0] 指向 idle
    current = idle;
    task[0] = idle;

    // 参考 idle 的设置，为 task[1] ~ task[NR_TASKS - 1] 进行初始化
    for (int i = 1; i < NR_TASKS; i++) {
        task[i] = (struct task_struct *)kalloc();

        // 2. 设置 state 为 TASK_RUNNING
        task[i]->state = TASK_RUNNING;

        // 3. 设置 counter 和 priority
        task[i]->priority = (uint64_t)rand() % (PRIORITY_MAX - PRIORITY_MIN + 1) + PRIORITY_MIN;
        task[i]->counter = task[i]->priority;
        task[i]->pid = i;

        // 4. 设置 thread_struct 中的 ra 和 sp
        task[i]->thread.ra = (uintptr_t)__dummy;  // ra 设置为 __dummy 的地址
        task[i]->thread.sp = (uintptr_t)task[i] + PGSIZE;  // sp 指向该页的高地址
    }

    printk("...task_init done!\n");
}



void switch_to(struct task_struct *next) {
    // 判断 next 是否与当前线程 current 相同
    if (next != current) {
        printk("\nswitch to [PID = %d PRIORITY = %d COUNTER = %d]\n", next->pid, next->priority, next->counter);
        // 调用 __switch_to 进行线程切换
        struct task_struct *prev = current;  // 保存当前线程
        current = next;  // 更新当前线程为 next
        __switch_to(prev, next);  // 执行线程切换
    }
}

void do_timer() {
    if (current == idle || current->counter <= 0) {
        schedule();
    }
    else {
        current->counter--;
        if (current->counter <= 0) {
            schedule();
        }
    }
}

void schedule() {
    struct task_struct *next = NULL;
    uint64_t max_counter = 0;
	//调度时选择 counter 最大的线程运行
    for (int i = 1; i < NR_TASKS; i++) {
        if (task[i] != NULL) {
            if (task[i]->counter > max_counter) {
                max_counter = task[i]->counter;
                next = task[i];
            }
        }
    }
	//如果所有线程 counter 都为 0，则令所有线程 counter = priority
    if (next == NULL || max_counter <= 0) {
        for (int i = 1; i < NR_TASKS; i++) {
            if (task[i] != NULL) {
                task[i]->counter = task[i]->priority;
            }
        }
        max_counter = 0;
        //设置完后需要重新进行调度
        for (int i = 1; i < NR_TASKS; i++) {
            if (task[i] != NULL && task[i]->counter > max_counter) {
                max_counter = task[i]->counter;
                next = task[i];
            }
        }
    }
	//最后通过 switch_to 切换到下一个线程
    if (next != NULL && next != current) {
        switch_to(next);
    }
}
#if TEST_SCHED
#define MAX_OUTPUT ((NR_TASKS - 1) * 10)
char tasks_output[MAX_OUTPUT];
int tasks_output_index = 0;
char expected_output[] = "2222222222111111133334222222222211111113";
#include "sbi.h"
#endif

void dummy() {
    uint64_t MOD = 1000000007;
    uint64_t auto_inc_local_var = 0;
    int last_counter = -1;
    while (1) {
        if ((last_counter == -1 || current->counter != last_counter) && current->counter > 0) {
            if (current->counter == 1) {
                --(current->counter);   // forced the counter to be zero if this thread is going to be scheduled
            }                           // in case that the new counter is also 1, leading the information not printed.
            last_counter = current->counter;
            auto_inc_local_var = (auto_inc_local_var + 1) % MOD;
            printk("[PID = %d] is running. auto_inc_local_var = %d\n", current->pid, auto_inc_local_var);
            #if TEST_SCHED
            tasks_output[tasks_output_index++] = current->pid + '0';
            if (tasks_output_index == MAX_OUTPUT) {
                for (int i = 0; i < MAX_OUTPUT; ++i) {
                    if (tasks_output[i] != expected_output[i]) {
                        printk("\033[31mTest failed!\033[0m\n");
                        printk("\033[31m    Expected: %s\033[0m\n", expected_output);
                        printk("\033[31m    Got:      %s\033[0m\n", tasks_output);
                        sbi_system_reset(SBI_SRST_RESET_TYPE_SHUTDOWN, SBI_SRST_RESET_REASON_NONE);
                    }
                }
                printk("\033[32mTest passed!\033[0m\n");
                printk("\033[32m    Output: %s\033[0m\n", expected_output);
                sbi_system_reset(SBI_SRST_RESET_TYPE_SHUTDOWN, SBI_SRST_RESET_REASON_NONE);
            }
            #endif
        }
    }
}
