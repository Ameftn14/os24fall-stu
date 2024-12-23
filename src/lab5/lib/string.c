#include "string.h"
#include "stdint.h"

void *memset(void *dest, int c, uint64_t n)
{
    char *s = (char *)dest;
    for (uint64_t i = 0; i < n; ++i)
    {
        s[i] = c;
    }
    return dest;
}

void *memcpy(void *dest, const void *src, uint64_t n)
{
    // 将void指针转换为char指针，以便可以通过指针算术进行操作
    char *d = (char *)dest;
    const char *s = (const char *)src;

    // 循环复制每个字节，直到复制了n个字节
    for (uint64_t i = 0; i < n; i++)
    {
        d[i] = s[i];
    }
    return dest;
}
