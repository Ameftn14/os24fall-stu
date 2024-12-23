#include "clock.h"
#include "printk.h"
#include "proc.h"
#include "syscall.h"
#include "defs.h"
#include "vm.h"
#include "string.h"

extern struct task_struct *current;
extern char _sramdisk[];
extern char _eramdisk[];

void do_page_fault(struct pt_regs *regs)
{
    uint64_t scause = csr_read(scause);
    uint64_t stval = csr_read(stval);
    uint64_t sepc = regs->sepc;
    struct vm_area_struct *vma = find_vma(&current->mm, stval);
    //[PID = 4 PC = 0x100e8] valid page fault at `0x100e8` with cause 12
    Log("[PID = %d PC = %lx] valid page fault at `%lx` with cause %lx", current->pid, sepc, stval, scause);
    if (vma == NULL)
    {
        Err("Page fault at addr %lx,scause %lx but no mapping found", stval, scause);
    }
    if ((scause == 12 && !(vma->vm_flags & VM_EXEC)) ||
        (scause == 13 && !(vma->vm_flags & VM_READ)) ||
        (scause == 15 && !(vma->vm_flags & VM_WRITE)))
    {
        Err("Page fault at addr %lx: permission denied", stval);
        return;
    }
    uint64_t aligned_addr = PGROUNDDOWN(stval);

    uint64_t *page = (uint64_t *)kalloc();
    if (page == NULL)
    {
        Err("Page allocation failed for addr %lx", aligned_addr);
        return;
    }

    memset(page, 0, PGSIZE);

    if (vma->vm_flags & VM_ANON)
    {
        uint64_t perm = vma->vm_flags;
        create_mapping(current->pgd, aligned_addr, (uint64_t)page - PA2VA_OFFSET, PGSIZE, perm | 0xd1);
    }
    else
    {
        uint64_t va_start = vma->vm_start;
        uint64_t va_end = vma->vm_end;
        // 非匿名页：从文件拷贝数据

        uint64_t file_offset = aligned_addr - va_start + vma->vm_pgoff;
        uint64_t file_size = vma->vm_filesz;

        // 计算需要拷贝的大小
        uint64_t copy_size = PGSIZE;
        // 从文件中读取数据到分配的物理页
        if (copy_size > 0)
        {
            memcpy(page, (uint64_t *)(_sramdisk + file_offset), copy_size);
        }
        // 大于filesz小于memsz的地方要清零
        if (aligned_addr + PGSIZE - va_start > file_size)
        {
            uint64_t setsize = (file_size > (aligned_addr - va_start)) ? PGSIZE - (file_size - (aligned_addr - va_start)) : PGSIZE;
            memset(page + PGSIZE - setsize, 0, setsize);
        }

        // 设置页面权限
        uint64_t perm = (vma->vm_flags) | 0xd1;
        create_mapping(current->pgd, aligned_addr, (uint64_t)page - PA2VA_OFFSET, copy_size, perm);
    }
}

void trap_handler(uint64_t scause, uint64_t sepc, struct pt_regs *regs)
{
    // Check if the interrupt is a timer interrupt
    if ((scause >> 63) && (scause << 1 >> 1) == 5)
    {
        // printk("[S] Supervisor Mode Timer Interrupt\n"); // Print the timer interrupt message
        clock_set_next_event(); // Set the next timer event
        do_timer();
        return; // Exit the handler
    }
    else if (scause == 8)
    {
        regs->sepc += 4;
        if (regs->regs[16] == SYS_WRITE)
            regs->regs[9] = sys_write((unsigned int)regs->regs[9], (const char *)regs->regs[10], (uint64_t)regs->regs[11]);
        else if (regs->regs[16] == SYS_GETPID)
            regs->regs[9] = sys_getpid();
        else if (regs->regs[16] == SYS_CLONE)
            regs->regs[9] = do_fork(regs);
        else
        {
            Err("Unsupported exception: scause: %lx, sepc: %lx\n", scause, sepc);
        }
    }
    else if (scause == 12 || scause == 13 || scause == 15)
    {
        do_page_fault(regs);
        return;
    }
    else
    {
        Err("Unsupported exception: scause: %lx, sepc: %lx\n", scause, sepc);
    }
}

// void do_page_fault(struct pt_regs *regs)
// {
//     uint64_t scause = csr_read(scause);
//     uint64_t stval = csr_read(stval);
//     uint64_t sepc = csr_read(sepc);
//     struct vm_area_struct *vma = find_vma(&current->mm, stval);
//     // Log("Page fault at addr %lx, scause: %lx, vm_start: %lx, vm_end: %lx, vm_pgoff: %lx", stval, scause, vma->vm_start, vma->vm_end, vma->vm_pgoff);
//     if (vma == NULL)
//     {
//         Err("Page fault at addr %lx,scause %lx but no mapping found", stval, scause);
//     }
//     if ((scause == 12 && !(vma->vm_flags & VM_EXEC)) ||
//         (scause == 13 && !(vma->vm_flags & VM_READ)) ||
//         (scause == 15 && !(vma->vm_flags & VM_WRITE)))
//     {
//         Err("Page fault at addr %lx: permission denied", stval);
//         return;
//     }
//     uint64_t aligned_addr = PGROUNDDOWN(stval);

//     if(pre_fault_addr == aligned_addr)
//     {
//         Err("Multiple page fault at addr %lx", stval);
//     }

//     pre_fault_addr = aligned_addr;

//     uint64_t *page = kalloc();
//     if (page == NULL)
//     {
//         Err("Page allocation failed for addr %lx", aligned_addr);
//         return;
//     }

//     memset(page, 0, PGSIZE);

//     if (vma->vm_flags & VM_ANON)
//     {
//         uint64_t perm = vma->vm_flags ;
//         Log("Page fault at addr %lx, page allocated at %lx, perm: %lx, aligned_addr: %lx", stval, page, perm, aligned_addr);
//         create_mapping(current->pgd, aligned_addr, (uint64_t)page - PA2VA_OFFSET, PGSIZE, perm | 0x11);
//     }
//     else
//     {
//         uint64_t va_start = vma->vm_start;
//         uint64_t va_end = vma->vm_end;
//         uint64_t va_start_aligned = PGROUNDDOWN(va_start);
//         // 非匿名页：从文件拷贝数据
//         uint64_t pageOffset = 0;

//         if(aligned_addr < va_start)
//         {
//             pageOffset = va_start & (PGSIZE - 1);
//         }

//         if(stval < va_start)
//         {
//             Err("Bad address at addr %lx, but no mapping found,", stval);
//         }

//         uint64_t file_offset = aligned_addr + pageOffset - va_start + vma->vm_pgoff;

//         // 计算需要拷贝的大小
//         uint64_t copy_size = PGSIZE;
//         if (aligned_addr + PGSIZE > va_end)
//         {
//             copy_size = va_end - aligned_addr;
//         }

//         if (pageOffset > 0)
//         {
//             copy_size -= pageOffset;
//         }

//         // 从文件中读取数据到分配的物理页
//         if (copy_size > 0)
//         {
//             memcpy((uint64_t *)((uint64_t)page+pageOffset), (uint64_t *)(_sramdisk + file_offset), copy_size);
//         }

//         // 设置页面权限
//         uint64_t perm = (vma->vm_flags) | 0x11;
//         create_mapping(current->pgd, aligned_addr + pageOffset , (uint64_t)page + pageOffset - PA2VA_OFFSET, copy_size, perm);
//         Log("Page fault at addr %lx, pageOffset: %lx, file_offset: %lx, copy_size: %lx, va_map_start: %lx", stval, pageOffset, file_offset, copy_size, aligned_addr + pageOffset);
//     }
// }
