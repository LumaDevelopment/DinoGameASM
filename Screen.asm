; Maintains an array that represents the current state of the
; screen. Allows for the terrain, obstacles, and dino to be 
; written to memory, then all of it can be rendered at once.

INCLUDE DinoGame.inc

ROW_SIZE = TARGET_COLS + 2 ; space for CRLF
SCREEN_BUFFER_SIZE = TARGET_ROWS * ROW_SIZE

WDTS_BUFFER_SIZE = 12 ; size of buffer for WriteDecToScreen procedure

.data
screenBuffer BYTE SCREEN_BUFFER_SIZE DUP(?)
             BYTE 0 ; null-terminator
blankRow     BYTE TARGET_COLS        DUP(' ')

; Used to determine sprite collisions
writeCollision BYTE 0
PUBLIC writeCollision

.code

; Sets the last two bytes of every row in 
; screenBuffer to 0dh,0ah. None of the other 
; procedures in this file should affect the 
; last two bytes of every row, so we should 
; never have to do this again
InitScreen PROC USES eax ecx
     mov ecx,TARGET_ROWS
     mov eax,OFFSET screenBuffer
     add eax,TARGET_COLS ; Point to first CRLF position

     InitRow:
          mov BYTE PTR [eax],0dh
          mov BYTE PTR [eax+1],0ah
          add eax,ROW_SIZE
          loop InitRow

      ret
InitScreen ENDP

; Plucks TARGET_COLS bytes from the given text and sets 
; the row at the given index to those bytes.
; THIS PROCEDURE DOES NOT CHECK FOR STRING LENGTH
SetRowInScreen PROC USES eax ecx edi esi,
     rowIndex:BYTE,   ; Unsigned int representing the index of the row to set
     rowText:PTR BYTE ; Pointer to the string 

     ; Calculate offset
     movzx eax,rowIndex
     imul  eax,ROW_SIZE

     ; Move bytes from rowText to eax pos
     cld
     mov esi,rowText
     lea edi,screenBuffer[eax]
     mov ecx,TARGET_COLS
     rep movsb

     ret
SetRowInScreen ENDP

; Replaces the row at the given index with spaces
WipeRowInScreen PROC,
     rowIndex:BYTE ; Unsigned int representing the index of the row to wipe

     INVOKE SetRowInScreen, rowIndex, OFFSET blankRow

     ret
WipeRowInScreen ENDP

; Wipes the screen by wiping every row in the screen
WipeScreen PROC USES eax ecx
     mov ecx,TARGET_ROWS

     WipeLoop:
          mov eax,ecx
          dec eax
          INVOKE WipeRowInScreen, al
          loop WipeLoop

     ret
WipeScreen ENDP

; Sets the pixel at the given row and column to 
; the character at the location of the given 
; pointer. Will be used for drawing the dino 
; and obstacles.
SetPixelInScreen PROC USES eax ebx esi,
     rowIndex:BYTE,
     colIndex:BYTE,
     charPointer:PTR BYTE ; Pointer to the byte to set at the given pixel in the screen

     ; Calculate offset in screen buffer
     movzx eax,rowIndex
     imul  eax,ROW_SIZE
     movzx ebx,colIndex ; avoid sign-extension
     add   eax,ebx

     ; Write 1 byte from charPointer into screenBuffer[eax]
     mov esi,charPointer
     mov bl,[esi] ; Already reserved EBX for offset calculation

     ; Determine if the character being 
     ; written and the character already 
     ; there is the same
     cmp screenBuffer[eax],bl
     jne NewCharacter

     SameCharacter:
          mov writeCollision,1
          jmp EndOfProcedure

     NewCharacter:
          mov screenBuffer[eax],bl

     EndOfProcedure:
          ret
SetPixelInScreen ENDP

; Procedure stolen from Irvine32.
; Writes an unsigned 32-bit decimal number to the
; screen at the given location.

.data
wdtsBuffer BYTE WDTS_BUFFER_SIZE DUP(?),0
xtable BYTE "0123456789ABCDEF"

.code
WriteDecToScreen PROC,
     rowIndex:BYTE,
     colIndex:BYTE,
     inputNum:DWORD

     pushad
     mov eax,inputNum

     mov ecx,0 ; digit counter
     mov edi,OFFSET wdtsBuffer
     add edi,(WDTS_BUFFER_SIZE - 1)
     mov ebx,10 ; decimal number base

     WI1:
          mov  edx,0      ; clear dividend to zero
          div  ebx        ; divide EAX by the radix

          xchg eax,edx    ; swap quotient, remainder

          ; convert AL to ASCII
          push ebx
          mov  ebx,OFFSET xtable
          xlat
          pop ebx

          mov  [edi],al   ; save the digit
          dec  edi        ; back up in buffer
          xchg eax,edx    ; swap quotient, remainder

          inc  ecx        ; increment digit count
          or   eax,eax    ; quotient = 0?
          jnz  WI1        ; no, divide again

     WI3:
          inc edi         ; edi points to string
          mov bl,rowIndex ; keep track of row in AL
          mov cl,colIndex ; keep track of col in BL

     DrawLoop:
          cmp BYTE PTR [edi],0
          je WI4          ; end procedure when 0 reached

          push eax
          INVOKE SetPixelInScreen, bl, cl, edi
          pop  eax

          inc edi         ; Move to next char
          inc cl          ; Move to next col of screen
          jmp DrawLoop

     WI4:
          popad
          ret
WriteDecToScreen ENDP

RenderScreen PROC USES edx
     ; Write entire buffer to screen!
     mov edx, OFFSET screenBuffer
     call WriteString
     ret
RenderScreen ENDP

END
