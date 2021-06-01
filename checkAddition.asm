
.code
checkAddition PROC
     _aOffset=8
     _aSize=_aOffset+4
     _bOffset=_aSize+2
     _bSize=_bOffset+4
     _cOffset=_bSize+2
     _cSize=_cOffset+4
     _resOffset=_cSize+2
     _addStringRes=-N
     _subStringRes=_addStringRes-N
     push ebp
	mov ebp, esp
     sub esp, N
     sub esp, N

     push ebx
     push ecx
     push edx
     push edi

     lea ebx, [ebp + _addStringRes]
     lea edi, [ebp + _subStringRes]

     mov eax,0                ; if !isValid(a) return false
     push word ptr [ebp + _aSize]
	push dword ptr [ebp + _aOffset]
     call isValid
     cmp al, 0
     je _false
	
     push word ptr [ebp + _bSize]
     push dword ptr [ebp + _bOffset]    ; if !isValid(b) return false
     call isValid
     cmp al, 0
     je _false

     push ebx ; call to add string
	push dword ptr [ebp + _aOffset]
	push dword ptr [ebp + _bOffset]
	push word ptr [ebp + _aSize]
	push word ptr [ebp + _bSize]
     call addString
     mov ecx, edx        ; save addString len in ecx

     push dword ptr [ebp + _cOffset]            ; if (sum == c) return true
     push ebx
     call CmpStr
     cmp al, 1
     je _true

     cmp edi, [ebp + _cSize]
     JAE _false          ; if(len(sum) >= len(c)) retrun false

     push dword ptr [ebp + _cOffset]            ; calc (sum != c.substr(0, sum.size())) for the ending condition
	push word ptr [ebp + _cSize]
     mov ax, 0
	push ax                        ; pos  
	push cx
	push edi
	call SubString 

     push edi           ; if (sum != c.substr(0, sum.size())) return false
     push ebx
     call CmpStr
     cmp al, 0
     je _false

     push offset res
     push ebx
     call pushBack

     push dword ptr [ebp + _cOffset]            ; calc c.substr(sum.size()) for the recurtion
	push word ptr [ebp + _cSize]
	push cx                        ; pos  
     mov ax, [ebp + _cSize]          ; calc the len for SubString
     sub ax, cx
	push ax
	push edi
	call SubString 

     push offset res          ; return checkAddition(res, b, sum, c.substr(sum.size()));
     mov ax, [ebp + _cSize]          ; calc the len for SubString
     sub ax, cx
     push ax
     push edi
     push cx                 ; sum size
     push ebx ; sum
     push word ptr [ebp + _bSize]
     push dword ptr [ebp + _bOffset]
     call checkAddition
     jmp done

     _false:
          mov al, 0
          jmp done

     _true:
          push offset res
          push ebx
          call PushBack
          mov al, 1
          jmp done

     done:
          pop edi
          pop edx
          pop ecx
          pop ebx
          mov esp, ebp
          pop ebp
	     ret 22
checkAddition ENDP

