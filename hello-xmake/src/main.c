#include <stdio.h>
#include <stddef.h>

const char* hello();
const char* world();

int main(int argc, char** argv)
{
    printf("%s %s\n", hello(), world());
    return 0;
}
