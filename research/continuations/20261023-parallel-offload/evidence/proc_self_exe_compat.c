#define _GNU_SOURCE
#include <unistd.h>
#include <string.h>
#include <stdio.h>
#include <dlfcn.h>

/* Linux namespace compatibility only. Lean 4.33.1 runtime/io.cpp:1402
 * constructs /proc/<getpid()>/exe. This execution host exposes /proc/self/exe
 * correctly, but its mounted proc PID numbers differ from getpid().
 * Only this current-process executable query is mapped to its equivalent
 * /proc/self/exe. All other reads and kernel/proof operations are unchanged.
 */
ssize_t readlink(const char *path, char *buf, size_t bufsiz) {
    ssize_t (*real_readlink)(const char *, char *, size_t) =
        (ssize_t (*)(const char *, char *, size_t))dlsym(RTLD_NEXT, "readlink");
    char current[80];
    snprintf(current, sizeof(current), "/proc/%ld/exe", (long)getpid());
    return real_readlink(strcmp(path, current) == 0 ? "/proc/self/exe" : path,
                         buf, bufsiz);
}
