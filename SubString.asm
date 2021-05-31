INCLUDE irvine32.inc

.data
a byte "abcdef",0
result byte 0
sizeA dword 6
pos dword 4
len dword 2


.code

main PROC
	push offset a
	push sizeA
	push pos
	push len
	push offset result
	call SubString 


	mov edx,offset result
	call writeString
	
	call dumpRegs
	
main ENDP


SubString PROC
offsetSubstring = 8
lenSubString = offsetSubstring + 4
posSubString = lenSubString + 4
sizeAString = posSubString + 4
offsetAString = sizeAString + 4
	push ebp
	mov ebp, esp

	push ebx
	push esi
	push edx
	push ecx
	

	mov ebx, dword ptr [ebp + posSubString] ; ebx = pos
	mov esi, dword ptr [ebp + sizeAString] ; esi = sizeA
	add ebx,[ebp+lenSubString]
	inc esi ; because pos is counted from 0 and the size is counted from 1
	cmp ebx,esi 
	jg false_ ;if esi < ebx  --> false (pos+len>sizeA)
	mov ebx,dword ptr [ebp+lenSubString]
	cmp ebx, 0 
	je true_ 	;if bx == 0 --> true (len==0)

	;else put a[pos] -> result , call the function with (a, sizeA, pos+1,len-1,result+1)
	
	
	mov edx, dword ptr [ebp + offsetAString] ; edx = &a
	mov ebx, dword ptr [ebp + posSubString] ; ebx = pos

	mov cl, byte ptr [edx + ebx] ;cl = A[pos]
	mov edx,[ebp + offsetSubstring] ; edx = &result
	mov byte ptr [edx],cl ; cl into result
	
	inc ebx ; pos++
	inc edx ; &result ++ 
	
	push [ebp+offsetAString] ; push &A
	push [ebp+sizeAString] 		 ; push a sizeA
	push ebx 			     ; push pos+1
	mov ebx, [ebp+lenSubString]
	dec ebx
	push ebx 				 ; push len-1
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
	pop edx
	pop esi
	pop ebx
	mov esp, ebp
	pop ebp
	ret 20
	
SubString ENDP 

END MAIN