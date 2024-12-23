#include "mm.h"
#include "defs.h"
#include "proc.h"
#include "stdlib.h"
#include "printk.h"
#include "vm.h"
#include "string.h"
#include "elf.h"

extern void __dummy();
extern uint64_t swapper_pg_dir[512];

struct task_struct *idle;           // idle process
struct task_struct *current;        // 指向当前运行线程的 task_struct
struct task_struct *task[NR_TASKS]; // 线程数组，所有的线程都保存在此

extern char _sramdisk[];
extern char _eramdisk[];

uint64_t nr_tasks = 0;

void task_init()
{
    srand(2024);

    // 1. 为 idle 分配一个物理页
    idle = (struct task_struct *)kalloc();

    // 2. 设置 state 为 TASK_RUNNING
    idle->state = TASK_RUNNING;

    // 3. counter 和 priority 设置为 0
    idle->counter = 0;
    idle->priority = 0;

    // 4. 设置 idle 的 pid 为 0
    idle->pid = 0;

    // 5. 将 current 和 task[0] 指向 idle
    current = idle;
    task[nr_tasks++] = idle;

    // 参考 idle 的设置，为 task[1] ~ task[NR_TASKS - 1] 进行初始化
    for (int i = 1; i < 2; i++)
    {
        task[i] = (struct task_struct *)kalloc();

        // 2. 设置 state 为 TASK_RUNNING
        task[i]->state = TASK_RUNNING;

        // 3. 设置 counter 和 priority
        task[i]->priority = (uint64_t)rand() % (PRIORITY_MAX - PRIORITY_MIN + 1) + PRIORITY_MIN;
        task[i]->counter = task[i]->priority;
        task[i]->pid = i;

        // 4. 设置 thread_struct 中的 ra 和 sp
        task[i]->thread.ra = (uintptr_t)__dummy;          // ra 设置为 __dummy 的地址
        task[i]->thread.sp = (uintptr_t)task[i] + PGSIZE; // sp 指向该页的高地址
        task[i]->thread.sepc = USER_START;                // sepc 设置为用户态的入口地址

        uint64_t _sstatus = csr_read(sstatus);
        _sstatus &= ~(1 << 8); // set sstatus[SPP] = 0
        _sstatus |= 1 << 18;   // set sstatus[SUM] = 1
        task[i]->thread.sstatus = _sstatus;

        // sscratch 设置为 U-Mode 的 sp，其值为 USER_END
        task[i]->thread.sscratch = USER_END;

        // 创建页表,复制内核页表
        task[i]->pgd = (uint64_t *)kalloc();
        memcpy(task[i]->pgd, swapper_pg_dir, PGSIZE);
        page_deep_copy(task[i]->pgd);

        task[i]->mm = *(struct mm_struct *)kalloc();
        task[i]->mm.mmap = NULL;

        // 先计算所需的页数（uapp _sramdisk-_eramdisk 的大小除以 PGSIZE 后向上取整），调用 alloc_pages() 函数，再将uapp memcpy 过去
        // uint64_t uapp_size = (uint64_t)_eramdisk - (uint64_t)_sramdisk;
        // uint64_t uapp_pages = (uapp_size + PGSIZE - 1) / PGSIZE;
        // uint64_t* uapp_start = alloc_pages(uapp_pages);
        //  memcpy(uapp_start, _sramdisk, uapp_size);

        // create_mapping(task[i]->pgd, (uint64_t)USER_START, (uint64_t)(uapp_start) - PA2VA_OFFSET, (uint64_t)(uapp_pages * PGSIZE), 0x1f);

        load_program(task[i]);

        // uint64_t *u_stack = kalloc();
        // create_mapping(task[i]->pgd, (uint64_t)(USER_END)-PGSIZE, (uint64_t)(u_stack)-PA2VA_OFFSET, PGSIZE, 0x17);
        do_mmap(&task[i]->mm, USER_END - PGSIZE, PGSIZE, 0, 0, VM_READ | VM_WRITE | VM_ANON);

        uint64_t _satp = csr_read(satp);
        _satp = (_satp >> 44) << 44;
        _satp |= (((uint64_t)(task[i]->pgd) - PA2VA_OFFSET) >> 12);
        task[i]->thread.satp = _satp;
    }
    nr_tasks = 2;

    printk("...task_init done!\n");
}

struct vm_area_struct *find_vma(struct mm_struct *mm, uint64_t addr)
{
    struct vm_area_struct *vma = mm->mmap;
    while (vma)
    {
        if (addr >= vma->vm_start && addr < vma->vm_end)
        {
            return vma;
        }
        vma = vma->vm_next;
    }
    return NULL;
}

uint64_t do_mmap(struct mm_struct *mm, uint64_t addr, uint64_t len, uint64_t vm_pgoff, uint64_t vm_filesz, uint64_t flags)
{
    uint64_t start = PGROUNDDOWN(addr);
    uint64_t end = PGROUNDUP(start + len);

    // uint64_t pg_num = size / PGSIZE;

    // for(uint64_t i = 0; i < pg_num; i++)
    // {
    //     if(find_vma(mm, start + i * PGSIZE) != NULL)
    //     {
    //         start = find_new_varea(mm, len);
    //         end = PGROUNDUP(start + len);
    //         break;
    //     }
    // }

    struct vm_area_struct *vma = (struct vm_area_struct *)kalloc();
    vma->vm_mm = mm;
    vma->vm_start = start;
    // vma->vm_start = addr;
    vma->vm_end = end;
    // vma->vm_end = addr + len;
    vma->vm_next = mm->mmap;
    vma->vm_flags = flags;
    vma->vm_pgoff = vm_pgoff;
    vma->vm_filesz = vm_filesz;
    if (mm->mmap != NULL)
        mm->mmap->vm_prev = vma;
    mm->mmap = vma;
    return addr;
}

// uint64_t find_new_varea(struct mm_struct *mm, uint64_t length)
// {
//     // 起始地址从用户空间的最低地址开始
//     uint64_t addr = USER_START;
//     // 计算需要的页数，向上取整
//     uint64_t page_num = (length + PGSIZE - 1) / PGSIZE;
//     // 遍历用户空间的地址范围
//     while (addr < USER_END)
//     {
//         bool found = true; // 假设从当前地址开始的范围是未映射的
//         // 检查从当前地址起的 page_num 个页是否已映射
//         for (uint64_t i = 0; i < page_num; ++i)
//         {
//             if (find_vma(mm, addr + i * PGSIZE) != NULL)
//             {
//                 // 如果发现某个页已映射，跳过当前范围
//                 addr += (i + 1) * PGSIZE;
//                 found = false;
//                 break;
//             }
//         }
//         // 如果找到了一个满足条件的连续未映射地址范围，返回起始地址
//         if (found)
//         {
//             return addr;
//         }
//     }
//     // 如果没有找到合适的地址范围，返回失败值
//     return 0;
// }

void load_program(struct task_struct *task)
{
    Elf64_Ehdr *ehdr = (Elf64_Ehdr *)_sramdisk;
    Elf64_Phdr *phdrs = (Elf64_Phdr *)(_sramdisk + ehdr->e_phoff);
    for (int i = 0; i < ehdr->e_phnum; ++i)
    {
        Elf64_Phdr *phdr = phdrs + i;
        if (phdr->p_type == PT_LOAD)
        {
            uint64_t va = phdr->p_vaddr;
            uint64_t offset = phdr->p_offset;
            uint64_t fileSize = phdr->p_filesz;
            uint64_t memSize = phdr->p_memsz;
            // uint64_t flags = (phdr->p_flags << 1) | 0x11;
            uint64_t flags = phdr->p_flags;
            uint64_t pageOffset = va & (PGSIZE - 1);

            // uint64_t segmentStart = _sramdisk + offset;
            // uint64_t copyPages = (uint64_t)alloc_pages((pageOffset + memSize + PGSIZE - 1) / PGSIZE);

            // uint64_t curStartPa = get_pa(task->pgd, va);
            // uint64_t curEndPa = get_pa(task->pgd, va + memSize);
            // uint64_t endOffset = curEndPa & (PGSIZE - 1);

            // memset(copyPages, 0, (pageOffset + memSize + PGSIZE - 1) / PGSIZE * PGSIZE);
            // memcpy((uint64_t *)(copyPages + pageOffset), segmentStart, fileSize);

            // create_mapping(task->pgd, va, copyPages + pageOffset - PA2VA_OFFSET, memSize, flags);
            Log("va: %lx, offset: %lx, fileSize: %lx, memSize: %lx, flags: %lx", va, offset, fileSize, memSize, flags);
            do_mmap(&task->mm, va, memSize, offset - pageOffset, fileSize + pageOffset, flags << 1);
        }
    }
    task->thread.sepc = ehdr->e_entry;
    printk("load program done!\n");
}

void switch_to(struct task_struct *next)
{
    // 判断 next 是否与当前线程 current 相同
    if (next != current)
    {

        // 调用 __switch_to 进行线程切换
        struct task_struct *prev = current; // 保存当前线程
        current = next;                     // 更新当前线程为 next
        printk("\nswitch to [PID = %d PRIORITY = %d COUNTER = %d]\n", next->pid, next->priority, next->counter);
        __switch_to(prev, next); // 执行线程切换
    }
}

void do_timer()
{
    if (current == idle || current->counter <= 0)
    {
        schedule();
    }
    else
    {
        current->counter--;
        if (current->counter <= 0)
        {
            schedule();
        }
    }
}

void schedule()
{
    struct task_struct *next = NULL;
    uint64_t max_counter = 0;
    // 调度时选择 counter 最大的线程运行
    for (int i = 1; i < nr_tasks; i++)
    {
        if (task[i] != NULL)
        {
            if (task[i]->counter > max_counter)
            {
                max_counter = task[i]->counter;
                next = task[i];
            }
        }
    }
    // 如果所有线程 counter 都为 0，则令所有线程 counter = priority
    if (next == NULL || max_counter <= 0)
    {
        for (int i = 1; i < nr_tasks; i++)
        {
            if (task[i] != NULL)
            {
                task[i]->counter = task[i]->priority;
            }
        }
        max_counter = 0;
        // 设置完后需要重新进行调度
        for (int i = 1; i < nr_tasks; i++)
        {
            if (task[i] != NULL && task[i]->counter > max_counter)
            {
                max_counter = task[i]->counter;
                next = task[i];
            }
        }
    }
    // 最后通过 switch_to 切换到下一个线程
    if (next != NULL && next != current)
    {
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

void dummy()
{
    uint64_t MOD = 1000000007;
    uint64_t auto_inc_local_var = 0;
    int last_counter = -1;
    while (1)
    {
        if ((last_counter == -1 || current->counter != last_counter) && current->counter > 0)
        {
            if (current->counter == 1)
            {
                --(current->counter); // forced the counter to be zero if this thread is going to be scheduled
            } // in case that the new counter is also 1, leading the information not printed.
            last_counter = current->counter;
            auto_inc_local_var = (auto_inc_local_var + 1) % MOD;
            printk("[PID = %d] is running. auto_inc_local_var = %d\n", current->pid, auto_inc_local_var);
#if TEST_SCHED
            tasks_output[tasks_output_index++] = current->pid + '0';
            if (tasks_output_index == MAX_OUTPUT)
            {
                for (int i = 0; i < MAX_OUTPUT; ++i)
                {
                    if (tasks_output[i] != expected_output[i])
                    {
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
