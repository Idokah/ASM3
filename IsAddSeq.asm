.code

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
               

               push dword ptr [ebp + _stringOffset]   ;  num.substr(0, i)
               push word ptr [ebp + _stringSize]
               push word ptr 0 ; pos
               push word ptr[ebp + _firstLoopIndex] ; len
               lea edx, [ebp+ _subString1]
               push edx
               call subString

               push dword ptr [ebp + _stringOffset]   ;  num.substr(i, j)
               push word ptr [ebp + _stringSize]
               push word ptr [ebp + _firstLoopIndex] ; pos
               push word ptr [ebp + _secondLoopIndex] ; len
               lea edx, [ebp+ _subString2]
               push edx
               ; push offset subString2
               call subString

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
               call subString     
               
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
