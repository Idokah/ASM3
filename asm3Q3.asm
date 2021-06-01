INCLUDE irvine32.inc

.data
num byte "235813", 0
N=Lengthof num
res byte N*2+1 dup (0) ;change

.code



; Receive 
; return 
checkAddition PROC
     _aOffset=8
     _aSize=_aOffset+4
     _bOffset=_aSize+2
     _bSize=_bOffset+4
     _cOffset=_bSize+2
     _cSize=_cOffset+4
     _resOffset=_cSize+2
     _addStringRes=-4
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


; Receive offset of two strings, and one offset of result string
; return the sum in the result string and its len in EDX
AddString PROC
     string2SizeOffset=8
     string1SizeOffset=string2SizeOffset+2
     string2Offset=string1SizeOffset+2
     string1Offset=string2Offset+4
     resStringOffset=string1Offset+4
     push ebp
	mov ebp, esp

     push eax
     push ebx
     push ecx
     push edi



     mov edi, [ebp + resStringOffset]
     mov cx, word ptr [ebp + string2SizeOffset]
     sub cx, 1
	mov bx, word ptr [ebp + string1SizeOffset] 
     sub bx, 1
     mov dl, 0 ; dl will hold the carry

     loopi:
          jmp checkLoopCondition
       continue:
          ; calling val for first string
          mov ax, 0
          push dword ptr [ebp + string1Offset]
          push bx
          push word ptr [ebp + string1SizeOffset]
          call val
          mov ah, al
          ; calling val for second string
          push dword ptr [ebp + string2Offset]
          push cx
          push word ptr [ebp + string2SizeOffset]
          call val
          add al, ah
          add al, dl

 

          cmp al, 10
          JAE withCarry
          jmp withoutCarry

          withCarry:
               sub al, 10
               mov dl, 1
               jmp endLoop

          withoutCarry:
               mov dl, 0
               jmp endLoop

          endLoop:
               add al, "0"
               mov [edi], al
               sub cx, 1
               sub bx, 1
               add edi, 1
               jmp loopi

     checkLoopCondition:
          cmp bx, 0
          JGE continue
          cmp cx, 0
          JGE continue
          jmp checkFinalCarry

     checkFinalCarry:
          cmp dl, 1
          je endStringWithCarry
          jmp done
          endStringWithCarry:
               mov al, "1"
               mov [edi], al
               add edi,1
               jmp done
     
     done:
          mov byte ptr [edi], 0

          mov edx, [ebp + resStringOffset]
          push edx
          call ReverseString

          mov edx, edi
          sub edx, [ebp + resStringOffset]   ; returning in edx the result string len

          pop edi
          pop ecx
          pop ebx
          pop eax
          mov esp, ebp
          pop ebp
	     ret 16
AddString ENDP


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

; Receive offset of string, the string size and location
; validate if the location less or equal to string size
; return in AL the numeral value of this location of the string.
val PROC
     stringSizeOffset=8
     locationOffset=stringSizeOffset+2
     stringPtrOffset=locationOffset+2
     push ebp
	mov ebp, esp
     push edx
     push ebx
     push ecx


     mov edx, 0
     mov dx, word ptr [ebp + locationOffset]
	mov bx, word ptr [ebp + stringSizeOffset] 
	mov ecx, dword ptr [ebp + stringPtrOffset]

     CMP dx, bx
     JGE notInRange
     CMP dx, 0
     JL notInRange
     jmp inRange

     inRange:
          add ecx, edx
          mov al, [ecx]
          sub al, "0"
          jmp done

     notInRange:
          mov al, 0
          jmp done

     done:
          pop ecx
          pop ebx
          pop edx
          mov esp, ebp
          pop ebp
	     ret 8
val ENDP

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
	mov byte ptr[eax+ecx]," "
	inc ecx
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
	ret 8
PushBack ENDP

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

SubString PROC
offsetSubstring = 8
lenSubString = offsetSubstring + 4
posSubString = lenSubString + 2
sizeAString = posSubString + 2
offsetAString = sizeAString + 2
	push ebp
	mov ebp, esp

	push ebx
	push esi
	push edx
	push ecx

	movzx ebx, word ptr [ebp + posSubString] ; ebx = pos
	movzx esi, word ptr [ebp + sizeAString] ; esi = sizeA
	add bx, [ebp+lenSubString]
	inc esi ; because pos is counted from 0 and the size is counted from 1
	cmp ebx,esi 
	jg false_ ;if esi < ebx  --> false (pos+len>sizeA)
	movzx ebx, word ptr [ebp+lenSubString]
	cmp ebx, 0 
	je true_ 	;if bx == 0 --> true (len==0)

	;else put a[pos] -> result , call the function with (a, sizeA, pos+1,len-1,result+1)
	
	
	mov edx, dword ptr [ebp + offsetAString] ; edx = &a
	movzx ebx, word ptr [ebp + posSubString] ; ebx = pos

	mov cl, byte ptr [edx + ebx] ;cl = A[pos]
	mov edx,[ebp + offsetSubstring] ; edx = &result
	mov byte ptr [edx],cl ; cl into result
	
	inc ebx ; pos++
	inc edx ; &result ++ 
	
	push dword ptr [ebp+offsetAString] ; push &A
	push word ptr [ebp+sizeAString] 		 ; push a sizeA
	push bx 			     ; push pos+1
	mov ebx, [ebp+lenSubString]
	dec ebx
	push bx 				 ; push len-1
	push edx				 ; push &result+1
	call SubString
	
	;after the call is back from substring - if its valid the result in al is 1 else 0
	jmp done
	
	
true_:
	mov al,1
	mov esi, [ebp+offsetSubstring]
	mov byte ptr [esi] , 0 ;put 0 on end of string.
	jmp done
	
false_:
	mov al,0
done:
    pop ecx
	pop edx
	pop esi
	pop ebx
	mov esp, ebp
	pop ebp
	ret 14
	
SubString ENDP 

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


IsAddSeq PROC
     _stringOffset=8
     _stringSize=_stringOffset+4
     _resStringOffset=_stringSize+2
     _firstLoopIndex=-2
     _secondLoopIndex=_firstLoopIndex-2
     _firstLoopLimit=_secondLoopIndex-2
     _secondLoopLimit=_firstLoopLimit-2
     _subString1=_secondLoopLimit-N
     _subString2=_subString1-N
     _subString3=_subString2-N
     push ebp
     mov ebp, esp
	sub esp, 8
     sub esp,3*N

	push ebx
	push ecx
	push edx
	push edi	
     ;push 

     mov bx, 1
     mov [ebp + _firstLoopIndex], bx
     mov dx,0
     mov eax, 0                        ; init first loop
     mov ax, [ebp + _stringSize]
     mov cx,2h
     div cx
     add al, 1  ; calc len/2
     mov [ebp + _firstLoopLimit], ax

     firstLoop:
          mov dx,0
          mov ax,[ebp + _firstLoopLimit]     ; check first loop condition
          cmp [ebp + _firstLoopIndex], ax
          je notFoundSum

          mov ax, 0
          mov ax, [ebp + _stringSize]   ; init second loop
          sub ax, [ebp + _firstLoopIndex]
          mov cx,2
          div cx
          add al, 1  ; calc len/2
          mov [ebp + _secondLoopLimit], ax
          
          mov ax,1
          mov [ebp + _secondLoopIndex], ax

          secondLoop:
               mov ax,[ebp + _secondLoopLimit]     ; check first loop condition
               cmp [ebp + _secondLoopIndex], ax
               je endSecondLoop
               
               push eax
               mov eax,0
               mov ax, [ebp + _secondLoopIndex]
               call crlf
               call writeInt
               push eax

               push eax
               mov eax,0
               mov ax, [ebp + _secondLoopIndex]
               call crlf
               call writeInt
               push eax

               push dword ptr [ebp + _stringOffset]   ;  num.substr(0, i)
               push word ptr [ebp + _stringSize]
               push word ptr 0 ; pos
               push word ptr[ebp + _firstLoopIndex] ; len
               lea edx, [ebp+ _subString1]
               push edx
               call subString

               ;push edx
               ;lea edx, [ebp+ _subString1]
               ;call writeString
               ;pop edx
               ;call crlf

               push dword ptr [ebp + _stringOffset]   ;  num.substr(i, j)
               push word ptr [ebp + _stringSize]
               push word ptr [ebp + _firstLoopIndex] ; pos
               push word ptr [ebp + _secondLoopIndex] ; len
               lea edx, [ebp+ _subString2]
               push edx
               ; push offset subString2
               call subString

               ;push edx
               ;lea edx, [ebp+ _subString2]
               ;call writeString
               ;pop edx
               ;call crlf

               push dword ptr [ebp + _stringOffset]   ;  num.substr(i + j)
               push word ptr [ebp + _stringSize]
               mov ax, word ptr [ebp + _firstLoopIndex]
               add ax, word ptr [ebp + _secondLoopIndex]
               push ax ; pos
               mov cx, [ebp + _stringSize]
               sub cx, ax
               push cx ; len
               lea edx, [ebp+ _subString3]
               push edx
               ;push offset subString3
               call subString     
               
               ;push edx
               ;lea edx, [ebp+ _subString3]
               ;call writeString
               ;pop edx
               ;call crlf
               
                      ; check addition
               push offset res
               push cx                       ; third string size
               lea edx, [ebp+ _subString3]
               push edx
               push word ptr [ebp + _secondLoopIndex] ; second string size
               lea edx, [ebp+ _subString2]
               push edx
               push word ptr [ebp + _firstLoopIndex]  ; first string size
               lea edx, [ebp+ _subString1]
               push edx
               call checkAddition
               
               cmp al, 1
               je foundSum
               
               mov ax, [ebp + _secondLoopIndex]
               add ax, 1
               mov [ebp + _secondLoopIndex], ax
               jmp secondLoop

     endSecondLoop:
          mov ax, word ptr [ebp + _firstLoopIndex]
          add ax, 1
          mov [ebp + _firstLoopIndex], ax
          jmp firstLoop
     
     foundSum:

          push offset res ; res.push_front(num.substr(i, j))
          lea edx, [ebp+ _subString2]
          push edx
          call writeString
          
          call PushFront

          push offset res       ;num.substr(0, i)
          lea edx, [ebp+ _subString1]
          push edx

          call PushFront
          
          mov al, 1
          jmp done

     notFoundSum:
          mov al, 0
          jmp done
     
     done:
		  pop edi
		  pop edx
		  pop ecx
		  pop ebx
		  
          mov esp, ebp
          pop ebp
	     ret 10
IsAddSeq ENDP

main PROC

	 push offset res
      mov ax, N-1
      push ax
      push offset num

	 call IsAddSeq
      mov edx, offset res
      call crlf
     call writeString
     call crlf
     movzx eax,al
     call writeint

	 
main ENDP
END main