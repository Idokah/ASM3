;receive offset of string and length in stack
;return in al 1 if the size is bigger than 1 abd the string is not starting with '0'
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
