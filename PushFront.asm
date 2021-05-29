INCLUDE irvine32.inc

.data
a byte "abc",0
b byte "def",0
result byte "a",0

.code
main PROC
push offset a
push offset b
push offset result
call PushBack
mov edx,offset result
call WriteString

call dumpRegs

main ENDP

;recv offset of string a, offset of string b, and offset of empty string - result
;returns in result : conactenation of a,b
PushBack PROC
offsetResult=8
offsetb=offsetResult+4
offseta=offsetb+4
	push ebp
	mov ebp, esp
	push eax
	push ebx
	push edx
	push ecx
	mov ecx,0
	mov eax,dword ptr[ebp+offsetb] ;		eax = &b
	mov ebx,dword ptr[ebp+offsetResult] ;	ebx = &result
copyBtoResult:
	mov dh,byte ptr[eax+ecx] ; dh = b[ecx]
	cmp dh,0
	je finishB
	mov [ebx+ecx],dh
	inc ecx
	jmp copyBtoResult
finishB:
	add ebx, ecx
	mov eax, dword ptr[ebp+offseta]
	mov ecx,0
copyAtoResult:
	mov dh,byte ptr[eax+ecx] ; dh = a[ecx]
	cmp dh,0
	je donePushBack
	mov [ebx+ecx],dh
	inc ecx
	jmp copyAtoResult
donePushBack:
	mov byte ptr [ebx+ecx], dh
	pop ecx
	pop edx
	pop ebx
	pop eax
	mov esp, ebp
	pop ebp
	ret 12
	
PushBack ENDP

END main