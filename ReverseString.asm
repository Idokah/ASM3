INCLUDE irvine32.inc

.data
validString BYTE "hello",0

.code
main PROC
	push offset validString
	call ReverseString
	
	mov edx,offset validString
	call writeString
	
main ENDP

;receive a string in stack and reverse it
ReverseString PROC
stringToReverseOffset = 8
	push ebp
	mov ebp, esp
	push ebx
	push ecx
	push edx
	mov ecx,0
	mov ebx,dword ptr [ebp+stringToReverseOffset]
push_:
	movzx dx, byte ptr [ebx+ecx]
	cmp dx, 0
	je pop_loop
	push dx 
	inc ecx
	jmp push_
	
pop_loop:
	pop dx
	mov [ebx], dl
	inc ebx
	loop pop_loop
	
	pop edx
	pop ecx
	pop ebx
	mov esp,ebp
	pop ebp
	ret 4
	
	

ReverseString ENDP

END main