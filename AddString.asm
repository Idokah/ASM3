INCLUDE irvine32.inc

.data
string1 BYTE "1",0
string1Size WORD 1
string2 BYTE "99",0
string2Size WORD 2
resString BYTE 4 DUP("0") ; max(string1Size,string2Size) + 1 (for 0)

.code     
main PROC
     push offset resString
     push offset string1
     push offset string2
     push string1Size
     push string2Size
     call dumpRegs
     call AddString
     mov edx, offset resString
     call writeString
     call dumpRegs
main ENDP



; Receive offset of two strings, and one offset of result string
; return the sum in the result string and its len in EDI
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
     push edx

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
          push [ebp + string1Offset]
          push bx
          push word ptr [ebp + string1SizeOffset]
          call val
          mov ah, al
          ; calling val for second string
          push [ebp + string2Offset]
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
          sub edi, [ebp + resStringOffset]   ; returning in edi the result string len
          mov edx, [ebp + resStringOffset]
          push edx
          call ReverseString
          pop edx
          pop ecx
          pop ebx
          pop eax
          mov esp, ebp
          pop ebp
	     ret 16
AddString ENDP

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

END main
