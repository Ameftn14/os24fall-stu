#include "syscall.h"
#include "stdint.h"
#include "printk.h"
#include "proc.h"
#include "defs.h"
#include "vm.h"

extern uint64_t swapper_pg_dir[512];

extern struct task_struct *task[NR_TASKS];

extern uint64_t nr_tasks;

extern struct task_struct *current;

extern void __ret_from_fork();

uint64_t sys_write(unsigned int fd, const char *buf, size_t count)
{
    if (fd == 1)
    {
        for (uint64_t i = 0; i < count; i++)
        {
            printk("%c", buf[i]);
        }
        return count;
    }
    else
    {
        printk("Unsupported file descriptor: %d\n", fd);
    }
    return -1;
}

uint64_t sys_getpid()
{
    return current->pid;
}

uint64_t do_fork(struct pt_regs *regs)
{
    // 1. 为新的 task_struct 分配内存并复制当前 task_struct 的内容
    struct task_struct *_task = (struct task_struct *)kalloc();
    if (_task == NULL)
    {
        Log("do_fork: failed to kalloc task_struct\n");
        return -1;
    }

    memcpy(_task, current, PGSIZE);
    // 2. 修改新的 task_struct 的 pid
    _task->pid = nr_tasks;

    // 3. 修改新的 task_struct 的 pgd
    _task->pgd = (uint64_t *)kalloc();
    if (_task->pgd == NULL)
    {
        kfree(_task);
        Log("do_fork: failed to kalloc pgd\n");
        return -1;
    }
    memcpy(_task->pgd, swapper_pg_dir, PGSIZE);
    page_deep_copy(_task->pgd);

    _task->thread.satp = (current->thread.satp >> 44) << 44;
    _task->thread.satp |= (((uint64_t)(_task->pgd) - PA2VA_OFFSET) >> 12);
    // 4. 清空新的 task_struct 的 mm_struct
    _task->mm.mmap = NULL;
    // 5. 遍历父进程 vma 链表，为子进程创建 vma
    struct vm_area_struct *vma = current->mm.mmap;
    while (vma)
    {
        do_mmap(&_task->mm, vma->vm_start, vma->vm_end - vma->vm_start, vma->vm_pgoff, vma->vm_filesz, vma->vm_flags);
        uint64_t va = vma->vm_start;
        uint64_t offset = vma->vm_pgoff;
        uint64_t fileSize = vma->vm_filesz;
        uint64_t memSize = vma->vm_end - vma->vm_start;
        uint64_t flags = vma->vm_flags;
        while (va < vma->vm_end)
        {
            uint64_t pa = get_pa(current->pgd, va);
            if (pa == 0)
            {
                va += PGSIZE;
                continue;
            }
            uint64_t *page = (uint64_t *)kalloc();
            if (page == NULL)
            {
                Log("do_fork: failed to kalloc page\n");
                return -1;
            }
            memcpy(page, (void *)(pa + PA2VA_OFFSET), PGSIZE);
            uint64_t perm = (vma->vm_flags) | 0xd1;
            create_mapping(_task->pgd, va, (uint64_t)page - PA2VA_OFFSET, PGSIZE, perm);
            Log("current pa: %lx, new pa: %lx\n", get_pa(current->pgd, va), get_pa(_task->pgd, va));
            va += PGSIZE;
        }
        vma = vma->vm_next;
    }
    // 6. 处理返回逻辑

    // 修改子进程的返回值用于__switch_to调度
    _task->thread.ra = __ret_from_fork;
    // 修改子进程用户的寄存器中的值
    struct pt_regs *regs_child = (struct pt_regs *)((uint64_t)regs + ((uint64_t)_task - (uint64_t)current));
    // 子进程的系统调用返回值 a0 为 0
    regs_child->regs[9] = 0;

    // 子进程系统的栈指针 sp 也要更新
    regs_child->regs[1] = regs->regs[1] + ((uint64_t)_task - (uint64_t)current);

    // 映射子进程上下文切换的系统栈
    _task->thread.sp = (uint64_t)regs + ((uint64_t)_task - (uint64_t)current);

    // 修改子进程的 sscratch 和 当前线程的 sscratch 同步
    _task->thread.sscratch = csr_read(sscratch);

    task[nr_tasks++] = _task;
    return _task->pid;
}