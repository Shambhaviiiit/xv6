#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/param.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int main(int argc, char *argv[])
{
#ifdef PBS
    int given_p = atoi(argv[1]);
    int given_pid = atoi(argv[2]);

    if (given_p < 0 || (given_pid > 101) || (given_pid < 0))
    {
        fprintf(2, "error: check arguments!\n");
        exit(1);
    }
    int sret = set_priority(given_p, given_pid);

    if (sret == 101)
    {
        printf("process not found!\n");
        exit(1);
    }
#endif

    exit(0);
}