// C program to read contents of file
#include <stdio.h>

// Driver Code
int main()
{
    int c;
    FILE *file;

    // open file test.txt
    file = fopen("test.txt", "r");
    if (file)
    {

        // read file line-by-line until
        // end of file
        while ((c = getc(file)) != EOF)
            putchar(c);

        fclose(file);
    }
    return 0;
}
