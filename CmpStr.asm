;receive offset of string1,string2 in stack returns 1 if equal else 0
CmpStr PROC
string2Offset=8
string1Offset=string2Offset+4
	push ebp
	mov ebp, esp
	sub esp, 2
	push ebx
	push edx
	push ecx
	push eax
	mov ecx,0
	mov ebx, dword ptr [ebp+string2Offset] ; ebx = &string2
	mov edx, dword ptr [ebp+string1Offset] ; edx = &string1
compare:
	mov al, byte ptr [ebx+ecx] ; al = string2[ecx]
	mov ah, byte ptr [edx+ecx] ; ah = string1[ecx]
	cmp al,ah
	jne notEqual
	cmp al,0
	je equal
	inc ecx
	jmp compare

equal:
	mov word ptr [ebp-2],1
	mov al,1
	jmp done

notEqual:
	mov word ptr [ebp-2],0
	mov al,0

done:
	pop eax
	pop ecx
	pop edx
	pop ebx
	mov al,byte ptr [ebp-2]
	mov esp, ebp
	pop ebp
	ret 8
	

CmpStr ENDP
