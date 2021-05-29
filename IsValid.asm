
INCLUDE irvine32.inc

.data

invalidString BYTE 0, "hello",0
validString BYTE "hello",0
len1 WORD 6


.code

main PROC
mov eax,0
push word ptr len1
push OFFSET invalidString
call IsValid
call WriteInt

call dumpRegs
main ENDP

;receive offset of string and length in stack
IsValid PROC
len=12
string = 8
	push ebp
	mov ebp, esp
	push ebx
	movzx ebx, word ptr [ebp+len] ;eax = len
	cmp ebx,0 
	je false_
	mov ebx, dword ptr [ebp+string] ;eax = &string
	mov bl,byte ptr [ebx] 
	cmp bl,0
	je false_
	mov al,1
	jmp done
false_:
	mov al,0
done:
	pop ebx
	mov esp,ebp
	pop ebp 
	ret 6

IsValid ENDP

END main