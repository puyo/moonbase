#include <cstdarg>
#include <cstdio>

void log(const char *text) {
    printf("%s\n", text);
}

void logf(const char *format, ...) {
    va_list argptr;
    va_start(argptr, format);
    vprintf(format, argptr);
    printf("\n");
    va_end(argptr);
}
