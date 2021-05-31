INCLUDE irvine32.inc

.data
num byte "199100199", 0
N=Lengthof num
res byte N*2+1 dup (0)
subString1 N/2 DUP("0")
subString2 N/2 DUP("0")
subString3 N/2 DUP("0")

.code
main PROC
     push offset num
     push N
     push offset res
     call dumpRegs
     call IsAddSeq
     call dumpRegs
main ENDP

; Receive 
; return 
IsAddSeq PROC
     _stringOffset=8
     _stringSize=_stringOffset+4
     _resStringOffset=_stringSize+2
     _firstLoopIndex=-4
     _secondLoopIndex=_firstLoopIndex-2
     _firstLoopLimit=_secondLoopIndex-2
     _secondLoopLimit=_firstLoopLimit-2
     push ebp
	mov ebp, esp

     ;push 

     mov bx, 1
     mov [ebp + _firstLoopIndex], bx

     mov eax, 0                        ; init first loop
     mov ax, [ebp + _stringSize]
     div 2
     add al, 1  ; calc len/2
     mov [ebp + _firstLoopLimit], ax

     firstLoop:
          mov ax,[ebp + _firstLoopLimit]     ; check first loop condition
          cmp [ebp + firstLoopIndex], ax
          je notFoundSum

          mov ax, 0
          mov ax, [ebp + _stringSize]   ; init second loop
          sub ax, [ebp + firstLoopIndex]
          div 2
          add al, 1  ; calc len/2
          mov [ebp + _secondLoopLimit], ax

          secondLoop:
               mov ax,[ebp + _secondLoopLimit]     ; check first loop condition
               cmp [ebp + secondLoopIndex], ax
               je endSecondLoop
               
               push [ebp + _stringOffset]   ;  num.substr(0, i)
               push [ebp + _stringSize]
               push 0 ; pos
               push [ebp + _firstLoopIndex] ; len
               push offset subString1
               call subString

               push [ebp + _stringOffset]   ;  num.substr(i, j)
               push [ebp + _stringSize]
               push [ebp + _firstLoopIndex] ; pos
               push [ebp + _secondLoopIndex] ; len
               push offset subString2
               call subString

               push [ebp + _stringOffset]   ;  num.substr(i + j)
               push [ebp + _stringSize]
               mov ax, [ebp + _firstLoopIndex]
               add ax, [ebp + _secondLoopIndex]
               push ax ; pos
               mov cx, [ebp + _stringSize]
               sub cx, ax
               push cx ; len
               push offset subString2
               call subString     

               push offset subString1        ; check addition
               push [ebp + _firstLoopIndex]  ; first string size
               push offset subString2
               push [ebp + _secondLoopIndex] ; second string size
               push offset subString3
               push cx                       ; third string size
               push offset res
               push offset num
               push N
               call checkAddition
               cmp al, 1
               je foundSum
               
               mov ax, [ebp + secondLoopIndex]
               add ax, 1
               mov [ebp + secondLoopIndex], ax
               jmp secondLoop

     endSecondLoop:
          mov ax, [ebp + firstLoopIndex]
          add ax, 1
          mov [ebp + firstLoopIndex], ax
          jmp firstLoop
     
     foundSum:
          push offset res       ; res.push_front(num.substr(i, j))
          push offset subString2
          push offset res
          call PushFront

          push offset res       ;num.substr(0, i)
          push offset subString1
          push offset res
          call PushFront

          mov al, 1
          jmp done

     notFoundSum:
          mov al, 0
          jmp done
     
     done:
          ;pop 
          mov esp, ebp
          pop ebp
	     ret 8
IsAddSeq ENDP

END main