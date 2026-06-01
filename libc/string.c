#include "string.h"

void* memcpy(void* dest, void* src, size_t n)
{
    char* d = (char*)dest;
    char* s = (char*)src;

    while (n--) *d++ = *s++;

    return dest;
}

void* memmove(void* dest, void* src, size_t n)
{
    char* d = (char*)dest;
    char* s = (char*)src;

    if (dest <= src) {
        while (n--) *d++ = *s++;
    }
    else if (dest > src) {
        d += n - 1;
        s += n - 1;

        while (n--) *d-- = *s--;
    }

    return dest;
}

void* memset(void* src, int c, size_t n)
{
    char* s = (char*)src;

    while (n--) *s++ = c;

    return src;
}
