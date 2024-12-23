#include "defs.h"
#include "stdlib.h"
#include "printk.h"
#include "stdint.h"

/* early_pgtbl: 用于 setup_vm 进行 1GiB 的映射 */
uint64_t early_pgtbl[512] __attribute__((__aligned__(0x1000)));
/* swapper_pg_dir: kernel pagetable 根目录，在 setup_vm_final 进行映射 */
uint64_t swapper_pg_dir[512] __attribute__((__aligned__(0x1000)));

extern char _stext[];   // 指向 .text 段起始位置
extern char _srodata[]; // 指向 .rodata 段起始位置
extern char _etext[];   // 指向 .text 段结束位置
extern char _erodata[]; // 指向 .rodata 段结束位置
extern char _sdata[];   // 指向 .data 段起始位置

void setup_vm_final()
{
    memset(swapper_pg_dir, 0x0, PGSIZE);

    // No OpenSBI mapping required

    // mapping kernel text X|-|R|V
    create_mapping(swapper_pg_dir, (uint64_t)_stext, (uint64_t)_stext - PA2VA_OFFSET, (uint64_t)(_etext - _stext), 11);

    // mapping kernel rodata -|-|R|V
    create_mapping(swapper_pg_dir, (uint64_t)_srodata, (uint64_t)_srodata - PA2VA_OFFSET, (uint64_t)(_erodata - _srodata), 3);

    // mapping other memory -|W|R|V
    create_mapping(swapper_pg_dir, (uint64_t)_sdata, (uint64_t)_sdata - PA2VA_OFFSET, PHY_SIZE - (_sdata - _stext), 7);

    // set satp with swapper_pg_dir
    uint64_t _satp = (((uint64_t)(swapper_pg_dir)-PA2VA_OFFSET) >> 12) | (8ULL << 60);
    csr_write(satp, _satp);
    // flush TLB
    asm volatile("sfence.vma zero, zero");
    printk("setup_vm_final done!\n");
    return;
}

/* 创建多级页表映射关系 */
/* 不要修改该接口的参数和返回值 */
// 为指定的虚拟地址范围创建映射到物理地址的页表项
void create_mapping(uint64_t *pgtbl, uint64_t va, uint64_t pa, uint64_t sz, uint64_t perm)
{
    uint64_t va_cur = va;
    uint64_t va_end = va + sz;
    uint64_t pa_cur = pa;

    uint64_t *tbl2_ad, *tbl3_ad;     // 二级和三级页表的指针
    uint64_t *tbl2_pa, *tbl3_pa;     // 物理地址映射的二级和三级页表
    uint64_t index1, index2, index3; // 索引值用于查找各级页表

    // 遍历每一页
    while (va_cur < va_end)
    {
        // 计算虚拟地址的各级页表索引
        index1 = (va_cur >> 30) & 0x1FF; // 一级页表索引
        index2 = (va_cur >> 21) & 0x1FF; // 二级页表索引
        index3 = (va_cur >> 12) & 0x1FF; // 三级页表索引

        // 处理一级页表
        if (!(pgtbl[index1] & 0x1))
        {
            // 如果一级页表项为空，分配一个新的二级页表
            tbl2_ad = (uint64_t *)kalloc();
            tbl2_pa = (uint64_t)tbl2_ad - PA2VA_OFFSET;              // 转换为物理地址
            pgtbl[index1] = (((uint64_t)tbl2_pa >> 12) << 10) | 0x1; // 设置页表项
        }
        else
        {
            // 如果一级页表项已存在，使用它指向的二级页表
            tbl2_ad = (uint64_t *)(((pgtbl[index1] >> 10) << 12) + PA2VA_OFFSET);
        }

        // 处理二级页表
        if (!(tbl2_ad[index2] & 0x1))
        {
            // 如果二级页表项为空，分配一个新的三级页表
            tbl3_ad = (uint64_t *)kalloc();
            tbl3_pa = (uint64_t)tbl3_ad - PA2VA_OFFSET;              // 转换为物理地址
            tbl2_ad[index2] = ((uint64_t)tbl3_pa >> 12) << 10 | 0x1; // 设置页表项
        }
        else
        {
            // 如果二级页表项已存在，使用它指向的三级页表
            tbl3_ad = (uint64_t *)(((tbl2_ad[index2] >> 10) << 12) + PA2VA_OFFSET);
        }

        // 处理三级页表，创建虚拟地址到物理地址的映射
        if (!(tbl3_ad[index3] & 0x1))
        {
            tbl3_ad[index3] = (pa_cur >> 12) << 10 | perm; // 设置页表项，加入权限
        }

        // 移动到下一页
        va_cur += PGSIZE;
        pa_cur += PGSIZE;
    }

    // 完成映射
    printk("create_mapping done!\n");
}

void setup_vm(void)
{
    uint64_t pa = PHY_START;
    // 等值映射
    uint64_t va1 = pa;
    // 映射至高位
    uint64_t va2 = pa + PA2VA_OFFSET;
    uint64_t index;
    // 页表的虚拟页号 9位
    index = (va1 >> 30) & 0x1ff;
    early_pgtbl[index] = ((pa >> 12) << 10) | 0xf;
    printk("early_pgtbl[%x] = %p\n", index, early_pgtbl[index]);

    // 同理
    index = (va2 >> 30) & 0x1ff;
    early_pgtbl[index] = ((pa >> 12) << 10) | 0xf;
    printk("early_pgtbl[%x] = %p\n", index, early_pgtbl[index]);

    printk("...setup_vm done!\n");
}