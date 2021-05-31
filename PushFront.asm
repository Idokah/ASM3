INCLUDE irvine32.inc

.data
f byte "1111111111111"
a byte "abc",0
b byte "def",0

.code
main PROC
push offset a
push offset b

call PushFront
mov edx,offset a
call WriteString

call dumpRegs

main ENDP

;recv offset of string a, offset of string b, and offset of empty string - result
;returns in result : conactenation of a,b
PushFront PROC
offsetb=8
offseta=offsetb+4
	push ebp
	mov ebp, esp
	push eax
	push ebx
	push edx
	push ecx
	mov ecx,0
	mov ebx,0
	mov eax,dword ptr[ebp+offsetb]      	; eax = &b
	;mov ebx,ebp+tempResult
	;mov ebx,dword ptr[ebp+tempResult] 		; ebx = &result
findBSize:
	mov dh,[eax+ecx]
	cmp dh,0
	je foundSize
	inc ecx
	jmp findBSize
foundSize:
	mov ebx, [ebp+offseta]
	sub ebx,ecx
	mov ecx,0
concatBToA:
	mov dh,byte ptr[eax+ecx] ; dh = b[ecx]
	cmp dh,0
	je donePushFront
	mov [ebx+ecx],dh
	inc ecx
	jmp concatBToA


donePushFront:
	pop ecx
	pop edx
	pop ebx
	pop eax
	mov esp, ebp
	pop ebp
	ret 8
	
PushFront ENDP

END main