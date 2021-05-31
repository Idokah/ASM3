INCLUDE irvine32.inc

.data
stringPtr BYTE "947",0
stringSize WORD 3
locaction WORD -1
zero BYTE "0", 0

.code
main PROC
     mov eax, 0
     push offset stringPtr
     push locaction
     push stringSize
     call dumpRegs
     call val
     call writeInt
     call dumpRegs
main ENDP

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

END main