#include <bios.h>
#include <conio.h>

int main(void)
{


textcolor(1);
textbackground(4);

clrscr();

textcolor(4);
textbackground(1);

window(10,10,40,11);

cprintf("hello world\r\n");

asm {
mov ax,0;
int 0x16;
}

   return 0;
}

