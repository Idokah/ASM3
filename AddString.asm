
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
