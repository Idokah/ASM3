INCLUDE irvine32.inc

.data
a byte "abc",0
b byte "def",0
N = 12

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
tempResult=-N

    call dumpRegs
	push ebp
	mov ebp, esp
    sub esp,N
	push eax
	push ebx
	push edx
	push ecx
    push esi

	mov ecx,0
	mov ebx,0
	mov eax,dword ptr[ebp+offsetb]      	; eax = &b
    lea ebx, [ebp+tempResult] 

copyBToResult:
    mov dh,[eax+ecx]
	cmp dh,0
    je concatSpace
    mov [ebx+ecx],dh
    inc ecx
    jmp copyBToResult

concatSpace:
	mov dh, " "
	mov [ebx+ecx],dh

    mov eax,[ebp+offseta] ; eax =&a
    inc ecx
    add ebx,ecx
    mov ecx,0
copyAToResult:
    mov dh,[eax+ecx]
    mov [ebx+ecx],dh
	cmp dh,0
    je copyResultToA
    inc ecx
    jmp copyAToResult

    mov ebx,dword ptr[ebp+tempResult]
    mov ecx,0
copyResultToA:
    mov dh,[ebx+ecx]
    mov [ebx+ecx],dh
    cmp dh,0
    je donePushFront
    inc ecx
    jmp copyResultToA

donePushFront:

	pop esi
    pop ecx
	pop edx
	pop ebx
	pop eax

	mov esp, ebp
	pop ebp
    call dumpRegs
	ret 8
	
PushFront ENDP

END main