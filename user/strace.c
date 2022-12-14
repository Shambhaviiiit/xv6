#include "user/user.h"
void strace(int number, char *argv[])
{
    int pid = fork();
    if (pid == 0)
    {
        trace(number);
        exec(argv[0], argv);
        exit(0);
    }
    wait(0);
    printf("\n");
}
int main(int argc, char *argv[])
{
    if (argc < 3)
    {
        write(1, "less arguments", 100);
        exit(1);
    }
    strace(atoi(argv[1]), &argv[2]);
    return 0;
}