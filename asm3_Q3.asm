INCLUDE irvine32.inc
INCLUDE asm3_Q3_data.inc
INCLUDE PushBack.asm
INCLUDE SubString.asm
INCLUDE CheckAddition.asm
INCLUDE IsAddSeq.asm
INCLUDE IsValid.asm
INCLUDE AddString.asm
INCLUDE CmpStr.asm
INCLUDE val.asm
INCLUDE ReverseString.asm
INCLUDE PushFront.asm

main PROC
     mov edx,offset header
     call writeString

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
     call writeInt

	 
main ENDP
END main