
;receive :
;offset of string A (DWORD) , size of string A (word)
;pos (word) - from where
;len (word) - how many characters from pos
;offset of substring - it is the result of the function
;al is 1 if the call was valid (pos + len) is not bigger than A size.
.code
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
