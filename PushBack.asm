INCLUDE irvine32.inc

.data
a byte "abc",0
b byte "def",0
result byte "a",0

.code
main PROC
push offset a
push offset b
call PushBack
mov edx,offset a
call WriteString

call dumpRegs

main ENDP

;recv offset of string a, offset of string b, and offset of empty string - result
;returns in result : conactenation of a,b
PushBack PROC
offsetb=8
offseta=offsetb+4
	push ebp
	mov ebp, esp
	push eax
	push ebx
	push edx
	push ecx
	mov ecx,0
	mov eax,dword ptr[ebp+offseta] ;		eax = &a
	mov ebx,dword ptr[ebp+offsetb] ;		ebx = &b

findEndOfA:
	mov dh,byte ptr[eax+ecx] ; dh = a[ecx]
	cmp dh,0
	je finishA
	inc ecx
	jmp findEndOfA
finishA:
	add eax, ecx
	mov ecx,0
copyBtoResult:
	mov dh,byte ptr[ebx+ecx] ; dh = b[ecx]
	cmp dh,0
	je donePushBack
	mov [eax+ecx],dh
	inc ecx
	jmp copyBtoResult
donePushBack:
	mov byte ptr [eax+ecx], dh
	pop ecx
	pop edx
	pop ebx
	pop eax
	mov esp, ebp
	pop ebp
	ret 12
	
PushBack ENDP

END main