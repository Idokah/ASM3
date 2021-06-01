.code

PushFront PROC
offsetb=8
offseta=offsetb+4
tempResult=-(2*N+1)

	push ebp
	mov ebp, esp
    sub esp,(2*N)
    sub esp,1
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
    je finishResult
    inc ecx
    jmp copyAToResult

finishResult:
    lea ebx,[ebp+tempResult]
    mov ecx,0
copyResultToA:
    mov dh,[ebx+ecx]
    mov [eax+ecx],dh
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
	ret 8
	
PushFront ENDP
